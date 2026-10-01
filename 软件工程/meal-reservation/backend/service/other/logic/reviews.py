"""Review submission and likes."""
from datetime import datetime

from flask import current_app

from Models import Order, Review, ReviewKeyword, ReviewLike, db
from utils import BadRequestError, ForbiddenError, NotFoundError, ok


def submit_review(current_user, data):
    order_id = data.get("order_id")
    if not order_id:
        raise BadRequestError("缺少 order_id")

    order = Order.query.get(int(order_id))
    if not order:
        raise NotFoundError("订单不存在")
    if order.user_id != current_user.id:
        raise ForbiddenError("无权对该订单评价")

    existing = Review.query.filter_by(order_id=order.id, user_id=current_user.id).first()
    if existing:
        raise BadRequestError("该订单已评价")

    rating = int(data.get("rating", 5) or 5)
    content = (data.get("content") or "").strip()
    images = data.get("images") or []
    food_rating = data.get("food_rating")
    packaging_rating = data.get("packaging_rating")
    service_rating = data.get("service_rating")

    review = Review(
        order_id=order.id,
        restaurant_id=order.restaurant_id,
        user_id=current_user.id,
        rating=rating,
        content=content,
        images=images,
        food_rating=food_rating,
        packaging_rating=packaging_rating,
        service_rating=service_rating,
        status="normal",
        review_status="pending",
    )

    try:
        keywords = ReviewKeyword.query.all()
        matched = None
        if keywords and content:
            lower = content.lower()
            for k in keywords:
                if k.keyword and k.keyword in lower:
                    matched = k.keyword
                    break
        if matched:
            review.review_status = "rejected"
            review.review_reject_reason = f'自动驳回：包含敏感关键词 "{matched}"'
            review.reviewed_at = datetime.utcnow()
    except Exception as e:
        if current_app:
            current_app.logger.warning(f"自动审核关键词检查失败: {e}")

    db.session.add(review)
    return review


def like_review(current_user, review_id, action="like"):
    action = (action or "like").lower()
    review = Review.query.get(review_id)
    if not review:
        raise NotFoundError("评价不存在")

    existing = ReviewLike.query.filter_by(review_id=review_id, user_id=current_user.id).first()

    if action == "like":
        if not existing:
            rl = ReviewLike(review_id=review_id, user_id=current_user.id)
            db.session.add(rl)
            review.likes = (review.likes or 0) + 1
        is_liked = True
    else:
        if existing:
            db.session.delete(existing)
            review.likes = max((review.likes or 0) - 1, 0)
        is_liked = False

    review.updated_at = datetime.utcnow()
    return review, is_liked
