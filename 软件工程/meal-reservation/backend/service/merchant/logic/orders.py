"""Merchant order helpers."""
from datetime import datetime

from Models import Order, Restaurant, Table, User, db


def fetch_orders(current_user):
    restaurant = Restaurant.query.filter_by(user_id=current_user.id).first()
    if not restaurant:
        return None, None
    orders = Order.query.filter_by(restaurant_id=restaurant.id).order_by(Order.order_time.desc()).all()
    return restaurant, orders


def enrich_order(order):
    d = order.to_dict()
    user = User.query.get(order.user_id)
    if user:
        d["customer_name"] = user.username
        d["customer_phone"] = user.phone
    d["items"] = [i.to_dict() for i in order.items.all()]
    return d


def get_order_for_merchant(current_user, order_id):
    restaurant = Restaurant.query.filter_by(user_id=current_user.id).first()
    if not restaurant:
        return None, None, "未找到餐厅信息"
    order = Order.query.get(order_id)
    if not order or order.restaurant_id != restaurant.id:
        return None, restaurant, "订单不存在"
    return order, restaurant, None


def accept(order, restaurant):
    order.status = "confirmed"
    order.confirmed_time = datetime.utcnow()
    order.pickup_number = Order.generate_pickup_number(restaurant.id)
    if order.order_type == "dinein" and order.table_id:
        table = Table.query.get(order.table_id)
        if table:
            occ = table.get_current_occupancy()
            if occ >= table.capacity or table.table_type == "private":
                table.status = "occupied"
    db.session.commit()


def reject(order, reason, operator_id):
    reason = (reason or "").strip()
    if not reason:
        return False, "请填写拒绝理由"
    for item in (order.items.all() if hasattr(order.items, "all") else (order.items or [])):
        try:
            if item.dish and item.dish.stock_quantity is not None:
                item.dish.update_stock(item.quantity, "return", operator_id,
                                       f"订单 {order.order_number} 商家拒单返还")
        except Exception:
            pass
    if order.table_id:
        try:
            table = Table.query.get(order.table_id)
            if table:
                table.status = "available"
                table.updated_at = datetime.utcnow()
        except Exception:
            pass
    order.status = "rejected"
    order.reject_reason = reason
    order.cancelled_time = datetime.utcnow()
    order.updated_at = datetime.utcnow()
    db.session.commit()
    return True, None


def serve(order, current_user_id):
    from ._helpers import _create_pickup_notification

    dinein = {"dinein", "dine_in", "dine-in"}
    table = Table.query.get(order.table_id) if order.table_id else None
    if order.order_type in dinein:
        order.status = "dining"
        if table:
            table.status, table.updated_at = "occupied", datetime.utcnow()
    else:
        order.status = "completed"
        order.completed_time = datetime.utcnow()
        _create_pickup_notification(order, current_user_id)
        if table:
            table.status, table.updated_at = "available", datetime.utcnow()
    order.updated_at = datetime.utcnow()
    db.session.commit()


def release_dine_in(order):
    from ._helpers import _normalize_order_type

    if _normalize_order_type(order.order_type) not in ("dinein", "dine_in"):
        return False, "仅堂食订单需要释放座位"
    if order.status != "dining":
        return False, "仅可释放用餐中的订单"
    table = Table.query.get(order.table_id) if order.table_id else None
    if table:
        table.status, table.updated_at = "available", datetime.utcnow()
    order.status = "completed"
    order.completed_time = datetime.utcnow()
    order.updated_at = datetime.utcnow()
    db.session.commit()
    return True, None
