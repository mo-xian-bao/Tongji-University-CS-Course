"""Shared merchant helpers."""
from Models import Message, Restaurant, db
from database import get_merchant_restaurant


def _normalize_order_type(order_type):
    return (order_type or "").replace("-", "").replace("_", "").lower()


def _is_takeout_order(order):
    return _normalize_order_type(getattr(order, "order_type", None)) == "takeout"


def _create_pickup_notification(order, sender_id):
    if not order or not _is_takeout_order(order):
        return
    if Message.query.filter_by(order_id=order.id, message_type="pickup_notice").first():
        return
    hint = order.pickup_number or "请凭订单编号取餐"
    text = f"您的订单 {order.order_number} 已完成，可以前往取餐。取餐号：{hint}"
    sender_type = "merchant" if sender_id else "system"
    db.session.add(Message(
        order_id=order.id, sender_id=sender_id or 0,
        sender_type=sender_type, text=text, message_type="pickup_notice",
    ))


def require_merchant(current_user):
    restaurant = get_merchant_restaurant(current_user)
    if not restaurant:
        return None
    return restaurant
