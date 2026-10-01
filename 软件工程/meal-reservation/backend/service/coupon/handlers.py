"""Coupon service handlers — orchestration layer."""
from datetime import datetime

from Models import CouponNotification, CouponUsage, db
from coupon_recommendation import get_recommended_coupons_for_user, record_coupon_user_action
from utils import ApiError, BadRequestError, BusinessError, ForbiddenError, NotFoundError, ok

from .logic.validation import validate_coupon_available
from .logic.actions import auto_follow_restaurant
from .logic.queries import build_my_coupons_query, enrich_detail


def get_recommendations(current_user, limit=10):
    try:
        recs = get_recommended_coupons_for_user(current_user.id, min(int(limit), 20))
        return ok({"success": True, "message": "获取推荐成功",
                   "data": {"recommendations": recs, "total": len(recs)}}, 200)
    except ValueError as e:
        raise BadRequestError(f"参数错误: {str(e)}")
    except Exception as exc:
        db.session.rollback()
        raise BusinessError("获取推荐失败", 500, {"error": str(exc)})


def accept_coupon(current_user, coupon_id):
    try:
        uid = current_user.id
        coupon = validate_coupon_available(coupon_id, uid)
        follow_msg, rest_name = auto_follow_restaurant(uid, coupon.restaurant_id)
        record_coupon_user_action(uid, coupon_id, "accept")
        db.session.commit()
        return ok({
            "success": True, "message": f"已接受优惠券推荐！{follow_msg}",
            "data": {"coupon": coupon.to_dict(), "follow_message": follow_msg, "restaurant_name": rest_name},
        }, 200)
    except ApiError:
        raise
    except Exception as exc:
        db.session.rollback()
        raise BusinessError("接受优惠券失败", 500, {"error": str(exc)})


def reject_coupon(current_user, coupon_id):
    try:
        if not CouponNotification.query.get(coupon_id):
            raise NotFoundError("优惠券不存在")
        record_coupon_user_action(current_user.id, coupon_id, "reject")
        return ok({"success": True, "message": "已记录您的选择，我们将优化后续推荐",
                   "data": {"coupon_id": coupon_id}}, 200)
    except ApiError:
        raise
    except Exception as exc:
        raise BusinessError("操作失败", 500, {"error": str(exc)})


def use_coupon(current_user, coupon_id, data):
    try:
        uid = current_user.id
        coupon = validate_coupon_available(coupon_id, uid)
        order_id = data.get("order_id")

        if order_id:
            _validate_order_for_coupon(order_id, uid, coupon)

        usage = CouponUsage(user_id=uid, coupon_id=coupon_id, order_id=order_id, used_at=datetime.utcnow())
        db.session.add(usage)
        record_coupon_user_action(uid, coupon_id, "use")
        db.session.commit()
        return ok({"success": True, "message": "优惠券使用成功",
                   "data": {"coupon": coupon.to_dict(), "usage_id": usage.id}}, 200)
    except ApiError:
        raise
    except Exception as exc:
        db.session.rollback()
        raise BusinessError("使用优惠券失败", 500, {"error": str(exc)})


def _validate_order_for_coupon(order_id, user_id, coupon):
    from Models import Order

    order = Order.query.get(order_id)
    if not order:
        raise NotFoundError("订单不存在")
    if order.user_id != user_id:
        raise ForbiddenError("无权操作此订单")
    if coupon.min_spend and order.total_price < coupon.min_spend:
        raise BadRequestError(f"订单金额未达到最低消费要求 ¥{coupon.min_spend}")
    if order.restaurant_id != coupon.restaurant_id:
        raise BadRequestError("优惠券不适用于此餐厅")


def my_coupons(current_user, status="available", page=1, per_page=20):
    try:
        page, per_page = max(int(page), 1), min(max(int(per_page), 1), 100)
        coupons, pagination = build_my_coupons_query(current_user.id, status, page, per_page)
        return ok({
            "success": True,
            "data": {
                "coupons": coupons,
                "pagination": {"page": pagination.page, "per_page": pagination.per_page,
                               "total_pages": pagination.pages, "total_items": pagination.total},
            },
        }, 200)
    except ValueError as e:
        raise BadRequestError(f"参数错误: {str(e)}")
    except Exception as exc:
        raise BusinessError("获取优惠券列表失败", 500, {"error": str(exc)})


def detail(current_user, coupon_id):
    try:
        coupon = CouponNotification.query.get(coupon_id)
        if not coupon:
            raise NotFoundError("优惠券不存在")
        return ok({"success": True, "data": enrich_detail(coupon, current_user.id)}, 200)
    except ApiError:
        raise
    except Exception as exc:
        raise BusinessError("获取优惠券详情失败", 500, {"error": str(exc)})


def recommendation_detail(current_user, coupon_id):
    try:
        recs = get_recommended_coupons_for_user(current_user.id, limit=50)
        target = next((r for r in recs if r.get("coupon", {}).get("id") == coupon_id), None)
        if not target:
            raise NotFoundError("该优惠券推荐不存在或已过期")
        return ok({"success": True, "data": target}, 200)
    except ApiError:
        raise
    except Exception as exc:
        raise BusinessError("获取推荐详情失败", 500, {"error": str(exc)})


def refresh_recommendations(current_user):
    try:
        recs = get_recommended_coupons_for_user(current_user.id, limit=10)
        return ok({"success": True, "message": f"推荐已更新，为您找到 {len(recs)} 个推荐优惠券",
                   "data": {"recommendations": recs, "total": len(recs)}}, 200)
    except ApiError:
        raise
    except Exception as exc:
        raise BusinessError("更新推荐失败", 500, {"error": str(exc)})


def status(current_user):
    try:
        recs = get_recommended_coupons_for_user(current_user.id, limit=10)
        total = CouponNotification.query.filter(CouponNotification.is_active == True).count()
        used = CouponUsage.query.filter_by(user_id=current_user.id).count()
        return ok({
            "success": True,
            "data": {
                "user_recommendations_count": len(recs),
                "total_available_coupons": total,
                "user_used_coupons": used,
                "last_updated": datetime.utcnow().isoformat(),
            },
        }, 200)
    except ApiError:
        raise
    except Exception as exc:
        raise BusinessError("获取状态失败", 500, {"error": str(exc)})
