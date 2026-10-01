"""Order change request operations."""
from datetime import datetime

from Models import Dish, OrderChangeRequest, Table, db
from utils import BadRequestError, BusinessError

from .validation import get_order_or_404, ensure_ownership, ensure_status


def request_order_change(current_user, order_id, data):
    order = get_order_or_404(order_id)
    ensure_ownership(order, current_user)

    if order.status != "confirmed":
        raise BadRequestError("仅可对已确认订单提交申请")
    request_type = (data.get("type") or "modify").strip()
    if request_type not in {"modify", "cancel"}:
        raise BadRequestError("申请类型无效")

    if request_type == "modify":
        payload = data.get("payload", {})
        if not payload or not payload.get("items"):
            raise BadRequestError("申请修改的内容不能为空")
        orig_qty = {item.dish_id: item.quantity for item in order.items}
        for item_data in payload.get("items", []):
            dish_id = item_data.get("dish_id")
            qty = int(item_data.get("quantity", 0))
            dish = Dish.query.get(dish_id)
            if not dish:
                raise BadRequestError(f"菜品ID {dish_id} 不存在")
            eff = (dish.stock_quantity or 0) + orig_qty.get(dish_id, 0)
            if eff < qty:
                raise BadRequestError(f"菜品 '{dish.name}' 库存不足，仅剩 {eff} 件可供调配")
        new_table_id = payload.get("table_id", order.table_id)
        new_customer_count = payload.get("customer_count", order.customer_count)
        if new_table_id:
            table = Table.query.get(new_table_id)
            if not table:
                raise BadRequestError("申请的桌位不存在")
            if table.restaurant_id != order.restaurant_id:
                raise BadRequestError("申请的桌位不属于该餐厅")
            occ = table.get_current_occupancy(exclude_order_id=order.id)
            if table.capacity < occ + new_customer_count:
                avail = table.capacity - occ
                raise BadRequestError(f"桌位 {table.table_number} 容量不足，除本单外还剩 {avail} 个座位")

    if OrderChangeRequest.query.filter_by(order_id=order.id, status="pending").first():
        raise BadRequestError("已有待处理申请，请勿重复提交")

    restaurant = order.restaurant
    if not restaurant:
        raise BusinessError("无法找到订单关联的餐厅信息", 500)

    cr = OrderChangeRequest(
        order_id=order.id,
        user_id=current_user.id,
        restaurant_id=restaurant.id,
        request_type=request_type,
        reason=(data.get("reason") or "").strip(),
        payload=data.get("payload") or {},
        status="pending",
    )
    db.session.add(cr)
    return cr


def withdraw_change_request(current_user, request_id):
    req = OrderChangeRequest.query.get(request_id)
    from utils import NotFoundError, ForbiddenError
    if not req:
        raise NotFoundError("申请单不存在")
    if req.user_id != current_user.id:
        raise ForbiddenError("无权限撤回该申请")
    if req.status != "pending":
        raise BadRequestError("申请已被处理，无法撤回")
    req.status = "withdrawn"
    req.updated_at = datetime.utcnow()
    return req
