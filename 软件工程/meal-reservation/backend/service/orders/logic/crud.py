"""Orders CRUD operations."""
import logging
from datetime import datetime, timedelta, timezone
from zoneinfo import ZoneInfo

from Models import (
    CouponUsage,
    Dish,
    Order,
    OrderChangeRequest,
    OrderItem,
    Restaurant,
    Review,
    Table,
    db,
)
from database import validate_order_items

from .validation import (
    ensure_ownership,
    ensure_status,
    get_order_or_404,
    validate_reservation_time,
    validate_table,
)
from .pricing import calculate_order

logger = logging.getLogger("orders")


def create_order(current_user, data):
    rid = data["restaurant_id"]
    items_data = data["items"]
    restaurant = Restaurant.query.get(rid)
    if not restaurant:
        from utils import NotFoundError
        raise NotFoundError("餐厅不存在")

    table_id = data.get("table_id")
    customer_count = data.get("customer_count", 1)
    is_reservation = data.get("order_type") == "dinein" and data.get("reserved_time")
    time_zone = ZoneInfo(data.get("timezone")) if data.get("timezone") else None
    order_type = data.get("order_type", "takeout")

    if order_type == "dinein" and table_id:
        validate_table(table_id, rid, customer_count, is_reservation)

    pickup_time = None
    if data.get("pickup_time"):
        try:
            pickup_time = datetime.fromisoformat(data["pickup_time"]).replace(tzinfo=time_zone).astimezone(timezone.utc)
            if pickup_time < datetime.utcnow():
                from utils import BadRequestError
                raise BadRequestError("取餐时间不能是过去的时间")
        except Exception:
            from utils import BadRequestError
            raise BadRequestError("取餐时间格式错误")

    validated, original_price, discount_amount, total_price = calculate_order(
        items_data, rid, data.get("coupon_id"), current_user.id
    )

    reservation_status = "none"
    reserved_time = reserved_end_time = None
    if order_type == "dinein" and data.get("reserved_time"):
        try:
            reserved_time, reserved_end_time, reservation_status = validate_reservation_time(
                data, time_zone, table_id, customer_count
            )
        except ValueError as e:
            from utils import BadRequestError
            raise BadRequestError(f"预约时间格式错误: {str(e)}")

    order = Order(
        order_number=Order.generate_order_number(),
        user_id=current_user.id,
        restaurant_id=rid,
        table_id=table_id,
        customer_count=customer_count,
        order_type=order_type,
        status="pending",
        reserved_time=reserved_time,
        reserved_end_time=reserved_end_time,
        reservation_status=reservation_status,
        total_price=total_price,
        original_price=original_price,
        discount_amount=discount_amount,
        coupon_id=data.get("coupon_id"),
        note=data.get("note"),
        order_time=datetime.utcnow(),
    )
    for item in validated:
        oi = OrderItem(
            dish_id=item["dish"].dish_id,
            quantity=item["quantity"],
            unit_price=item["unit_price"],
            subtotal=item["subtotal"],
            spiciness=item["spiciness"],
            garnish=item["garnish"],
        )
        order.items.append(oi)
        if item["dish"].stock_quantity is not None:
            item["dish"].update_stock(-item["quantity"], "销售", current_user.id, f"订单 {order.order_number} 销售")
    db.session.add(order)
    db.session.flush()
    if data.get("coupon_id"):
        db.session.add(CouponUsage(
            user_id=current_user.id, coupon_id=data["coupon_id"],
            order_id=order.id, used_at=datetime.utcnow(),
        ))
    return order, total_price, original_price, discount_amount


def list_user_orders(current_user):
    orders = Order.query.filter_by(user_id=current_user.id).order_by(Order.order_time.desc()).all()
    result = []
    for order in orders:
        d = order.to_dict()
        d["items"] = [item.to_dict() for item in order.items.all()]
        cr = (
            OrderChangeRequest.query.filter_by(order_id=order.id)
            .filter(OrderChangeRequest.status.in_(["pending", "approved", "rejected"]))
            .order_by(OrderChangeRequest.updated_at.desc())
            .first()
        )
        d["latest_change_request"] = cr.to_dict() if cr else None
        try:
            rv = Review.query.filter_by(order_id=order.id, user_id=current_user.id).order_by(Review.created_at.desc()).first()
            d["has_review"] = bool(rv)
            d["review_summary"] = {
                "id": rv.id,
                "review_status": rv.review_status,
                "created_at": rv.created_at.isoformat() if rv.created_at else None,
            } if rv else None
        except Exception:
            d["has_review"] = False
            d["review_summary"] = None
        result.append(d)
    return result


def get_order_detail(current_user, order_id):
    order = get_order_or_404(order_id)
    ensure_ownership(order, current_user)
    d = order.to_dict()
    d["items"] = [item.to_dict() for item in order.items.all()]
    return d


def update_user_order(current_user, order_id, data):
    order = get_order_or_404(order_id)
    ensure_ownership(order, current_user)
    ensure_status(order, "pending", "仅可修改待接单状态的订单")

    items_data = data.get("items", [])
    if not items_data:
        from utils import BadRequestError
        raise BadRequestError("订单项不能为空")

    orig_qty = {item.dish_id: item.quantity for item in order.items}

    # Validate stock with original quantities returned
    for item_data in items_data:
        dish_id = item_data.get("dish_id")
        qty = int(item_data.get("quantity", 0))
        dish = Dish.query.get(dish_id)
        if not dish:
            from utils import BadRequestError
            raise BadRequestError(f"菜品ID {dish_id} 不存在")
        orig = orig_qty.get(dish_id, 0)
        eff = (dish.stock_quantity or 0) + orig
        if eff < qty:
            from utils import BadRequestError
            raise BadRequestError(f"菜品 '{dish.name}' 库存不足，仅剩 {eff} 件可供调配")

    # Return stock from original items
    for item in order.items:
        if item.dish and item.dish.stock_quantity is not None:
            item.dish.update_stock(item.quantity, "return", current_user.id, f"订单 {order.order_number} 修改，返还")
    db.session.commit()

    # Validate table
    new_table_id = data.get("table_id", order.table_id)
    new_customer_count = data.get("customer_count", order.customer_count)
    if new_table_id:
        table = Table.query.get(new_table_id)
        if not table:
            from utils import NotFoundError
            raise NotFoundError("所选桌位不存在")
        if table.restaurant_id != order.restaurant_id:
            from utils import BadRequestError
            raise BadRequestError("所选桌位不属于该餐厅")
        if not table.can_accommodate(new_customer_count, exclude_order_id=order.id):
            occ = table.get_current_occupancy(exclude_order_id=order.id)
            avail = 0 if table.table_type == "private" and occ > 0 else table.capacity - occ
            from utils import BadRequestError
            raise BadRequestError(f"桌位 {table.table_number} 容量不足，除本单外还剩 {avail} 个座位")

    # Delete existing items and replace with new
    for existing_item in order.items.all():
        db.session.delete(existing_item)
    db.session.flush()
    validated_items, total_price = validate_order_items(order.restaurant_id, items_data)
    for item_data in validated_items:
        oi = OrderItem(
            dish_id=item_data["dish"].dish_id,
            quantity=item_data["quantity"],
            unit_price=item_data["unit_price"],
            subtotal=item_data["subtotal"],
            spiciness=item_data["spiciness"],
            garnish=item_data["garnish"],
        )
        order.items.append(oi)
        if item_data["dish"].stock_quantity is not None:
            item_data["dish"].update_stock(-item_data["quantity"], "update", current_user.id, f"订单 {order.order_number} 修改，新增")
    order.note = data.get("note", order.note)
    order.table_id = new_table_id
    order.customer_count = new_customer_count
    order.total_price = total_price
    order.updated_at = datetime.utcnow()
    return order


def cancel_user_order(current_user, order_id):
    order = get_order_or_404(order_id)
    ensure_ownership(order, current_user)
    ensure_status(order, "pending", "仅可取消待接单状态的订单")

    for item in order.items.all():
        try:
            if item.dish and item.dish.stock_quantity is not None:
                item.dish.update_stock(item.quantity, "return", current_user.id, f"订单 {order.order_number} 取消返还")
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
    order.status = "cancelled"
    order.cancelled_time = datetime.utcnow()
    order.updated_at = datetime.utcnow()
    return order
