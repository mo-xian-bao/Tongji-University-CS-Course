"""Dish CRUD helpers."""
from datetime import datetime

from Models import Dish, StockLog, db
from database import create_dish_launch_notification
from utils import BadRequestError, format_dish_data, validate_dish_data


def validate_and_format(data):
    rid = data.get("restaurant_id")
    try:
        rid = int(rid)
    except (TypeError, ValueError):
        raise BadRequestError("无效的餐厅ID")
    data["restaurant_id"] = rid
    valid, msg = validate_dish_data(data)
    if not valid:
        raise BadRequestError("数据验证失败", {"errors": msg})
    fmtd = format_dish_data(data)
    fmtd["restaurant_id"] = rid
    if isinstance(data.get("tags"), list):
        fmtd["tags"] = data["tags"]
    fmtd["monthly_sales"] = int(data.get("monthly_sales", 0) or 0)
    fmtd["stock_capacity"] = data.get("stock_capacity", fmtd.get("stock_quantity"))
    return fmtd


def create_initial_stock_log(dish, operator_id):
    if dish.stock_quantity and dish.stock_quantity > 0:
        price = float(dish.original_price or 0)
        db.session.add(StockLog(
            restaurant_id=dish.restaurant_id, dish_id=dish.dish_id,
            change_type="restock", quantity_change=dish.stock_quantity,
            stock_before=0, stock_after=dish.stock_quantity,
            operator_id=operator_id, cost=price * dish.stock_quantity,
            note="创建菜品初始库存",
        ))


def try_create_launch_notification(dish):
    try:
        n = create_dish_launch_notification(dish, auto_commit=True)
        return n.to_dict() if n else None
    except Exception:
        return None


def apply_update_fields(dish, fmtd):
    fmtd.pop("restaurant_id", None)
    for field, value in fmtd.items():
        if field in ("id", "dish_id"):
            continue
        setattr(dish, field, value)
    dish.updated_at = datetime.utcnow()


def execute_create(data, operator_id):
    """Full create: validate → build → stock log → notification. Returns dish + notif."""
    fmtd = validate_and_format(data)
    dish = Dish(**fmtd)
    db.session.add(dish)
    db.session.flush()
    create_initial_stock_log(dish, operator_id)
    notification = try_create_launch_notification(dish)
    return dish, notification


def execute_update(dish, data):
    """Full update: validate → apply fields. Modifies dish in-place."""
    rid = data.get("restaurant_id")
    try:
        rid = int(rid)
    except (TypeError, ValueError):
        raise BadRequestError("无效的餐厅ID")
    data["restaurant_id"] = rid
    fmtd = validate_and_format(data)
    apply_update_fields(dish, fmtd)
