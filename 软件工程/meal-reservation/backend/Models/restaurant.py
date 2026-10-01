"""Restaurant related models."""
from datetime import datetime, timezone

from app_init import db


class MerchantBroadcast(db.Model):
    __tablename__ = 'merchant_broadcasts'

    id = db.Column(db.Integer, primary_key=True)
    restaurant_id = db.Column('merchant_id', db.Integer, db.ForeignKey('restaurants.id'), nullable=False)
    title = db.Column(db.String(100), nullable=False)
    content = db.Column(db.Text, nullable=False)
    start_time = db.Column(db.DateTime)
    end_time = db.Column(db.DateTime)
    is_active = db.Column(db.Boolean, default=True)
    created_at = db.Column(db.DateTime, default=datetime.utcnow, nullable=False)
    updated_at = db.Column(db.DateTime, default=datetime.utcnow, onupdate=datetime.utcnow, nullable=False)

    restaurant = db.relationship('Restaurant', backref=db.backref('broadcasts', lazy=True))

    def to_dict(self):
        return {
            'id': self.id,
            'restaurant_id': self.restaurant_id,
            'restaurant_name': self.restaurant.name if self.restaurant else None,
            'title': self.title,
            'content': self.content,
            'start_time': self.start_time.replace(tzinfo=timezone.utc).isoformat() if self.start_time else None,
            'end_time': self.end_time.replace(tzinfo=timezone.utc).isoformat() if self.end_time else None,
            'is_active': self.is_active,
            'created_at': self.created_at.replace(tzinfo=timezone.utc).isoformat() if self.created_at else None,
            'updated_at': self.updated_at.replace(tzinfo=timezone.utc).isoformat() if self.updated_at else None
        }


class Restaurant(db.Model):
    """餐厅模型"""
    __tablename__ = 'restaurants'
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(100), nullable=False)  # 餐厅名称
    address = db.Column(db.String(200), nullable=False)  # 餐厅地址
    phone = db.Column(db.String(20), nullable=False)  # 联系电话
    opening_hours = db.Column(db.String(100), nullable=False)  # 营业时间，格式 "09:00-21:00"
    is_open = db.Column(db.Boolean, nullable=False, default=True)  # 是否营业
    notice = db.Column(db.Text, nullable=True)  # 餐厅公告
    avatar_url = db.Column(db.String(255), nullable=True)  # 头像URL
    user_id = db.Column(db.Integer, db.ForeignKey('users.id'), nullable=False)  # 关联的用户ID
    created_at = db.Column(db.DateTime, default=datetime.utcnow)
    updated_at = db.Column(db.DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)

    # 新增字段：评分，允许为空
    rating = db.Column(db.Float, default=None, nullable=True)

    # 关联关系
    user = db.relationship('User', backref=db.backref('restaurant', uselist=False))

    def to_dict(self):
        """转换为字典格式"""
        # 计算排队信息（按实时占用计算：pending 下单即占桌；独立桌占用后可用座位为0）
        tables = self.tables.all() if hasattr(self, 'tables') else []

        idle_tables = 0
        idle_seats = 0
        for table in tables:
            # 维护状态不计入空闲
            if getattr(table, 'status', None) == 'maintenance':
                continue

            current_occupancy = table.get_current_occupancy() if hasattr(table, 'get_current_occupancy') else 0
            if getattr(table, 'table_type', None) == 'private':
                available_seats = table.capacity if current_occupancy == 0 else 0
            else:
                available_seats = max((table.capacity or 0) - current_occupancy, 0)

            idle_seats += available_seats
            if available_seats > 0:
                idle_tables += 1

        queue_count = self.orders.filter_by(status='pending').count() if hasattr(self, 'orders') else 0

        # 智能排队时间预测 (基于餐桌周转率)
        total_tables = len(tables)

        if total_tables > 0:
            # 假设平均用餐时间为 45 分钟
            avg_dining_duration = 45.0
            # 商家平均接单处理时间 2 分钟
            avg_process_time = 2.0

            # 计算餐桌周转速率 (分钟/桌)
            # 例如: 45分钟用餐时间 / 10张桌子 = 平均每4.5分钟释放一张桌子
            table_turnover_rate = avg_dining_duration / total_tables

            # 计算溢出队列 (队列人数 - 当前空闲桌数)
            # 如果有空桌，溢出为0；否则为需要等待翻台的人数
            overflow_queue = max(0, queue_count - idle_tables)

            # 总等待时间 = (所有人的订单处理时间) + (溢出人员的翻台等待时间)
            wait_time = int((queue_count * avg_process_time) + (overflow_queue * table_turnover_rate))
        else:
            # 兜底策略：每单估算 5 分钟
            wait_time = queue_count * 5

        return {
            'id': self.id,
            'name': self.name,
            'address': self.address,
            'phone': self.phone,
            'opening_hours': self.opening_hours,
            'is_open': bool(self.is_open),
            'notice': self.notice,
            'avatar_url': self.avatar_url,
            'user_id': self.user_id,
            'created_at': self.created_at.replace(tzinfo=timezone.utc).isoformat() if self.created_at else None,
            'updated_at': self.updated_at.replace(tzinfo=timezone.utc).isoformat() if self.updated_at else None,
            'followers_count': self.followers.count() if hasattr(self, 'followers') else 0,
            'rating': self.rating if self.rating else None,
            # 新增排队字段
            'idle_tables_count': idle_tables,
            'idle_seats_count': idle_seats,
            'queue_orders_count': queue_count,
            'estimated_wait_time': wait_time
        }


class RestaurantFollow(db.Model):
    __tablename__ = 'restaurant_follows'

    id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer, db.ForeignKey('users.id'), nullable=False)
    restaurant_id = db.Column(db.Integer, db.ForeignKey('restaurants.id'), nullable=False)
    created_at = db.Column(db.DateTime, default=datetime.utcnow, nullable=False)

    __table_args__ = (
        db.UniqueConstraint('user_id', 'restaurant_id', name='uq_user_restaurant_follow'),
    )

    user = db.relationship('User', backref=db.backref('following_restaurants', lazy='dynamic'))
    restaurant = db.relationship('Restaurant', backref=db.backref('followers', lazy='dynamic'))

    def to_dict(self, include_restaurant=False):
        payload = {
            'id': self.id,
            'user_id': self.user_id,
            'restaurant_id': self.restaurant_id,
            'created_at': self.created_at.replace(tzinfo=timezone.utc).isoformat() if self.created_at else None
        }
        if include_restaurant and self.restaurant:
            payload['restaurant'] = self.restaurant.to_dict()
        return payload
