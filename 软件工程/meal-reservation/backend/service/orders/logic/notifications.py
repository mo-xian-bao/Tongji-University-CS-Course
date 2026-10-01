"""Order pickup notification logic."""
import logging
from datetime import timezone

from Models import Message, Order
from utils import NotFoundError, ForbiddenError

logger = logging.getLogger("orders")


def build_pickup_payload(message, include_items=False):
    order = message.order if message else None
    rest = order.restaurant if order else None
    base = {
        "id": message.id if message else None,
        "order_id": order.id if order else None,
        "order_number": order.order_number if order else None,
        "restaurant_id": rest.id if rest else None,
        "restaurant_name": rest.name if rest else None,
        "pickup_number": order.pickup_number if order else None,
        "status": order.status if order else None,
        "text": message.text if message else None,
        "created_at": message.created_at.replace(tzinfo=timezone.utc).isoformat() if message and message.created_at else None,
        "total_price": float(order.total_price) if order and order.total_price is not None else None,
    }
    if include_items and order and hasattr(order.items, "all"):
        try:
            base["items"] = [item.to_dict() for item in order.items.all()]
        except Exception:
            base["items"] = []
    return base


def list_pickup_notifications(current_user):
    msgs = (
        Message.query.join(Order, Message.order_id == Order.id)
        .filter(Order.user_id == current_user.id, Message.message_type == "pickup_notice")
        .order_by(Message.created_at.desc())
        .all()
    )
    return [build_pickup_payload(m) for m in msgs]


def get_pickup_notification(current_user, notification_id):
    msg = Message.query.get(notification_id)
    if not msg or msg.message_type != "pickup_notice":
        raise NotFoundError("通知不存在")
    order = msg.order
    if not order or order.user_id != current_user.id:
        raise ForbiddenError("无权访问该通知")
    return build_pickup_payload(msg, include_items=True)
