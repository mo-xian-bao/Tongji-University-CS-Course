"""Orders service handlers — orchestration layer."""
import logging

from Models import db
from utils import ApiError, BadRequestError, BusinessError, ok

from .logic import changes, crud, notifications

logger = logging.getLogger("orders")


def create_order(current_user, data):
    try:
        if not data.get("restaurant_id") or not data.get("items"):
            raise BadRequestError("缺少必要参数")
        order, total_price, original_price, discount_amount = crud.create_order(current_user, data)
        db.session.commit()
        return ok({
            "success": True,
            "message": "订单创建成功",
            "data": {
                "order_id": order.id,
                "order_number": order.order_number,
                "total_price": total_price,
                "original_price": original_price,
                "discount_amount": discount_amount,
            },
        }, 200)
    except ApiError:
        raise
    except Exception as exc:
        db.session.rollback()
        raise BusinessError("订单创建失败", 500, {"error": str(exc)})


def list_user_orders(current_user):
    try:
        result = crud.list_user_orders(current_user)
        return ok({"success": True, "data": result}, 200)
    except ApiError:
        raise
    except Exception as exc:
        raise BusinessError("获取订单列表失败", 500, {"error": str(exc)})


def get_order_detail(current_user, order_id):
    try:
        d = crud.get_order_detail(current_user, order_id)
        return ok({"success": True, "data": d}, 200)
    except ApiError:
        raise
    except Exception as exc:
        raise BusinessError("获取订单详情失败", 500, {"error": str(exc)})


def update_user_order(current_user, order_id, data):
    try:
        order = crud.update_user_order(current_user, order_id, data)
        db.session.commit()
        return ok({"success": True, "message": "订单更新成功", "data": order.to_dict()}, 200)
    except ApiError:
        raise
    except Exception as exc:
        db.session.rollback()
        raise BusinessError("订单更新失败", 500, {"error": str(exc)})


def cancel_user_order(current_user, order_id):
    try:
        order = crud.cancel_user_order(current_user, order_id)
        db.session.commit()
        return ok({"success": True, "message": "订单已取消", "data": order.to_dict()}, 200)
    except ApiError:
        raise
    except Exception as exc:
        db.session.rollback()
        raise BusinessError("订单取消失败", 500, {"error": str(exc)})


def request_order_change(current_user, order_id, data):
    try:
        cr = changes.request_order_change(current_user, order_id, data)
        db.session.commit()
        return ok({"success": True, "message": "申请已提交", "data": cr.to_dict()}, 201)
    except ApiError:
        raise
    except Exception as exc:
        db.session.rollback()
        raise BusinessError("提交修改申请失败", 500, {"error": str(exc)})


def withdraw_change_request(current_user, request_id):
    try:
        req = changes.withdraw_change_request(current_user, request_id)
        db.session.commit()
        return ok({"success": True, "message": "申请已撤回", "data": req.to_dict()}, 200)
    except ApiError:
        raise
    except Exception as exc:
        db.session.rollback()
        raise BusinessError("撤回申请失败", 500, {"error": str(exc)})


def get_order_review(current_user, order_id):
    try:
        from .logic.validation import get_order_or_404, ensure_ownership
        from Models import Review

        order = get_order_or_404(order_id)
        ensure_ownership(order, current_user)
        rv = Review.query.filter_by(order_id=order.id, user_id=current_user.id).order_by(Review.created_at.desc()).first()
        return ok({"success": True, "data": {"review": rv.to_dict() if rv else None}}, 200)
    except ApiError:
        raise
    except Exception as exc:
        raise BusinessError("获取评价失败", 500, {"error": str(exc)})


def list_pickup_notifications(current_user):
    try:
        data = notifications.list_pickup_notifications(current_user)
        return ok({"success": True, "data": data}, 200)
    except ApiError:
        raise
    except Exception as exc:
        raise BusinessError("获取取餐通知失败", 500, {"error": str(exc)})


def get_pickup_notification(current_user, notification_id):
    try:
        data = notifications.get_pickup_notification(current_user, notification_id)
        return ok({"success": True, "data": data}, 200)
    except ApiError:
        raise
    except Exception as exc:
        raise BusinessError("获取通知详情失败", 500, {"error": str(exc)})
