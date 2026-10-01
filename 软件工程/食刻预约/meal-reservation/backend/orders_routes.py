from flask import Blueprint
from datetime import datetime, timedelta,timezone
import logging
from zoneinfo import ZoneInfo

from auxiliary_function import token_required,request, jsonify, g
from Models import Restaurant, Table, Dish, Order, OrderItem, CouponNotification, CouponUsage, OrderChangeRequest, Review, Message
from app_init import db
from db_exe import check_table_availability_for_reservation, validate_order_items


orders_bp = Blueprint('orders', __name__, url_prefix='/api/orders')
orders_logger = logging.getLogger('orders')

# 创建订单
@orders_bp.route('/create', methods=['POST'])
@token_required
def create_order():
    """创建新订单"""
    try:
        current_user = g.current_user
        data = request.get_json()
        # 验证必要参数
        if not data.get('restaurant_id') or not data.get('items'):
            return jsonify({'success': False, 'message': '缺少必要参数'}), 400
        
        restaurant_id = data['restaurant_id']
        order_items = data['items']
        
        # 验证餐厅是否存在
        restaurant = Restaurant.query.get(restaurant_id)
        if not restaurant:
            return jsonify({'success': False, 'message': '餐厅不存在'}), 404
        
        # 验证桌位信息（如果是堂食）
        table_id = data.get('table_id')
        customer_count = data.get('customer_count', 1)
        is_reservation = data.get('order_type') == 'dinein' and data.get('reserved_time')
        
        if data.get('order_type') == 'dinein' and table_id:
            table = Table.query.get(table_id)
            if not table:
                return jsonify({'success': False, 'message': '桌位不存在'}), 404
            
            # 验证桌位所属餐厅
            if table.restaurant_id != restaurant_id:
                return jsonify({'success': False, 'message': '桌位不属于该餐厅'}), 400
            
            # 对于非预约订单（立即到店），验证当前时刻桌位是否有足够的剩余座位
            # 预约订单的桌位可用性在后面通过 check_table_availability_for_reservation 检查
            if not is_reservation:
                if not table.can_accommodate(customer_count):
                    current_occupancy = table.get_current_occupancy()
                    available_seats = 0 if table.table_type == 'private' and current_occupancy > 0 else table.capacity - current_occupancy
                    return jsonify({
                        'success': False, 
                        'message': f'该桌位剩余{available_seats}个座位，无法容纳{customer_count}人，请选择其他桌位'
                    }), 400
        
        time_zone = data.get('timezone')
        time_zone = ZoneInfo(time_zone) if time_zone else None

        # 验证取餐时间（如果有）
        pickup_time = None
        if data.get('pickup_time'):
            try:
                pickup_time = datetime.fromisoformat(data['pickup_time']).replace(tzinfo=time_zone).astimezone(timezone.utc)
                # 验证取餐时间是否合理（不能是过去的时间）
                if pickup_time < datetime.utcnow():
                    return jsonify({'success': False, 'message': '取餐时间不能是过去的时间'}), 400
            except Exception:
                return jsonify({'success': False, 'message': '取餐时间格式错误'}), 400
        
        # 验证库存并计算总价
        total_price = 0.0
        validated_items = []
        
        for item in order_items:
            dish_id = item.get('dish_id')
            quantity = item.get('quantity', 1)
            
            if not dish_id or quantity <= 0:
                return jsonify({'success': False, 'message': '订单项参数错误'}), 400
            
            # 查询菜品信息
            dish = Dish.query.filter_by(dish_id=dish_id).first()
            if not dish:
                return jsonify({'success': False, 'message': f'菜品ID {dish_id} 不存在'}), 404
            
            # 验证菜品所属餐厅
            if dish.restaurant_id != restaurant_id:
                return jsonify({'success': False, 'message': f'菜品ID {dish_id} 不属于该餐厅'}), 400
            
            # 验证菜品是否可售
            if not dish.is_available():
                return jsonify({'success': False, 'message': f'菜品 {dish.name} 已售罄或不可用'}), 400
            
            # 验证库存
            if dish.stock_quantity is not None and dish.stock_quantity < quantity:
                return jsonify({'success': False, 'message': f'菜品 {dish.name} 库存不足'}), 400
            
            # 获取辣度和葱花香菜选项
            spiciness = item.get('spiciness')
            garnish = item.get('garnish')

            # 验证辣度选项
            if dish.is_spicy_selectable and spiciness not in ['不辣', '微辣', '中辣', '特辣', '变态辣']:
                return jsonify({'success': False, 'message': f'菜品 {dish.name} 的辣度选项无效'}), 400
            
            # 验证葱花香菜选项
            if dish.is_garnish_selectable and garnish not in ['要葱花香菜', '要葱花', '要香菜', '不要葱花不要香菜']:
                return jsonify({'success': False, 'message': f'菜品 {dish.name} 的葱花香菜选项无效'}), 400

            # 计算价格
            unit_price = float(dish.price)
            subtotal = unit_price * quantity
            total_price += subtotal
            
            validated_items.append({
                'dish': dish,
                'quantity': quantity,
                'unit_price': unit_price,
                'subtotal': subtotal,
                'spiciness': spiciness if dish.is_spicy_selectable else None,
                'garnish': garnish if dish.is_garnish_selectable else None
            })
        
        # 保存原始价格
        original_price = total_price
        discount_amount = 0.0
        coupon_id = data.get('coupon_id')
        
        # 处理优惠券
        if coupon_id:
            # 1. 验证优惠券是否存在
            coupon = CouponNotification.query.get(coupon_id)
            if not coupon:
                return jsonify({'success': False, 'message': '优惠券不存在'}), 404
            
            # 2. 验证优惠券是否属于该餐厅
            if coupon.restaurant_id != restaurant_id:
                return jsonify({'success': False, 'message': '此优惠券不适用于该餐厅'}), 400
            
            # 3. 验证优惠券是否激活
            if not coupon.is_active:
                return jsonify({'success': False, 'message': '优惠券已停用'}), 400
            
            # 4. 验证优惠券有效期
            now = datetime.utcnow()
            if coupon.valid_from and now < coupon.valid_from:
                return jsonify({'success': False, 'message': '优惠券还未生效'}), 400
            if coupon.valid_to and now > coupon.valid_to:
                return jsonify({'success': False, 'message': '优惠券已过期'}), 400
            
            # 5. 验证最低消费
            if coupon.min_spend and original_price < coupon.min_spend:
                return jsonify({
                    'success': False, 
                    'message': f'未达到最低消费金额，需满¥{coupon.min_spend:.2f}元'
                }), 400
            
            # 6. 验证用户是否已使用过此优惠券
            existing_usage = CouponUsage.query.filter_by(
                user_id=current_user.id,
                coupon_id=coupon_id
            ).first()
            if existing_usage:
                return jsonify({'success': False, 'message': '此优惠券已使用过'}), 400
            
            # 7. 计算折扣金额
            if coupon.discount_type == 'amount':
                # 满减优惠
                discount_amount = float(coupon.amount) if coupon.amount else 0.0
            elif coupon.discount_type == 'percentage':
                # 折扣优惠（amount为折扣百分比）
                discount_percentage = float(coupon.amount) if coupon.amount else 0.0
                discount_amount = original_price * (discount_percentage / 100.0)
            # gift类型不减少订单金额
            
            # 确保折扣不超过原价
            discount_amount = min(discount_amount, original_price)
            total_price = original_price - discount_amount
        
        # 处理预约时间（仅堂食支持预约）
        reserved_time = None
        reserved_end_time = None
        reservation_status = 'none'
        
        if data.get('order_type') == 'dinein' and data.get('reserved_time'):
            try:
                reserved_time = datetime.fromisoformat(data['reserved_time'].replace('Z', '+00:00')).replace(tzinfo=time_zone).astimezone(timezone.utc)
                # 如果是 naive datetime，假设为本地时间
                if reserved_time.tzinfo is not None:
                    reserved_time = reserved_time.replace(tzinfo=None)
                
                duration_minutes = data.get('duration', 120)  # 默认2小时
                reserved_end_time = reserved_time + timedelta(minutes=duration_minutes)
                
                now = datetime.utcnow()
                min_advance = timedelta(minutes=30)
                max_advance = timedelta(days=7)
                
                # 验证预约时间
                if reserved_time < now + min_advance:
                    return jsonify({'success': False, 'message': '预约时间至少需要提前30分钟'}), 400
                if reserved_time > now + max_advance:
                    return jsonify({'success': False, 'message': '预约时间不能超过7天后'}), 400
                
                # 验证桌位在该时段是否可用
                if table_id:
                    table = Table.query.get(table_id)
                    is_available, available_seats = check_table_availability_for_reservation(
                        table_id, reserved_time, reserved_end_time, customer_count
                    )
                    if not is_available:
                        if table.table_type == 'private':
                            return jsonify({'success': False, 'message': '该独立桌在所选时段不可用（已被占用或已被预约）'}), 400
                        else:
                            return jsonify({'success': False, 'message': f'该桌位在所选时段剩余{available_seats}个座位，无法容纳{customer_count}人'}), 400
                
                reservation_status = 'pending'  # 预约订单需要商家确认
                
            except ValueError as e:
                return jsonify({'success': False, 'message': f'预约时间格式错误: {str(e)}'}), 400
        
        # 创建订单
        order = Order(
            order_number=Order.generate_order_number(),
            user_id=current_user.id,
            restaurant_id=restaurant_id,
            table_id=data.get('table_id'),
            customer_count=data.get('customer_count', 1),
            order_type=data.get('order_type', 'takeout'),
            status='pending',
            reserved_time=reserved_time,
            reserved_end_time=reserved_end_time,
            reservation_status=reservation_status,
            total_price=total_price,
            original_price=original_price,
            discount_amount=discount_amount,
            coupon_id=coupon_id,
            note=data.get('note'),
            order_time=datetime.utcnow()
        )
        
        # 添加订单项
        for item_data in validated_items:
            order_item = OrderItem(
                dish_id=item_data['dish'].dish_id,
                quantity=item_data['quantity'],
                unit_price=item_data['unit_price'],
                subtotal=item_data['subtotal'],
                spiciness=item_data['spiciness'],
                garnish=item_data['garnish']
            )
            order.items.append(order_item)
            
            # 更新菜品库存
            if item_data['dish'].stock_quantity is not None:
                item_data['dish'].update_stock(-item_data['quantity'],'销售', current_user.id, f'订单 {order.order_number} 销售')
        
        # 提交订单
        db.session.add(order)
        db.session.flush()  # 获取order.id
        
        # 如果使用了优惠券，创建CouponUsage记录
        if coupon_id:
            coupon_usage = CouponUsage(
                user_id=current_user.id,
                coupon_id=coupon_id,
                order_id=order.id,
                used_at=datetime.utcnow()
            )
            db.session.add(coupon_usage)
        
        db.session.commit()
        
        return jsonify({
            'success': True,
            'message': '订单创建成功',
            'data': {
                'order_id': order.id,
                'order_number': order.order_number,
                'total_price': total_price,
                'original_price': original_price,
                'discount_amount': discount_amount
            }
        }), 200
        
    except Exception as e:
        db.session.rollback()
        print(f"创建订单失败: {e}")
        return jsonify({'success': False, 'message': '订单创建失败', 'error': str(e)}), 500

# 获取用户订单列表
@orders_bp.route('', methods=['GET'])
@token_required
def get_user_orders():
    """获取当前用户的订单列表"""

    try:
        current_user = g.current_user
        orders = Order.query.filter_by(user_id=current_user.id).order_by(Order.order_time.desc()).all()

        orders_data = []
        for order in orders:
            order_dict = order.to_dict()
            items = []
            for item in order.items.all():
                items.append(item.to_dict())
            order_dict['items'] = items

            # 包括 pending/approved/rejected 的最新申请
            latest_request = OrderChangeRequest.query.filter_by(order_id=order.id) \
                .filter(OrderChangeRequest.status.in_(['pending', 'approved', 'rejected'])) \
                .order_by(OrderChangeRequest.updated_at.desc()) \
                .first()
            latest_request_dict = latest_request.to_dict() if latest_request else None

            # 向前端返回 latest_change_request
            order_dict['latest_change_request'] = latest_request_dict

            # --- 新增：记录当前用户是否已对该订单发表过评价 ---
            try:
                review = Review.query.filter_by(order_id=order.id, user_id=current_user.id).order_by(Review.created_at.desc()).first()
                order_dict['has_review'] = bool(review)
                if review:
                    order_dict['review_summary'] = {
                        'id': review.id,
                        'review_status': review.review_status,
                        'created_at': review.created_at.isoformat() if review.created_at else None
                    }
            except Exception as e:
                # 确保即便 Review 表还未迁移，接口也不会崩溃
                orders_logger.warning(f'检查订单是否有评价失败: {e}')
                order_dict['has_review'] = False
                order_dict['review_summary'] = None

            orders_data.append(order_dict)

        return jsonify({'success': True, 'data': orders_data}), 200
        
        
    except Exception as e:
        print(f"获取订单列表失败: {e}")
        return jsonify({'success': False, 'message': '获取订单列表失败', 'error': str(e)}), 500

# 获取订单详情
@orders_bp.route('/<int:order_id>', methods=['GET'])
@token_required
def get_order_detail(order_id):
    """获取单个订单的详细信息"""
    try:
        current_user = g.current_user
        
        # 查询订单
        order = Order.query.get(order_id)
        if not order:
            return jsonify({'success': False, 'message': '订单不存在'}), 404
        
        # 验证订单所有权
        if order.user_id != current_user.id:
            return jsonify({'success': False, 'message': '无权访问此订单'}), 403
        
        # 获取订单信息
        order_dict = order.to_dict()
        
        # 添加订单项信息
        items = []
        for item in order.items.all():
            items.append(item.to_dict())
        order_dict['items'] = items
        
        return jsonify({
            'success': True,
            'data': order_dict
        }), 200
        
    except Exception as e:
        print(f"获取订单详情失败: {e}")
        return jsonify({'success': False, 'message': '获取订单详情失败', 'error': str(e)}), 500

@orders_bp.route('/<int:order_id>', methods=['PUT'])
@token_required
def update_user_order(order_id):
    """更新用户订单信息"""
    try:
        data = request.get_json()
        current_user = g.current_user

        order = Order.query.get(order_id)
        if not order:
            return jsonify({'success': False, 'message': '订单不存在'}), 404
        if order.user_id != current_user.id:
            return jsonify({'success': False, 'message': '无权修改此订单'}), 403
        if order.status != 'pending':
            return jsonify({'success': False, 'message': '仅可修改待接单状态的订单'}), 400

        # 统计原订单每个菜品的数量
        original_item_quantities = {item.dish_id: item.quantity for item in order.items}

        items_data = data.get('items', [])
        if not items_data:
            return jsonify({'success': False, 'message': '订单项不能为空'}), 400

        # 预验证库存
        try:
            for item_data in items_data:
                dish_id = item_data.get('dish_id')
                requested_quantity = int(item_data.get('quantity', 0))
                dish = Dish.query.get(dish_id)
                if not dish:
                    raise ValueError(f"菜品ID {dish_id} 不存在")
                original_quantity = original_item_quantities.get(dish_id, 0)
                effective_stock = (dish.stock_quantity or 0) + original_quantity
                if effective_stock < requested_quantity:
                    raise ValueError(f"菜品 '{dish.name}' 库存不足，仅剩 {effective_stock} 件可供调配")
        except ValueError as ve:
            return jsonify({'success': False, 'message': str(ve)}), 400

        # 归还旧订单项的库存
        for existing_item in order.items:
            if existing_item.dish and existing_item.dish.stock_quantity is not None:
                existing_item.dish.update_stock(existing_item.quantity,'return', current_user.id, f'订单 {order.order_number} 修改，返还')
        db.session.commit()  # 立即提交归还后的库存

        # 再次验证库存（防止并发情况下库存被其他订单占用）
        try:
            for item_data in items_data:
                dish_id = item_data.get('dish_id')
                requested_quantity = int(item_data.get('quantity', 0))
                dish = Dish.query.get(dish_id)
                original_quantity = original_item_quantities.get(dish_id, 0)
                effective_stock = (dish.stock_quantity or 0) + original_quantity
                if effective_stock < requested_quantity:
                    raise ValueError(f"菜品 '{dish.name}' 库存不足，仅剩 {effective_stock} 件可供调配")
        except ValueError as ve:
            return jsonify({'success': False, 'message': str(ve)}), 400

        # 验证桌位容量
        new_table_id = data.get('table_id', order.table_id)
        new_customer_count = data.get('customer_count', order.customer_count)
        if new_table_id:
            table = Table.query.get(new_table_id)
            if not table:
                return jsonify({'success': False, 'message': '所选桌位不存在'}), 404
            if table.restaurant_id != order.restaurant_id:
                return jsonify({'success': False, 'message': '所选桌位不属于该餐厅'}), 400
            if not table.can_accommodate(new_customer_count, exclude_order_id=order.id):
                other_orders_occupancy = table.get_current_occupancy(exclude_order_id=order.id)
                available_seats = 0 if table.table_type == 'private' and other_orders_occupancy > 0 else table.capacity - other_orders_occupancy
                return jsonify({'success': False, 'message': f'桌位 {table.table_number} 容量不足，除本单外还剩 {available_seats} 个座位'}), 400

        # 清空现有关联的订单项
        for existing_item in order.items.all():
            db.session.delete(existing_item)
        db.session.flush()

        # 使用 validate_order_items 重新计算价格并添加新订单项
        validated_items, total_price = validate_order_items(order.restaurant_id, items_data)

        # 添加新订单项并扣减新库存
        for item_data in validated_items:
            order_item = OrderItem(
                dish_id=item_data['dish'].dish_id,
                quantity=item_data['quantity'],
                unit_price=item_data['unit_price'],
                subtotal=item_data['subtotal'],
                spiciness=item_data['spiciness'],
                garnish=item_data['garnish']
            )
            order.items.append(order_item)
            if item_data['dish'].stock_quantity is not None:
                item_data['dish'].update_stock(-item_data['quantity'], 'update', current_user.id, f'订单 {order.order_number} 修改，新增')

        # 更新订单主信息
        order.note = data.get('note', order.note)
        order.table_id = new_table_id
        order.customer_count = new_customer_count
        order.total_price = total_price
        order.updated_at = datetime.utcnow()

        db.session.commit()

        return jsonify({
            'success': True,
            'message': '订单更新成功',
            'data': order.to_dict()
        }), 200

    except Exception as e:
        db.session.rollback()
        print(f"更新订单失败: {e}")
        return jsonify({'success': False, 'message': '订单更新失败', 'error': str(e)}), 500

@orders_bp.route('/<int:order_id>/cancel', methods=['POST'])
@token_required
def cancel_user_order(order_id):
    """取消用户订单（允许在商家接单前直接取消；取消后返还库存与释放桌位）"""
    try:
        # 兼容前端可能不传 body 的情况，避免 JSON 解析错误
        _ = request.get_json(silent=True) or {}
        current_user = g.current_user

        order = Order.query.get(order_id)
        if not order:
            return jsonify({'success': False, 'message': '订单不存在'}), 404
        if order.user_id != current_user.id:
            return jsonify({'success': False, 'message': '无权修改此订单'}), 403

        # 仅允许在商家接单之前取消（pending 状态）
        if order.status != 'pending':
            return jsonify({'success': False, 'message': '仅可取消待接单状态的订单'}), 400

        # 返还库存：把订单中每项的数量加回到对应菜品
        for existing_item in order.items.all():
            try:
                if existing_item.dish and existing_item.dish.stock_quantity is not None:
                    existing_item.dish.update_stock(existing_item.quantity,'return', current_user.id, f'订单 {order.order_number} 取消返还')
            except Exception:
                # 个别菜品更新库存失败不阻止整体取消，记录日志
                orders_logger.exception(f"返还库存失败：order_id={order.id}, item_id={existing_item.id}")

        # 释放桌位（如果有）
        if order.table_id:
            try:
                table = Table.query.get(order.table_id)
                if table:
                    table.status = 'available'
                    table.updated_at = datetime.utcnow()
            except Exception:
                orders_logger.exception(f"释放桌位失败：order_id={order.id}, table_id={order.table_id}")

        # 标记订单为已取消
        order.status = 'cancelled'
        order.cancelled_time = datetime.utcnow()
        order.updated_at = datetime.utcnow()

        db.session.commit()

        return jsonify({'success': True, 'message': '订单已取消', 'data': order.to_dict()}), 200

    except Exception as e:
        db.session.rollback()
        orders_logger.exception(f"取消订单失败: {e}")
        return jsonify({'success': False, 'message': '订单取消失败', 'error': str(e)}), 500

@orders_bp.route('/<int:order_id>/request-change', methods=['POST'])
@token_required
def request_order_change(order_id):
    """请求修改/取消订单（仅限已确认订单）"""
    try:
        current_user = g.current_user
        data = request.get_json() or {}

        order = Order.query.get(order_id)
        if not order:
            return jsonify({'success': False, 'message': '订单不存在'}), 404
        if order.user_id != current_user.id:
            return jsonify({'success': False, 'message': '无权操作此订单'}), 403
        if order.status != 'confirmed':
            return jsonify({'success': False, 'message': '仅可对已确认订单提交申请'}), 400

        request_type = (data.get('type') or 'modify').strip()
        if request_type not in {'modify', 'cancel'}:
            return jsonify({'success': False, 'message': '申请类型无效'}), 400

        # 如果是修改申请，预先验证库存和桌位
        if request_type == 'modify':
            payload = data.get('payload', {})
            if not payload or not payload.get('items'):
                return jsonify({'success': False, 'message': '申请修改的内容不能为空'}), 400
            
            try:
                # --- 关键修复：临时回补库存以进行准确验证 ---
                # 1. 统计原始订单中每个菜品的数量
                original_item_quantities = {item.dish_id: item.quantity for item in order.items}

                # 2. 验证新订单时，将原始数量考虑在内
                for item_data in payload.get('items', []):
                    dish_id = item_data.get('dish_id')
                    requested_quantity = int(item_data.get('quantity', 0))
                    
                    dish = Dish.query.get(dish_id)
                    if not dish:
                        raise ValueError(f"菜品ID {dish_id} 不存在")

                    # 计算可用库存：当前数据库库存 + 此订单原先占用的库存
                    original_quantity = original_item_quantities.get(dish_id, 0)
                    effective_stock = (dish.stock_quantity or 0) + original_quantity;

                    if effective_stock < requested_quantity:
                        raise ValueError(f"菜品 '{dish.name}' 库存不足，仅剩 {effective_stock} 件可供调配")
                
                # --- 关键修复：验证桌位容量 ---
                new_table_id = payload.get('table_id', order.table_id)
                new_customer_count = payload.get('customer_count', order.customer_count)
                if new_table_id:
                    table = Table.query.get(new_table_id)
                    if not table:
                        return jsonify({'success': False, 'message': '申请的桌位不存在'}), 404
                    if table.restaurant_id != order.restaurant_id:
                        return jsonify({'success': False, 'message': '申请的桌位不属于该餐厅'}), 400
                    
                    # 计算除当前订单外的其他订单占用的座位数
                    other_orders_occupancy = table.get_current_occupancy(exclude_order_id=order.id)
                    
                    # 检查桌位是否能容纳新的人数
                    if table.capacity < other_orders_occupancy + new_customer_count:
                        available_seats = table.capacity - other_orders_occupancy
                        return jsonify({'success': False, 'message': f'桌位 {table.table_number} 容量不足，除本单外还剩 {available_seats} 个座位'}), 400
            except ValueError as ve:
                return jsonify({'success': False, 'message': str(ve)}), 400

        existing_pending = OrderChangeRequest.query.filter_by(
            order_id=order.id,
            status='pending'
        ).first()
        if existing_pending:
            return jsonify({'success': False, 'message': '已有待处理申请，请勿重复提交'}), 400

        # 确保 restaurant_id 被正确获取
        restaurant = order.restaurant
        if not restaurant:
            return jsonify({'success': False, 'message': '无法找到订单关联的餐厅信息'}), 500

        change_request = OrderChangeRequest(
            order_id=order.id,
            user_id=current_user.id,
            restaurant_id=restaurant.id, # 使用 restaurant.id 确保值不为 None
            request_type=request_type,
            reason=(data.get('reason') or '').strip(),
            payload=data.get('payload') or {},
            status='pending'
        )
        db.session.add(change_request)
        db.session.commit()

        return jsonify({'success': True, 'message': '申请已提交', 'data': change_request.to_dict()}), 201
    except Exception as e:
        db.session.rollback()
        orders_logger.error(f"提交修改申请失败: {e}")
        return jsonify({'success': False, 'message': '提交修改申请失败', 'error': str(e)}), 500

# 新增：撤回用户提交的申请（仅能撤回 pending）
@orders_bp.route('/change-requests/<int:request_id>/withdraw', methods=['POST'])
@token_required
def withdraw_change_request(request_id):
    try:
        current_user = g.current_user
        req = OrderChangeRequest.query.get(request_id)
        if not req:
            return jsonify({'success': False, 'message': '申请单不存在'}), 404

        # 仅申请发起人能撤回
        if req.user_id != current_user.id:
            return jsonify({'success': False, 'message': '无权限撤回该申请'}), 403

        if req.status != 'pending':
            return jsonify({'success': False, 'message': '申请已被处理，无法撤回'}), 400

        req.status = 'withdrawn'
        req.updated_at = datetime.utcnow()
        db.session.commit()
        return jsonify({'success': True, 'message': '申请已撤回', 'data': req.to_dict()}), 200
    except Exception as exc:
        db.session.rollback()
        orders_logger.error(f"撤回申请失败: {exc}")
        return jsonify({'success': False, 'message': '撤回申请失败', 'error': str(exc)}), 500
    

@orders_bp.route('/<int:order_id>/review', methods=['GET'])
@token_required
def get_order_review(order_id):
    """获取当前用户针对订单的评价（用于查看详情）"""
    try:
        current_user = g.current_user
        order = Order.query.get(order_id)
        if not order:
            return jsonify({'success': False, 'message': '订单不存在'}), 404
        if order.user_id != current_user.id:
            return jsonify({'success': False, 'message': '无权访问'}), 403

        # 查找该用户对该订单最新的一条评价
        review = Review.query.filter_by(order_id=order.id, user_id=current_user.id).order_by(Review.created_at.desc()).first()
        if not review:
            return jsonify({'success': True, 'data': {'review': None}}), 200

        return jsonify({'success': True, 'data': {'review': review.to_dict()}}), 200
    except Exception as e:
        print(f"获取订单评价失败: {e}")
        return jsonify({'success': False, 'message': '获取评价失败', 'error': str(e)}), 500


def _pickup_message_payload(message, include_items=False):
    order = message.order if message else None
    restaurant = order.restaurant if order else None
    base = {
        'id': message.id if message else None,
        'order_id': order.id if order else None,
        'order_number': order.order_number if order else None,
        'restaurant_id': restaurant.id if restaurant else None,
        'restaurant_name': restaurant.name if restaurant else None,
        'pickup_number': order.pickup_number if order else None,
        'status': order.status if order else None,
        'text': message.text if message else None,
        'created_at': message.created_at.replace(tzinfo=timezone.utc).isoformat() if message and message.created_at else None,
        'total_price': float(order.total_price) if order and order.total_price is not None else None
    }

    if include_items and order and hasattr(order.items, 'all'):
        try:
            base['items'] = [item.to_dict() for item in order.items.all()]
        except Exception:
            base['items'] = []
    return base


@orders_bp.route('/pickup-notifications', methods=['GET'])
@token_required
def list_pickup_notifications():
    try:
        current_user = g.current_user
        messages = (
            Message.query.join(Order, Message.order_id == Order.id)
            .filter(Order.user_id == current_user.id, Message.message_type == 'pickup_notice')
            .order_by(Message.created_at.desc())
            .all()
        )

        payload = [_pickup_message_payload(message) for message in messages]
        return jsonify({'success': True, 'data': payload}), 200
    except Exception as exc:
        orders_logger.exception(f'获取取餐通知失败: {exc}')
        return jsonify({'success': False, 'message': '获取取餐通知失败', 'error': str(exc)}), 500


@orders_bp.route('/pickup-notifications/<int:notification_id>', methods=['GET'])
@token_required
def get_pickup_notification(notification_id):
    try:
        current_user = g.current_user
        message = Message.query.get(notification_id)
        if not message or message.message_type != 'pickup_notice':
            return jsonify({'success': False, 'message': '通知不存在'}), 404

        order = message.order
        if not order or order.user_id != current_user.id:
            return jsonify({'success': False, 'message': '无权访问该通知'}), 403

        data = _pickup_message_payload(message, include_items=True)
        return jsonify({'success': True, 'data': data}), 200
    except Exception as exc:
        orders_logger.exception(f'获取取餐通知详情失败: {exc}')
        return jsonify({'success': False, 'message': '获取通知详情失败', 'error': str(exc)}), 500
   