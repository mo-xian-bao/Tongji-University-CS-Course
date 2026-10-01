"""Users service handlers — orchestration layer."""
from Models import db
from utils import ApiError, BusinessError, ok

from .logic import credentials, profile, queries


def get_profile(current_user):
    try:
        data = profile.get_profile(current_user)
        return ok({"success": True, "message": "获取用户信息成功", "data": {"user": data}}, 200)
    except ApiError:
        raise
    except Exception as exc:
        raise BusinessError("获取用户信息失败", 500, {"error": str(exc)})


def get_user_by_id(current_user, user_id):
    try:
        data = profile.get_user_by_id(current_user, user_id)
        return ok({"success": True, "data": data}, 200)
    except ApiError:
        raise
    except Exception as exc:
        raise BusinessError("获取用户信息失败", 500, {"error": str(exc)})


def change_password(current_user, old_password, new_password):
    try:
        credentials.change_password(current_user, old_password, new_password)
        db.session.commit()
        return ok({"success": True, "message": "密码修改成功"}, 200)
    except ApiError:
        raise
    except Exception as exc:
        db.session.rollback()
        raise BusinessError("修改失败", 500, {"error": str(exc)})


def change_phone(current_user, new_phone, sms_code):
    try:
        credentials.change_phone(current_user, new_phone, sms_code)
        db.session.commit()
        return ok({"success": True, "message": "手机号修改成功", "data": {"user": current_user.to_dict()}}, 200)
    except ApiError:
        raise
    except Exception as exc:
        db.session.rollback()
        raise BusinessError("修改失败", 500, {"error": str(exc)})


def update_profile(current_user, form, files):
    try:
        data = profile.update_profile(current_user, form, files)
        db.session.commit()
        return ok({"success": True, "message": "更新成功", "data": {"user": data}}, 200)
    except ApiError:
        raise
    except Exception as exc:
        db.session.rollback()
        raise BusinessError("更新失败", 500, {"error": str(exc)})


def followed_restaurants(current_user):
    try:
        return queries.followed_restaurants(current_user)
    except ApiError:
        raise
    except Exception as exc:
        raise BusinessError("获取关注列表失败", 500, {"error": str(exc)})


def user_restaurant(current_user):
    try:
        data = queries.user_restaurant(current_user)
        return ok({"success": True, "message": "获取餐厅信息成功", "data": data}, 200)
    except ApiError:
        raise
    except Exception as exc:
        raise BusinessError("获取餐厅信息失败", 500, {"error": str(exc)})


def system_notifications(current_user):
    try:
        data = queries.system_notifications(current_user)
        return ok({"success": True, "data": data}, 200)
    except ApiError:
        raise
    except Exception as exc:
        raise BusinessError("获取系统通知失败", 500, {"error": str(exc)})
