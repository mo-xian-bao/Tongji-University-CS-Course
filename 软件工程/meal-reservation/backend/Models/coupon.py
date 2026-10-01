"""Coupon related models."""
from datetime import datetime, timezone

from app_init import db


class CouponNotification(db.Model):
    """优惠券推送记录"""
    __tablename__ = 'coupon_notifications'

    id = db.Column(db.Integer, primary_key=True)
    restaurant_id = db.Column(db.Integer, db.ForeignKey('restaurants.id'), nullable=False)
    title = db.Column(db.String(150), nullable=False)
    description = db.Column(db.Text, nullable=True)
    discount_type = db.Column(db.String(30), nullable=False, default='amount')
    amount = db.Column(db.Float, nullable=True)
    min_spend = db.Column(db.Float, nullable=True)
    valid_from = db.Column(db.DateTime, nullable=True)
    valid_to = db.Column(db.DateTime, nullable=True)
    total_quantity = db.Column(db.Integer, nullable=True)
    extra_data = db.Column(db.JSON, nullable=True, default=dict)
    is_active = db.Column(db.Boolean, nullable=False, default=True)
    created_at = db.Column(db.DateTime, default=datetime.utcnow, nullable=False)
    broadcast_id = db.Column(db.Integer, db.ForeignKey('merchant_broadcasts.id'))

    restaurant = db.relationship('Restaurant', backref=db.backref('coupon_notifications', lazy=True))
    broadcast = db.relationship('MerchantBroadcast', backref=db.backref('coupon_notification', uselist=False))

    def to_dict(self):
        return {
            'id': self.id,
            'restaurant_id': self.restaurant_id,
            'restaurant_name': self.restaurant.name if self.restaurant else None,
            'title': self.title,
            'description': self.description,
            'discount_type': self.discount_type,
            'amount': self.amount,
            'min_spend': self.min_spend,
            'valid_from': self.valid_from.replace(tzinfo=timezone.utc).isoformat() if self.valid_from else None,
            'valid_to': self.valid_to.replace(tzinfo=timezone.utc).isoformat() if self.valid_to else None,
            'total_quantity': self.total_quantity,
            'extra_data': self.extra_data or {},
            'is_active': self.is_active,
            'created_at': self.created_at.replace(tzinfo=timezone.utc).isoformat() if self.created_at else None,
            'broadcast_id': self.broadcast_id,
            'broadcast': self.broadcast.to_dict() if self.broadcast else None
        }


class CouponUsage(db.Model):
    """优惠券使用记录表"""
    __tablename__ = 'coupon_usages'

    id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer, db.ForeignKey('users.id'), nullable=False)
    coupon_id = db.Column(db.Integer, db.ForeignKey('coupon_notifications.id'), nullable=False)
    order_id = db.Column(db.Integer, db.ForeignKey('orders.id'), nullable=True)
    used_at = db.Column(db.DateTime, default=datetime.utcnow, nullable=False)

    # 唯一约束：每个用户每个优惠券只能使用一次
    __table_args__ = (
        db.UniqueConstraint('user_id', 'coupon_id', name='unique_user_coupon'),
    )

    # 关系
    user = db.relationship('User', backref='coupon_usages')
    coupon = db.relationship('CouponNotification', backref='usages')
    order = db.relationship('Order', backref='coupon_usage')

    def to_dict(self):
        return {
            'id': self.id,
            'user_id': self.user_id,
            'coupon_id': self.coupon_id,
            'order_id': self.order_id,
            'used_at': self.used_at.replace(tzinfo=timezone.utc).isoformat() if self.used_at else None
        }


class CouponUserChoice(db.Model):
    """用户对优惠券推荐的选择记录"""
    __tablename__ = 'coupon_user_choices'

    id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer, db.ForeignKey('users.id'), nullable=False)
    coupon_id = db.Column(db.Integer, db.ForeignKey('coupon_notifications.id'), nullable=False)
    choice = db.Column(db.String(20), nullable=False)  # 'accept', 'reject', 'ignore'
    chosen_at = db.Column(db.DateTime, default=datetime.utcnow, nullable=False)
    recommendation_context = db.Column(db.JSON, nullable=True)  # 推荐时的上下文信息

    # 唯一约束：每个用户每个优惠券只能有一次选择记录
    __table_args__ = (
        db.UniqueConstraint('user_id', 'coupon_id', name='unique_user_coupon_choice'),
    )

    # 关系
    user = db.relationship('User', backref='coupon_choices')
    coupon = db.relationship('CouponNotification', backref='user_choices')

    def to_dict(self):
        """转换为字典格式"""
        return {
            'id': self.id,
            'user_id': self.user_id,
            'coupon_id': self.coupon_id,
            'choice': self.choice,
            'chosen_at': self.chosen_at.replace(tzinfo=timezone.utc).isoformat() if self.chosen_at else None,
            'recommendation_context': self.recommendation_context or {}
        }
