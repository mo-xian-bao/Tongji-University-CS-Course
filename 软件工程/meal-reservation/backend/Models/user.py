"""User and appeal related models."""
from datetime import datetime, timezone

from werkzeug.security import generate_password_hash, check_password_hash

from app_init import db


class User(db.Model):
    __tablename__ = 'users'

    id = db.Column(db.Integer, primary_key=True)
    phone = db.Column(db.String(11), unique=True, nullable=False)
    username = db.Column(db.String(50), unique=True, nullable=False)
    password_hash = db.Column(db.String(128), nullable=False)
    created_at = db.Column(db.DateTime, default=datetime.utcnow)
    updated_at = db.Column(db.DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)
    usertype = db.Column(db.Integer, nullable=False)  # 0为管理员，1为商家，2为用户,100为客服

    # 关联关系
    user_info = db.relationship('UserInfo', backref='user', uselist=False, cascade='all, delete-orphan')

    def set_password(self, password):
        self.password_hash = generate_password_hash(password)

    def check_password(self, password):
        return check_password_hash(self.password_hash, password)

    def to_dict(self):
        return {
            'id': self.id,
            'phone': self.phone,
            'username': self.username,
            'avatar_url': self.user_info.avatar_url if self.user_info else None,
            'birthday': self.user_info.birthday.isoformat() if self.user_info and self.user_info.birthday else None,
            'bio': self.user_info.bio if self.user_info else None,
            'created_at': self.created_at.replace(tzinfo=timezone.utc).isoformat() if self.created_at else None,
            'updated_at': self.updated_at.replace(tzinfo=timezone.utc).isoformat() if self.updated_at else None,
            'usertype': self.usertype,
            'status': self.get_effective_status(),
            'last_login': self.get_last_login_time(),
            'registerTime': self.created_at.replace(tzinfo=timezone.utc).isoformat() if self.created_at else None
        }

    def get_effective_status(self):
        """获取用户的有效状态（考虑封禁）"""
        active_ban = UserBan.query.filter_by(user_id=self.id).order_by(UserBan.created_at.desc()).first()
        if active_ban and active_ban.is_active_ban():
            return active_ban.status
        return 'normal'

    def get_last_login_time(self):
        """获取最后登录时间（模拟字段，实际项目中应该从登录记录表获取）"""
        # 这里返回一个模拟时间，实际项目中应该从登录记录表查询
        from datetime import datetime
        return datetime.utcnow().replace(tzinfo=timezone.utc).isoformat()

    def get_user_type_text(self):
        """获取用户类型文本"""
        type_map = {
            0: '管理员',
            1: '商家',
            2: '顾客'
        }
        return type_map.get(self.usertype, '未知')


class UserInfo(db.Model):
    """用户扩展信息模型"""
    __tablename__ = 'user_info'
    id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer, db.ForeignKey('users.id'), unique=True, nullable=False)
    avatar_url = db.Column(db.String(255), nullable=True)  # 头像URL
    birthday = db.Column(db.Date, nullable=True)  # 生日
    bio = db.Column(db.Text, nullable=True)  # 个性签名
    created_at = db.Column(db.DateTime, default=datetime.utcnow)
    updated_at = db.Column(db.DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)

    def to_dict(self):
        """转换为字典格式"""
        return {
            'id': self.id,
            'user_id': self.user_id,
            'avatar_url': self.avatar_url,
            'birthday': self.birthday.isoformat() if self.birthday else None,
            'bio': self.bio,
            'created_at': self.created_at.replace(tzinfo=timezone.utc).isoformat() if self.created_at else None,
            'updated_at': self.updated_at.replace(tzinfo=timezone.utc).isoformat() if self.updated_at else None
        }


class UserBan(db.Model):
    """用户封禁信息表"""
    __tablename__ = 'user_bans'

    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    user_id = db.Column(db.Integer, db.ForeignKey('users.id', ondelete='CASCADE'), nullable=False)
    status = db.Column(db.String(20), nullable=False, default='normal', comment='状态：normal/banned/temporarily_banned')
    ban_type = db.Column(db.String(20), nullable=True, comment='封禁类型：permanently/temporarily')
    ban_reason = db.Column(db.String(50), nullable=True, comment='封禁原因：spam/fraud/harassment/violation/illegal/other')
    ban_description = db.Column(db.Text, nullable=True, comment='封禁详细说明')
    ban_until = db.Column(db.DateTime, nullable=True, comment='临时封禁到期时间，永久封禁为null')
    banned_at = db.Column(db.DateTime, nullable=True, comment='封禁时间')
    unbanned_at = db.Column(db.DateTime, nullable=True, comment='解封时间')
    admin_id = db.Column(db.Integer, db.ForeignKey('users.id'), nullable=True, comment='执行封禁的管理员ID')
    notify_user = db.Column(db.Boolean, default=True, comment='是否通知用户')

    # 时间戳
    created_at = db.Column(db.DateTime, default=datetime.utcnow)
    updated_at = db.Column(db.DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)

    # 关系
    user = db.relationship('User', foreign_keys=[user_id], backref=db.backref('ban_info', uselist=False))
    admin = db.relationship('User', foreign_keys=[admin_id], backref='bans_applied')

    def to_dict(self):
        """转换为字典格式"""
        return {
            'id': self.id,
            'user_id': self.user_id,
            'username': self.user.username if self.user else None,
            'phone': self.user.phone if self.user else None,
            'status': self.status,
            'ban_type': self.ban_type,
            'ban_reason': self.ban_reason,
            'ban_reason_text': self.get_reason_text(),
            'ban_description': self.ban_description,
            'ban_until': self.ban_until.replace(tzinfo=timezone.utc).isoformat() if self.ban_until else None,
            'banned_at': self.banned_at.replace(tzinfo=timezone.utc).isoformat() if self.banned_at else None,
            'unbanned_at': self.unbanned_at.replace(tzinfo=timezone.utc).isoformat() if self.unbanned_at else None,
            'admin_name': self.admin.username if self.admin else None,
            'notify_user': self.notify_user,
            'created_at': self.created_at.replace(tzinfo=timezone.utc).isoformat() if self.created_at else None,
            'updated_at': self.updated_at.replace(tzinfo=timezone.utc).isoformat() if self.updated_at else None
        }

    def get_reason_text(self):
        """获取封禁原因文本"""
        reason_map = {
            'spam': '发布垃圾信息',
            'fraud': '欺诈行为',
            'harassment': '骚扰他人',
            'violation': '违反平台规定',
            'illegal': '违法内容',
            'other': '其他'
        }
        return reason_map.get(self.ban_reason, self.ban_reason or '未知原因')

    def is_active_ban(self):
        """检查是否为活跃的封禁状态"""
        if self.status != 'banned' and self.status != 'temporarily_banned':
            return False

        # 如果是临时封禁，检查是否过期
        if self.status == 'temporarily_banned' and self.ban_until:
            return datetime.utcnow() < self.ban_until

        return True

    def is_temporarily_banned(self):
        """检查是否为临时封禁"""
        return self.status == 'temporarily_banned'

    def is_permanently_banned(self):
        """检查是否为永久封禁"""
        return self.status == 'banned'

    @classmethod
    def get_active_ban(cls, user_id):
        """获取用户当前活跃的封禁记录"""
        return cls.query.filter_by(user_id=user_id, status__in=['banned', 'temporarily_banned']).first()

    @classmethod
    def get_ban_history(cls, user_id):
        """获取用户封禁历史"""
        return cls.query.filter_by(user_id=user_id).order_by(cls.created_at.desc()).all()


class UserAppeal(db.Model):
    """用户申诉表"""
    __tablename__ = 'user_appeals'

    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    user_id = db.Column(db.Integer, db.ForeignKey('users.id', ondelete='CASCADE'), nullable=False)
    ban_id = db.Column(db.Integer, db.ForeignKey('user_bans.id', ondelete='CASCADE'), nullable=False)

    # 申诉信息
    appeal_reason = db.Column(db.Text, nullable=False, comment='申诉理由')
    appeal_type = db.Column(db.String(50), nullable=False, comment='申诉类型：mistake_ban/punishment_too_heavy/evidence_provided/other')
    contact_info = db.Column(db.String(200), nullable=True, comment='联系方式')
    additional_info = db.Column(db.Text, nullable=True, comment='补充说明')

    # 状态字段
    status = db.Column(db.String(20), nullable=False, default='pending', comment='申诉状态：pending/processing/approved/rejected/closed')

    # 处理信息
    admin_id = db.Column(db.Integer, db.ForeignKey('users.id'), nullable=True, comment='处理申诉的管理员ID')
    admin_note = db.Column(db.Text, nullable=True, comment='管理员处理意见')
    processed_at = db.Column(db.DateTime, nullable=True, comment='处理时间')
    new_ban_status = db.Column(db.String(20), nullable=True, comment='新的封禁状态')

    # 时间戳
    created_at = db.Column(db.DateTime, default=datetime.utcnow, nullable=False)
    updated_at = db.Column(db.DateTime, default=datetime.utcnow, onupdate=datetime.utcnow, nullable=False)

    # 关系
    user = db.relationship('User', foreign_keys=[user_id], backref=db.backref('appeals', lazy='dynamic'))
    ban = db.relationship('UserBan', foreign_keys=[ban_id], backref=db.backref('appeals', lazy='dynamic'))
    admin = db.relationship('User', foreign_keys=[admin_id], backref='processed_appeals')

    def to_dict(self):
        """转换为字典格式"""
        return {
            'id': self.id,
            'user_id': self.user_id,
            'username': self.user.username if self.user else None,
            'user_phone': self.user.phone if self.user else None,
            'ban_id': self.ban_id,
            'ban_reason': self.ban.ban_reason if self.ban else None,
            'ban_reason_text': self.ban.get_reason_text() if self.ban else None,
            'appeal_reason': self.appeal_reason,
            'appeal_type': self.appeal_type,
            'appeal_type_text': self.get_appeal_type_text(),
            'contact_info': self.contact_info,
            'additional_info': self.additional_info,
            'status': self.status,
            'status_text': self.get_status_text(),
            'admin_id': self.admin_id,
            'admin_name': self.admin.username if self.admin else None,
            'admin_note': self.admin_note,
            'processed_at': self.processed_at.replace(tzinfo=timezone.utc).isoformat() if self.processed_at else None,
            'new_ban_status': self.new_ban_status,
            'created_at': self.created_at.replace(tzinfo=timezone.utc).isoformat() if self.created_at else None,
            'updated_at': self.updated_at.replace(tzinfo=timezone.utc).isoformat() if self.updated_at else None
        }

    def get_appeal_type_text(self):
        """获取申诉类型文本"""
        type_map = {
            'mistake_ban': '误封',
            'punishment_too_heavy': '处罚过重',
            'evidence_provided': '提供证据',
            'other': '其他'
        }
        return type_map.get(self.appeal_type, self.appeal_type or '未知')

    def get_status_text(self):
        """获取申诉状态文本"""
        status_map = {
            'pending': '待处理',
            'processing': '处理中',
            'approved': '已通过',
            'rejected': '已拒绝',
            'closed': '已关闭'
        }
        return status_map.get(self.status, self.status or '未知')

    def is_pending(self):
        """检查是否为待处理状态"""
        return self.status == 'pending'

    def is_processing(self):
        """检查是否为处理中状态"""
        return self.status == 'processing'

    def is_approved(self):
        """检查是否已通过"""
        return self.status == 'approved'

    def is_rejected(self):
        """检查是否被拒绝"""
        return self.status == 'rejected'

    def is_closed(self):
        """检查是否已关闭"""
        return self.status == 'closed'

    @classmethod
    def get_by_user(cls, user_id):
        """根据用户ID获取申诉列表"""
        return cls.query.filter_by(user_id=user_id).order_by(cls.created_at.desc()).all()

    @classmethod
    def get_pending_appeals(cls):
        """获取待处理的申诉列表"""
        return cls.query.filter_by(status='pending').order_by(cls.created_at.desc()).all()

    @classmethod
    def get_by_ban(cls, ban_id):
        """根据封禁ID获取申诉列表"""
        return cls.query.filter_by(ban_id=ban_id).order_by(cls.created_at.desc()).all()


class AppealAttachment(db.Model):
    """申诉附件表"""
    __tablename__ = 'appeal_attachments'

    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    appeal_id = db.Column(db.Integer, db.ForeignKey('user_appeals.id', ondelete='CASCADE'), nullable=False)

    # 附件信息
    file_name = db.Column(db.String(255), nullable=False, comment='原始文件名')
    file_path = db.Column(db.String(500), nullable=False, comment='文件存储路径')
    file_size = db.Column(db.Integer, nullable=False, comment='文件大小（字节）')
    file_type = db.Column(db.String(50), nullable=False, comment='文件类型')
    mime_type = db.Column(db.String(100), nullable=True, comment='MIME类型')

    # 状态
    status = db.Column(db.String(20), nullable=False, default='active', comment='状态：active/deleted')

    # 时间戳
    created_at = db.Column(db.DateTime, default=datetime.utcnow, nullable=False)
    updated_at = db.Column(db.DateTime, default=datetime.utcnow, onupdate=datetime.utcnow, nullable=False)

    # 关系
    appeal = db.relationship('UserAppeal', backref=db.backref('attachments', lazy='dynamic', cascade='all, delete-orphan'))

    def to_dict(self):
        """转换为字典格式"""
        return {
            'id': self.id,
            'appeal_id': self.appeal_id,
            'file_name': self.file_name,
            'file_path': self.file_path,
            'file_url': self.get_file_url(),
            'file_size': self.file_size,
            'file_size_text': self.get_file_size_text(),
            'file_type': self.file_type,
            'mime_type': self.mime_type,
            'status': self.status,
            'created_at': self.created_at.replace(tzinfo=timezone.utc).isoformat() if self.created_at else None,
            'updated_at': self.updated_at.replace(tzinfo=timezone.utc).isoformat() if self.updated_at else None
        }

    def get_file_url(self):
        """获取文件访问URL"""
        if self.file_path:
            # 去掉绝对路径前缀，返回相对路径用于前端访问
            if self.file_path.startswith('backend/static/'):
                return '/' + self.file_path
            if self.file_path.startswith('/'):
                return self.file_path
            return '/' + self.file_path
        return None

    def get_file_size_text(self):
        """获取人类可读的文件大小"""
        if not self.file_size:
            return '未知'

        size = self.file_size
        for unit in ['B', 'KB', 'MB', 'GB']:
            if size < 1024.0:
                return f"{size:.1f} {unit}"
            size /= 1024.0
        return f"{size:.1f} TB"

    def is_active(self):
        """检查文件是否为活跃状态"""
        return self.status == 'active'

    def is_image(self):
        """检查是否为图片文件"""
        return self.file_type.lower() in ['jpg', 'jpeg', 'png', 'gif', 'bmp', 'webp']

    def is_document(self):
        """检查是否为文档文件"""
        return self.file_type.lower() in ['pdf', 'doc', 'docx', 'txt', 'rtf']
