"""Auth service handlers — orchestration layer."""
from Models import db
from database import add_user, identify_user, reset_password, send_sms_code
from utils import ApiError, BadRequestError, BusinessError, coerce_result

from .logic.validation import check_phone, check_username
from .logic.params import extract_register_params, extract_login_params, extract_reset_password_params
from .logic.token import attach_jwt_to_payload, resolve_user_from_auth_header


def register_user(data):
    """用户注册"""
    try:
        phone, username, password, confirm_password, sms_code = extract_register_params(data)
        if not all([phone, username, password, confirm_password, sms_code]):
            raise BadRequestError("请填写完整信息")
        payload, status_code = coerce_result(
            add_user(phone, username, password, confirm_password, sms_code))
        return attach_jwt_to_payload(payload), status_code
    except ApiError:
        raise
    except Exception as exc:
        db.session.rollback()
        raise BusinessError("注册失败，请稍后重试", 500, {"error": str(exc)})


def login_user(data):
    """用户登录"""
    try:
        identifier, password, sms_code, login_type = extract_login_params(data)
        if not identifier:
            raise BadRequestError("请输入手机号或用户名")
        if login_type == "password":
            if not password:
                raise BadRequestError("请输入密码")
        elif login_type == "sms":
            if not sms_code:
                raise BadRequestError("请输入短信验证码")
        else:
            raise BadRequestError("不支持的登录类型")
        payload, status_code = coerce_result(
            identify_user(identifier, password, sms_code, login_type))
        return attach_jwt_to_payload(payload), status_code
    except ApiError:
        raise
    except Exception as exc:
        raise BusinessError("登录失败，请稍后重试", 500, {"error": str(exc)})


def validate_token(current_user):
    """验证 Token"""
    return {
        "success": True, "message": "Token验证成功",
        "data": {"user": current_user.to_dict(), "user_type": current_user.usertype},
    }, 200


def send_sms_service(phone, purpose="register"):
    """发送短信验证码"""
    try:
        phone = (phone or "").strip()
        if not phone:
            raise BadRequestError("请输入手机号")
        return coerce_result(send_sms_code(phone, purpose))
    except ApiError:
        raise
    except Exception as exc:
        raise BusinessError("发送失败，请稍后重试", 500, {"error": str(exc)})


def send_reset_password_code(phone):
    """发送密码重置验证码"""
    return send_sms_service(phone, "reset_password")


def reset_password_with_sms(data, auth_header=""):
    """短信重置密码（支持已登录/未登录两种场景）"""
    try:
        phone, sms_code, new_password, confirm_password = extract_reset_password_params(data)
        if not phone or not sms_code or not new_password:
            raise BadRequestError("请填写完整信息")
        if confirm_password and new_password != confirm_password:
            raise BadRequestError("两次输入的密码不一致")

        current_user = resolve_user_from_auth_header(auth_header)
        if current_user and phone != current_user.phone:
            raise BadRequestError("手机号与当前用户不匹配")

        return coerce_result(reset_password(phone, sms_code, new_password))
    except ApiError:
        raise
    except Exception as exc:
        db.session.rollback()
        raise BusinessError("密码重置失败，请稍后重试", 500, {"error": str(exc)})
