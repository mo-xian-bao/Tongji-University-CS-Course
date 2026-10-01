"""Merchant reservation helpers."""
from datetime import datetime

from sqlalchemy import func

from Models import Order, Restaurant, Table, db
from utils import BadRequestError, NotFoundError


def fetch_reservations(current_user, date_str, status, page, per_page):
    restaurant = Restaurant.query.filter_by(user_id=current_user.id).first()
    if not restaurant:
        return None, None
    query = Order.query.filter(Order.restaurant_id == restaurant.id, Order.reservation_status != "none")
    if date_str:
        try:
            fd = datetime.strptime(date_str, "%Y-%m-%d").date()
            query = query.filter(func.date(Order.reserved_time) == fd)
        except Exception:
            pass
    if status:
        query = query.filter(Order.reservation_status == status)
    pagination = query.order_by(Order.reserved_time.asc()).paginate(
        page=page, per_page=per_page, error_out=False)
    reservations = []
    for o in pagination.items:
        d = o.to_dict()
        d["user_name"] = o.user.username if o.user else None
        d["user_phone"] = o.user.phone if o.user else None
        reservations.append(d)
    return reservations, pagination


def update_status(current_user, order_id, data):
    from ._helpers import _create_pickup_notification

    restaurant = Restaurant.query.filter_by(user_id=current_user.id).first()
    if not restaurant:
        raise NotFoundError("您不是商家")
    order = Order.query.get(order_id)
    if not order or order.restaurant_id != restaurant.id:
        raise NotFoundError("订单不存在")
    if order.reservation_status == "none":
        raise BadRequestError("此订单不是预约订单")

    new_status = data.get("status")
    if new_status not in ["confirmed", "seated", "completed", "cancelled", "no_show"]:
        raise BadRequestError(f"无效的状态，可选值: {['confirmed', 'seated', 'completed', 'cancelled', 'no_show']}")

    transitions = {"pending": ["confirmed", "cancelled"],
                   "confirmed": ["seated", "cancelled", "no_show"],
                   "seated": ["completed"]}
    cur = order.reservation_status
    if cur in transitions and new_status not in transitions[cur]:
        raise BadRequestError(f"不能从 {cur} 转换到 {new_status}")

    order.reservation_status = new_status
    if new_status == "confirmed":
        order.status = "confirmed"
        order.confirmed_time = datetime.utcnow()
        order.pickup_number = Order.generate_pickup_number(restaurant.id)
    elif new_status == "seated":
        order.status = "dining"
    elif new_status == "completed":
        order.status = "completed"
        order.completed_time = datetime.utcnow()
        _create_pickup_notification(order, current_user.id)
    elif new_status in ("cancelled", "no_show"):
        order.status = "cancelled"
        order.cancelled_time = datetime.utcnow()
        order.reject_reason = data.get("reason", order.reject_reason)

    db.session.commit()
    return order


def fetch_table_schedule(current_user, table_id, date_str):
    restaurant = Restaurant.query.filter_by(user_id=current_user.id).first()
    if not restaurant:
        return None, None
    table = Table.query.get(table_id)
    if not table or table.restaurant_id != restaurant.id:
        return None, None
    fd = datetime.strptime(date_str, "%Y-%m-%d").date() if date_str else datetime.utcnow().date()
    sod = datetime.combine(fd, datetime.min.time())
    eod = datetime.combine(fd, datetime.max.time())
    reservations = Order.query.filter(
        Order.table_id == table_id,
        Order.reservation_status.in_(["pending", "confirmed", "seated"]),
        Order.reserved_time >= sod, Order.reserved_time <= eod,
    ).order_by(Order.reserved_time.asc()).all()
    schedule = [{
        "order_id": o.id, "order_number": o.order_number,
        "reserved_time": o.reserved_time.isoformat() if o.reserved_time else None,
        "reserved_end_time": o.reserved_end_time.isoformat() if o.reserved_end_time else None,
        "customer_count": o.customer_count,
        "user_name": o.user.username if o.user else None,
        "reservation_status": o.reservation_status,
    } for o in reservations]
    return table, schedule
