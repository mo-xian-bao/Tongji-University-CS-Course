from flask import Blueprint, send_file
from sqlalchemy import func, and_
from datetime import datetime, timedelta, timezone
from collections import Counter
import logging
import os
import uuid
import jieba
import re
from zoneinfo import ZoneInfo

from auxiliary_function import (token_required,request, jsonify, g,
                                allowed_file, MERCHANT_UPLOAD_FOLDER)
from Models import (User, Review, Restaurant, Dish,
                     Order, Table, OrderChangeRequest,
                    OrderItem, StockLog, Message )
from app_init import db
from db_exe import validate_order_items, get_merchant_restaurant

merchant_bp = Blueprint('merchant', __name__, url_prefix='/api/merchant')
merchant_logger = logging.getLogger('merchant')


def _safe_zoneinfo(tz_name):
    """Return ZoneInfo for tz_name; fallback to UTC on missing/invalid."""
    try:
        return ZoneInfo(tz_name) if tz_name else timezone.utc
    except Exception:
        return timezone.utc


def _localize_iso(value, tz, is_end=False):
    """Parse ISO string from frontend (usually naive local time) into aware datetimes.

    Returns (local_dt, utc_dt). If value is date-only, expands to start/end of day in tz.
    """
    if not value:
        return None, None

    raw = str(value).strip()
    is_date_only = 'T' not in raw

    dt = datetime.fromisoformat(raw)
    if getattr(dt, 'tzinfo', None) is None:
        if is_date_only:
            if is_end:
                dt = dt.replace(hour=23, minute=59, second=59, microsecond=999999)
            else:
                dt = dt.replace(hour=0, minute=0, second=0, microsecond=0)
        local_dt = dt.replace(tzinfo=tz)
    else:
        # If client sent an offset-aware datetime, normalize to requested tz.
        local_dt = dt.astimezone(tz)

    return local_dt, local_dt.astimezone(timezone.utc)


def _parse_range_from_frontend(start_str, end_str, tz_name, default_days=7):
    """Interpret frontend date range in tz_name and convert to UTC for DB filtering.

    Returns (tz, local_start, local_end, utc_start, utc_end).
    """
    tz = _safe_zoneinfo(tz_name)
    if not start_str or not end_str:
        utc_end = datetime.utcnow().replace(tzinfo=timezone.utc)
        utc_start = utc_end - timedelta(days=default_days)
        return tz, utc_start.astimezone(tz), utc_end.astimezone(tz), utc_start, utc_end

    local_start, utc_start = _localize_iso(start_str, tz, is_end=False)
    local_end, utc_end = _localize_iso(end_str, tz, is_end=True)

    # Safety: ensure range is valid
    if utc_start and utc_end and utc_end < utc_start:
        utc_start, utc_end = utc_end, utc_start
        local_start, local_end = local_end, local_start

    return tz, local_start, local_end, utc_start, utc_end


def _normalize_order_type(order_type):
    value = (order_type or '').replace('-', '').replace('_', '').lower()
    return value


def _is_takeout_order(order):
    return _normalize_order_type(getattr(order, 'order_type', None)) == 'takeout'


def _create_pickup_notification(order, sender_id):
    """Send a single pickup notification message for takeout orders."""
    if not order or not _is_takeout_order(order):
        return

    existing_notice = Message.query.filter_by(order_id=order.id, message_type='pickup_notice').first()
    if existing_notice:
        return

    pickup_hint = order.pickup_number or '请凭订单编号取餐'
    text = f"您的订单 {order.order_number} 已完成，可以前往取餐。取餐号：{pickup_hint}"
    sender_type = 'merchant' if sender_id else 'system'

    message = Message(
        order_id=order.id,
        sender_id=sender_id or 0,
        sender_type=sender_type,
        text=text,
        message_type='pickup_notice'
    )
    db.session.add(message)


def build_menu_dish_payload(dish):
    if not dish:
        return {}
    return dish.to_menu_card()

# ---- 简易的店家结算 API（示例，仅用于前端开发和演示） ----
@merchant_bp.route('/settlements', methods=['GET', 'POST'])
def merchant_settlements():
    """GET: 根据日期范围返回订单结算列表（示例数据）
       POST: 标记指定订单为已结算（示例，不修改数据库，只返回成功）
    """
    try:
        if request.method == 'GET':
            # 简单的示例数据，真实项目应从数据库查询
            from_date = request.args.get('from')
            to_date = request.args.get('to')

            sample = [
                {
                    'order_id': 'ORD1001',
                    'date': datetime.utcnow().isoformat(),
                    'amount': 120.00,
                    'fee': 6.00,
                    'settled': False
                },
                {
                    'order_id': 'ORD1002',
                    'date': datetime.utcnow().isoformat(),
                    'amount': 56.50,
                    'fee': 2.82,
                    'settled': True
                },
                {
                    'order_id': 'ORD1003',
                    'date': datetime.utcnow().isoformat(),
                    'amount': 230.00,
                    'fee': 11.5,
                    'settled': False
                }
            ]

            # 可按 from/to 过滤：这里为了示例直接返回全部
            return jsonify({'success': True, 'data': {'settlements': sample}}), 200

        # POST 请求用于标记结算（示例）
        data = request.get_json() or {}
        order_id = data.get('order_id')
        if not order_id:
            return jsonify({'success': False, 'message': '缺少 order_id'}), 400

        # 真实项目中需要在数据库中更新结算状态并做鉴权/权限检查
        return jsonify({'success': True, 'message': f'订单 {order_id} 标记为已结算'}), 200

    except Exception as e:
        return jsonify({'success': False, 'message': '结算接口错误', 'error': str(e)}), 500

@merchant_bp.route('/menu', methods=['GET'])
@token_required
def get_merchant_menu():
    try:
        restaurant = get_merchant_restaurant(g.current_user)
        if not restaurant:
            return jsonify({'success': False, 'message': '未找到商户餐厅或无权访问'}), 403

        dishes = Dish.query.filter_by(restaurant_id=restaurant.id).order_by(Dish.created_at.desc()).all()
        categories = sorted({d.category for d in dishes if d.category})
        status_counter = Counter(d.status for d in dishes)

        return jsonify({
            'success': True,
            'data': {
                'dishes': [build_menu_dish_payload(d) for d in dishes],
                'categories': categories,
                'status_counts': dict(status_counter)
            }
        }), 200
    except Exception as exc:
        merchant_logger.exception('加载菜单失败')
        return jsonify({'success': False, 'message': '加载菜单失败', 'error': str(exc)}), 500

@merchant_bp.route('/upload', methods=['POST'])
@token_required
def upload_merchant_file():
    """专门用于商户申请的文件上传接口"""
    try:
        # 检查文件
        if 'file' not in request.files:
            return jsonify({'success': False, 'message': '缺少文件'}), 400

        file = request.files['file']
        if not file or file.filename == '':
            return jsonify({'success': False, 'message': '未选择文件'}), 400

        if not allowed_file(file.filename):
            return jsonify({'success': False, 'message': '不支持的文件类型'}), 400

        # 根据文件类型创建子文件夹
        file_type = request.form.get('file_type', 'license')
        subfolder = file_type
        file_subfolder = os.path.join(MERCHANT_UPLOAD_FOLDER, subfolder)
        os.makedirs(file_subfolder, exist_ok=True)

        # 生成文件名
        filename = file.filename#secure_filename(file.filename)
        ext = filename.rsplit('.', 1)[1].lower()
        timestamp = int(datetime.utcnow().timestamp())
        unique_name = f"{g.current_user.id}_{timestamp}_{uuid.uuid4().hex}.{ext}"
        save_path = os.path.join(file_subfolder, unique_name)

        # 保存文件
        file.save(save_path)

        # 返回相对URL
        url = f"/static/uploads/merchant/{subfolder}/{unique_name}"
        return jsonify({
            'success': True,
            'url': url,
            'filename': unique_name,
            'file_type': file_type
        }), 200

    except Exception as e:
        db.session.rollback()
        return jsonify({'success': False, 'message': '上传失败', 'error': str(e)}), 500

# ==================== 预约桌位相关函数和API ====================

@merchant_bp.route('/orders/<int:order_id>/reservation-status', methods=['PUT'])
@token_required
def update_reservation_status(order_id):
    """
    商家更新预约状态
    
    Body参数:
    - status: 新状态 (confirmed/seated/completed/cancelled/no_show)
    - reason: 原因（取消时需要）
    """
    try:
        user = g.current_user
        restaurant = Restaurant.query.filter_by(user_id=user.id).first()
        
        if not restaurant:
            return jsonify({'success': False, 'message': '您不是商家'}), 403
        
        order = Order.query.get(order_id)
        if not order:
            return jsonify({'success': False, 'message': '订单不存在'}), 404
        
        if order.restaurant_id != restaurant.id:
            return jsonify({'success': False, 'message': '无权操作此订单'}), 403
        
        if order.reservation_status == 'none':
            return jsonify({'success': False, 'message': '此订单不是预约订单'}), 400
        
        data = request.get_json()
        new_status = data.get('status')
        
        valid_statuses = ['confirmed', 'seated', 'completed', 'cancelled', 'no_show']
        if new_status not in valid_statuses:
            return jsonify({'success': False, 'message': f'无效的状态，可选值: {valid_statuses}'}), 400
        
        # 状态转换验证
        current_status = order.reservation_status
        valid_transitions = {
            'pending': ['confirmed', 'cancelled'],
            'confirmed': ['seated', 'cancelled', 'no_show'],
            'seated': ['completed'],
        }
        
        if current_status in valid_transitions and new_status not in valid_transitions.get(current_status, []):
            return jsonify({'success': False, 'message': f'不能从 {current_status} 转换到 {new_status}'}), 400
        
        order.reservation_status = new_status
        
        # 同步更新订单状态
        if new_status == 'confirmed':
            order.status = 'confirmed'
            order.confirmed_time = datetime.utcnow()
            # 生成取单号
            order.pickup_number = Order.generate_pickup_number(restaurant.id)
        elif new_status == 'seated':
            order.status = 'dining'
        elif new_status == 'completed':
            order.status = 'completed'
            order.completed_time = datetime.utcnow()
            _create_pickup_notification(order, user.id)
        elif new_status in ['cancelled', 'no_show']:
            order.status = 'cancelled'
            order.cancelled_time = datetime.utcnow()
            if data.get('reason'):
                order.reject_reason = data.get('reason')
        
        db.session.commit()
        
        return jsonify({
            'success': True,
            'message': '预约状态更新成功',
            'data': order.to_dict()
        })
        
    except Exception as e:
        db.session.rollback()
        print(f"更新预约状态失败: {e}")
        return jsonify({'success': False, 'message': '更新预约状态失败', 'error': str(e)}), 500


@merchant_bp.route('/reservations', methods=['GET'])
@token_required
def get_merchant_reservations():
    """
    获取商家的预约列表
    
    Query参数:
    - date: 日期筛选 (YYYY-MM-DD)
    - status: 状态筛选 (pending/confirmed/seated/completed/cancelled/no_show)
    - page: 页码
    - per_page: 每页数量
    """
    try:
        user = g.current_user
        restaurant = Restaurant.query.filter_by(user_id=user.id).first()
        
        if not restaurant:
            return jsonify({'success': False, 'message': '您不是商家'}), 403
        
        date_str = request.args.get('date')
        status = request.args.get('status')
        page = request.args.get('page', 1, type=int)
        per_page = request.args.get('per_page', 20, type=int)
        
        query = Order.query.filter(
            Order.restaurant_id == restaurant.id,
            Order.reservation_status != 'none'
        )
        
        if date_str:
            try:
                filter_date = datetime.strptime(date_str, '%Y-%m-%d').date()
                query = query.filter(
                    func.date(Order.reserved_time) == filter_date
                )
            except:
                pass
        
        if status:
            query = query.filter(Order.reservation_status == status)
        
        query = query.order_by(Order.reserved_time.asc())
        
        pagination = query.paginate(page=page, per_page=per_page, error_out=False)
        
        reservations = []
        for order in pagination.items:
            order_dict = order.to_dict()
            order_dict['user_name'] = order.user.username if order.user else None
            order_dict['user_phone'] = order.user.phone if order.user else None
            reservations.append(order_dict)
        
        return jsonify({
            'success': True,
            'data': {
                'reservations': reservations,
                'pagination': {
                    'page': pagination.page,
                    'per_page': pagination.per_page,
                    'total_pages': pagination.pages,
                    'total_items': pagination.total
                }
            }
        })
        
    except Exception as e:
        print(f"获取预约列表失败: {e}")
        return jsonify({'success': False, 'message': '获取预约列表失败', 'error': str(e)}), 500


@merchant_bp.route('/tables/<int:table_id>/schedule', methods=['GET'])
@token_required
def get_table_schedule(table_id):
    """
    获取桌位的预约时间表
    
    Query参数:
    - date: 日期 (YYYY-MM-DD，默认今天)
    """
    try:
        user = g.current_user
        restaurant = Restaurant.query.filter_by(user_id=user.id).first()
        
        if not restaurant:
            return jsonify({'success': False, 'message': '您不是商家'}), 403
        
        table = Table.query.get(table_id)
        if not table:
            return jsonify({'success': False, 'message': '桌位不存在'}), 404
        
        if table.restaurant_id != restaurant.id:
            return jsonify({'success': False, 'message': '无权查看此桌位'}), 403
        
        date_str = request.args.get('date')
        if date_str:
            try:
                filter_date = datetime.strptime(date_str, '%Y-%m-%d').date()
            except:
                filter_date = datetime.utcnow().date()
        else:
            filter_date = datetime.utcnow().date()
        
        # 获取当天该桌位的所有有效预约
        start_of_day = datetime.combine(filter_date, datetime.min.time())
        end_of_day = datetime.combine(filter_date, datetime.max.time())
        
        reservations = Order.query.filter(
            Order.table_id == table_id,
            Order.reservation_status.in_(['pending', 'confirmed', 'seated']),
            Order.reserved_time >= start_of_day,
            Order.reserved_time <= end_of_day
        ).order_by(Order.reserved_time.asc()).all()
        
        schedule = []
        for order in reservations:
            schedule.append({
                'order_id': order.id,
                'order_number': order.order_number,
                'reserved_time': order.reserved_time.isoformat() if order.reserved_time else None,
                'reserved_end_time': order.reserved_end_time.isoformat() if order.reserved_end_time else None,
                'customer_count': order.customer_count,
                'user_name': order.user.username if order.user else None,
                'reservation_status': order.reservation_status
            })
        
        return jsonify({
            'success': True,
            'data': {
                'table': {
                    'id': table.id,
                    'table_number': table.table_number,
                    'capacity': table.capacity,
                    'table_type': table.table_type
                },
                'date': filter_date.isoformat(),
                'schedule': schedule
            }
        })
        
    except Exception as e:
        print(f"获取桌位时间表失败: {e}")
        return jsonify({'success': False, 'message': '获取桌位时间表失败', 'error': str(e)}), 500


@merchant_bp.route('/reviews', methods=['GET'])
@token_required
def merchant_get_reviews():
    try:
        current_user = g.current_user
        if current_user.usertype != 1:
            return jsonify({'success': False, 'message': '只有商家可以访问'}), 403

        restaurant = Restaurant.query.filter_by(user_id=current_user.id).first()
        if not restaurant:
            return jsonify({'success': False, 'message': '未找到商家餐厅'}), 404

        # 商家端仅显示管理员审核通过的评论（客户可见评论）
        reviews = Review.query.filter_by(restaurant_id=restaurant.id, status='normal', review_status='approved').order_by(Review.created_at.desc()).all()
        return jsonify({'success': True, 'data': {'reviews': [r.to_dict() for r in reviews]}}), 200
    except Exception as e:
        print(f"商家获取评价失败: {e}")
        return jsonify({'success': False, 'message': '获取失败', 'error': str(e)}), 500


@merchant_bp.route('/reviews/<int:review_id>/reply', methods=['POST'])
@token_required
def merchant_reply_review(review_id):
    try:
        current_user = g.current_user
        if current_user.usertype != 1:
            return jsonify({'success': False, 'message': '只有商家可以回复'}), 403

        restaurant = Restaurant.query.filter_by(user_id=current_user.id).first()
        if not restaurant:
            return jsonify({'success': False, 'message': '未找到商家餐厅'}), 404

        review = Review.query.get(review_id)

        if not review or review.restaurant_id != restaurant.id:
             return jsonify({'success': False, 'message': '评价不存在或无权回复'}), 404
        if review.review_status != 'approved':
            return jsonify({'success': False, 'message': '仅可回复已通过审核的评论'}), 400

        data = request.get_json() or {}
        reply = (data.get('reply') or '').strip()
        if not reply:
            return jsonify({'success': False, 'message': '回复内容不能为空'}), 400

        review.merchant_reply = reply
        review.merchant_reply_time = datetime.utcnow()
        review.updated_at = datetime.utcnow()
        db.session.commit()

        return jsonify({'success': True, 'message': '回复已保存', 'data': review.to_dict()}), 200
    except Exception as e:
        db.session.rollback()
        print(f"商家回复失败: {e}")
        return jsonify({'success': False, 'message': '回复失败', 'error': str(e)}), 500

# 商家获取订单列表
@merchant_bp.route('/orders', methods=['GET'])
@token_required
def get_merchant_orders():
    """商家获取自己餐厅的订单列表"""
    try:
        current_user = g.current_user
        
        # 验证用户是否为商家
        if current_user.usertype != 1:
            return jsonify({'success': False, 'message': '只有商家可以访问此接口'}), 403
        
        # 获取商家的餐厅
        restaurant = Restaurant.query.filter_by(user_id=current_user.id).first()
        if not restaurant:
            return jsonify({'success': False, 'message': '未找到餐厅信息'}), 404
        
        # 获取订单状态筛选参数
        status_filter = request.args.get('status')
        
        # 构建查询
        query = Order.query.filter_by(restaurant_id=restaurant.id)
        
        if status_filter:
            query = query.filter_by(status=status_filter)
        
        # 按时间倒序排列
        orders = query.order_by(Order.order_time.desc()).all()
        
        # 转换为字典列表
        orders_data = []
        for order in orders:
            order_dict = order.to_dict()
            # 添加用户信息
            user = User.query.get(order.user_id)
            if user:
                order_dict['customer_name'] = user.username
                order_dict['customer_phone'] = user.phone
            
            # 添加订单项信息
            items = []
            for item in order.items.all():
                items.append(item.to_dict())
            order_dict['items'] = items
            orders_data.append(order_dict)
        
        return jsonify({
            'success': True,
            'data': orders_data
        }), 200
        
    except Exception as e:
        print(f"获取商家订单列表失败: {e}")
        return jsonify({'success': False, 'message': '获取订单列表失败', 'error': str(e)}), 500

# 商家接单
@merchant_bp.route('/orders/<int:order_id>/accept', methods=['POST'])
@token_required
def accept_order(order_id):
    """商家接单"""
    try:
        current_user = g.current_user
        
        # 验证用户是否为商家
        if current_user.usertype != 1:
            return jsonify({'success': False, 'message': '只有商家可以访问此接口'}), 403
        
        # 获取商家的餐厅
        restaurant = Restaurant.query.filter_by(user_id=current_user.id).first()
        if not restaurant:
            return jsonify({'success': False, 'message': '未找到餐厅信息'}), 404
        
        # 查询订单
        order = Order.query.get(order_id)
        if not order:
            return jsonify({'success': False, 'message': '订单不存在'}), 404
        
        # 验证订单所属餐厅
        if order.restaurant_id != restaurant.id:
            return jsonify({'success': False, 'message': '无权操作此订单'}), 403
        
        # 验证订单状态
        if order.status != 'pending':
            return jsonify({'success': False, 'message': '订单状态不允许接单'}), 400
        
        # 更新订单状态
        order.status = 'confirmed'
        order.confirmed_time = datetime.utcnow()
        
        # 生成取单号（传入餐厅ID以避免重复）
        order.pickup_number = Order.generate_pickup_number(restaurant.id)
        
        # 如果是堂食订单且有桌位，更新桌位状态
        if order.order_type == 'dinein' and order.table_id:
            table = Table.query.get(order.table_id)
            if table:
                # 检查该桌位是否已满
                current_occupancy = table.get_current_occupancy()
                if current_occupancy >= table.capacity:
                    table.status = 'occupied'  # 桌位已满
                # 如果是独立桌位，直接标记为占用
                elif table.table_type == 'private':
                    table.status = 'occupied'
        
        db.session.commit()
        
        return jsonify({
            'success': True,
            'message': '接单成功',
            'data': {
                'order_id': order.id,
                'pickup_number': order.pickup_number
            }
        }), 200
        
    except Exception as e:
        db.session.rollback()
        print(f"接单失败: {e}")
        return jsonify({'success': False, 'message': '接单失败', 'error': str(e)}), 500

# 商家拒单
@merchant_bp.route('/orders/<int:order_id>/reject', methods=['POST'])
@token_required
def reject_order(order_id):
    """商家拒单"""
    try:
        current_user = g.current_user
        data = request.get_json()
        
        # 验证用户是否为商家
        if current_user.usertype != 1:
            return jsonify({'success': False, 'message': '只有商家可以访问此接口'}), 403
        
        # 获取商家的餐厅
        restaurant = Restaurant.query.filter_by(user_id=current_user.id).first()
        if not restaurant:
            return jsonify({'success': False, 'message': '未找到餐厅信息'}), 404
        
        # 查询订单
        order = Order.query.get(order_id)
        if not order:
            return jsonify({'success': False, 'message': '订单不存在'}), 404
        
        # 验证订单所属餐厅
        if order.restaurant_id != restaurant.id:
            return jsonify({'success': False, 'message': '无权操作此订单'}), 403
        
        # 验证订单状态
        if order.status != 'pending':
            return jsonify({'success': False, 'message': '订单状态不允许拒单'}), 400
        
        # 获取拒绝理由
        reject_reason = data.get('reason', '').strip()
        if not reject_reason:
            return jsonify({'success': False, 'message': '请填写拒绝理由'}), 400

        # 拒单返还库存：把订单中每项的数量加回到对应菜品
        for existing_item in order.items.all():
            try:
                if existing_item.dish and existing_item.dish.stock_quantity is not None:
                    existing_item.dish.update_stock(
                        existing_item.quantity,
                        'return',
                        current_user.id,
                        f'订单 {order.order_number} 商家拒单返还'
                    )
            except Exception:
                merchant_logger.exception(
                    f"拒单返还库存失败：order_id={order.id}, item_id={getattr(existing_item, 'id', None)}"
                )

        # 释放桌位（如果有）
        if order.table_id:
            try:
                table = Table.query.get(order.table_id)
                if table:
                    table.status = 'available'
                    table.updated_at = datetime.utcnow()
            except Exception:
                merchant_logger.exception(
                    f"拒单释放桌位失败：order_id={order.id}, table_id={order.table_id}"
                )
        
        # 更新订单状态
        order.status = 'rejected'
        order.reject_reason = reject_reason
        order.cancelled_time = datetime.utcnow()
        order.updated_at = datetime.utcnow()
        
        db.session.commit()
        
        return jsonify({
            'success': True,
            'message': '已拒绝订单',
            'data': {
                'order_id': order.id
            }
        }), 200
        
    except Exception as e:
        db.session.rollback()
        print(f"拒单失败: {e}")
        return jsonify({'success': False, 'message': '拒单失败', 'error': str(e)}), 500

@merchant_bp.route('/orders/<int:order_id>/serve', methods=['POST'])
@token_required
def serve_order(order_id):
    """出餐：confirmed→(堂食)dining / (外带)completed"""
    try:
        current_user = g.current_user
        if current_user.usertype != 1:
            return jsonify({'success': False, 'message': '只有商家可以操作订单'}), 403

        restaurant = Restaurant.query.filter_by(user_id=current_user.id).first()
        if not restaurant:
            return jsonify({'success': False, 'message': '未找到商家餐厅'}), 404

        order = Order.query.get(order_id)
        if not order or order.restaurant_id != restaurant.id:
            return jsonify({'success': False, 'message': '订单不存在'}), 404

        if order.status != 'confirmed':
            return jsonify({'success': False, 'message': '仅可对已确认订单出餐'}), 400

        dine_in_types = {'dinein', 'dine_in', 'dine-in'}
        takeout_types = {'takeout', 'take_out', 'take-out'}

        table = Table.query.get(order.table_id) if order.table_id else None
        if order.order_type in dine_in_types:
            order.status = 'dining'
            if table:
                table.status = 'occupied'
                table.updated_at = datetime.utcnow()
        else:
            order.status = 'completed'
            order.completed_time = datetime.utcnow()
            _create_pickup_notification(order, current_user.id)
            if table:
                table.status = 'available'
                table.updated_at = datetime.utcnow()

        order.updated_at = datetime.utcnow()
        db.session.commit()

        return jsonify({'success': True, 'message': '出餐成功', 'data': order.to_dict()}), 200
    except Exception as exc:
        db.session.rollback()
        merchant_logger.error(f"出餐失败: {exc}")
        return jsonify({'success': False, 'message': '出餐失败', 'error': str(exc)}), 500


@merchant_bp.route('/orders/<int:order_id>/release-seat', methods=['POST'])
@token_required
def release_dine_in_order(order_id):
    """堂食释放座位：dining→completed"""
    try:
        current_user = g.current_user
        if current_user.usertype != 1:
            return jsonify({'success': False, 'message': '只有商家可以操作订单'}), 403

        restaurant = Restaurant.query.filter_by(user_id=current_user.id).first()
        if not restaurant:
            return jsonify({'success': False, 'message': '未找到商家餐厅'}), 404

        order = Order.query.get(order_id)
        if not order or order.restaurant_id != restaurant.id:
            return jsonify({'success': False, 'message': '订单不存在'}), 404

        dine_in_types = {'dinein', 'dine_in', 'dine-in'}
        if order.order_type not in dine_in_types:
            return jsonify({'success': False, 'message': '仅堂食订单需要释放座位'}), 400

        if order.status != 'dining':
            return jsonify({'success': False, 'message': '仅可释放用餐中的订单'}), 400

        table = Table.query.get(order.table_id) if order.table_id else None
        if table:
            table.status = 'available'
            table.updated_at = datetime.utcnow()

        order.status = 'completed'
        order.completed_time = datetime.utcnow()
        order.updated_at = datetime.utcnow()
        db.session.commit()

        return jsonify({'success': True, 'message': '座位已释放，订单完成', 'data': order.to_dict()}), 200
    except Exception as exc:
        db.session.rollback()
        merchant_logger.error(f"释放座位失败: {exc}")
        return jsonify({'success': False, 'message': '释放座位失败', 'error': str(exc)}), 500

@merchant_bp.route('/orders/change-requests', methods=['GET'])
@token_required
def merchant_list_change_requests():
    """商家查看订单修改/取消申请"""
    try:
        merchant = g.current_user
        if merchant.usertype != 1:
            return jsonify({'success': False, 'message': '只有商家可以访问'}), 403

        restaurant = Restaurant.query.filter_by(user_id=merchant.id).first()
        if not restaurant:
            return jsonify({'success': False, 'message': '未找到商家餐厅'}), 404

        status_filter = request.args.get('status')
        query = OrderChangeRequest.query.filter_by(restaurant_id=restaurant.id)
        if status_filter:
            query = query.filter_by(status=status_filter)

        change_requests = []
        for req in query.order_by(OrderChangeRequest.created_at.desc()).all():
            payload = req.to_dict()
            payload['order_number'] = req.order.order_number if req.order else None
            payload['order_status'] = req.order.status if req.order else None
            
            # 如果是修改申请，附带原始订单信息用于对比
            if req.order and req.request_type == 'modify':
                payload['original_order_details'] = {
                    'items': [item.to_dict() for item in req.order.items.all()],
                    'note': req.order.note,
                    'customer_count': req.order.customer_count
                }

            change_requests.append(payload)

        return jsonify({'success': True, 'data': change_requests}), 200
    except Exception as exc:
        merchant_logger.error(f"获取修改申请失败: {exc}")
        return jsonify({'success': False, 'message': '获取申请失败', 'error': str(exc)}), 500


@merchant_bp.route('/orders/change-requests/<int:request_id>', methods=['PATCH'])
@token_required
def merchant_handle_change_request(request_id):
    """商家审核订单修改/取消申请"""
    try:
        merchant = g.current_user
        if merchant.usertype != 1:
            return jsonify({'success': False, 'message': '只有商家可以访问'}), 403

        restaurant = Restaurant.query.filter_by(user_id=merchant.id).first()
        if not restaurant:
            return jsonify({'success': False, 'message': '未找到商家餐厅'}), 404

        change_request = OrderChangeRequest.query.get(request_id)
        if not change_request:
            return jsonify({'success': False, 'message': '申请单不存在'}), 404
        order = Order.query.get(change_request.order_id)
        if not order:
            # 如果订单不存在，则无法继续，直接提交状态变更
            db.session.commit()
            return jsonify({'success': True, 'message': '处理完成（关联订单不存在）', 'data': change_request.to_dict()}), 200

        # 验证权限：确保该申请属于当前用户
        if change_request.restaurant_id != restaurant.id:
            return jsonify({'success': False, 'message': '无权处理该申请'}), 403

        data = request.get_json() or {}
        new_status = data.get('status')
        if new_status not in {'approved', 'rejected'}:
            return jsonify({'success': False, 'message': '状态必须为 approved/rejected'}), 400

        change_request.status = new_status
        change_request.admin_note = data.get('note')
        change_request.updated_at = datetime.utcnow()

        # 如果申请被批准
        if new_status == 'approved':
            # 处理取消申请
            if change_request.request_type == 'cancel':
                if order.status not in {'cancelled', 'completed'}:
                    order.status = 'cancelled'
                    order.cancelled_time = datetime.utcnow()
                    if order.table_id:
                        table = Table.query.get(order.table_id)
                        if table:
                            table.status = 'available'
                            table.updated_at = datetime.utcnow()
            
            # 处理修改申请
            elif change_request.request_type == 'modify':
                payload = change_request.payload
                if not payload or not payload.get('items'):
                    change_request.status = 'rejected'
                    change_request.admin_note = '系统拒绝：修改内容为空'
                    db.session.commit()
                    return jsonify({'success': False, 'message': '申请的修改内容为空，已自动拒绝'}), 400
                # --- 1. 归还旧订单项的库存 ---
                for item in order.items:
                    if item.dish and item.dish.stock_quantity is not None:
                        item.dish.update_stock(item.quantity,'return', restaurant.id, f'订单 {order.order_number} 修改，返还')

                # 使用 validate_order_items 验证新订单项并计算总价
                validated_items, total_price = validate_order_items(order.restaurant_id, payload['items'])

                # 清空旧的订单项
                for item in order.items.all():
                    db.session.delete(item)
                db.session.flush()
                
                # 添加新的订单项并扣减新库存
                for item_data in validated_items:
                    order_item = OrderItem(
                        dish_id=item_data['dish'].dish_id,
                        quantity=item_data['quantity'],
                        unit_price=item_data['unit_price'],
                        subtotal=item_data['subtotal'],
                        spiciness=item_data.get('spiciness'),
                        garnish=item_data.get('garnish')
                    )
                    order.items.append(order_item)
                    # --- 2. 扣减新订单项的库存 ---
                    if item_data['dish'].stock_quantity is not None:
                        item_data['dish'].update_stock(-item_data['quantity'],'update', restaurant.id, f'订单 {order.order_number} 修改，新增')

                # 更新订单主信息
                order.total_price = total_price
                order.note = payload.get('note', order.note)
                order.customer_count = payload.get('customer_count', order.customer_count)
                # 如果 payload 中包含 table_id，也一并更新
                if 'table_id' in payload:
                    order.table_id = payload.get('table_id')
                
                order.updated_at = datetime.utcnow()

        db.session.commit()
        return jsonify({'success': True, 'message': '处理完成', 'data': change_request.to_dict()}), 200
    except Exception as exc:
        db.session.rollback()
        merchant_logger.error(f"处理修改申请失败: {exc}")
        return jsonify({'success': False, 'message': '处理失败', 'error': str(exc)}), 500

# ==================== 数据统计可视化 API ====================

@merchant_bp.route('/statistics/overview', methods=['GET'])
@token_required
def get_statistics_overview():
    """获取运营数据概览（核心指标）"""
    try:
        user = g.current_user
        
        # 获取商家的餐厅信息
        restaurant = Restaurant.query.filter_by(user_id=user.id).first()
        if not restaurant:
            return jsonify({
                'success': False,
                'message': '未找到餐厅信息'
            }), 404
        
        # 获取筛选参数（前端按其 timezone 传入；DB 存 UTC，这里统一转 UTC 查询）
        start_date_str = request.args.get('start_date')
        end_date_str = request.args.get('end_date')
        tz_name = request.args.get('timezone')
        time_zone, local_start, local_end, start_date, end_date = _parse_range_from_frontend(
            start_date_str,
            end_date_str,
            tz_name,
            default_days=7
        )
        
        # 构建基础查询
        base_query = Order.query.filter(
            Order.restaurant_id == restaurant.id,
            Order.order_time >= start_date,
            Order.order_time <= end_date
        )
        
        # 计算核心指标
        # 1. 总订单量
        total_orders = base_query.count()
        
        # 2. 已完成订单
        completed_orders = base_query.filter(Order.status == 'completed').all()
        completed_count = len(completed_orders)
        
        # 3. 总营业额（已完成订单的总金额）
        total_revenue = sum(order.total_price for order in completed_orders) if completed_orders else 0
        
        # 4. 客单价（人均消费）
        avg_order_value = total_revenue / completed_count if completed_count > 0 else 0
        
        # 5. 订单取消率
        cancelled_count = base_query.filter(Order.status.in_(['cancelled', 'rejected'])).count()
        cancellation_rate = (cancelled_count / total_orders * 100) if total_orders > 0 else 0
        
        # 6. 在售菜品数
        active_dishes_count = Dish.query.filter_by(
            restaurant_id=restaurant.id,
            status='available'
        ).count()
        
        # 计算环比数据（与上一周期对比）
        duration = end_date - start_date
        if duration.total_seconds() <= 0:
            duration = timedelta(days=1)
        previous_start = start_date - duration
        previous_end = start_date
        
        previous_query = Order.query.filter(
            Order.restaurant_id == restaurant.id,
            Order.order_time >= previous_start,
            Order.order_time < previous_end
        )
        
        previous_total_orders = previous_query.count()
        previous_completed = previous_query.filter(Order.status == 'completed').all()
        previous_revenue = sum(order.total_price for order in previous_completed) if previous_completed else 0
        
        # 计算增长率
        def calculate_growth_rate(current, previous):
            if previous == 0:
                return 100 if current > 0 else 0
            return ((current - previous) / previous) * 100
        
        orders_growth = calculate_growth_rate(total_orders, previous_total_orders)
        revenue_growth = calculate_growth_rate(total_revenue, previous_revenue)
        
        return jsonify({
            'success': True,
            'data': {
                'total_orders': total_orders,
                'total_revenue': round(total_revenue, 2),
                'avg_order_value': round(avg_order_value, 2),
                'cancellation_rate': round(cancellation_rate, 2),
                'active_dishes': active_dishes_count,
                'completed_orders': completed_count,
                'orders_growth': round(orders_growth, 2),
                'revenue_growth': round(revenue_growth, 2),
                'period': {
                    'start': (local_start.isoformat() if local_start else start_date.isoformat()),
                    'end': (local_end.isoformat() if local_end else end_date.isoformat()),
                    'timezone': str(tz_name or 'UTC')
                }
            }
        }), 200
        
    except Exception as e:
        print(f"获取统计概览失败: {e}")
        import traceback
        traceback.print_exc()
        return jsonify({
            'success': False,
            'message': f'获取统计数据失败: {str(e)}'
        }), 500


@merchant_bp.route('/statistics/trend', methods=['GET'])
@token_required
def get_order_trend():
    """获取订单趋势数据（订单量和营业额随时间变化）"""
    try:
        user = g.current_user
        restaurant = Restaurant.query.filter_by(user_id=user.id).first()
        
        if not restaurant:
            return jsonify({
                'success': False,
                'message': '未找到餐厅信息'
            }), 404
        
        # 获取筛选参数（前端时区 -> UTC 查询；趋势按“前端时区的日期”聚合）
        start_date_str = request.args.get('start_date')
        end_date_str = request.args.get('end_date')
        tz_name = request.args.get('timezone')
        time_zone, local_start, local_end, start_date, end_date = _parse_range_from_frontend(
            start_date_str,
            end_date_str,
            tz_name,
            default_days=30
        )
        
        # 查询订单数据
        orders = Order.query.filter(
            Order.restaurant_id == restaurant.id,
            Order.order_time >= start_date,
            Order.order_time <= end_date
        ).all()
        
        # 按日期分组统计
        trend_data = {}
        for order in orders:
            order_time = order.order_time
            if order_time is None:
                continue
            if getattr(order_time, 'tzinfo', None) is None:
                order_time = order_time.replace(tzinfo=timezone.utc)
            local_time = order_time.astimezone(time_zone)
            date_key = local_time.strftime('%Y-%m-%d')
            
            if date_key not in trend_data:
                trend_data[date_key] = {
                    'date': date_key,
                    'order_count': 0,
                    'revenue': 0,
                    'completed_count': 0
                }
            
            trend_data[date_key]['order_count'] += 1
            
            if order.status == 'completed':
                trend_data[date_key]['completed_count'] += 1
                trend_data[date_key]['revenue'] += order.total_price
        
        # 填充缺失的日期（使订单量为0）
        # 填充缺失的日期（按前端时区的“自然日”补齐）
        fill_start = (local_start.date() if local_start else start_date.astimezone(time_zone).date())
        fill_end = (local_end.date() if local_end else end_date.astimezone(time_zone).date())
        current_date = fill_start
        while current_date <= fill_end:
            date_key = current_date.strftime('%Y-%m-%d')
            if date_key not in trend_data:
                trend_data[date_key] = {
                    'date': date_key,
                    'order_count': 0,
                    'revenue': 0,
                    'completed_count': 0
                }
            current_date += timedelta(days=1)
        
        # 排序并转换为列表
        sorted_trend = sorted(trend_data.values(), key=lambda x: x['date'])
        
        return jsonify({
            'success': True,
            'data': {
                'trend': sorted_trend
            }
        }), 200
        
    except Exception as e:
        print(f"获取订单趋势失败: {e}")
        import traceback
        traceback.print_exc()
        return jsonify({
            'success': False,
            'message': f'获取趋势数据失败: {str(e)}'
        }), 500


@merchant_bp.route('/statistics/peak-hours', methods=['GET'])
@token_required
def get_peak_hours():
    """获取热门时段数据（按小时统计订单分布）"""
    try:
        user = g.current_user
        restaurant = Restaurant.query.filter_by(user_id=user.id).first()
        
        if not restaurant:
            return jsonify({
                'success': False,
                'message': '未找到餐厅信息'
            }), 404
        
        # 获取筛选参数（前端时区 -> UTC 查询；小时统计按前端时区的小时）
        start_date_str = request.args.get('start_date')
        end_date_str = request.args.get('end_date')
        tz_name = request.args.get('timezone')
        time_zone, local_start, local_end, start_date, end_date = _parse_range_from_frontend(
            start_date_str,
            end_date_str,
            tz_name,
            default_days=7
        )
        
        # 查询订单数据
        orders = Order.query.filter(
            Order.restaurant_id == restaurant.id,
            Order.order_time >= start_date,
            Order.order_time <= end_date
        ).all()
        
        # 按小时统计
        hour_stats = {hour: 0 for hour in range(24)}
        
        for order in orders:
            order_time = order.order_time
            # 数据库存的时间通常为 UTC（可能是 naive datetime）。这里统一按 UTC 解释后再转到请求时区。
            if order_time is None:
                continue
            if getattr(order_time, 'tzinfo', None) is None:
                order_time = order_time.replace(tzinfo=timezone.utc)
            try:
                local_time = order_time.astimezone(time_zone)
            except Exception:
                local_time = order_time.astimezone(timezone.utc)

            hour = local_time.hour
            hour_stats[hour] += 1
        # 转换为列表格式
        peak_hours_data = [
            {
                'hour': f'{hour:02d}:00',
                'order_count': count
            }
            for hour, count in sorted(hour_stats.items())
        ]
        
        return jsonify({
            'success': True,
            'data': {
                'peak_hours': peak_hours_data
            }
        }), 200
        
    except Exception as e:
        print(f"获取热门时段失败: {e}")
        import traceback
        traceback.print_exc()
        return jsonify({
            'success': False,
            'message': f'获取时段数据失败: {str(e)}'
        }), 500


@merchant_bp.route('/statistics/top-dishes', methods=['GET'])
@token_required
def get_top_dishes():
    """获取热门菜品排行榜"""
    try:
        user = g.current_user
        restaurant = Restaurant.query.filter_by(user_id=user.id).first()
        
        if not restaurant:
            return jsonify({
                'success': False,
                'message': '未找到餐厅信息'
            }), 404
        
        # 获取筛选参数（前端时区 -> UTC 查询）
        start_date_str = request.args.get('start_date')
        end_date_str = request.args.get('end_date')
        tz_name = request.args.get('timezone')
        time_zone, local_start, local_end, start_date, end_date = _parse_range_from_frontend(
            start_date_str,
            end_date_str,
            tz_name,
            default_days=7
        )
        
        limit = request.args.get('limit', 10, type=int)
        
        # 查询订单项并统计菜品销量
        dish_sales = db.session.query(
            OrderItem.dish_id,
            Dish.name,
            Dish.category,
            func.sum(OrderItem.quantity).label('total_quantity'),
            func.sum(OrderItem.subtotal).label('total_revenue')
        ).join(
            Order, OrderItem.order_id == Order.id
        ).join(
            Dish, OrderItem.dish_id == Dish.dish_id
        ).filter(
            Order.restaurant_id == restaurant.id,
            Order.order_time >= start_date,
            Order.order_time <= end_date,
            Order.status == 'completed'
        ).group_by(
            OrderItem.dish_id, Dish.name, Dish.category
        ).order_by(
            func.sum(OrderItem.quantity).desc()
        ).limit(limit).all()
        
        # 转换为字典格式
        top_dishes_data = [
            {
                'dish_id': item.dish_id,
                'dish_name': item.name,
                'category': item.category or '未分类',
                'sales_count': int(item.total_quantity),
                'revenue': round(float(item.total_revenue), 2)
            }
            for item in dish_sales
        ]
        
        return jsonify({
            'success': True,
            'data': {
                'top_dishes': top_dishes_data
            }
        }), 200
        
    except Exception as e:
        print(f"获取热门菜品失败: {e}")
        import traceback
        traceback.print_exc()
        return jsonify({
            'success': False,
            'message': f'获取菜品数据失败: {str(e)}'
        }), 500


@merchant_bp.route('/statistics/order-status', methods=['GET'])
@token_required
def get_order_status_distribution():
    """获取订单状态分布"""
    try:
        user = g.current_user
        restaurant = Restaurant.query.filter_by(user_id=user.id).first()
        
        if not restaurant:
            return jsonify({
                'success': False,
                'message': '未找到餐厅信息'
            }), 404
        
        # 获取筛选参数（前端时区 -> UTC 查询）
        start_date_str = request.args.get('start_date')
        end_date_str = request.args.get('end_date')
        tz_name = request.args.get('timezone')
        time_zone, local_start, local_end, start_date, end_date = _parse_range_from_frontend(
            start_date_str,
            end_date_str,
            tz_name,
            default_days=30
        )
        
        # 查询订单状态统计
        status_stats = db.session.query(
            Order.status,
            func.count(Order.id).label('count')
        ).filter(
            Order.restaurant_id == restaurant.id,
            Order.order_time >= start_date,
            Order.order_time <= end_date
        ).group_by(Order.status).all()
        
        # 状态名称映射
        status_names = {
            'pending': '待接单',
            'confirmed': '已接单',
            'dining': '用餐中',
            'completed': '已完成',
            'cancelled': '已取消',
            'rejected': '已拒绝'
        }
        
        # 转换为字典格式
        status_data = [
            {
                'status': item.status,
                'status_name': status_names.get(item.status, item.status),
                'count': item.count
            }
            for item in status_stats
        ]
        
        return jsonify({
            'success': True,
            'data': {
                'status_distribution': status_data
            }
        }), 200
        
    except Exception as e:
        print(f"获取订单状态分布失败: {e}")
        import traceback
        traceback.print_exc()
        return jsonify({
            'success': False,
            'message': f'获取状态数据失败: {str(e)}'
        }), 500


@merchant_bp.route('/statistics/category-share', methods=['GET'])
@token_required
def get_category_share():
    """获取菜品分类销售占比"""
    try:
        user = g.current_user
        restaurant = Restaurant.query.filter_by(user_id=user.id).first()
        
        if not restaurant:
            return jsonify({
                'success': False,
                'message': '未找到餐厅信息'
            }), 404
        
        # 获取筛选参数（前端时区 -> UTC 查询）
        start_date_str = request.args.get('start_date')
        end_date_str = request.args.get('end_date')
        tz_name = request.args.get('timezone')
        time_zone, local_start, local_end, start_date, end_date = _parse_range_from_frontend(
            start_date_str,
            end_date_str,
            tz_name,
            default_days=30
        )
        
        # 查询菜品分类销售统计
        category_stats = db.session.query(
            Dish.category,
            func.sum(OrderItem.quantity).label('total_quantity'),
            func.sum(OrderItem.subtotal).label('total_revenue')
        ).join(
            Order, OrderItem.order_id == Order.id
        ).join(
            Dish, OrderItem.dish_id == Dish.dish_id
        ).filter(
            Order.restaurant_id == restaurant.id,
            Order.order_time >= start_date,
            Order.order_time <= end_date,
            Order.status == 'completed'
        ).group_by(Dish.category).all()
        
        # 转换为字典格式
        category_data = [
            {
                'category': item.category or '未分类',
                'sales_count': int(item.total_quantity),
                'revenue': round(float(item.total_revenue), 2)
            }
            for item in category_stats
        ]
        
        return jsonify({
            'success': True,
            'data': {
                'category_share': category_data
            }
        }), 200
        
    except Exception as e:
        print(f"获取分类占比失败: {e}")
        import traceback
        traceback.print_exc()
        return jsonify({
            'success': False,
            'message': f'获取分类数据失败: {str(e)}'
        }), 500


@merchant_bp.route('/statistics/review-wordcloud', methods=['GET'])
@token_required
def get_review_wordcloud():
    """获取评论词云数据"""
    try:
        user_id = g.current_user.id
        # 直接查询数据库获取餐厅对象，而不是使用返回字典的辅助函数
        restaurant = Restaurant.query.filter_by(user_id=user_id).first()
        
        if not restaurant:
            return jsonify({'success': False, 'message': '未找到餐厅信息'}), 404
            
        # 获取筛选参数（前端时区 -> UTC 查询；这里 start/end 通常为 YYYY-MM-DD）
        start_date_str = request.args.get('start_date')
        end_date_str = request.args.get('end_date')
        tz_name = request.args.get('timezone')
        time_zone = _safe_zoneinfo(tz_name)
        
        # 构建查询 - 只统计已审核通过的评论
        query = Review.query.join(Order).filter(
            Order.restaurant_id == restaurant.id,
            Review.review_status == 'approved'  # 只统计审核通过的评论
        )
        
        if start_date_str:
            _, utc_start = _localize_iso(start_date_str, time_zone, is_end=False)
            if utc_start:
                query = query.filter(Review.created_at >= utc_start)

        if end_date_str:
            # 结束日期按“当天结束”处理，因此使用 is_end=True 并以 <= 结束；这里用 < next_day_start 更安全
            local_end, utc_end = _localize_iso(end_date_str, time_zone, is_end=True)
            if utc_end:
                query = query.filter(Review.created_at <= utc_end)
            
        reviews = query.all()
        
        # print(start_date_str, end_date_str)

        # 提取所有评论内容
        text = "".join([r.content for r in reviews if r.content])
        
        # 使用jieba分词
        # 加载停用词（这里简单定义一些常见的中文停用词）
        stop_words = set(['的', '了', '和', '是', '就', '都', '而', '及', '与', '着', '或', '一个', '没有', '我们', '你们', '他们', '它', '在', '有', '个', '好', '我', '也', '很', '不', '去', '吃', '点', '来', '这', '那', '吗', '吧', '啊', '呢', '嘛', '但是', '虽然', '因为', '所以', '如果', '而且', '还是', '或者', '不过', '只是', '比如', '例如', '像', '如', '对于', '关于', '至于', '根据', '按照', '通过', '由于', '为了', '以便', '从而', '因此', '于是', '然后', '接着', '最后', '总之', '综上所述', '总而言之', '一般', '通常', '往往', '经常', '总是', '一直', '曾经', '已经', '正在', '将要', '能够', '可以', '必须', '应该', '需要', '值得', '可能', '也许', '大概', '恐怕', '似乎', '好像', '仿佛', '确实', '真的', '实在', '非常', '特别', '尤其', '极其', '相当', '十分', '比较', '稍微', '有点', '几乎', '简直', '太', '更', '最', '越', '再', '又', '还', '也', '才', '就', '便', '即', '只', '仅', '光', '单', '净', '老', '总', '光', '净', '唯', '仅', '但', '却', '可', '倒', '并', '给', '让', '叫', '被', '把', '将', '由', '从', '自', '向', '往', '在', '当', '于', '朝', '按', '照', '凭', '据', '依', '靠', '沿', '顺', '趁', '随着', '为了', '为', '因', '由于', '自', '从', '打', '到', '往', '在', '当', '朝', '向', '顺', '沿', '按', '照', '遵', '依', '靠', '本', '据', '凭', '论', '比', '同', '和', '跟', '与', '及', '或', '或者', '还是', '否则', '不然', '而', '而且', '并且', '况且', '何况', '以及', '从而', '因此', '因而', '所以', '以致', '致使', '因为', '由于', '虽然', '固然', '尽管', '纵然', '即使', '假如', '如果', '要是', '果真', '若', '倘若', '只要', '只有', '除非', '无论', '不管', '不论', '任凭', '以免', '以便', '为的是', '省得', '关于', '对于', '至于', '对', '向', '为了', '为', '给', '替', '帮', '叫', '让', '被', '把', '将', '比', '和', '跟', '同', '与', '及', '或', '或者', '还是', '否则', '不然', '而', '而且', '并且', '况且', '何况', '以及', '从而', '因此', '因而', '所以', '以致', '致使', '因为', '由于', '虽然', '固然', '尽管', '纵然', '即使', '假如', '如果', '要是', '果真', '若', '倘若', '只要', '只有', '除非', '无论', '不管', '不论', '任凭', '以免', '以便', '为的是', '省得', '！', '？', '，', '。', '、', '；', '：', '“', '”', '‘', '’', '（', '）', '【', '】', '《', '》', '…', '—', '·', ' '])
        
        words = jieba.cut(text)
        
        # 过滤停用词和单字
        filtered_words = [word for word in words if word not in stop_words and len(word) > 1 and not re.match(r'^\d+$', word)]
        
        # 统计词频
        word_counts = Counter(filtered_words)
        
        # 转换为前端需要的格式
        wordcloud_data = [{'name': word, 'value': count} for word, count in word_counts.most_common(100)]
        
        return jsonify({
            'success': True,
            'data': {
                'wordcloud': wordcloud_data
            }
        })
        
    except Exception as e:
        print(f"获取评论词云失败: {str(e)}")
        return jsonify({
            'success': False,
            'message': '获取数据失败'
        }), 500


@merchant_bp.route('/statistics/export', methods=['GET'])
@token_required
def export_statistics_report():
    """导出统计报表为Excel"""
    try:
        import pandas as pd
        from io import BytesIO
        
        user = g.current_user
        restaurant = Restaurant.query.filter_by(user_id=user.id).first()
        
        if not restaurant:
            return jsonify({
                'success': False,
                'message': '未找到餐厅信息'
            }), 404
        
        # 获取筛选参数（前端时区 -> UTC 查询；导出时间展示按前端时区）
        start_date_str = request.args.get('start_date')
        end_date_str = request.args.get('end_date')
        tz_name = request.args.get('timezone')
        time_zone, local_start, local_end, start_date, end_date = _parse_range_from_frontend(
            start_date_str,
            end_date_str,
            tz_name,
            default_days=30
        )
        
        # 创建Excel写入器
        output = BytesIO()
        writer = pd.ExcelWriter(output, engine='openpyxl')
        
        # 1. 订单明细表
        orders = Order.query.filter(
            Order.restaurant_id == restaurant.id,
            Order.order_time >= start_date,
            Order.order_time <= end_date
        ).all()
        
        orders_data = []
        for order in orders:
            order_time = order.order_time
            if order_time is not None and getattr(order_time, 'tzinfo', None) is None:
                order_time = order_time.replace(tzinfo=timezone.utc)
            order_time_local = order_time.astimezone(time_zone) if order_time is not None else None
            orders_data.append({
                '订单号': order.order_number,
                '订单时间': (order_time_local.strftime('%Y-%m-%d %H:%M:%S') if order_time_local else ''),
                '订单类型': '堂食' if order.order_type in ('dinein', 'dine_in', 'dine-in') else '外带',
                '桌号': order.table.table_number if order.table else '-',
                '就餐人数': order.customer_count,
                '订单状态': order.status,
                '订单金额': order.total_price,
                '备注': order.note or ''
            })
        
        df_orders = pd.DataFrame(orders_data)
        df_orders.to_excel(writer, sheet_name='订单明细', index=False)
        
        # 2. 热门菜品统计
        dish_sales = db.session.query(
            Dish.name,
            Dish.category,
            func.sum(OrderItem.quantity).label('sales_count'),
            func.sum(OrderItem.subtotal).label('revenue')
        ).join(
            Order, OrderItem.order_id == Order.id
        ).join(
            Dish, OrderItem.dish_id == Dish.dish_id
        ).filter(
            Order.restaurant_id == restaurant.id,
            Order.order_time >= start_date,
            Order.order_time <= end_date,
            Order.status == 'completed'
        ).group_by(Dish.name, Dish.category).order_by(
            func.sum(OrderItem.quantity).desc()
        ).all()
        
        dishes_data = [{
            '菜品名称': item.name,
            '分类': item.category or '未分类',
            '销售数量': int(item.sales_count),
            '销售金额': round(float(item.revenue), 2)
        } for item in dish_sales]
        
        df_dishes = pd.DataFrame(dishes_data)
        df_dishes.to_excel(writer, sheet_name='菜品销售统计', index=False)
        
        # 3. 每日汇总统计
        trend_data = {}
        for order in orders:
            date_key = order.order_time.strftime('%Y-%m-%d')
            
            if date_key not in trend_data:
                trend_data[date_key] = {
                    '日期': date_key,
                    '订单总数': 0,
                    '完成订单': 0,
                    '取消订单': 0,
                    '营业额': 0
                }
            
            trend_data[date_key]['订单总数'] += 1
            
            if order.status == 'completed':
                trend_data[date_key]['完成订单'] += 1
                trend_data[date_key]['营业额'] += order.total_price
            elif order.status in ['cancelled', 'rejected']:
                trend_data[date_key]['取消订单'] += 1
        
        df_trend = pd.DataFrame(list(trend_data.values()))
        try:
            df_trend = df_trend.sort_values('日期')
        except:
            print("报表为空")
            
        df_trend.to_excel(writer, sheet_name='每日汇总', index=False)
        
        # 保存Excel
        writer.close()
        output.seek(0)
        
        # 生成文件名
        filename = f"{restaurant.name}_统计报表_{start_date.strftime('%Y%m%d')}_{end_date.strftime('%Y%m%d')}.xlsx"
        
        return send_file(
            output,
            mimetype='application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
            as_attachment=True,
            download_name=filename
        )
        
    except Exception as e:
        print(f"导出报表失败: {e}")
        import traceback
        traceback.print_exc()
        return jsonify({
            'success': False,
            'message': f'导出失败: {str(e)}'
        }), 500



# ===== 库存统计 API =====
@merchant_bp.route('/stock/options', methods=['GET'])
@token_required
def get_stock_options():
    """获取库存统计筛选项（分类）"""
    try:
        user = g.current_user
        if user.usertype != 1:
            return jsonify({'success': False, 'message': '只有商家可以访问'}), 403
        
        restaurant = Restaurant.query.filter_by(user_id=user.id).first()
        if not restaurant:
            return jsonify({'success': False, 'message': '未找到餐厅'}), 404

        # 分类：从菜品中获取唯一分类
        categories = db.session.query(Dish.category).filter(
            Dish.restaurant_id == restaurant.id
        ).distinct().all()
        categories = [{'id': cat[0], 'name': cat[0]} for cat in categories if cat[0]]
        
        return jsonify({'success': True, 'data': {'categories': categories}}), 200
    except Exception as e:
        return jsonify({'success': False, 'message': f'获取选项失败: {str(e)}'}), 500


@merchant_bp.route('/stock/statistics/overview', methods=['GET'])
@token_required
def get_stock_overview():
    try:
        user = g.current_user
        restaurant = Restaurant.query.filter_by(user_id=user.id).first()
        if not restaurant:
            return jsonify({'success': False, 'message': '未找到餐厅'}), 404
        
        # 1. 获取参数
        start_date_str = request.args.get('start_date')
        end_date_str = request.args.get('end_date')
        time_zone = request.args.get('timezone')
        time_zone = ZoneInfo(time_zone)
        category = request.args.get('category')

        # 2. 处理日期 (增加容错)
        try:
            if not start_date_str or not end_date_str:
                end_date = datetime.utcnow()
                start_date = end_date - timedelta(days=30)
            else:
                # 截取前10位 YYYY-MM-DD 防止前端发来 ISO 格式带时间
                start_date = datetime.strptime(start_date_str[:10], '%Y-%m-%d')
                end_date = datetime.strptime(end_date_str[:10], '%Y-%m-%d').replace(hour=23, minute=59, second=59)
                start_date = start_date.replace(tzinfo=time_zone).astimezone(timezone.utc)
                end_date = end_date.replace(tzinfo=time_zone).astimezone(timezone.utc)

        except ValueError as e:
            print(f"日期解析错误: {e}")
            return jsonify({'success': False, 'message': '日期格式错误'}), 400

        # 3. 基础过滤条件 (列表法)
        dish_filters = [Dish.restaurant_id == restaurant.id]
        if category and category.strip():
            dish_filters.append(Dish.category == category)
        
        # --- 查询 A: 当前库存 (实时，不随时间变动) ---
        total_quantity = db.session.query(func.sum(Dish.stock_quantity)).filter(*dish_filters).scalar() or 0
        total_cost = db.session.query(func.sum(Dish.original_price * Dish.stock_quantity)).filter(*dish_filters).scalar() or 0
        
        # --- 查询 B: 期间补货 ---
        restock_filters = [
            StockLog.restaurant_id == restaurant.id,
            StockLog.change_type.in_(['restock', 'update']),
            StockLog.created_at >= start_date,
            StockLog.created_at <= end_date
        ]
        if category and category.strip():
            # 使用 join 来通过 dish 过滤
            restock_filters.append(StockLog.dish.has(category=category))

        total_in = db.session.query(func.sum(StockLog.quantity_change)).filter(*restock_filters).scalar() or 0
        cost_in = db.session.query(func.sum(StockLog.cost)).filter(*restock_filters).scalar() or 0
        
        # --- 查询 C: 期间消耗 ---
        out_filters = [
            StockLog.restaurant_id == restaurant.id,
            StockLog.change_type.in_(['sales', 'loss']),
            StockLog.created_at >= start_date,
            StockLog.created_at <= end_date
        ]
        if category and category.strip():
            out_filters.append(StockLog.dish.has(category=category))
            
        total_out = db.session.query(func.sum(func.abs(StockLog.quantity_change))).filter(*out_filters).scalar() or 0
        
        # --- 查询 D: 预警 ---
        # 复制一份 filter 避免污染
        warning_filters = dish_filters[:] 
        warning_filters.append(Dish.stock_quantity <= Dish.stock_alert_threshold)
        warning_filters.append(Dish.stock_alert_enabled == True) # 确保开启了预警才算
        
        warning_count = db.session.query(func.count(Dish.dish_id)).filter(*warning_filters).scalar() or 0
        
        return jsonify({'success': True, 'data': {
            'total_quantity': int(total_quantity),
            'total_cost': float(total_cost),
            'total_in': int(total_in),
            'cost_in': float(cost_in),
            'total_out': int(total_out),
            'warning_count': int(warning_count)
        }}), 200

    except Exception as e:
        import traceback
        traceback.print_exc() # 关键：会在控制台打印具体报错行数
        return jsonify({'success': False, 'message': f'服务端错误: {str(e)}'}), 500

@merchant_bp.route('/stock/statistics/trend', methods=['GET'])
@token_required
def get_stock_trend():
    try:
        user = g.current_user
        restaurant = Restaurant.query.filter_by(user_id=user.id).first()
        # 【修复点】添加判空逻辑
        if not restaurant:
            return jsonify({'success': False, 'message': '未找到餐厅信息'}), 404
        
        # 1. 参数处理
        start_date_str = request.args.get('start_date')
        end_date_str = request.args.get('end_date')
        time_zone = request.args.get('timezone')
        time_zone = ZoneInfo(time_zone)
        category = request.args.get('category')

        if not start_date_str or not end_date_str:
            end_date = datetime.utcnow()
            start_date = end_date - timedelta(days=30)
        else:
            try:
                start_date = datetime.strptime(start_date_str[:10], '%Y-%m-%d')
                end_date = datetime.strptime(end_date_str[:10], '%Y-%m-%d').replace(hour=23, minute=59, second=59)
            except:
                return jsonify({'success': False, 'message': '日期格式错误'}), 400

        start_date = start_date.replace(tzinfo=time_zone).astimezone(timezone.utc)
        end_date = end_date.replace(tzinfo=time_zone).astimezone(timezone.utc)

        # =========================================================
        # 第一步：构建当前时刻的【单品库存快照】
        # =========================================================
        dish_query = Dish.query.filter(Dish.restaurant_id == restaurant.id)
        if category and category.strip():
            dish_query = dish_query.filter(Dish.category == category)
        
        # 内存映射：{dish_id: current_stock}
        # 注意：这里我们取 max(0, stock) 避免负库存干扰总数
        dish_stock_map = {d.dish_id: (d.stock_quantity if d.stock_quantity is not None else 0) for d in dish_query.all()}

        # =========================================================
        # 第二步：获取从【开始日期】到【现在】的所有原始日志
        # 我们不再在 SQL 里聚合，而是拉取出来在 Python 里逐条处理
        # =========================================================
        log_query = StockLog.query.filter(
            StockLog.restaurant_id == restaurant.id,
            StockLog.created_at >= start_date # 查开始之后的所有日志
        )
        if category and category.strip():
            log_query = log_query.join(Dish, StockLog.dish_id == Dish.dish_id).filter(Dish.category == category)
            
        # 获取需要的字段，按时间倒序排列（最新的在前面，方便处理 Gap）
        all_logs = log_query.order_by(StockLog.created_at.desc()).all()

        # =========================================================
        # 第三步：处理 Gap (从此刻回滚到 end_date)
        # =========================================================
        # 我们的目标是把 dish_stock_map 回滚到 end_date 那一刻的状态
        
        # 将日志按日期归类： {'2023-11-28': [log1, log2...]}
        logs_by_date = {}
        
        for log in all_logs:
            # 如果日志时间晚于 end_date，说明是“未来”发生的，需要立刻回滚掉
            log_time = log.created_at.replace(tzinfo=timezone.utc)
            if log_time > end_date:
                if log.dish_id in dish_stock_map:
                    # 回滚操作：当前是加，回去就是减；当前是减，回去就是加
                    # 所以：历史库存 = 当前库存 - 变动量
                    dish_stock_map[log.dish_id] -= log.quantity_change
            else:
                # 如果在查询范围内，存起来稍后处理
                d_str = log.created_at.strftime('%Y-%m-%d')
                if d_str not in logs_by_date:
                    logs_by_date[d_str] = []
                logs_by_date[d_str].append(log)

        # =========================================================
        # 第四步：倒推每一天
        # =========================================================
        result_list = []
        
        # 生成日期序列
        date_list = []
        temp = start_date
        while temp <= end_date:
            date_list.append(temp.strftime('%Y-%m-%d'))
            temp += timedelta(days=1)

        # 从 end_date 往回跑到 start_date
        for day_str in reversed(date_list):
            # 1. 计算【这一天结束时】的总库存
            # 过滤掉可能存在的负数库存（脏数据保护），求和
            total_stock_today = sum(stock for stock in dish_stock_map.values() if stock > 0)
            
            # 获取当天的日志
            todays_logs = logs_by_date.get(day_str, [])
            
            # 计算当天的补货总额 (用于柱状图)
            daily_restock = sum(l.quantity_change for l in todays_logs if l.change_type in ['restock', 'return', 'update'] and l.quantity_change > 0)

            # 记录结果
            result_list.append({
                'date': day_str,
                'total_stock': int(total_stock_today),
                'restock_amount': int(daily_restock)
            })

            # 2. 回滚库存到【前一天】
            for log in todays_logs:
                if log.dish_id in dish_stock_map:
                    
                    # 核心修复：检查是否是“创建菜品初始库存”
                    # 如果这天是创建日，那么这天之前的库存强制为 0
                    if log.change_type == 'restock' and log.note == '创建菜品初始库存':
                        dish_stock_map[log.dish_id] = 0
                    else:
                        # 普通回滚：库存 = 当前 - 变动
                        dish_stock_map[log.dish_id] -= log.quantity_change

        return jsonify({'success': True, 'data': result_list[::-1]}), 200

    except Exception as e:
        import traceback
        traceback.print_exc()
        return jsonify({'success': False, 'message': f'获取趋势失败: {str(e)}'}), 500


@merchant_bp.route('/stock/statistics/in-out', methods=['GET'])
@token_required
def get_stock_in_out():
    try:
        user = g.current_user
        restaurant = Restaurant.query.filter_by(user_id=user.id).first()
        # 【修复点】添加判空逻辑
        if not restaurant:
            return jsonify({'success': False, 'message': '未找到餐厅信息'}), 404
        
        start_date_str = request.args.get('start_date')
        end_date_str = request.args.get('end_date')
        time_zone = request.args.get('timezone')
        time_zone = ZoneInfo(time_zone)
        category = request.args.get('category') # 注意：前端传来的可能是 ID 或 名称

        # 日期处理
        if not start_date_str or not end_date_str:
            end_date = datetime.utcnow()
            start_date = end_date - timedelta(days=30)
        else:
            try:
                start_date = datetime.strptime(start_date_str[:10], '%Y-%m-%d')
                end_date = datetime.strptime(end_date_str[:10], '%Y-%m-%d').replace(hour=23, minute=59, second=59)
            except:
                return jsonify({'success': False, 'message': '日期格式不正确'}), 400

        start_date = start_date.replace(tzinfo=time_zone).astimezone(timezone.utc)
        end_date = end_date.replace(tzinfo=time_zone).astimezone(timezone.utc)

        # --- 构建过滤器 ---
        # 基础过滤：时间范围 + 餐厅
        log_filters = [
            StockLog.restaurant_id == restaurant.id,
            StockLog.created_at >= start_date,
            StockLog.created_at <= end_date
        ]
        
        # --- 关键修复点 ---
        # 如果有分类筛选，直接添加到 log_filters 中
        # 但是！因为我们要 join Dish，所以这里先不加 .has()，而是稍后直接 filter(Dish.category == ...)
        
        # 构建查询：指定 select_from 确保 JOIN 顺序正确
        query = db.session.query(
            Dish.category,
            StockLog.change_type,
            func.sum(func.abs(StockLog.quantity_change)).label('qty')
        ).select_from(StockLog).join(Dish, StockLog.dish_id == Dish.dish_id)

        # 应用基础过滤
        query = query.filter(*log_filters)

        # 应用分类过滤 (直接使用 JOIN 后的 Dish 表字段)
        if category and category.strip():
            query = query.filter(Dish.category == category)
        
        # 分组查询
        in_out_data = query.group_by(Dish.category, StockLog.change_type).all()
        
        # --- 数据处理逻辑不变 ---
        category_data = {}
        for row in in_out_data:
            cat_name = row.category or '未分类'
            qty = int(row.qty or 0)
            ctype = row.change_type
            
            if cat_name not in category_data:
                category_data[cat_name] = {'in_qty': 0, 'out_qty': 0}
            
            if ctype in ['restock', 'return']: 
                category_data[cat_name]['in_qty'] += qty
            elif ctype in ['sales', 'loss']: 
                category_data[cat_name]['out_qty'] += qty
        
        result = [{'category_name': k, 'in_qty': v['in_qty'], 'out_qty': v['out_qty']} for k, v in category_data.items()]
        
        return jsonify({'success': True, 'data': result}), 200

    except Exception as e:
        import traceback
        traceback.print_exc() # 在后台打印详细报错
        return jsonify({'success': False, 'message': f'查询出入库失败: {str(e)}'}), 500

@merchant_bp.route('/stock/statistics/cost-distribution', methods=['GET'])
@token_required
def get_stock_cost_distribution():
    """获取库存成本分布"""
    try:
        user = g.current_user
        if user.usertype != 1:
            return jsonify({'success': False, 'message': '只有商家可以访问'}), 403
        
        restaurant = Restaurant.query.filter_by(user_id=user.id).first()
        if not restaurant:
            return jsonify({'success': False, 'message': '未找到餐厅'}), 404
        
        category = request.args.get('category')  # 新增：分类过滤
        
        # 按分类统计库存成本
        dish_filter = Dish.restaurant_id == restaurant.id
        if category:
            dish_filter = and_(dish_filter, Dish.category == category)
        
        cost_data = db.session.query(
            Dish.category,
            func.sum(Dish.original_price * Dish.stock_quantity).label('cost')
        ).filter(dish_filter).group_by(Dish.category).all()
        
        result = [{'category_name': row.category or '未分类', 'cost': float(row.cost or 0)} for row in cost_data]
        return jsonify({'success': True, 'data': result}), 200
    except Exception as e:
        return jsonify({'success': False, 'message': f'获取成本分布失败: {str(e)}'}), 500

@merchant_bp.route('/stock/statistics/logs', methods=['GET'])
@token_required
def get_stock_logs():
    """获取库存流水日志"""
    try:
        user = g.current_user
        if user.usertype != 1:
            return jsonify({'success': False, 'message': '未找到餐厅'}), 404
        
        # 1. 获取参数
        start_date_str = request.args.get('start_date')
        end_date_str = request.args.get('end_date')
        time_zone = request.args.get('timezone')
        time_zone = ZoneInfo(time_zone)
        category = request.args.get('category')
  
        page = int(request.args.get('page', 1))
        per_page = int(request.args.get('per_page', 50))
        
        restaurant = Restaurant.query.filter_by(user_id=user.id).first()
        # 【修复点】添加判空逻辑
        if not restaurant:
            return jsonify({'success': False, 'message': '未找到餐厅信息'}), 404

        query = StockLog.query.filter(StockLog.restaurant_id == restaurant.id)
        print(time_zone)
        # 2. 【关键修复】处理日期时间边界
        if start_date_str:
            try:
                # 截取前10位YYYY-MM-DD，防止 ISO 格式尾巴干扰
                start_date = datetime.strptime(start_date_str[:10], '%Y-%m-%d')
                start_date = start_date.replace(tzinfo=time_zone).astimezone(timezone.utc)
                query = query.filter(StockLog.created_at >= start_date)
            except ValueError:
                pass # 忽略格式错误的日期

        if end_date_str:
            try:
                # 必须将结束时间设为当天的最后一秒，否则当天的记录查不出来
                end_date = datetime.strptime(end_date_str[:10], '%Y-%m-%d').replace(hour=23, minute=59, second=59)
                end_date = end_date.replace(tzinfo=time_zone).astimezone(timezone.utc)
                query = query.filter(StockLog.created_at <= end_date)
            except ValueError:
                pass

        # 3. 处理分类筛选
        if category and category.strip():
            # 这里使用了 join，确保 dish 对应的记录被筛选
            query = query.join(Dish, StockLog.dish_id == Dish.dish_id).filter(Dish.category == category)
        
        # 4. 分页查询
        # 使用 join 加载 dish 信息防止 N+1 问题 (可选优化，视你的 to_dict 实现而定)
        logs = query.order_by(StockLog.created_at.desc()).paginate(page=page, per_page=per_page, error_out=False)
        
        result = [log.to_dict() for log in logs.items]
        return jsonify({'success': True, 'data': result}), 200
        
    except Exception as e:
        import traceback
        traceback.print_exc() # 打印报错方便调试
        return jsonify({'success': False, 'message': f'获取日志失败: {str(e)}'}), 500

@merchant_bp.route('/stock/statistics/export', methods=['GET'])
@token_required
def export_stock_report():
    """导出库存报表为Excel"""
    try:
        # 确保安装了必要库: pip install pandas openpyxl
        import pandas as pd
        from io import BytesIO
        
        user = g.current_user
        restaurant = Restaurant.query.filter_by(user_id=user.id).first()
        
        if not restaurant:
            return jsonify({'success': False, 'message': '未找到餐厅信息'}), 404
        
        # 1. 获取并处理日期参数
        start_date_str = request.args.get('start_date')
        end_date_str = request.args.get('end_date')
        time_zone = request.args.get('timezone')
        time_zone = ZoneInfo(time_zone)
        category = request.args.get('category')
        
        if not start_date_str or not end_date_str:
            end_date = datetime.utcnow()
            start_date = end_date - timedelta(days=30)
        else:
            try:
                # 统一使用更稳健的日期解析
                start_date = datetime.strptime(start_date_str[:10], '%Y-%m-%d')
                end_date = datetime.strptime(end_date_str[:10], '%Y-%m-%d').replace(hour=23, minute=59, second=59)
            except ValueError:
                return jsonify({'success': False, 'message': '日期格式错误'}), 400
        
        start_date = start_date.replace(tzinfo=time_zone).astimezone(timezone.utc)
        end_date = end_date.replace(tzinfo=time_zone).astimezone(timezone.utc)

        # 创建内存中的 Excel 文件
        output = BytesIO()
        writer = pd.ExcelWriter(output, engine='openpyxl')
        
        # ==========================================
        # Sheet 1: 库存概览
        # ==========================================
        # 【修复1】使用列表构建过滤条件
        dish_filters = [Dish.restaurant_id == restaurant.id]
        if category and category.strip():
            dish_filters.append(Dish.category == category)
        
        # 使用 *dish_filters 解包
        total_quantity = db.session.query(func.sum(Dish.stock_quantity)).filter(*dish_filters).scalar() or 0
        total_cost = db.session.query(func.sum(Dish.price * Dish.stock_quantity)).filter(*dish_filters).scalar() or 0
        
        overview_data = [{
            '指标': '当前库存总量',
            '数值': int(total_quantity),
            '单位': '件/kg'
        }, {
            '指标': '库存总成本',
            '数值': round(float(total_cost), 2),
            '单位': '元'
        }, {
            '指标': '统计时间段',
            '数值': f"{start_date.strftime('%Y-%m-%d')} 至 {end_date.strftime('%Y-%m-%d')}",
            '单位': '-'
        }]
        
        df_overview = pd.DataFrame(overview_data)
        df_overview.to_excel(writer, sheet_name='库存概览', index=False)
        
        # ==========================================
        # Sheet 2: 库存流水明细
        # ==========================================
        # 【修复2】修复元组错误，改用列表
        stock_log_filters = [
            StockLog.restaurant_id == restaurant.id,
            StockLog.created_at >= start_date,
            StockLog.created_at <= end_date
        ]
        
        if category and category.strip():
            # 使用 .has() 进行关联过滤
            stock_log_filters.append(StockLog.dish.has(category=category))
        
        # 使用 *stock_log_filters 解包
        logs = StockLog.query.filter(*stock_log_filters).order_by(StockLog.created_at.desc()).all()
        
        logs_data = []
        for log in logs:
            # 尝试获取操作人名称
            operator_name = '-'
            if log.operator: # 假设 StockLog 有 operator 关系
                operator_name = log.operator.username 
            elif log.operator_id:
                operator_name = str(log.operator_id)

            logs_data.append({
                '时间': log.created_at.strftime('%Y-%m-%d %H:%M:%S'),
                '单号': str(log.id), # 简单起见直接用ID，或者你可以解析 note 里的订单号
                '菜品名称': log.dish.name if log.dish else '已删除菜品',
                '变动类型': log.change_type,
                '变动数量': log.quantity_change,
                '变动后库存': log.stock_after,
                '变动金额': log.cost or 0,
                '操作人': operator_name,
                '备注': log.note or '-'
            })
        
        df_logs = pd.DataFrame(logs_data)
        df_logs.to_excel(writer, sheet_name='库存流水', index=False)
        
        # 保存并发送
        writer.close()
        output.seek(0)
        
        filename = f"库存报表_{start_date.strftime('%Y%m%d')}_{end_date.strftime('%Y%m%d')}.xlsx"
        
        # 兼容旧版 Flask 的 attachment_filename 写法
        try:
            return send_file(
                output,
                mimetype='application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
                as_attachment=True,
                download_name=filename
            )
        except TypeError:
            # 如果是 Flask 2.0 以下版本
            return send_file(
                output,
                mimetype='application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
                as_attachment=True,
                attachment_filename=filename
            )
        
    except Exception as e:
        print(f"导出库存报表失败: {e}")
        import traceback
        traceback.print_exc() # 在后台打印完整报错
        return jsonify({
            'success': False,
            'message': f'服务端导出失败: {str(e)}'
        }), 500

             