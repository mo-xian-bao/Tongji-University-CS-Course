"""Restaurant service handlers — orchestration layer."""
from Models import db
from utils import ApiError, BusinessError, coerce_result, ok

from .logic import availability, broadcasts, crud, follows, reviews


def create_restaurant_api(current_user, data):
    try:
        return coerce_result(crud.create_restaurant(current_user, data))
    except ApiError:
        raise
    except Exception as exc:
        raise BusinessError("创建餐厅失败", 500, {"error": str(exc)})


def update_restaurant_api(current_user, restaurant_id, data):
    try:
        return coerce_result(crud.update_restaurant(current_user, restaurant_id, data))
    except ApiError:
        raise
    except Exception as exc:
        raise BusinessError("更新餐厅失败", 500, {"error": str(exc)})


def get_restaurant_status(current_user, restaurant_id):
    try:
        rest = crud.get_restaurant_status(current_user, restaurant_id)
        return ok({
            "success": True,
            "message": "获取营业状态成功",
            "data": {"restaurant_id": rest.id, "is_open": bool(rest.is_open)},
        }, 200)
    except ApiError:
        raise
    except Exception as exc:
        raise BusinessError("获取状态失败", 500, {"error": str(exc)})


def set_restaurant_status(current_user, restaurant_id, is_open=None):
    try:
        rest = crud.set_restaurant_status(current_user, restaurant_id, is_open)
        db.session.commit()
        return ok({
            "success": True,
            "message": "营业状态更新成功",
            "data": {"restaurant_id": rest.id, "is_open": bool(rest.is_open)},
        }, 200)
    except ApiError:
        raise
    except Exception as exc:
        db.session.rollback()
        raise BusinessError("更新状态失败", 500, {"error": str(exc)})


def get_by_user_id(user_id):
    try:
        return coerce_result(crud.get_by_user_id(user_id))
    except ApiError:
        raise
    except Exception as exc:
        raise BusinessError("获取餐厅信息失败", 500, {"error": str(exc)})


def get_all():
    try:
        data = crud.get_all()
        return ok({"success": True, "message": "获取餐厅列表成功", "data": {"restaurants": data}}, 200)
    except ApiError:
        raise
    except Exception as exc:
        raise BusinessError("获取餐厅列表失败", 500, {"error": str(exc)})


def get_by_id(restaurant_id):
    try:
        data = crud.get_by_id(restaurant_id)
        return ok({"success": True, "message": "获取餐厅信息成功", "data": data}, 200)
    except ApiError:
        raise
    except Exception as exc:
        raise BusinessError("获取餐厅信息失败", 500, {"error": str(exc)})


def get_tables_public(restaurant_id):
    try:
        tables = crud.get_tables_public(restaurant_id)
        return ok({"tables": tables, "success": True}, 200)
    except ApiError:
        raise
    except Exception as exc:
        raise BusinessError("获取桌位信息失败", 500, {"error": str(exc)})


def create_broadcast_api(restaurant_id, data):
    try:
        return broadcasts.create_broadcast_api(restaurant_id, data)
    except ApiError:
        raise
    except Exception as exc:
        raise BusinessError("创建广播失败", 500, {"error": str(exc)})


def create_coupon_broadcast_api(current_user, restaurant_id, data):
    try:
        return coerce_result(broadcasts.create_coupon_broadcast_api(current_user, restaurant_id, data))
    except ApiError:
        raise
    except Exception as exc:
        raise BusinessError("推送优惠券失败", 500, {"error": str(exc)})


def broadcast_list(restaurant_id, include_inactive, page, per_page):
    try:
        return coerce_result(broadcasts.broadcast_list(restaurant_id, include_inactive, page, per_page))
    except ApiError:
        raise
    except Exception as exc:
        raise BusinessError("获取广播列表失败", 500, {"error": str(exc)})


def broadcast_update(restaurant_id, broadcast_id, data):
    try:
        return coerce_result(broadcasts.broadcast_update(restaurant_id, broadcast_id, data))
    except ApiError:
        raise
    except Exception as exc:
        raise BusinessError("更新广播失败", 500, {"error": str(exc)})


def broadcast_delete(restaurant_id, broadcast_id):
    try:
        return coerce_result(broadcasts.broadcast_delete(restaurant_id, broadcast_id))
    except ApiError:
        raise
    except Exception as exc:
        raise BusinessError("删除广播失败", 500, {"error": str(exc)})


def broadcast_detail(broadcast_id):
    try:
        return coerce_result(broadcasts.broadcast_detail(broadcast_id))
    except ApiError:
        raise
    except Exception as exc:
        raise BusinessError("获取广播详情失败", 500, {"error": str(exc)})


def handle_follow(user_id, restaurant_id, method):
    try:
        return coerce_result(follows.handle_follow(user_id, restaurant_id, method))
    except ApiError:
        raise
    except Exception as exc:
        raise BusinessError("操作失败", 500, {"error": str(exc)})


def get_available_tables(restaurant_id, reserved_time_str, customer_count, duration, time_zone_str):
    try:
        tables = availability.get_available_tables(
            restaurant_id, reserved_time_str, customer_count, duration, time_zone_str
        )
        return ok({"success": True, "data": {"tables": tables}}, 200)
    except ApiError:
        raise
    except Exception as exc:
        raise BusinessError("获取桌位信息失败", 500, {"error": str(exc)})


def get_available_slots(restaurant_id, date_str, days, time_zone_str):
    try:
        bh, result = availability.get_available_slots(restaurant_id, date_str, days, time_zone_str)
        return ok({"success": True, "data": {"business_hours": bh, "available_days": result}}, 200)
    except ApiError:
        raise
    except Exception as exc:
        raise BusinessError("获取可用时段失败", 500, {"error": str(exc)})


def get_restaurant_reviews(restaurant_id, page=1, per_page=20, auth_header=""):
    try:
        reviews_list, total = reviews.get_restaurant_reviews(restaurant_id, page, per_page, auth_header)
        return ok({"success": True, "data": {"reviews": reviews_list, "total": total}}, 200)
    except ApiError:
        raise
    except Exception as exc:
        raise BusinessError("获取评价失败", 500, {"error": str(exc)})
