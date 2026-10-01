from flask import Blueprint
from auxiliary_function import create_jwt, token_required,request, jsonify, g,decode_jwt
from Models import User
from app_init import db
from db_exe import add_user, identify_user,send_sms_code, reset_password

auth_bp = Blueprint('auth', __name__, url_prefix='/api')

@auth_bp.route('/register', methods=['POST'])
def register():
    """用户注册"""
    try:
        data = request.get_json()

        # 获取表单数据
        phone = data.get('phone', '').strip()
        username = data.get('username', '').strip()
        password = data.get('password', '').strip()
        confirm_password = data.get('confirmPassword', '').strip()
        sms_code = data.get('smsCode', '').strip()

        # 基本验证
        if not all([phone, username, password, confirm_password, sms_code]):
            return {
                'success': False,
                'message': '请填写完整信息'
            }, 400

        dict_return, status_code =add_user(phone, username, password, confirm_password, sms_code)
        if dict_return['success'] == True:
            jwt_token = create_jwt(dict_return['data']['user']['id'])
            dict_return['data']['token'] = jwt_token
            
        return jsonify(dict_return), status_code
    
    except Exception as e:
        db.session.rollback()
        return jsonify({
            'success': False,
            'message': '注册失败，请稍后重试',
            'error': str(e)
        }), 500

@auth_bp.route('/login', methods=['POST'])
def login():
    """用户登录"""
    try:
        data = request.get_json()

        # 获取登录信息
        identifier = data.get('identifier', '').strip()  # 手机号或用户名
        password = data.get('password', '').strip()
        sms_code = data.get('smsCode', '').strip()
        login_type = data.get('loginType', 'password')  # 'password' 或 'sms'

        # 基本验证
        if not identifier:
            return jsonify({
                'success': False,
                'message': '请输入手机号或用户名'
            }), 400

        # 根据登录类型验证必要参数
        if login_type == 'password':
            if not password:
                return jsonify({
                    'success': False,
                    'message': '请输入密码'
                }), 400
        elif login_type == 'sms':
            if not sms_code:
                return jsonify({
                    'success': False,
                    'message': '请输入短信验证码'
                }), 400
        else:
            return jsonify({
                'success': False,
                'message': '不支持的登录类型'
            }), 400

        dict_return, status_code = identify_user(identifier, password, sms_code, login_type)
        # 若登录成功，替换返回的示例 token 为 JWT
        if dict_return.get('success') and dict_return.get('data') and dict_return['data'].get('user'):
            user_info = dict_return['data']['user']
            user_id = user_info.get('id')
            if user_id:
                jwt_token = create_jwt(user_id)
                dict_return['data']['token'] = jwt_token
        return jsonify(dict_return), status_code

    except Exception as e:
        return jsonify({
            'success': False,
            'message': '登录失败，请稍后重试',
            'error': str(e)
        }), 500

@auth_bp.route('/auth/validate', methods=['GET'])
@token_required
def validate_token():
    """验证token并返回用户信息"""
    user = g.current_user
    return jsonify({
        'success': True,
        'message': 'Token验证成功',
        'data': {
            'user': user.to_dict(),
            'user_type': user.usertype
        }
    })

@auth_bp.route('/check-phone', methods=['GET'])
def check_phone():
    """检查手机号是否可用"""
    try:
        phone = request.args.get('phone', '').strip()

        if not phone:
            return jsonify({
                'success': False,
                'message': '手机号不能为空'
            }), 400

        # 检查手机号格式
        import re
        if not re.match(r'^1[3-9]\d{9}$', phone):
            return jsonify({
                'success': False,
                'message': '手机号格式不正确'
            }), 400

        # 检查手机号是否已存在
        existing_user = User.query.filter_by(phone=phone).first()
        if existing_user is None:
            available = True
        else:
            available = False
        print(available)
        return jsonify({
            'success': True,
            'message': '检查完成',
            'data': {
                'phone': phone,
                'available': available
            }
        })

    except Exception as e:
        return jsonify({
            'success': False,
            'message': '检查失败',
            'error': str(e)
        }), 500

@auth_bp.route('/check-username', methods=['GET'])
def check_username():
    """检查用户名是否可用"""
    try:
        username = request.args.get('username', '').strip()

        if not username:
            return jsonify({
                'success': False,
                'message': '用户名不能为空'
            }), 400

        if len(username) < 2 or len(username) > 20:
            return jsonify({
                'success': False,
                'message': '用户名长度为2-20个字符'
            }), 400

        # 检查用户名是否已存在
        existing_user = User.query.filter_by(username=username).first()
        available = not bool(existing_user)

        return jsonify({
            'success': True,
            'message': '检查完成',
            'data': {
                'username': username,
                'available': available
            }
        })

    except Exception as e:
        return jsonify({
            'success': False,
            'message': '检查失败',
            'error': str(e)
        }), 500
    
@auth_bp.route('/sms/send', methods=['POST'])
def send_sms():
    """发送短信验证码"""
    try:
        data = request.get_json()

        # 获取参数
        phone = data.get('phone', '').strip()
        purpose = data.get('purpose', 'register')  # 'register'、'login' 或 'reset_password'

        # 验证手机号
        if not phone:
            return jsonify({
                'success': False,
                'message': '请输入手机号'
            }), 400

        # 发送验证码
        dict_return, status_code = send_sms_code(phone, purpose)
        return jsonify(dict_return), status_code

    except Exception as e:
        return jsonify({
            'success': False,
            'message': '发送失败，请稍后重试',
            'error': str(e)
        }), 500

@auth_bp.route('/reset-password/send-code', methods=['POST'])
def send_reset_password_code():
    """发送密码重置验证码"""
    try:
        data = request.get_json()

        # 获取参数
        phone = data.get('phone', '').strip()

        # 验证手机号
        if not phone:
            return jsonify({
                'success': False,
                'message': '请输入手机号'
            }), 400

        # 发送验证码（重置密码用途）
        dict_return, status_code = send_sms_code(phone, 'reset_password')
        return jsonify(dict_return), status_code

    except Exception as e:
        return jsonify({
            'success': False,
            'message': '发送失败，请稍后重试',
            'error': str(e)
        }), 500

@auth_bp.route('/reset-password', methods=['POST'])
def reset_password_route():
    """重置用户密码（支持登录和未登录场景）"""
    try:
        data = request.get_json()

        # 获取参数 - 兼容两种参数格式
        phone = data.get('phone', '').strip()
        sms_code = data.get('smsCode') or data.get('sms_code', '').strip()  # 兼容两种命名
        new_password = data.get('newPassword') or data.get('new_password', '').strip()
        confirm_password = data.get('confirmPassword', '').strip()

        # 基本验证
        if not phone or not sms_code or not new_password:
            return jsonify({
                'success': False,
                'message': '请填写完整信息'
            }), 400

        # 如果提供了确认密码，验证两次密码输入是否一致
        if confirm_password and new_password != confirm_password:
            return jsonify({
                'success': False,
                'message': '两次输入的密码不一致'
            }), 400

        # 检查是否是登录用户调用（通过 Authorization header）
        auth_header = request.headers.get('Authorization', '')
        is_logged_in = False
        current_user = None
        
        if auth_header.startswith('Bearer '):
            token = auth_header.split(' ', 1)[1].strip()
            payload = decode_jwt(token)
            if payload:
                user_id = payload.get('sub')
                if user_id and user_id != '0':
                    current_user = User.query.get(int(user_id))
                    is_logged_in = True
        
        # 如果是登录用户，验证手机号是否匹配
        if is_logged_in and current_user:
            if phone != current_user.phone:
                return jsonify({
                    'success': False,
                    'message': '手机号与当前用户不匹配'
                }), 400

        # 重置密码
        dict_return, status_code = reset_password(phone, sms_code, new_password)
        return jsonify(dict_return), status_code

    except Exception as e:
        db.session.rollback()
        return jsonify({
            'success': False,
            'message': '密码重置失败，请稍后重试',
            'error': str(e)
        }), 500