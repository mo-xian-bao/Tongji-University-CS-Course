"""Admin appeal helpers."""
from datetime import datetime

from Models import UserAppeal, db
from utils import ForbiddenError


def require_admin(current_user):
    if current_user.usertype != 0:
        raise ForbiddenError("无权限")


def fetch_appeals(status, page, per_page):
    query = UserAppeal.query
    if status:
        query = query.filter_by(status=status)
    query = query.order_by(UserAppeal.created_at.desc())
    pagination = query.paginate(page=page, per_page=per_page, error_out=False)
    appeals_data = []
    for appeal in pagination.items:
        d = appeal.to_dict()
        d["attachments"] = [att.to_dict() for att in appeal.attachments]
        appeals_data.append(d)
    return appeals_data, pagination


def process(appeal_id, action, admin_id, admin_note):
    appeal = UserAppeal.query.get(appeal_id)
    if not appeal:
        return None, "申诉不存在"
    if appeal.status not in ["pending", "processing"]:
        return None, "此申诉已被处理，无需重复操作"
    if action not in ["approve", "reject"]:
        return None, "处理操作无效，只能是 approve 或 reject"

    if action == "approve":
        appeal.status = "approved"
        if appeal.ban:
            appeal.ban.status = "normal"
            appeal.ban.unbanned_at = datetime.utcnow()
    else:
        appeal.status = "rejected"

    appeal.admin_id = admin_id
    appeal.admin_note = admin_note
    appeal.processed_at = datetime.utcnow()
    db.session.commit()
    action_text = "通过" if action == "approve" else "拒绝"
    return appeal, f"申诉已{action_text}"
