"""Review related models."""
from datetime import datetime, timezone

from app_init import db


class Review(db.Model):
    """用户对订单/商家/菜品的评价"""
    __tablename__ = 'reviews'

    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    order_id = db.Column(db.Integer, db.ForeignKey('orders.id'), nullable=False)
    restaurant_id = db.Column(db.Integer, db.ForeignKey('restaurants.id'), nullable=False)
    user_id = db.Column(db.Integer, db.ForeignKey('users.id'), nullable=False)

    rating = db.Column(db.Integer, nullable=False, default=5)
    food_rating = db.Column(db.Integer, nullable=True)
    packaging_rating = db.Column(db.Integer, nullable=True)
    service_rating = db.Column(db.Integer, nullable=True)

    content = db.Column(db.Text, nullable=True)
    images = db.Column(db.JSON, nullable=True, default=list)

    likes = db.Column(db.Integer, nullable=False, default=0)

    merchant_reply = db.Column(db.Text, nullable=True)
    merchant_reply_time = db.Column(db.DateTime, nullable=True)

    status = db.Column(db.String(20), nullable=False, default='normal')  # normal/hidden/deleted

    # 新增审核流程字段：只有 review_status == 'approved' 且 status == 'normal' 才在店铺/商家端显示
    review_status = db.Column(db.String(20), nullable=False, default='pending')  # pending/approved/rejected
    reviewer_id = db.Column(db.Integer, db.ForeignKey('users.id'), nullable=True)
    reviewed_at = db.Column(db.DateTime, nullable=True)
    # 管理员驳回理由
    review_reject_reason = db.Column(db.Text, nullable=True)

    created_at = db.Column(db.DateTime, default=datetime.utcnow)
    updated_at = db.Column(db.DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)

    # 关联
    user = db.relationship('User', foreign_keys=[user_id], backref=db.backref('reviews', lazy='dynamic'))
    restaurant = db.relationship('Restaurant', backref=db.backref('reviews', lazy='dynamic'))
    order = db.relationship('Order', backref=db.backref('reviews', lazy='dynamic'))
    reviewer = db.relationship('User', foreign_keys=[reviewer_id], backref=db.backref('reviewed_reviews', lazy='dynamic'))

    def to_dict(self):
        return {
            'id': self.id,
            'order_id': self.order_id,
            'restaurant_id': self.restaurant_id,
            'user_id': self.user_id,
            'username': self.user.username if self.user else None,
            'rating': self.rating,
            'food_rating': self.food_rating,
            'packaging_rating': self.packaging_rating,
            'service_rating': self.service_rating,
            'content': self.content,
            'images': self.images or [],
            'likes': self.likes,
            'merchant_reply': self.merchant_reply,
            'merchant_reply_time': self.merchant_reply_time.replace(tzinfo=timezone.utc).isoformat() if self.merchant_reply_time else None,
            'status': self.status,
            'review_status': self.review_status,
            'reviewer_id': self.reviewer_id,
            'reviewer_name': self.reviewer.username if self.reviewer else None,
            'reviewed_at': self.reviewed_at.replace(tzinfo=timezone.utc).isoformat() if self.reviewed_at else None,
            'review_reject_reason': self.review_reject_reason,
            'created_at': self.created_at.replace(tzinfo=timezone.utc).isoformat() if self.created_at else None,
            'updated_at': self.updated_at.replace(tzinfo=timezone.utc).isoformat() if self.updated_at else None
        }

    # helper
    def is_visible(self):
        return (self.review_status == 'approved') and (self.status == 'normal')

    def approve(self, reviewer_id=None):
        self.review_status = 'approved'
        if reviewer_id:
            self.reviewer_id = reviewer_id
        self.reviewed_at = datetime.utcnow()

    def reject(self, reviewer_id=None):
        self.review_status = 'rejected'
        if reviewer_id:
            self.reviewer_id = reviewer_id
        self.reviewed_at = datetime.utcnow()

    def is_pending_review(self):
        return self.review_status == 'pending'

    def is_approved(self):
        return self.review_status == 'approved'

    def is_rejected(self):
        return self.review_status == 'rejected'


class ReviewLike(db.Model):
    """记录用户对评论的点赞，确保每个用户对每条评论只能点赞一次"""
    __tablename__ = 'review_likes'

    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    review_id = db.Column(db.Integer, db.ForeignKey('reviews.id'), nullable=False)
    user_id = db.Column(db.Integer, db.ForeignKey('users.id'), nullable=False)
    created_at = db.Column(db.DateTime, default=datetime.utcnow)

    # 约束：同一用户对同一评论只能有一条记录
    __table_args__ = (
        db.UniqueConstraint('review_id', 'user_id', name='uix_review_user'),
    )

    review = db.relationship('Review', backref=db.backref('likes_rel', lazy='dynamic', cascade='all, delete-orphan'))
    user = db.relationship('User', backref=db.backref('review_likes', lazy='dynamic'))

    def to_dict(self):
        return {
            'id': self.id,
            'review_id': self.review_id,
            'user_id': self.user_id,
            'created_at': self.created_at.replace(tzinfo=timezone.utc).isoformat() if self.created_at else None
        }


class ReviewKeyword(db.Model):
    """敏感或自动拒绝关键词，管理员维护"""
    __tablename__ = 'review_keywords'
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    keyword = db.Column(db.String(128), nullable=False, unique=True)
    created_by = db.Column(db.Integer, db.ForeignKey('users.id'), nullable=True)
    created_at = db.Column(db.DateTime, default=datetime.utcnow)

    def to_dict(self):
        return {
            'id': self.id,
            'keyword': self.keyword,
            'created_by': self.created_by,
            'created_at': self.created_at.replace(tzinfo=timezone.utc).isoformat() if self.created_at else None
        }
