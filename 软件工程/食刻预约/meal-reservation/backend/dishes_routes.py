from flask import Blueprint
from sqlalchemy import func
import logging
from datetime import datetime
import os
import uuid

from auxiliary_function import (token_required,request, jsonify, g,
                                allowed_file, validate_dish_data, format_dish_data,
                                DISH_UPLOAD_FOLDER)
from Models import Dish, Restaurant, StockLog, Order, OrderItem, DishOffShelfLog

from app_init import db
from db_exe import (get_merchant_restaurant,create_dish_launch_notification)


dishes_bp = Blueprint('dishes', __name__, url_prefix='/api/dishes')
dishes_logger = logging.getLogger('dishes')

# ===== 菜品信息管理 API =====

@dishes_bp.route('/<int:dish_id>/status', methods=['PATCH'])
@token_required
def update_dish_status(dish_id):
    try:
        restaurant = get_merchant_restaurant(g.current_user)
        if not restaurant:
            return jsonify({'success': False, 'message': '只有商家可以操作菜品'}), 403

        dish = Dish.query.filter_by(dish_id=dish_id, restaurant_id=restaurant.id).first()
        if not dish:
            return jsonify({'success': False, 'message': '菜品不存在'}), 404

        payload = request.get_json() or {}
        new_status = payload.get('status')
        if new_status not in {'available', 'sold_out', 'unavailable'}:
            return jsonify({'success': False, 'message': '状态不合法'}), 400

        # 下架原因：下架(unavailable)必须填写；售罄(sold_out)自动记为“售罄”
        off_shelf_reason = (payload.get('off_shelf_reason') or '').strip()
        if new_status == 'unavailable' and not off_shelf_reason:
            return jsonify({'success': False, 'message': '下架需要填写下架原因'}), 400
        if new_status == 'sold_out':
            off_shelf_reason = '售罄'

        # 【新增】记录更新前的库存量
        old_stock_quantity = dish.stock_quantity

        if 'stock_quantity' in payload:
            try:
                stock_quantity = max(0, int(payload['stock_quantity']))
            except (TypeError, ValueError):
                return jsonify({'success': False, 'message': '库存格式错误'}), 400
            dish.stock_quantity = stock_quantity
            if dish.stock_capacity is None or stock_quantity > (dish.stock_capacity or 0):
                dish.stock_capacity = stock_quantity

        if new_status == 'sold_out':
            dish.stock_quantity = 0
        elif new_status == 'available' and (dish.stock_quantity or 0) == 0:
            dish.stock_quantity = dish.stock_capacity or dish.stock_quantity


        new_stock_quantity = dish.stock_quantity

        # 【新增】直接记录库存变动到 StockLog（不修改库存）
        stock_diff = new_stock_quantity - old_stock_quantity
        if stock_diff != 0:
            if dish.original_price is not None:
                total_price = float(dish.original_price)*(stock_diff if stock_diff > 0 else 0)
            else:
                total_price = 0

            stock_log = StockLog(
                restaurant_id=restaurant.id,
                dish_id=dish_id,
                change_type='restock' if stock_diff > 0 else 'loss',  # 状态更新
                quantity_change=stock_diff,
                stock_before=old_stock_quantity,
                stock_after=new_stock_quantity,  # 记录当前库存
                cost=total_price,
                operator_id=g.current_user.id,
                note='补货' if stock_diff > 0 else '损耗',
            )
            db.session.add(stock_log)

        dish.status = new_status
        dish.updated_at = datetime.utcnow()

        # 记录下架原因（仅在下架/售罄时写入记录；上架不写入）
        if new_status in {'sold_out', 'unavailable'}:
            db.session.add(DishOffShelfLog(
                restaurant_id=restaurant.id,
                dish_id=dish_id,
                reason=off_shelf_reason,
                operator_id=getattr(g.current_user, 'id', None)
            ))

        db.session.commit()

        return jsonify({'success': True, 'message': '状态已更新', 'data': dish.to_menu_card()}), 200
    except Exception as exc:
        db.session.rollback()
        dishes_logger.exception('更新菜品状态失败')
        return jsonify({'success': False, 'message': '更新菜品状态失败', 'error': str(exc)}), 500


@dishes_bp.route('/<int:dish_id>/off-shelf-info', methods=['GET'])
@token_required
def get_latest_off_shelf_info(dish_id):
    """查询菜品最近一次下架信息（原因/时间/操作人）。"""
    try:
        restaurant = get_merchant_restaurant(g.current_user)
        if not restaurant:
            return jsonify({'success': False, 'message': '只有商家可以查询'}), 403

        dish = Dish.query.filter_by(dish_id=dish_id, restaurant_id=restaurant.id).first()
        if not dish:
            return jsonify({'success': False, 'message': '菜品不存在'}), 404

        latest = (DishOffShelfLog.query
                  .filter_by(restaurant_id=restaurant.id, dish_id=dish_id)
                  .order_by(DishOffShelfLog.created_at.desc())
                  .first())

        return jsonify({
            'success': True,
            'data': latest.to_dict() if latest else None
        }), 200
    except Exception as exc:
        dishes_logger.exception('查询下架信息失败')
        return jsonify({'success': False, 'message': '查询下架信息失败', 'error': str(exc)}), 500


@dishes_bp.route('/batch-status', methods=['POST'])
@token_required
def batch_update_dish_status():
    try:
        restaurant = get_merchant_restaurant(g.current_user)
        if not restaurant:
            return jsonify({'success': False, 'message': '只有商家可以操作菜品'}), 403

        data = request.get_json() or {}
        dish_ids = {int(did) for did in data.get('dish_ids', []) if str(did).isdigit()}
        status = data.get('status')
        if not dish_ids or status not in {'available', 'sold_out', 'unavailable'}:
            return jsonify({'success': False, 'message': '参数不完整'}), 400

        dishes = Dish.query.filter(Dish.dish_id.in_(dish_ids), Dish.restaurant_id == restaurant.id).all()
        if len(dishes) != len(dish_ids):
            return jsonify({'success': False, 'message': '部分菜品不存在或无权操作'}), 404

        for dish in dishes:
            dish.status = status
            if status == 'sold_out':
                dish.stock_quantity = 0
            elif status == 'available' and (dish.stock_quantity or 0) == 0:
                dish.stock_quantity = dish.stock_capacity or dish.stock_quantity
            dish.updated_at = datetime.utcnow()

        db.session.commit()
        return jsonify({'success': True, 'message': '批量更新成功'}), 200
    except Exception as exc:
        db.session.rollback()
        dishes_logger.exception('批量更新菜品状态失败')
        return jsonify({'success': False, 'message': '批量更新失败', 'error': str(exc)}), 500

@dishes_bp.route('/batch-tags', methods=['POST'])
@token_required
def batch_append_dish_tag():
    try:
        restaurant = get_merchant_restaurant(g.current_user)
        if not restaurant:
            return jsonify({'success': False, 'message': '只有商家可以操作菜品'}), 403

        data = request.get_json() or {}
        dish_ids = {int(did) for did in data.get('dish_ids', []) if str(did).isdigit()}
        tag = (data.get('tag') or '').strip()
        if not dish_ids or not tag:
            return jsonify({'success': False, 'message': '参数不完整'}), 400

        dishes = Dish.query.filter(Dish.dish_id.in_(dish_ids), Dish.restaurant_id == restaurant.id).all()
        if len(dishes) != len(dish_ids):
            return jsonify({'success': False, 'message': '部分菜品不存在或无权操作'}), 404

        for dish in dishes:
            current_tags = set(dish.tags or [])
            current_tags.add(tag)
            dish.tags = list(current_tags)
            dish.updated_at = datetime.utcnow()

        db.session.commit()
        return jsonify({'success': True, 'message': '标签批量更新成功'}), 200
    except Exception as exc:
        db.session.rollback()
        dishes_logger.exception('批量更新菜品标签失败')
        return jsonify({'success': False, 'message': '批量更新标签失败', 'error': str(exc)}), 500

@dishes_bp.route('/recommendations', methods=['GET'])
@token_required
def get_recommendations():
    """
    获取推荐菜品
    规则：
    1. 购买次数多的菜品优先级高
    2. 同种类的菜品优先级高
    """
    try:
        current_user = g.current_user
        
        # 1. 获取用户历史订单中的菜品统计
        # 联表查询：Order -> OrderItem
        # 筛选：当前用户，有效订单(非cancelled/rejected/pending)
        user_history = db.session.query(
            OrderItem.dish_id, 
            func.sum(OrderItem.quantity).label('total_quantity')
        ).join(Order, OrderItem.order_id == Order.id)\
         .filter(Order.user_id == current_user.id)\
         .filter(Order.status.notin_(['cancelled', 'rejected', 'pending']))\
         .group_by(OrderItem.dish_id).all()
         
        # 转换为字典: {dish_id: quantity}
        dish_purchase_counts = {item.dish_id: int(item.total_quantity) for item in user_history}
        
        # 2. 统计用户偏好的分类
        purchased_dish_ids = list(dish_purchase_counts.keys())
        
        category_weights = {}
        if purchased_dish_ids:
            purchased_dishes = Dish.query.filter(Dish.dish_id.in_(purchased_dish_ids)).all()
            for dish in purchased_dishes:
                if dish.category:
                    count = dish_purchase_counts.get(dish.dish_id, 0)
                    category_weights[dish.category] = category_weights.get(dish.category, 0) + count
                
        # 3. 获取所有可售菜品（且餐厅未打烊）
        all_dishes = (
            Dish.query
            .join(Restaurant, Dish.restaurant_id == Restaurant.id)
            .filter(Dish.status == 'available')
            .filter(Restaurant.is_open.is_(True))
            .all()
        )
        
        # 4. 计算每个菜品的得分
        scored_dishes = []
        for dish in all_dishes:
            score = 0
            
            # 规则1: 购买次数 (权重: 1000 + 次数*10) - 确保买过的排在最前
            purchase_count = dish_purchase_counts.get(dish.dish_id, 0)
            if purchase_count > 0:
                score += 1000 + (purchase_count * 10)
            
            # 规则2: 同种类 (权重: 100 + 种类购买总次数*1) - 确保同种类的排在中间
            if dish.category:
                category_score = category_weights.get(dish.category, 0)
                if category_score > 0:
                    score += 100 + category_score
            
            # 规则3: 销量 (权重: 0.1) - 没买过也没同类的排在最后，按销量排序
            score += (dish.monthly_sales or 0) * 0.1
                
            scored_dishes.append({
                'dish': dish,
                'score': score
            })
            
        # 5. 排序
        scored_dishes.sort(key=lambda x: x['score'], reverse=True)
        
        # 6. 返回结果 (返回前50个)
        recommendations = []
        for item in scored_dishes[:50]:
            dish_data = item['dish'].to_public_dict()
            dish_data['restaurant_id'] = item['dish'].restaurant_id
            if item['dish'].restaurant:
                dish_data['restaurant_name'] = item['dish'].restaurant.name
            recommendations.append(dish_data)
            
        return jsonify({
            'success': True, 
            'data': {
                'dishes': recommendations
            }
        }), 200
        
    except Exception as e:
        dishes_logger.error(f"获取推荐失败: {e}")
        return jsonify({'success': False, 'message': '获取推荐失败', 'error': str(e)}), 500

@dishes_bp.route('', methods=['GET', 'POST'])
@dishes_bp.route('/', methods=['GET', 'POST'])
@token_required
def handle_dishes():
    """菜品列表管理 - GET: 获取菜品列表, POST: 创建新菜品"""
    try:
        if request.method == 'GET':
            restaurant_id = request.args.get('restaurant_id')
            query = Dish.query

            if restaurant_id:
                try:
                    restaurant_id = int(restaurant_id)
                    query = query.filter_by(restaurant_id=restaurant_id)
                except (TypeError, ValueError):
                    return jsonify({'success': False, 'message': '无效的餐厅ID'}), 400
            
            # 支持按状态筛选
            status = request.args.get('status')
            if status:
                query = query.filter_by(status=status)

            dishes = query.order_by(Dish.created_at.desc()).all()
            
            dishes_data = []
            for dish in dishes:
                d_dict = dish.to_dict()
                # 补充餐厅名称，用于前端展示
                if 'restaurant_name' not in d_dict and hasattr(dish, 'restaurant') and dish.restaurant:
                    d_dict['restaurant_name'] = dish.restaurant.name
                dishes_data.append(d_dict)

            return jsonify({
                'success': True,
                'data': {
                    'dishes': dishes_data,
                    'total': len(dishes)
                }
            }), 200

        elif request.method == 'POST':
            data = request.get_json()
            if not data:
                return jsonify({'success': False, 'message': '缺少请求数据'}), 400

            restaurant_id = data.get('restaurant_id')
            try:
                restaurant_id = int(restaurant_id)
            except (TypeError, ValueError):
                return jsonify({'success': False, 'message': '无效的餐厅ID'}), 400

            data['restaurant_id'] = restaurant_id
            is_valid, validation_result = validate_dish_data(data)
            if not is_valid:
                return jsonify({
                    'success': False,
                    'message': '数据验证失败',
                    'errors': validation_result
                }), 400

            formatted_data = format_dish_data(data)
            formatted_data['restaurant_id'] = restaurant_id
            tags_payload = data.get('tags')
            if isinstance(tags_payload, list):
                formatted_data['tags'] = tags_payload
            formatted_data['monthly_sales'] = int(data.get('monthly_sales', 0) or 0)
            formatted_data['stock_capacity'] = data.get(
                'stock_capacity',
                formatted_data.get('stock_quantity')
            )

            new_dish = Dish(**formatted_data)
            db.session.add(new_dish)

            db.session.flush()

            # 【新增】记录创建菜品时的初始库存日志
            if new_dish.stock_quantity and new_dish.stock_quantity > 0:
                if new_dish.original_price is not None:
                    total_price = float(new_dish.original_price) * new_dish.stock_quantity
                else:
                    total_price = 0

                stock_log = StockLog(
                    restaurant_id=new_dish.restaurant_id,
                    dish_id=new_dish.dish_id,
                    change_type='restock',  # 初始补货
                    quantity_change=new_dish.stock_quantity,
                    stock_before=0,  # 创建前库存为0
                    stock_after=new_dish.stock_quantity,
                    operator_id=g.current_user.id,
                    cost=total_price,
                    note='创建菜品初始库存'
                 )
                db.session.add(stock_log)


            dish_payload = new_dish.to_dict()
            notification_payload = None

            try:
                notification = create_dish_launch_notification(new_dish, auto_commit=True)
                if notification:
                    notification_payload = notification.to_dict()
            except Exception as notify_error:
                db.session.rollback()
                dishes_logger.error('菜品创建成功，但生成上新通知失败: %s', notify_error, exc_info=True)

            db.session.commit()  # 统一提交日志

            response_payload = {
                'success': True,
                'message': '菜品创建成功',
                'data': dish_payload
            }
            if notification_payload:
                response_payload['dish_launch_notification'] = notification_payload

            return jsonify(response_payload), 201

    except Exception as e:
        db.session.rollback()
        return jsonify({'success': False, 'message': '菜品操作失败', 'error': str(e)}), 500

@dishes_bp.route('/<int:dish_id>', methods=['GET', 'PUT', 'DELETE'])
@token_required  # 添加token验证装饰器
def handle_dish(dish_id):
    """单个菜品操作 - GET: 获取菜品详情, PUT: 更新菜品, DELETE: 删除菜品"""
    try:
        # 注意：Dish模型使用dish_id作为主键
        dish = Dish.query.filter_by(dish_id=dish_id).first()
        if not dish:
            return jsonify({'success': False, 'message': '菜品不存在'}), 404

        if request.method == 'GET':
            restaurant_id = request.args.get('restaurant_id', type=int)
            if restaurant_id is not None and dish.restaurant_id != restaurant_id:
                return jsonify({'success': False, 'message': '菜品不存在于指定餐厅'}), 404

            return jsonify({
                'success': True,
                 'data': dish.to_dict()
            }), 200

        elif request.method == 'PUT':
            data = request.get_json()
            if not data:
                return jsonify({'success': False, 'message': '缺少请求数据'}), 400

            restaurant_id = data.get('restaurant_id')
            try:
                restaurant_id = int(restaurant_id)
            except (TypeError, ValueError):
                return jsonify({'success': False, 'message': '无效的餐厅ID'}), 400

            if dish.restaurant_id != restaurant_id:
                return jsonify({'success': False, 'message': '菜品不存在于指定餐厅'}), 404

            data['restaurant_id'] = restaurant_id

            is_valid, validation_result = validate_dish_data(data)
            if not is_valid:
                return jsonify({
                    'success': False,
                    'message': '数据验证失败',
                    'errors': validation_result
                }), 400
            formatted_data = format_dish_data(data)
            formatted_data.pop('restaurant_id', None)
            print(f"更新菜品数据: {formatted_data}")
            # 直接将格式化后的字段写入到 dish 对象（允许直接覆盖库存）
            for field, value in formatted_data.items():
                if field in ('id', 'dish_id'):
                    continue
                setattr(dish, field, value)

            dish.updated_at = datetime.utcnow()

            db.session.commit()

            return jsonify({
                'success': True,
                'message': '菜品更新成功',
                'data': dish.to_dict()
            }), 200

        elif request.method == 'DELETE':
            restaurant_id = request.args.get('restaurant_id', type=int)
            if restaurant_id is None:
                return jsonify({'success': False, 'message': '缺少餐厅ID参数'}), 400

            # 验证权限：确保当前用户有操作该餐厅的权限
            # 检查当前用户是否是餐厅所属商家
            restaurant = Restaurant.query.filter_by(id=restaurant_id).first()
            if not restaurant:
                return jsonify({'success': False, 'message': '餐厅不存在'}), 404
            
            # 检查用户权限
            if g.current_user.usertype != 0 and g.current_user.id != restaurant.user_id:
                return jsonify({'success': False, 'message': '您没有权限删除该餐厅的菜品'}), 403

            if dish.restaurant_id != restaurant_id:
                return jsonify({'success': False, 'message': '菜品不存在于指定餐厅'}), 404

            try:
                # 先删除与该菜品相关的通知记录，避免外键约束错误
                from Models import DishLaunchNotification
                DishLaunchNotification.query.filter_by(dish_id=dish_id).delete()
                
                dish_name = dish.name
                db.session.delete(dish)
                db.session.commit()

                return jsonify({
                    'success': True,
                    'message': f'菜品 "{dish_name}" 删除成功'
                }), 200
            except Exception as e:
                db.session.rollback()
                dishes_logger.error(f'删除菜品失败: {str(e)}')
                return jsonify({
                    'success': False,
                    'message': f'数据库操作失败: {str(e)}',
                    'error': str(e)
                }), 500

    except Exception as e:
        db.session.rollback()
        return jsonify({'success': False, 'message': '菜品操作失败', 'error': str(e)}), 500

@dishes_bp.route('/upload', methods=['POST'])
@token_required
def upload_dish_image():
    """菜品图片上传接口"""
    try:
        # 检查文件
        if 'file' not in request.files:
            print("错误：请求中缺少文件字段")
            return jsonify({'success': False, 'message': '缺少文件'}), 400

        file = request.files['file']
        print(f"文件信息：filename={file.filename}, content_type={file.content_type}")

        if not file or file.filename == '':
            return jsonify({'success': False, 'message': '未选择文件'}), 400

        if not allowed_file(file.filename):
            return jsonify({'success': False, 'message': f'不支持的文件类型：{file.filename}'}), 400

        # 获取文件大小
        try:
            file.seek(0, os.SEEK_END)  # 移动到文件末尾
            file_size = file.tell()    # 获取当前位置（即文件大小）
            file.seek(0)              # 回到文件开头

            if file_size > 5 * 1024 * 1024:  # 5MB限制
                return jsonify({'success': False, 'message': '文件大小不能超过5MB'}), 400

        except Exception as e:
            print(f"获取文件大小失败：{str(e)}")
            return jsonify({'success': False, 'message': '无法获取文件大小'}), 400

        # 获取餐厅信息用于文件夹命名
        restaurant = get_merchant_restaurant(g.current_user)
        if not restaurant:
            return jsonify({'success': False, 'message': '未找到商户餐厅信息'}), 403

        print(f"用户餐厅ID：{restaurant.id}")

        # 创建餐厅专属文件夹
        restaurant_folder = os.path.join(DISH_UPLOAD_FOLDER, str(restaurant.id))
        os.makedirs(restaurant_folder, exist_ok=True)
        print(f"创建文件夹：{restaurant_folder}")

        # 生成文件名
        filename = file.filename
        ext = filename.rsplit('.', 1)[1].lower()
        timestamp = int(datetime.utcnow().timestamp())
        unique_name = f"{timestamp}_{uuid.uuid4().hex}.{ext}"
        save_path = os.path.join(restaurant_folder, unique_name)

        print(f"保存文件到：{save_path}")

        # 保存文件
        file.save(save_path)

        # 返回相对URL
        url = f"/static/uploads/dishes/{restaurant.id}/{unique_name}"
        return jsonify({
            'success': True,
            'url': url,
            'filename': unique_name,
            'restaurant_id': restaurant.id
        }), 200

    except Exception as e:
        print(f"上传失败：{str(e)}")
        return jsonify({'success': False, 'message': '上传失败', 'error': str(e)}), 500

@dishes_bp.route('/menu/<int:restaurant_id>')
def get_restaurant_menu(restaurant_id):
    """获取餐厅完整菜单（用于前端显示）"""
    try:
        dishes = Dish.query.filter_by(
            restaurant_id=restaurant_id,
            status='available'
        ).order_by(Dish.created_at.desc()).all()
        # 按分类分组菜品
        menu_by_category = {}
        for dish in dishes:
            category = dish.category or '未分类'
            if category not in menu_by_category:
                menu_by_category[category] = []
            menu_by_category[category].append(dish.to_public_dict())

        return jsonify({
            'success': True,
            'data': {
                'menu': menu_by_category,
                'total_dishes': len(dishes),
                'categories': list(menu_by_category.keys())
            }
        }), 200

    except Exception as e:
        return jsonify({'success': False, 'message': '获取菜单失败', 'error': str(e)}), 500
