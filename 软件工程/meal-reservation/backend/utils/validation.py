"""Basic input validation helpers."""
import re


def validate_phone(phone):
    """验证手机号格式"""
    phone_pattern = r'^1[3-9]\d{9}$'
    return re.match(phone_pattern, phone) is not None


def validate_username(username):
    """验证用户名格式"""
    if len(username) < 2 or len(username) > 50:
        return False
    # 可以添加更多规则，如不允许特殊字符等
    return True


def validate_password(password):
    """验证密码强度"""
    if len(password) < 6:
        return False
    # 可以添加更多密码强度规则
    return True
