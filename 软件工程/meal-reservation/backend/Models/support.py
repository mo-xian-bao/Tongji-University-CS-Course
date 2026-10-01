"""Support related models."""
from datetime import datetime, timezone
import random
import string

from app_init import db


class SupportTicket(db.Model):
    __tablename__ = 'support_tickets'

    id = db.Column(db.Integer, primary_key=True)
    ticket_number = db.Column(db.String(64), unique=True, nullable=False, index=True)
    user_id = db.Column(db.Integer, db.ForeignKey('users.id'), nullable=False)
    ticket_type = db.Column(db.String(50), nullable=False, default='general')
    subject = db.Column(db.String(200), nullable=False)
    content = db.Column(db.Text, nullable=False)
    order_id = db.Column(db.Integer, db.ForeignKey('orders.id'), nullable=True)
    status = db.Column(db.String(30), nullable=False, default='open')  # open, in_progress, resolved, closed
    assigned_cs_id = db.Column(db.Integer, db.ForeignKey('users.id'), nullable=True)
    attachments = db.Column(db.JSON, nullable=True, default=list)  # 存储上传附件的 URL 列表
    internal_notes = db.Column(db.Text, nullable=True)  # 仅客服可见的内部备注列表
    replies = db.Column(db.Text, nullable=True)  # 用户/客服的对话回复列表
    rating = db.Column(db.Integer, nullable=True)  # 用户对工单处理的评分（1-5）
    rating_comment = db.Column(db.Text, nullable=True)  # 可选的评分评论
    created_at = db.Column(db.DateTime, default=datetime.utcnow())
    updated_at = db.Column(db.DateTime, default=datetime.utcnow(), onupdate=datetime.utcnow())

    # relationships
    user = db.relationship('User', foreign_keys=[user_id], backref=db.backref('support_tickets', lazy='dynamic'))
    assigned_cs = db.relationship('User', foreign_keys=[assigned_cs_id])

    @staticmethod
    def generate_ticket_number():
        ts = datetime.utcnow().strftime('%Y%m%d%H%M%S')
        rand = ''.join(random.choices(string.digits, k=4))
        return f'TKT{ts}{rand}'

    def to_dict(self):
        import json
        return {
            'id': self.id,
            'ticket_number': self.ticket_number,
            'user_id': self.user_id,
            'user_name': self.user.username,
            'user_phone': self.user.phone,
            'ticket_type': self.ticket_type,
            'subject': self.subject,
            'content': self.content,
            'order_id': self.order_id,
            'attachments': self.attachments or [],
            'internal_notes': json.loads(self.internal_notes) if self.internal_notes else [],
            'replies': json.loads(self.replies) if self.replies else [],
            'rating': self.rating,
            'rating_comment': self.rating_comment,
            'status': self.status,
            'assigned_cs_id': self.assigned_cs_id,
            'assigned_cs_name': self.assigned_cs.username if self.assigned_cs else None,
            'created_at': self.created_at.replace(tzinfo=timezone.utc).isoformat() if self.created_at else None,
            'updated_at': self.updated_at.replace(tzinfo=timezone.utc).isoformat() if self.updated_at else None
        }


class SystemNotification(db.Model):
    __tablename__ = 'system_notifications'

    admin_id = db.Column(db.Integer, db.ForeignKey('users.id'), nullable=False, primary_key=True)
    target_audience = db.Column(db.String(50), nullable=False, primary_key=True)  # 'all', 'merchants', 'users'
    messages = db.Column(db.Text, nullable=False, default='[]')  # JSON array of {content, timestamp}
    created_at = db.Column(db.DateTime, default=datetime.utcnow)
    updated_at = db.Column(db.DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)

    # 关系
    admin = db.relationship('User', backref='system_notifications')

    def to_dict(self):
        import json
        return {
            'admin_id': self.admin_id,
            'admin_name': self.admin.username if self.admin else None,
            'target_audience': self.target_audience,
            'messages': json.loads(self.messages) if self.messages else [],
            'created_at': self.created_at.replace(tzinfo=timezone.utc).isoformat() if self.created_at else None,
            'updated_at': self.updated_at.replace(tzinfo=timezone.utc).isoformat() if self.updated_at else None
        }
