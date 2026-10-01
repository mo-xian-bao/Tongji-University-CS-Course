"""Order validation helpers — dish, coupon, reservation time, table, ownership checks."""
from datetime import datetime, timedelta

from Models import Dish, Order, Table
from database import check_table_availability_for_reservation
from utils import BadRequestError, ForbiddenError, NotFoundError


def validate_order_items(restaurant_id, items_data):
    """Validate all order items. Returns (validated_items, total_price)."""
    total_price = 0.0
    validated = []
    for item in items_data:
        dish_id = item.get("dish_id")
        qty = item.get("quantity", 1)
        if not dish_id or qty <= 0:
            raise BadRequestError("订单项参数错误")
        dish = Dish.query.filter_by(dish_id=dish_id).first()
        if not dish:
            raise NotFoundError(f"菜品ID {dish_id} 不存在")
        if dish.restaurant_id != restaurant_id:
            raise BadRequestError(f"菜品ID {dish_id} 不属于该餐厅")
        if not dish.is_available():
            raise BadRequestError(f"菜品 {dish.name} 已售罄或不可用")
        if dish.stock_quantity is not None and dish.stock_quantity < qty:
            raise BadRequestError(f"菜品 {dish.name} 库存不足")
        spiciness = item.get("spiciness")
        garnish = item.get("garnish")
        if dish.is_spicy_selectable and spiciness not in ["不辣", "微辣", "中辣", "特辣", "变态辣"]:
            raise BadRequestError(f"菜品 {dish.name} 的辣度选项无效")
        if dish.is_garnish_selectable and garnish not in ["要葱花香菜", "要葱花", "要香菜", "不要葱花不要香菜"]:
            raise BadRequestError(f"菜品 {dish.name} 的葱花香菜选项无效")
        unit_price = float(dish.price)
        subtotal = unit_price * qty
        total_price += subtotal
        validated.append({
            "dish": dish, "quantity": qty, "unit_price": unit_price,
            "subtotal": subtotal,
            "spiciness": spiciness if dish.is_spicy_selectable else None,
            "garnish": garnish if dish.is_garnish_selectable else None,
        })
    return validated, total_price


def validate_coupon(coupon_id, current_user_id, restaurant_id, original_price):
    """Validate coupon and return discount_amount. Raises on invalid."""
    from Models import CouponNotification, CouponUsage

    coupon = CouponNotification.query.get(coupon_id)
    if not coupon:
        raise NotFoundError("优惠券不存在")
    if coupon.restaurant_id != restaurant_id:
        raise BadRequestError("此优惠券不适用于该餐厅")
    if not coupon.is_active:
        raise BadRequestError("优惠券已停用")
    now = datetime.utcnow()
    if coupon.valid_from and now < coupon.valid_from:
        raise BadRequestError("优惠券还未生效")
    if coupon.valid_to and now > coupon.valid_to:
        raise BadRequestError("优惠券已过期")
    if coupon.min_spend and original_price < coupon.min_spend:
        raise BadRequestError(f"未达到最低消费金额，需满{coupon.min_spend:.2f}元")
    if CouponUsage.query.filter_by(user_id=current_user_id, coupon_id=coupon_id).first():
        raise BadRequestError("此优惠券已使用过")

    discount_amount = 0.0
    if coupon.discount_type == "amount":
        discount_amount = float(coupon.amount or 0)
    elif coupon.discount_type == "percentage":
        pct = float(coupon.amount or 0)
        discount_amount = original_price * (pct / 100.0)
    return min(discount_amount, original_price)


def validate_reservation_time(data, time_zone, table_id, customer_count):
    """Validate reservation time and table. Returns (reserved_time, reserved_end_time, reservation_status)."""
    from datetime import timezone as tz_utc

    reserved_time = datetime.fromisoformat(
        data["reserved_time"].replace("Z", "+00:00")
    ).replace(tzinfo=time_zone).astimezone(tz_utc)
    if reserved_time.tzinfo is not None:
        reserved_time = reserved_time.replace(tzinfo=None)
    dur = data.get("duration", 120)
    reserved_end_time = reserved_time + timedelta(minutes=dur)
    now = datetime.utcnow()
    if reserved_time < now + timedelta(minutes=30):
        raise BadRequestError("预约时间至少需要提前30分钟")
    if reserved_time > now + timedelta(days=7):
        raise BadRequestError("预约时间不能超过7天后")
    if table_id:
        avail, seats = check_table_availability_for_reservation(
            table_id, reserved_time, reserved_end_time, customer_count
        )
        if not avail:
            raise BadRequestError("该桌位在所选时段不可用")
    return reserved_time, reserved_end_time, "pending"


def validate_table(table_id, restaurant_id, customer_count, is_reservation, exclude_order_id=None):
    """Validate table exists and has capacity."""
    table = Table.query.get(table_id)
    if not table:
        raise NotFoundError("桌位不存在")
    if table.restaurant_id != restaurant_id:
        raise BadRequestError("桌位不属于该餐厅")
    if not is_reservation:
        occ = table.get_current_occupancy(exclude_order_id=exclude_order_id) if exclude_order_id else table.get_current_occupancy()
        if not table.can_accommodate(customer_count, exclude_order_id=exclude_order_id):
            avail = 0 if table.table_type == "private" and occ > 0 else table.capacity - occ
            raise BadRequestError(f"该桌位剩余{avail}个座位，无法容纳{customer_count}人，请选择其他桌位")
    return table


def get_order_or_404(order_id):
    order = Order.query.get(order_id)
    if not order:
        raise NotFoundError("订单不存在")
    return order


def ensure_ownership(order, current_user):
    if order.user_id != current_user.id:
        raise ForbiddenError("无权访问此订单")


def ensure_status(order, expected_status, message="状态不允许此操作"):
    if order.status != expected_status:
        raise BadRequestError(message)
