"""Appeal service handlers — orchestration layer."""
from Models import UserAppeal, db
from utils import ApiError, BusinessError, ForbiddenError, NotFoundError, ok

from .logic.attachments import upload_attachment, download_attachment
from .logic.validation import authenticate_user, find_active_ban, check_duplicate_appeal, validate_appeal_fields, build_attachments


def create_appeal(data):
    """提交申诉：验证身份 → 检查封禁 → 防重复 → 保存"""
    try:
        user = authenticate_user(
            data.get("user_identifier"), data.get("password"))
        active_ban = find_active_ban(user.id)
        check_duplicate_appeal(user.id, active_ban.id)
        reason, appeal_type, contact, additional = validate_appeal_fields(data)

        appeal = UserAppeal(
            user_id=user.id, ban_id=active_ban.id,
            appeal_reason=reason, appeal_type=appeal_type,
            contact_info=contact, additional_info=additional,
        )
        db.session.add(appeal)
        db.session.flush()
        build_attachments(appeal.id, data.get("attachments"))
        db.session.commit()
        return ok({"success": True, "message": "申诉提交成功，请耐心等待处理结果",
                   "data": appeal.to_dict()}, 201)
    except ApiError:
        raise
    except Exception as exc:
        db.session.rollback()
        raise BusinessError("申诉提交失败", 500, {"error": str(exc)})


def list_user_appeals(current_user):
    """获取用户的所有申诉"""
    try:
        appeals = (UserAppeal.query.filter_by(user_id=current_user.id)
                   .order_by(UserAppeal.created_at.desc()).all())
        data = []
        for a in appeals:
            d = a.to_dict()
            d["attachments"] = [att.to_dict() for att in a.attachments]
            data.append(d)
        return ok({"success": True, "message": "获取申诉列表成功", "data": data}, 200)
    except ApiError:
        raise
    except Exception as exc:
        raise BusinessError("获取申诉列表失败", 500, {"error": str(exc)})


def get_appeal_detail(current_user, appeal_id):
    """获取单个申诉详情"""
    try:
        appeal = UserAppeal.query.get(appeal_id)
        if not appeal:
            raise NotFoundError("申诉不存在")
        if current_user.usertype != 0 and appeal.user_id != current_user.id:
            raise ForbiddenError("无权查看此申诉")
        d = appeal.to_dict()
        d["attachments"] = [att.to_dict() for att in appeal.attachments]
        return ok({"success": True, "message": "获取申诉详情成功", "data": d}, 200)
    except ApiError:
        raise
    except Exception as exc:
        raise BusinessError("获取申诉详情失败", 500, {"error": str(exc)})
