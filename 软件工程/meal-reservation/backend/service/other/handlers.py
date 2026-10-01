"""Other service handlers — orchestration layer (health, uploads, notifications, applications, reviews, messages)."""
from flask import current_app

from Models import db
from utils import ApiError, BadRequestError, BusinessError, ok

from .logic import applications, health, messages as msg_logic, notifications, reviews, uploads


def get_health():
    return health.get_health()


def upload_file(file, host_url):
    try:
        return uploads.upload_file(file, host_url)
    except ApiError:
        raise
    except Exception as exc:
        raise BusinessError("文件上传失败", 500, {"error": str(exc)})


def list_dish_notifications(restaurant_id=None, include_inactive=False, page=1, per_page=20):
    try:
        return notifications.list_dish_notifications(restaurant_id, include_inactive, page, per_page)
    except ApiError:
        raise
    except Exception as exc:
        raise BusinessError("获取菜品通知失败", 500, {"error": str(exc)})


def fetch_dish_notification(notification_id):
    try:
        return notifications.fetch_dish_notification(notification_id)
    except ApiError:
        raise
    except Exception as exc:
        raise BusinessError("获取通知详情失败", 500, {"error": str(exc)})


def list_coupon_notifications(current_user_id, restaurant_id=None, include_inactive=False, page=1, per_page=20):
    try:
        return notifications.list_coupon_notifications(current_user_id, restaurant_id, include_inactive, page, per_page)
    except ApiError:
        raise
    except Exception as exc:
        raise BusinessError("获取优惠券通知失败", 500, {"error": str(exc)})


def fetch_coupon_notification(notification_id):
    try:
        return notifications.fetch_coupon_notification(notification_id)
    except ApiError:
        raise
    except Exception as exc:
        raise BusinessError("获取通知详情失败", 500, {"error": str(exc)})


def list_or_create_merchant_application(method, content_type, form_data, json_data, current_user):
    try:
        result = applications.list_or_create(method, content_type, form_data, json_data, current_user)
        db.session.commit()
        return result
    except ApiError:
        raise
    except Exception as exc:
        db.session.rollback()
        raise BusinessError("申请操作失败", 500, {"error": str(exc)})


def get_or_update_merchant_application(method, content_type, form_data, json_data, current_user, application_id):
    try:
        result = applications.get_or_update(method, content_type, form_data, json_data, current_user, application_id)
        db.session.commit()
        return result
    except ApiError:
        raise
    except Exception as exc:
        db.session.rollback()
        raise BusinessError("申请操作失败", 500, {"error": str(exc)})


def submit_review(current_user, data):
    try:
        review = reviews.submit_review(current_user, data)
        db.session.commit()
        if review.review_status == "rejected":
            return ok({
                "success": True,
                "message": "评论已提交，但包含敏感词已被自动拒绝",
                "data": review.to_dict(),
            }, 201)
        return ok({
            "success": True,
            "message": "评论提交成功，等待管理员审核",
            "data": review.to_dict(),
        }, 201)
    except ApiError:
        raise
    except Exception as exc:
        db.session.rollback()
        raise BusinessError("提交评价失败", 500, {"error": str(exc)})


def like_review(current_user, review_id, action="like"):
    try:
        review_obj, is_liked = reviews.like_review(current_user, review_id, action)
        db.session.commit()
        return ok({
            "success": True,
            "data": {"review_id": review_obj.id, "likes": review_obj.likes, "is_liked": is_liked},
        }, 200)
    except ApiError:
        raise
    except Exception as exc:
        db.session.rollback()
        raise BusinessError("操作失败", 500, {"error": str(exc)})


def messages_api(method, current_user, json_data, query_params):
    try:
        if method == "POST":
            data = json_data or {}
            msg = msg_logic.send_message(current_user, data)
            db.session.commit()
            return ok({"success": True, "data": msg.to_dict()}, 201)
        data = msg_logic.list_messages(query_params)
        return ok({"success": True, "data": data}, 200)
    except ApiError:
        raise
    except Exception as exc:
        if current_app:
            current_app.logger.exception(f"消息接口错误: {exc}")
        raise BusinessError("消息操作失败", 500, {"error": str(exc)})
