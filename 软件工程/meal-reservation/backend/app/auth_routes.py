from flask import Blueprint, request, jsonify, g

from utils import token_required
from service.auth import handlers  # 模块导入，避免路由函数与 service 函数重名

auth_bp = Blueprint('auth', __name__, url_prefix='/api')

@auth_bp.route('/register', methods=['POST'])
def register():
    """用户注册"""
    payload, status_code = handlers.register_user(request.get_json() or {})
    return jsonify(payload), status_code

@auth_bp.route('/login', methods=['POST'])
def login():
    """用户登录"""
    payload, status_code = handlers.login_user(request.get_json() or {})
    return jsonify(payload), status_code

@auth_bp.route('/auth/validate', methods=['GET'])
@token_required
def validate_token():
    """验证token并返回用户信息"""
    payload, status_code = handlers.validate_token(g.current_user)
    return jsonify(payload), status_code

@auth_bp.route('/check-phone', methods=['GET'])
def check_phone():
    """检查手机号是否可用"""
    payload, status_code = handlers.check_phone(request.args.get("phone"))
    return jsonify(payload), status_code

@auth_bp.route('/check-username', methods=['GET'])
def check_username():
    """检查用户名是否可用"""
    payload, status_code = handlers.check_username(request.args.get("username"))
    return jsonify(payload), status_code
    
@auth_bp.route('/sms/send', methods=['POST'])
def send_sms():
    """发送短信验证码"""
    data = request.get_json() or {}
    payload, status_code = handlers.send_sms_service(data.get("phone"), data.get("purpose", "register"))
    return jsonify(payload), status_code

@auth_bp.route('/reset-password/send-code', methods=['POST'])
def send_reset_password_code():
    """发送密码重置验证码"""
    data = request.get_json() or {}
    payload, status_code = handlers.send_reset_password_code(data.get("phone"))
    return jsonify(payload), status_code

@auth_bp.route('/reset-password', methods=['POST'])
def reset_password_route():
    """重置用户密码（支持登录和未登录场景）"""
    payload, status_code = handlers.reset_password_with_sms(
        request.get_json() or {},
        request.headers.get("Authorization", ""),
    )
    return jsonify(payload), status_code