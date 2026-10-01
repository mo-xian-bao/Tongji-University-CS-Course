"""Auth validation helpers — pure check functions, no orchestration."""
import re

from Models import User
from utils import ApiError, BadRequestError, BusinessError


def check_phone(phone):
    """Check whether a phone is available."""
    try:
        phone = (phone or "").strip()
        if not phone:
            raise BadRequestError("手机号不能为空")

        if not re.match(r"^1[3-9]\d{9}$", phone):
            raise BadRequestError("手机号格式不正确")

        existing_user = User.query.filter_by(phone=phone).first()
        available = existing_user is None
        return {
            "success": True,
            "message": "检查完成",
            "data": {"phone": phone, "available": available},
        }, 200
    except ApiError:
        raise
    except Exception as exc:
        raise BusinessError("检查失败", 500, {"error": str(exc)})


def check_username(username):
    """Check whether a username is available."""
    try:
        username = (username or "").strip()
        if not username:
            raise BadRequestError("用户名不能为空")

        if len(username) < 2 or len(username) > 20:
            raise BadRequestError("用户名长度为2-20个字符")

        existing_user = User.query.filter_by(username=username).first()
        available = not bool(existing_user)
        return {
            "success": True,
            "message": "检查完成",
            "data": {"username": username, "available": available},
        }, 200
    except ApiError:
        raise
    except Exception as exc:
        raise BusinessError("检查失败", 500, {"error": str(exc)})
