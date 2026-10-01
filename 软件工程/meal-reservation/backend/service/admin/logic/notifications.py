"""Admin system notification helpers."""
import json
import logging
from datetime import datetime, timezone

from Models import SystemNotification, db
from utils import ForbiddenError

admin_logger = logging.getLogger("admin")


def require_admin(current_user):
    if current_user.usertype != 0:
        raise ForbiddenError("无权限")


def fetch_all():
    notifications = SystemNotification.query.all()
    return [n.to_dict() for n in notifications]


def publish(admin_id, content, target_audience):
    content = (content or "").strip()
    if not content:
        return None, "公告内容不能为空"
    if target_audience not in ["all", "merchants", "users"]:
        return None, f"发送对象无效: {target_audience}"

    existing = SystemNotification.query.filter_by(
        admin_id=admin_id, target_audience=target_audience
    ).first()

    message_obj = {"content": content, "timestamp": datetime.now(timezone.utc).isoformat()}

    if existing:
        messages = json.loads(existing.messages) if existing.messages else []
        messages.append(message_obj)
        existing.messages = json.dumps(messages)
        existing.updated_at = datetime.utcnow()
    else:
        notification = SystemNotification(
            admin_id=admin_id,
            target_audience=target_audience,
            messages=json.dumps([message_obj]),
        )
        db.session.add(notification)
    db.session.commit()
    return True, None


def remove_message(admin_id, target_audience, timestamp):
    notification = SystemNotification.query.filter_by(
        admin_id=admin_id, target_audience=target_audience
    ).first()
    if not notification:
        return False, "公告不存在"

    messages = json.loads(notification.messages) if notification.messages else []
    original = len(messages)
    messages = [m for m in messages if m.get("timestamp") != timestamp]
    if len(messages) == original:
        return False, "消息不存在"

    if not messages:
        db.session.delete(notification)
    else:
        notification.messages = json.dumps(messages)
        notification.updated_at = datetime.utcnow()
    db.session.commit()
    return True, None


def remove_all(current_user_id, admin_id, target_audience):
    if current_user_id != admin_id:
        return False, "无权限删除他人的公告"

    notification = SystemNotification.query.filter_by(
        admin_id=admin_id, target_audience=target_audience
    ).first()
    if not notification:
        return False, "公告不存在"

    db.session.delete(notification)
    db.session.commit()
    return True, None
