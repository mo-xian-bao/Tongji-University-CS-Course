"""Order helpers."""
from datetime import datetime

from Models import db, Order, Dish, Table


def create_order(user_id, restaurant_id, table_id=None, customer_count=1, order_type='dine_in', note=None):
    """创建订单"""
    try:
        order = Order(
            order_number=Order.generate_order_number(),
            user_id=user_id,
            restaurant_id=restaurant_id,
            table_id=table_id,
            customer_count=customer_count,
            order_type=order_type,
            note=note,
            status='pending'
        )
        db.session.add(order)
        db.session.commit()
        return order
    except Exception as e:
        db.session.rollback()
        raise e


def get_order_by_id(order_id):
    """根据ID获取订单"""
    return Order.query.get(order_id)


def get_user_orders(user_id):
    """获取用户所有订单"""
    return Order.query.filter_by(user_id=user_id).order_by(Order.created_at.desc()).all()


def get_restaurant_orders(restaurant_id, status=None):
    """获取餐厅订单"""
    query = Order.query.filter_by(restaurant_id=restaurant_id)
    if status:
        query = query.filter_by(status=status)
    return query.order_by(Order.created_at.desc()).all()


def update_order_status(order_id, status):
    """更新订单状态"""
    try:
        order = Order.query.get(order_id)
        if not order:
            return None

        order.status = status
        if status == 'confirmed':
            order.confirmed_time = datetime.utcnow()
        elif status == 'completed':
            order.completed_time = datetime.utcnow()
        elif status == 'cancelled':
            order.cancelled_time = datetime.utcnow()

        order.updated_at = datetime.utcnow()
        db.session.commit()
        return order
    except Exception as e:
        db.session.rollback()
        raise e


def validate_order_items(restaurant_id, items_payload):
    if not items_payload:
        raise ValueError('订单项不能为空')
    validated_items, total_price = [], 0.0
    for item in items_payload:
        dish_id = item.get('dish_id')
        quantity = int(item.get('quantity', 1) or 1)
        if not dish_id or quantity <= 0:
            raise ValueError('存在无效的菜品或数量')
        dish = Dish.query.filter_by(dish_id=dish_id, restaurant_id=restaurant_id).first()
        if not dish:
            raise ValueError(f'菜品 {dish_id} 不存在')
        if not dish.is_available():
            raise ValueError(f'{dish.name} 已售罄或不可售')
        if dish.stock_quantity is not None and dish.stock_quantity < quantity:
            raise ValueError(f'{dish.name} 库存不足')
        spiciness = item.get('spiciness')
        garnish = item.get('garnish')
        if dish.is_spicy_selectable and spiciness and spiciness not in ['不辣', '微辣', '中辣', '特辣', '变态辣']:
            raise ValueError(f'{dish.name} 的辣度选项无效')
        if dish.is_garnish_selectable and garnish and garnish not in ['要葱花香菜', '要葱花', '要香菜', '不要葱花不要香菜']:
            raise ValueError(f'{dish.name} 的配菜选项无效')
        unit_price = float(dish.price)
        subtotal = unit_price * quantity
        validated_items.append({
            'dish': dish,
            'quantity': quantity,
            'unit_price': unit_price,
            'subtotal': subtotal,
            'spiciness': spiciness if dish.is_spicy_selectable else None,
            'garnish': garnish if dish.is_garnish_selectable else None
        })
        total_price += subtotal
    return validated_items, total_price
