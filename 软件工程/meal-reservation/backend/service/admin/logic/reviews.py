"""Admin review helpers — queries and operations."""
from datetime import datetime

from sqlalchemy import func

from Models import Restaurant, Review, db
from utils import BadRequestError, NotFoundError


def get_or_404(review_id):
    rv = Review.query.get(review_id)
    if not rv:
        raise NotFoundError("评价不存在")
    return rv


def apply_status_change(review, new_status):
    if new_status in {"hidden", "normal"} and review.review_status != "approved":
        raise BadRequestError("仅可对已通过审核的评论执行隐藏/显示")
    review.status = new_status


def apply_merchant_reply(review, reply_text):
    review.merchant_reply = reply_text
    review.merchant_reply_time = datetime.utcnow()


def apply_review_status(review, rs, reject_reason, reviewer_id):
    if rs not in {"pending", "approved", "rejected"}:
        raise BadRequestError("无效的review_status")
    if rs == "rejected":
        reason = (reject_reason or "").strip()
        if not reason:
            raise BadRequestError("拒绝评论必须填写驳回理由")
        review.review_reject_reason = reason
    review.review_status = rs
    if rs in {"approved", "rejected"}:
        review.reviewer_id = reviewer_id
        review.reviewed_at = datetime.utcnow()


def recalc_restaurant_rating(restaurant_id):
    avg_rating = (
        db.session.query(func.avg(Review.rating))
        .filter(
            Review.restaurant_id == restaurant_id,
            Review.status == "normal",
            Review.review_status == "approved",
        )
        .scalar()
    )
    restaurant = Restaurant.query.get(restaurant_id)
    if restaurant:
        new_rating = round(float(avg_rating), 1) if avg_rating is not None else None
        if restaurant.rating != new_rating:
            restaurant.rating = new_rating
            db.session.commit()


def list_paginated(page, per_page):
    query = Review.query.order_by(Review.created_at.desc())
    total = query.count()
    items = query.offset((page - 1) * per_page).limit(per_page).all()
    return total, items
