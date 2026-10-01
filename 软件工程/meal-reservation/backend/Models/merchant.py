"""Merchant related models."""
from datetime import datetime, timezone

from app_init import db


class MerchantApplication(db.Model):
    """商户申请模型"""
    __tablename__ = 'merchant_applications'

    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    user_id = db.Column(db.Integer, db.ForeignKey('users.id'), nullable=False)

    # 店铺基本信息
    shop_name = db.Column(db.String(100), comment='店铺名称')
    shop_type = db.Column(db.String(50), comment='店铺类型')
    business_license = db.Column(db.String(50), comment='营业执照号')
    phone = db.Column(db.String(20), comment='联系电话')
    address = db.Column(db.Text, comment='店铺地址')
    business_hours = db.Column(db.String(100), comment='营业时间')
    description = db.Column(db.Text, nullable=True, comment='店铺简介')

    # 证明文件
    license_file_url = db.Column(db.String(255), nullable=True, comment='营业执照文件URL')
    id_file_url = db.Column(db.String(255), nullable=True, comment='身份证文件URL')

    # 状态字段：draft（草稿）或 submitted（提交）
    status = db.Column(db.String(20), default='draft', comment='申请状态：draft/submitted')

    # 审核信息
    review_status = db.Column(db.String(20), default='pending', comment='审核状态：pending/approved/rejected')
    review_note = db.Column(db.Text, nullable=True, comment='审核备注')
    reviewed_at = db.Column(db.DateTime, nullable=True, comment='审核时间')
    reviewer_id = db.Column(db.Integer, db.ForeignKey('users.id'), nullable=True, comment='审核人ID')

    # 时间戳
    created_at = db.Column(db.DateTime, default=datetime.utcnow, comment='创建时间')
    updated_at = db.Column(db.DateTime, default=datetime.utcnow, onupdate=datetime.utcnow, comment='更新时间')

    # 关系
    user = db.relationship('User', foreign_keys=[user_id], backref=db.backref('merchant_applications', lazy='dynamic'))
    reviewer = db.relationship('User', foreign_keys=[reviewer_id], backref='reviewed_applications')

    def to_dict(self):
        """转换为字典格式"""
        return {
            'id': self.id,
            'user_id': self.user_id,
            'shop_name': self.shop_name,
            'shop_type': self.shop_type,
            'business_license': self.business_license,
            'phone': self.phone,
            'address': self.address,
            'business_hours': self.business_hours,
            'description': self.description,
            'license_file_url': self.license_file_url,
            'id_file_url': self.id_file_url,
            'status': self.status,
            'review_status': self.review_status,
            'review_note': self.review_note,
            'reviewed_at': self.reviewed_at.replace(tzinfo=timezone.utc).isoformat() if self.reviewed_at else None,
            'reviewer_id': self.reviewer_id,
            'created_at': self.created_at.replace(tzinfo=timezone.utc).isoformat() if self.created_at else None,
            'updated_at': self.updated_at.replace(tzinfo=timezone.utc).isoformat() if self.updated_at else None,
            'reviewer_name': self.reviewer.username if self.reviewer else None
        }

    def to_public_dict(self):
        """转换为公开的字典格式（不包含敏感信息）"""
        data = self.to_dict()
        # 移除敏感字段
        data.pop('business_license', None)
        data.pop('license_file_url', None)
        data.pop('id_file_url', None)
        return data

    @classmethod
    def get_by_user(cls, user_id):
        """根据用户ID获取申请列表"""
        return cls.query.filter_by(user_id=user_id).order_by(cls.created_at.desc()).all()

    @classmethod
    def get_pending_applications(cls):
        """获取待审核的申请列表"""
        return cls.query.filter_by(review_status='pending').order_by(cls.created_at.desc()).all()

    def is_draft(self):
        """检查是否为草稿状态"""
        return self.status == 'draft'

    def is_submitted(self):
        """检查是否为提交状态"""
        return self.status == 'submitted'

    def is_pending_review(self):
        """检查是否待审核"""
        return self.review_status == 'pending'

    def is_approved(self):
        """检查是否已通过审核"""
        return self.review_status == 'approved'

    def is_rejected(self):
        """检查是否被拒绝"""
        return self.review_status == 'rejected'
