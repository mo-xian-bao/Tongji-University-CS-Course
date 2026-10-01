"""Users credential operations."""
import re
from datetime import datetime

from Models import SMSVerification, User, db
from utils import BadRequestError


def change_password(current_user, old_password, new_password):
    if not old_password or not new_password:
        raise BadRequestError("旧密码和新密码不能为空")
    if len(new_password) < 6:
        raise BadRequestError("新密码长度至少为6位")
    if not current_user.check_password(old_password):
        raise BadRequestError("当前密码错误")
    if old_password == new_password:
        raise BadRequestError("新密码不能与当前密码相同")
    current_user.set_password(new_password)
    current_user.updated_at = datetime.utcnow()


def change_phone(current_user, new_phone, sms_code):
    if not new_phone or not sms_code:
        raise BadRequestError("手机号和验证码不能为空")
    if not re.match(r"^1[3-9]\d{9}$", new_phone):
        raise BadRequestError("手机号格式不正确")
    existing_user = User.query.filter_by(phone=new_phone).first()
    if existing_user and existing_user.id != current_user.id:
        raise BadRequestError("该手机号已被其他用户使用")
    verification = SMSVerification.query.filter_by(
        phone=new_phone, code=sms_code, purpose="change_phone", is_used=False
    ).order_by(SMSVerification.created_at.desc()).first()
    if not verification:
        raise BadRequestError("验证码错误或已失效")
    if verification.is_expired():
        raise BadRequestError("验证码已过期")
    current_user.phone = new_phone
    current_user.updated_at = datetime.utcnow()
    verification.mark_as_used()
