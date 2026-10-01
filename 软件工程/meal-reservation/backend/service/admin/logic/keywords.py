"""Admin review keywords helpers."""
import logging
from datetime import datetime

from sqlalchemy import func

from Models import Review, ReviewKeyword, db
from utils import ForbiddenError

admin_logger = logging.getLogger("admin")


def require_admin(current_user):
    if current_user.usertype != 0:
        raise ForbiddenError("无权限")


def compute_review_stats():
    total = Review.query.count()
    avg = (
        db.session.query(func.avg(Review.rating))
        .filter(Review.status == "normal", Review.review_status == "approved")
        .scalar()
    ) or 0.0
    today = datetime.utcnow().date()
    today_start = datetime(today.year, today.month, today.day)
    today_new = Review.query.filter(Review.created_at >= today_start).count()
    pending = Review.query.filter_by(review_status="pending").count()
    return {
        "total_reviews": total,
        "average_rating": round(float(avg), 2),
        "today_new": today_new,
        "pending_reviews": pending,
    }


def list_all_keywords():
    return [k.to_dict() for k in ReviewKeyword.query.order_by(ReviewKeyword.created_at.desc()).all()]


def add_keyword(keyword, created_by):
    kw = (keyword or "").strip().lower()
    if not kw:
        return None, "关键词不能为空"
    if ReviewKeyword.query.filter_by(keyword=kw).first():
        return None, "关键词已存在"
    rk = ReviewKeyword(keyword=kw, created_by=created_by)
    db.session.add(rk)
    db.session.commit()
    return rk, None


def remove_keyword(kw_id):
    rk = ReviewKeyword.query.get(kw_id)
    if not rk:
        return False
    db.session.delete(rk)
    db.session.commit()
    return True
