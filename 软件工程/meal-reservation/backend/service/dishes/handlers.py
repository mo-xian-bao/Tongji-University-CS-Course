"""Dishes service handlers — orchestration layer."""
from Models import DishLaunchNotification, db
from utils import ApiError, BadRequestError, BusinessError, NotFoundError, ok

from .logic import querier as _q, status as _st, crud
from .logic.recommendations import get_recommendations
from .logic.menu import list_dishes, get_menu
from .logic.images import upload_image


# ── status ───────────────────────────────────────────────────────────

def update_dish_status(current_user, dish_id, data):
    rest = _q.get_merchant_rest(current_user)
    dish = _q.get_dish(dish_id, rest.id)
    _st.execute_status_change(dish, data.get("status"), data, rest, current_user.id)
    db.session.commit()
    return ok({"success": True, "message": "状态已更新", "data": dish.to_menu_card()}, 200)


def off_shelf_info(current_user, dish_id):
    rest = _q.get_merchant_rest(current_user)
    _q.get_dish(dish_id, rest.id)  # validate exists
    latest = _q.get_latest_off_shelf_log(rest.id, dish_id)
    return ok({"success": True, "data": latest.to_dict() if latest else None}, 200)


def batch_update_status(current_user, data):
    rest = _q.get_merchant_rest(current_user)
    ids = {int(did) for did in data.get("dish_ids", []) if str(did).isdigit()}
    new_status = data.get("status")
    if not ids or new_status not in {"available", "sold_out", "unavailable"}:
        raise BadRequestError("参数不完整")
    dishes = _q.get_dishes_by_ids(ids, rest.id)
    _st.batch_apply_status(dishes, new_status)
    db.session.commit()
    return ok({"success": True, "message": "批量更新成功"}, 200)


def batch_append_tag(current_user, data):
    rest = _q.get_merchant_rest(current_user)
    ids = {int(did) for did in data.get("dish_ids", []) if str(did).isdigit()}
    tag = (data.get("tag") or "").strip()
    if not ids or not tag:
        raise BadRequestError("参数不完整")
    for dish in _q.get_dishes_by_ids(ids, rest.id):
        tags = set(dish.tags or [])
        tags.add(tag)
        dish.tags = list(tags)
    db.session.commit()
    return ok({"success": True, "message": "标签批量更新成功"}, 200)


# ── CRUD ─────────────────────────────────────────────────────────────

def create_dish(current_user, data):
    dish, notification = crud.execute_create(data, current_user.id)
    db.session.commit()
    resp = {"success": True, "message": "菜品创建成功", "data": dish.to_dict()}
    if notification:
        resp["dish_launch_notification"] = notification
    return ok(resp, 201)


def get_dish(dish_id, req_restaurant_id=None):
    dish = _q.get_dish(dish_id, req_restaurant_id)
    return ok({"success": True, "data": dish.to_dict()}, 200)


def update_dish(dish_id, data):
    dish = _q.get_dish(dish_id)
    crud.execute_update(dish, data)
    db.session.commit()
    return ok({"success": True, "message": "菜品更新成功", "data": dish.to_dict()}, 200)


def delete_dish(current_user, dish_id, restaurant_id):
    dish = _q.get_dish(dish_id, restaurant_id)
    rest = _q.get_restaurant(restaurant_id)
    _q.validate_dish_ownership(current_user, rest)
    try:
        DishLaunchNotification.query.filter_by(dish_id=dish_id).delete()
        name = dish.name
        db.session.delete(dish)
        db.session.commit()
        return ok({"success": True, "message": f'菜品 "{name}" 删除成功'}, 200)
    except Exception as exc:
        db.session.rollback()
        if isinstance(exc, ApiError):
            raise
        raise BusinessError("数据库操作失败", 500, {"error": str(exc)})
