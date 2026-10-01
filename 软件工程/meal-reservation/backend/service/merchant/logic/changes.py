"""Merchant order change request helpers."""
from datetime import datetime

from Models import Order, OrderChangeRequest, OrderItem, Restaurant, Table, db
from database import validate_order_items


def fetch_change_requests(current_user, status_filter):
    restaurant = Restaurant.query.filter_by(user_id=current_user.id).first()
    if not restaurant:
        return None, None
    query = OrderChangeRequest.query.filter_by(restaurant_id=restaurant.id)
    if status_filter:
        query = query.filter_by(status=status_filter)
    result = []
    for req in query.order_by(OrderChangeRequest.created_at.desc()).all():
        p = req.to_dict()
        p["order_number"] = req.order.order_number if req.order else None
        p["order_status"] = req.order.status if req.order else None
        if req.order and req.request_type == "modify":
            p["original_order_details"] = {
                "items": [i.to_dict() for i in req.order.items.all()],
                "note": req.order.note, "customer_count": req.order.customer_count,
            }
        result.append(p)
    return restaurant, result


def process(current_user, request_id, data):
    restaurant = Restaurant.query.filter_by(user_id=current_user.id).first()
    if not restaurant:
        return None, "未找到商家餐厅"
    cr = OrderChangeRequest.query.get(request_id)
    if not cr:
        return None, "申请单不存在"
    if cr.restaurant_id != restaurant.id:
        return None, "无权处理该申请"

    new_status = data.get("status")
    if new_status not in ("approved", "rejected"):
        return None, "状态必须为 approved/rejected"

    cr.status = new_status
    cr.admin_note = data.get("note")
    cr.updated_at = datetime.utcnow()
    order = Order.query.get(cr.order_id)

    if new_status == "approved" and order:
        if cr.request_type == "cancel" and order.status not in ("cancelled", "completed"):
            for item in (order.items.all() if hasattr(order.items, "all") else (order.items or [])):
                try:
                    if item.dish and item.dish.stock_quantity is not None:
                        item.dish.update_stock(item.quantity, "return", current_user.id,
                                               f"订单 {order.order_number} 取消申请批准，返还库存")
                except Exception:
                    pass
            order.status = "cancelled"
            order.cancelled_time = datetime.utcnow()
            if order.table_id:
                t = Table.query.get(order.table_id)
                if t:
                    t.status, t.updated_at = "available", datetime.utcnow()
        elif cr.request_type == "modify":
            payload = cr.payload
            if not payload or not payload.get("items"):
                cr.status = "rejected"
                cr.admin_note = "系统拒绝：修改内容为空"
                db.session.commit()
                return cr, None
            for item in (order.items.all() if hasattr(order.items, "all") else (order.items or [])):
                if item.dish and item.dish.stock_quantity is not None:
                    item.dish.update_stock(item.quantity, "return", current_user.id,
                                           f"订单 {order.order_number} 修改，返还")
            validated_items, total_price = validate_order_items(order.restaurant_id, payload["items"])
            for item in order.items.all():
                db.session.delete(item)
            db.session.flush()
            for v in validated_items:
                oi = OrderItem(dish_id=v["dish"].dish_id, quantity=v["quantity"],
                               unit_price=v["unit_price"], subtotal=v["subtotal"],
                               spiciness=v.get("spiciness"), garnish=v.get("garnish"))
                order.items.append(oi)
                if v["dish"].stock_quantity is not None:
                    v["dish"].update_stock(-v["quantity"], "update", current_user.id,
                                           f"订单 {order.order_number} 修改，新增")
            order.total_price = total_price
            order.note = payload.get("note", order.note)
            order.customer_count = payload.get("customer_count", order.customer_count)
            if "table_id" in payload:
                order.table_id = payload["table_id"]
            order.updated_at = datetime.utcnow()

    db.session.commit()
    return cr, None
