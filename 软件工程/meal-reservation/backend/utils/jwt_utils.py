"""JWT helpers."""
from datetime import datetime, timedelta

import jwt

from app_init import app


def create_jwt(user_id, expire_minutes=60 * 24 * 7):
    """生成 JWT，默认过期 7 天"""
    payload = {
        'sub': str(int(user_id)),  # JWT的sub字段必须是字符串
        'exp': datetime.utcnow() + timedelta(minutes=expire_minutes),
        'iat': datetime.utcnow()
    }
    try:
        token = jwt.encode(
            payload,
            app.config['SECRET_KEY'],
            algorithm='HS256'
        )
        # PyJWT 2.0+ 返回字符串类型
        if isinstance(token, bytes):
            return token.decode('utf-8')
        return token
    except Exception as e:
        app.logger.error(f"JWT encoding failed: {e}")
        return None


def decode_jwt(token):
    try:
        payload = jwt.decode(token, app.config['SECRET_KEY'], algorithms=['HS256'])
        return payload
    except jwt.ExpiredSignatureError:
        app.logger.warning("Token has expired")
        return None
    except jwt.InvalidTokenError as e:
        app.logger.warning(f"Invalid token: {e}")
        return None
    except Exception as e:
        app.logger.error(f"JWT decode failed: {e}")
        return None
