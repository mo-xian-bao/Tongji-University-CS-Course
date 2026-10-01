"""Coupon validation helpers."""
from datetime import datetime

from Models import CouponNotification, CouponUsage
from utils import BadRequestError, NotFoundError


def validate_coupon_available(coupon_id, user_id):
    """Validate a coupon exists, is active, not expired, and not already used by this user.
    Returns the coupon if valid, raises on failure.
    """
    coupon = CouponNotification.query.get(coupon_id)
    if not coupon:
        raise NotFoundError("优惠券不存在")
    if not coupon.is_active:
        raise BadRequestError("优惠券已失效")

    now = datetime.utcnow()
    if coupon.valid_from and coupon.valid_from > now:
        raise BadRequestError("优惠券尚未生效")
    if coupon.valid_to and coupon.valid_to < now:
        raise BadRequestError("优惠券已过期")

    if CouponUsage.query.filter_by(user_id=user_id, coupon_id=coupon_id).first():
        raise BadRequestError("您已经使用过该优惠券")

    return coupon
