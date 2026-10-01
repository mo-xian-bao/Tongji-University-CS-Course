"""Appeal validation and query helpers."""
from werkzeug.security import check_password_hash

from Models import AppealAttachment, User, UserAppeal, UserBan, db
from utils import BadRequestError, UnauthorizedError


def authenticate_user(user_identifier, password):
    """Find user by phone/username and verify password. Raise on failure."""
    if not user_identifier or not password:
        raise BadRequestError("请提供用户标识和密码")
    user = User.query.filter(
        (User.username == user_identifier) | (User.phone == user_identifier)
    ).first()
    if not user:
        raise BadRequestError("用户不存在")
    if not check_password_hash(user.password_hash, password):
        raise UnauthorizedError("密码错误")
    return user


def find_active_ban(user_id):
    """Find the active ban record for a user. Raise if not banned."""
    active_ban = (
        UserBan.query.filter_by(user_id=user_id)
        .filter(UserBan.status.in_(["banned", "temporarily_banned"]))
        .order_by(UserBan.created_at.desc())
        .first()
    )
    if not active_ban:
        raise BadRequestError("您当前没有被封禁，无需申诉")
    return active_ban


def check_duplicate_appeal(user_id, ban_id):
    """Raise if user already has a pending/processing appeal for this ban."""
    existing = (
        UserAppeal.query.filter_by(user_id=user_id, ban_id=ban_id)
        .filter(UserAppeal.status.in_(["pending", "processing"]))
        .first()
    )
    if existing:
        raise BadRequestError("您已有未处理的申诉，请耐心等待处理结果")


def validate_appeal_fields(data):
    """Validate appeal form fields. Returns (reason, appeal_type, contact, additional)."""
    appeal_reason = (data.get("appeal_reason") or "").strip()
    appeal_type = (data.get("appeal_type") or "").strip()
    contact_info = (data.get("contact_info") or "").strip()
    additional_info = (data.get("additional_info") or "").strip()

    if not appeal_reason:
        raise BadRequestError("申诉理由不能为空")
    if appeal_type not in ["mistake_ban", "punishment_too_heavy", "evidence_provided", "other"]:
        raise BadRequestError("请选择正确的申诉类型")

    return appeal_reason, appeal_type, contact_info, additional_info


def build_attachments(appeal_id, attachments_data):
    """Create AppealAttachment objects from raw data. Returns list (already added to session)."""
    results = []
    for att in (attachments_data or []):
        if not isinstance(att, dict):
            continue
        attachment = AppealAttachment(
            appeal_id=appeal_id,
            file_name=att.get("file_name", ""),
            file_path=att.get("file_path", ""),
            file_size=att.get("file_size", 0),
            file_type=att.get("file_type", ""),
            mime_type=att.get("mime_type", ""),
        )
        if all([attachment.file_name, attachment.file_path, attachment.file_size, attachment.file_type]):
            db.session.add(attachment)
            results.append(attachment)
    return results
