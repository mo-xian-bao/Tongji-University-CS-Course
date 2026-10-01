"""SMS verification model."""
from datetime import datetime, timedelta, timezone
import random
import string

from app_init import db


class SMSVerification(db.Model):
    """短信验证码模型"""
    __tablename__ = 'sms_verifications'

    id = db.Column(db.Integer, primary_key=True)
    phone = db.Column(db.String(11), nullable=False, index=True)
    code = db.Column(db.String(6), nullable=False)
    purpose = db.Column(db.String(20), nullable=False)  # 'register', 'login', 'reset_password'
    is_used = db.Column(db.Boolean, default=False)
    created_at = db.Column(db.DateTime, default=datetime.utcnow)
    expires_at = db.Column(db.DateTime, nullable=False)
    used_at = db.Column(db.DateTime, nullable=True)

    def __init__(self, phone, purpose='register', expiry_minutes=5):
        self.phone = phone
        self.code = self.generate_code()
        self.purpose = purpose
        self.expires_at = datetime.utcnow() + timedelta(minutes=expiry_minutes)

    @staticmethod
    def generate_code():
        """生成6位数字验证码"""
        return ''.join(random.choices(string.digits, k=6))

    def is_expired(self):
        """检查验证码是否过期"""
        return datetime.utcnow() > self.expires_at

    def is_valid(self):
        """检查验证码是否有效（未使用且未过期）"""
        return not self.is_used and not self.is_expired()

    def mark_as_used(self):
        """标记验证码为已使用"""
        self.is_used = True
        self.used_at = datetime.utcnow()
        db.session.commit()

    def to_dict(self):
        """转换为字典格式"""
        return {
            'id': self.id,
            'phone': self.phone,
            'purpose': self.purpose,
            'is_used': self.is_used,
            'created_at': self.created_at.replace(tzinfo=timezone.utc).isoformat() if self.created_at else None,
            'expires_at': self.expires_at.replace(tzinfo=timezone.utc).isoformat() if self.expires_at else None,
            'used_at': self.used_at.replace(tzinfo=timezone.utc).isoformat() if self.used_at else None
        }
