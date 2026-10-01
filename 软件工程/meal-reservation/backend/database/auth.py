"""User auth and account helpers."""
from datetime import datetime

from Models import db, User, UserInfo, UserBan
from utils.validation import validate_phone, validate_username, validate_password
from utils.sms_service import sms_service


def add_user(phone, username, password, confirm_password, sms_code=None):
    """
    添加用户

    Args:
        phone (str): 手机号
        username (str): 用户名
        password (str): 密码
        confirm_password (str): 确认密码
        sms_code (str, optional): 短信验证码
        usertype (int): 用户种类

    Returns:
        tuple: (result_dict, status_code)
    """
    # 验证手机号格式
    if not validate_phone(phone):
        return {
            'success': False,
            'message': '请输入正确的手机号格式'
        }, 400

    # 验证短信验证码
    if not sms_code:
        return {
            'success': False,
            'message': '请输入短信验证码'
        }, 400

    # 验证短信验证码有效性
    sms_result = sms_service.verify_code(phone, sms_code, 'register')
    if not sms_result['success']:
        return {
            'success': False,
            'message': sms_result['message']
        }, 400

    # 验证用户名
    if not validate_username(username):
        return {
            'success': False,
            'message': '用户名长度应在2-50个字符之间'
        }, 400

    # 验证密码
    if not validate_password(password):
        return {
            'success': False,
            'message': '密码至少需要6个字符'
        }, 400

    # 验证确认密码
    if password != confirm_password:
        return {
            'success': False,
            'message': '两次输入的密码不一致'
        }, 400

    # 检查手机号是否已存在
    if User.query.filter_by(phone=phone).first():
        return {
            'success': False,
            'message': '该手机号已被注册'
        }, 409

    # 检查用户名是否已存在
    if User.query.filter_by(username=username).first():
        return {
            'success': False,
            'message': '该用户名已被使用'
        }, 409

    # 创建新用户
    user = User(phone=phone, username=username, usertype=2)
    user.set_password(password)

    try:
        db.session.add(user)
        db.session.flush()  # 获取新用户的 ID

        # 创建对应的用户扩展信息
        user_info = UserInfo(user_id=user.id)
        db.session.add(user_info)

        db.session.commit()

        return {
            'success': True,
            'message': '注册成功',
            'data': {
                'user': user.to_dict()
            }
        }, 201

    except Exception as e:
        db.session.rollback()
        print(f"注册失败: {str(e)}")
        return {
            'success': False,
            'message': f'注册失败: {str(e)}'
        }, 500


def identify_user(identifier, password, sms_code=None, login_type='password'):
    """
    用户登录

    Args:
        identifier (str): 手机号或用户名
        password (str): 密码（密码登录时需要）
        sms_code (str): 短信验证码（短信登录时需要）
        login_type (str): 登录类型 'password' 或 'sms'
    """
    # 查找用户（支持手机号或用户名登录）
    user = None
    if validate_phone(identifier):
        # 手机号登录
        user = User.query.filter_by(phone=identifier).first()
    else:
        # 用户名登录（仅支持密码登录）
        if login_type == 'sms':
            return {
                'success': False,
                'message': '短信登录只支持手机号'
            }, 400
        user = User.query.filter_by(username=identifier).first()

    # 验证用户是否存在
    if not user:
        return {
            'success': False,
            'message': '用户不存在'
        }, 401

    # 根据登录类型进行验证
    if login_type == 'password':
        # 密码登录验证
        if not password:
            return {
                'success': False,
                'message': '请输入密码'
            }, 400

        if not user.check_password(password):
            return {
                'success': False,
                'message': '密码错误'
            }, 401

    elif login_type == 'sms':
        # 短信验证码登录验证
        if not sms_code:
            return {
                'success': False,
                'message': '请输入短信验证码'
            }, 400

        # 验证短信验证码
        sms_result = sms_service.verify_code(user.phone, sms_code, 'login')
        if not sms_result['success']:
            return {
                'success': False,
                'message': sms_result['message']
            }, 400

    else:
        return {
            'success': False,
            'message': '不支持的登录类型'
        }, 400

    # 检查用户封禁状态
    effective_status = user.get_effective_status()
    if effective_status != 'normal':
        # 获取封禁信息
        active_ban = UserBan.query.filter_by(user_id=user.id).filter(
            UserBan.status.in_(['banned', 'temporarily_banned'])
        ).order_by(UserBan.created_at.desc()).first()

        ban_info = active_ban.to_dict() if active_ban else None

        return {
            'success': False,
            'message': f'账号已被封禁，原因：{ban_info.get("ban_reason_text", "未知原因")}',
            'data': {
                'ban_info': ban_info,
                'can_appeal': True
            }
        }, 423  # 423 Locked 表示资源被锁定

    # 更新最后登录时间
    user.updated_at = datetime.utcnow()
    db.session.commit()

    # 登录成功，返回用户信息（JWT 由应用入口统一生成以避免循环导入）
    return {
        'success': True,
        'message': '登录成功',
        'data': {
            'user': user.to_dict(),
            'login_type': login_type
        }
    }, 200


def send_sms_code(phone, purpose='register'):
    """
    发送短信验证码

    Args:
        phone (str): 手机号
        purpose (str): 用途 'register' 或 'login' 或 'reset_password' 或 'change_phone'

    Returns:
        tuple: (result_dict, status_code)
    """
    # 验证手机号格式
    if not validate_phone(phone):
        return {
            'success': False,
            'message': '请输入正确的手机号格式'
        }, 400

    # 不同用途的用户存在性验证
    if purpose == 'login' or purpose == 'reset_password':
        user = User.query.filter_by(phone=phone).first()
        if not user:
            return {
                'success': False,
                'message': '该手机号尚未注册'
            }, 404

    # change_phone 不需要验证用户是否存在（因为是新手机号）

    # 发送验证码
    result = sms_service.send_verification_code(phone, purpose)

    if result['success']:
        return result, 200
    return result, 400


def reset_password(phone, sms_code, new_password):
    """
    重置用户密码

    Args:
        phone (str): 手机号
        sms_code (str): 短信验证码
        new_password (str): 新密码

    Returns:
        tuple: (result_dict, status_code)
    """
    # 验证手机号格式
    if not validate_phone(phone):
        return {
            'success': False,
            'message': '请输入正确的手机号格式'
        }, 400

    # 验证新密码格式
    if not validate_password(new_password):
        return {
            'success': False,
            'message': '密码至少需要6个字符'
        }, 400

    # 查找用户
    user = User.query.filter_by(phone=phone).first()
    if not user:
        return {
            'success': False,
            'message': '用户不存在'
        }, 404

    # 验证短信验证码
    sms_result = sms_service.verify_code(phone, sms_code, 'reset_password')
    if not sms_result['success']:
        return {
            'success': False,
            'message': sms_result['message']
        }, 400

    # 更新密码
    user.set_password(new_password)
    user.updated_at = datetime.utcnow()
    db.session.commit()

    return {
        'success': True,
        'message': '密码重置成功'
    }, 200
