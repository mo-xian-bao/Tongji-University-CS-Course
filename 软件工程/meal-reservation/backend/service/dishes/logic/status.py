"""Dish status management — implementation details."""
from datetime import datetime

from Models import DishOffShelfLog, StockLog, db
from utils import BadRequestError


def resolve_off_shelf_reason(new_status, data):
    reason = (data.get("off_shelf_reason") or "").strip()
    if new_status == "unavailable" and not reason:
        return None, "下架需要填写下架原因"
    if new_status == "sold_out":
        reason = "售罄"
    return reason, None


def apply_stock_quantity(dish, data, new_status):
    old_stock = dish.stock_quantity
    if "stock_quantity" in data:
        sq = max(0, int(data["stock_quantity"])) if str(data["stock_quantity"]).lstrip("-").isdigit() else None
        if sq is not None:
            dish.stock_quantity = sq
            if dish.stock_capacity is None or sq > (dish.stock_capacity or 0):
                dish.stock_capacity = sq
    if new_status == "sold_out":
        dish.stock_quantity = 0
    elif new_status == "available" and (dish.stock_quantity or 0) == 0:
        dish.stock_quantity = dish.stock_capacity or dish.stock_quantity
    new_stock = dish.stock_quantity
    return old_stock, new_stock, new_stock - old_stock


def record_stock_log(restaurant_id, dish_id, old_stock, new_stock, diff, price, operator_id):
    db.session.add(StockLog(
        restaurant_id=restaurant_id, dish_id=dish_id,
        change_type="restock" if diff > 0 else "loss",
        quantity_change=diff, stock_before=old_stock, stock_after=new_stock,
        cost=price * (diff if diff > 0 else 0),
        operator_id=operator_id, note="补货" if diff > 0 else "损耗",
    ))


def record_off_shelf_log(restaurant_id, dish_id, reason, operator_id):
    db.session.add(DishOffShelfLog(
        restaurant_id=restaurant_id, dish_id=dish_id,
        reason=reason, operator_id=operator_id,
    ))


def validate_new_status(new_status):
    if new_status not in {"available", "sold_out", "unavailable"}:
        raise BadRequestError("状态不合法")


def execute_status_change(dish, new_status, data, rest, operator_id):
    """Full status change: validate → apply stock → log → save. Returns dish."""
    validate_new_status(new_status)
    reason, err = resolve_off_shelf_reason(new_status, data)
    if err:
        raise BadRequestError(err)

    old_stock, new_stock, diff = apply_stock_quantity(dish, data, new_status)
    if diff != 0:
        price = float(dish.original_price or 0)
        record_stock_log(rest.id, dish.dish_id, old_stock, new_stock, diff, price, operator_id)

    dish.status = new_status
    dish.updated_at = datetime.utcnow()
    if new_status in {"sold_out", "unavailable"}:
        record_off_shelf_log(rest.id, dish.dish_id, reason, operator_id)
    return dish


def batch_apply_status(dishes, new_status):
    for dish in dishes:
        dish.status = new_status
        if new_status == "sold_out":
            dish.stock_quantity = 0
        elif new_status == "available" and (dish.stock_quantity or 0) == 0:
            dish.stock_quantity = dish.stock_capacity or dish.stock_quantity
        dish.updated_at = datetime.utcnow()
