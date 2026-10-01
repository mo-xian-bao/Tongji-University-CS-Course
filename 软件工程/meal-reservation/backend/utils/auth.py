"""Auth decorators."""
from functools import wraps

from flask import request, g

from Models import User
from .api_errors import UnauthorizedError
from .jwt_utils import decode_jwt


def token_required(f):
    @wraps(f)
    def decorated(*args, **kwargs):
        auth = request.headers.get('Authorization', '')
        if auth.startswith('Bearer '):
            token = auth.split(' ', 1)[1].strip()
        else:
            token = auth.strip() or None

        if not token:
            raise UnauthorizedError('缺少 token')

        payload = decode_jwt(token)
        if not payload:
            raise UnauthorizedError('无效或已过期的 token')

        user_id = payload.get('sub')
        # 特殊处理游客用户（user_id = '0'）
        if user_id == '0':
            # 创建一个临时的游客用户对象
            from types import SimpleNamespace
            guest_user = SimpleNamespace()
            guest_user.id = 0
            guest_user.name = '游客'
            guest_user.phone = ''
            guest_user.username = 'guest'
            guest_user.to_dict = lambda: {'id': 0, 'name': '游客', 'phone': '', 'username': 'guest'}
            guest_user.usertype = 2  # 游客视为普通用户
            g.current_user = guest_user
            return f(*args, **kwargs)

        # 正式用户需要从数据库查询
        user = User.query.get(int(user_id))
        if not user:
            raise UnauthorizedError('用户不存在')

        # 被封禁的用户无法进行任何操作
        if user.get_effective_status() != 'normal':
            raise UnauthorizedError('该账号已被封禁，无法进行操作')
        g.current_user = user
        return f(*args, **kwargs)

    return decorated


def optional_token_required(f):
    @wraps(f)
    def decorated(*args, **kwargs):
        auth = request.headers.get('Authorization', '')
        if auth.startswith('Bearer '):
            token = auth.split(' ', 1)[1].strip()
        else:
            token = auth.strip() or None

        if token:
            payload = decode_jwt(token)
            if payload:
                user_id = payload.get('sub')
                if user_id == '0':
                    # 游客用户
                    from types import SimpleNamespace
                    guest_user = SimpleNamespace()
                    guest_user.id = 0
                    guest_user.name = '游客'
                    guest_user.phone = ''
                    guest_user.username = 'guest'
                    guest_user.usertype = 2
                    g.current_user = guest_user
                else:
                    # 正式用户
                    user = User.query.get(int(user_id))
                    if user:
                        g.current_user = user

        return f(*args, **kwargs)

    return decorated
