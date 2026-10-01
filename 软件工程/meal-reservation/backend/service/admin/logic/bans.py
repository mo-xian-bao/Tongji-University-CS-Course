"""Admin user ban helpers."""
from datetime import datetime, timedelta

from Models import User, UserBan, db
from utils import ForbiddenError


def require_admin(current_user):
    if current_user.usertype != 0:
        raise ForbiddenError("无权限")


def compute_ban_stats():
    total_users = User.query.filter(User.usertype != 0).count()
    active_banned = UserBan.query.filter(
        UserBan.status.in_(["banned", "temporarily_banned"]),
        UserBan.banned_at.isnot(None),
    ).count()
    temp_banned = UserBan.query.filter(
        UserBan.status == "temporarily_banned",
        UserBan.ban_until.isnot(None),
    ).count()
    today = datetime.utcnow().date()
    today_banned = UserBan.query.filter(
        UserBan.status.in_(["banned", "temporarily_banned"]),
        UserBan.banned_at >= today,
    ).count()
    return {
        "totalUsers": total_users,
        "bannedUsers": active_banned,
        "tempBannedUsers": temp_banned,
        "todayBanned": today_banned,
    }


def search_users(search, type_filter, page, per_page):
    query = User.query
    if search:
        query = query.filter(
            (User.username.ilike(f"%{search}%")) | (User.phone.ilike(f"%{search}%"))
        )
    type_map = {"customer": 2, "merchant": 1}
    if type_filter in type_map:
        query = query.filter(User.usertype == type_map[type_filter])
    elif type_filter == "no admin":
        query = query.filter(User.usertype != 0)
    return query.order_by(User.created_at.desc()).paginate(
        page=page, per_page=per_page, error_out=False
    )


def get_user_or_none(user_id):
    return User.query.get(user_id)


def find_active_ban(user_id):
    return UserBan.query.filter_by(user_id=user_id).order_by(UserBan.created_at.desc()).first()


def create_ban(user_id, ban_type, reason, description, duration, admin_id, notify):
    ban_record = UserBan(
        user_id=user_id,
        status="banned" if ban_type == "permanently" else "temporarily_banned",
        ban_type=ban_type,
        ban_reason=reason,
        ban_description=description,
        banned_at=datetime.utcnow(),
        admin_id=admin_id,
        notify_user=notify,
    )
    if ban_type == "temporarily_banned":
        ban_record.ban_until = datetime.utcnow() + timedelta(days=int(duration))
    db.session.add(ban_record)
    db.session.commit()
    return ban_record


def unban(user_id):
    active_ban = find_active_ban(user_id)
    if not active_ban or active_ban.status not in ["banned", "temporarily_banned"]:
        return False, "用户未被封禁"
    active_ban.status = "normal"
    active_ban.unbanned_at = datetime.utcnow()
    db.session.commit()
    return True, None


def get_ban_history(user_id):
    return UserBan.query.filter_by(user_id=user_id).order_by(UserBan.created_at.desc()).all()
