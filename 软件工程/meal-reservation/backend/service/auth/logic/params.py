"""Auth parameter extraction helpers."""


def extract_register_params(data):
    """Extract and validate registration parameters."""
    phone = (data.get("phone") or "").strip()
    username = (data.get("username") or "").strip()
    password = (data.get("password") or "").strip()
    confirm_password = (data.get("confirmPassword") or "").strip()
    sms_code = (data.get("smsCode") or "").strip()
    return phone, username, password, confirm_password, sms_code


def extract_login_params(data):
    """Extract and validate login parameters."""
    identifier = (data.get("identifier") or "").strip()
    password = (data.get("password") or "").strip()
    sms_code = (data.get("smsCode") or "").strip()
    login_type = data.get("loginType") or "password"
    return identifier, password, sms_code, login_type


def extract_reset_password_params(data):
    """Extract reset-password parameters."""
    phone = (data.get("phone") or "").strip()
    sms_code = (data.get("smsCode") or data.get("sms_code") or "").strip()
    new_password = (data.get("newPassword") or data.get("new_password") or "").strip()
    confirm_password = (data.get("confirmPassword") or "").strip()
    return phone, sms_code, new_password, confirm_password
