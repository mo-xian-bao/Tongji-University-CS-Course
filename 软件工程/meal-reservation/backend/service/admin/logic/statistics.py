"""Admin statistics helpers."""
from datetime import date, datetime, timedelta

from Models import MerchantApplication, UserAppeal
from utils import ForbiddenError


def require_admin(current_user):
    if current_user.usertype != 0:
        raise ForbiddenError("无权限")


def compute_merchant_app_stats():
    pending = MerchantApplication.query.filter_by(review_status="pending").count()
    today = date.today()
    today_start = datetime(today.year, today.month, today.day)
    today_processed = MerchantApplication.query.filter(
        MerchantApplication.reviewed_at >= today_start,
        MerchantApplication.review_status.in_(["approved", "rejected"]),
    ).count()
    month_start = datetime(today.year, today.month, 1)
    monthly_approved = MerchantApplication.query.filter(
        MerchantApplication.reviewed_at >= month_start,
        MerchantApplication.review_status == "approved",
    ).count()
    monthly_rejected = MerchantApplication.query.filter(
        MerchantApplication.reviewed_at >= month_start,
        MerchantApplication.review_status == "rejected",
    ).count()
    return {
        "pending": pending,
        "todayProcessed": today_processed,
        "monthlyApproved": monthly_approved,
        "monthlyRejected": monthly_rejected,
    }


def compute_appeal_stats():
    pending = UserAppeal.query.filter_by(status="pending").count()
    today = date.today()
    today_start = datetime(today.year, today.month, today.day)
    today_processed = UserAppeal.query.filter(UserAppeal.processed_at >= today_start).count()
    month_start = datetime(today.year, today.month, 1)
    monthly_total = UserAppeal.query.filter(UserAppeal.processed_at >= month_start).count()
    monthly_approved = UserAppeal.query.filter(
        UserAppeal.processed_at >= month_start, UserAppeal.status == "approved"
    ).count()
    approval_rate = round((monthly_approved / monthly_total) * 100, 1) if monthly_total else 0

    thirty_days_ago = datetime.utcnow() - timedelta(days=30)
    recent = UserAppeal.query.filter(
        UserAppeal.processed_at >= thirty_days_ago,
        UserAppeal.processed_at.isnot(None),
        UserAppeal.created_at.isnot(None),
    ).all()
    total_time, count = 0, 0
    for a in recent:
        if a.processed_at and a.created_at:
            total_time += (a.processed_at - a.created_at).total_seconds() / 3600
            count += 1
    avg_time = round(total_time / count, 1) if count else 0

    return {
        "pendingAppeals": pending,
        "todayProcessed": today_processed,
        "monthlyApprovalRate": approval_rate,
        "avgProcessTime": avg_time,
    }
