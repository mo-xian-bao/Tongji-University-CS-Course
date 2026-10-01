"""Coupon query helpers."""
from datetime import datetime

from Models import CouponNotification, CouponUsage, Restaurant, RestaurantFollow, db


def build_my_coupons_query(uid, status, page, per_page):
    used_ids = [r[0] for r in db.session.query(CouponUsage.coupon_id).filter(CouponUsage.user_id == uid).all()]

    if status == "used":
        query = CouponNotification.query.filter(CouponNotification.id.in_(used_ids))
    elif status == "available":
        now = datetime.utcnow()
        query = CouponNotification.query.filter(
            CouponNotification.is_active == True,
            CouponNotification.valid_from <= now,
            CouponNotification.valid_to >= now,
        ).filter(~CouponNotification.id.in_(used_ids))
    else:
        query = CouponNotification.query

    pagination = query.order_by(CouponNotification.created_at.desc()).paginate(
        page=page, per_page=per_page, error_out=False)
    coupons = []
    for c in pagination.items:
        d = c.to_dict()
        d["is_used"] = c.id in used_ids
        coupons.append(d)
    return coupons, pagination


def enrich_detail(coupon, user_id):
    usage = CouponUsage.query.filter_by(user_id=user_id, coupon_id=coupon.id).first()
    d = coupon.to_dict()
    d["is_used"] = usage is not None
    d["used_at"] = usage.used_at.isoformat() if usage else None
    restaurant = Restaurant.query.get(coupon.restaurant_id)
    if restaurant:
        d["restaurant"] = restaurant.to_dict()
        d["is_following_restaurant"] = bool(
            RestaurantFollow.query.filter_by(user_id=user_id, restaurant_id=restaurant.id).first())
    return d
