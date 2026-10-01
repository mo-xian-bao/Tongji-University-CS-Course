from app_init import db
from werkzeug.security import generate_password_hash, check_password_hash
from datetime import datetime,timedelta,timezone
import random
import string
import os
import json

class User(db.Model):
    __tablename__ = 'users'

    id = db.Column(db.Integer, primary_key=True)
    phone = db.Column(db.String(11), unique=True, nullable=False)
    username = db.Column(db.String(50), unique=True, nullable=False)
    password_hash = db.Column(db.String(128), nullable=False)
    created_at = db.Column(db.DateTime, default=datetime.utcnow)
    updated_at = db.Column(db.DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)
    usertype = db.Column(db.Integer,nullable=False) #0为管理员，1为商家，2为用户,100为客服
    
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
# 用户扩展信息模型
class UserInfo(db.Model):
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
    
# 餐厅模型
class Restaurant(db.Model):
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

# 短信验证码模型
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


# 菜品信息模型
class Dish(db.Model):
    """菜品信息数据表"""
    __tablename__ = 'dishes'

    # 主键：菜品ID
    dish_id = db.Column(db.Integer, primary_key=True, autoincrement=True, comment='菜品ID')
    # 外键：关联餐厅表的ID
    restaurant_id = db.Column(db.Integer, db.ForeignKey('restaurants.id'), nullable=False, comment='关联餐厅ID')

    # 菜品基本信息
    name = db.Column(db.String(100), nullable=False, comment='菜品名称')
    description = db.Column(db.Text, nullable=True, comment='菜品描述')
    price = db.Column(db.Numeric(10, 2), nullable=False, comment='菜品价格')
    original_price = db.Column(db.Numeric(10, 2), nullable=True, comment='原价')
    category = db.Column(db.String(50), nullable=True, comment='菜品分类')

    # 菜品状态
    status = db.Column(db.String(20), default='available', comment='菜品状态：available/sold_out/unavailable')
    is_spicy_selectable = db.Column(db.Boolean, default=False, comment='是否可选择辣度')
    is_garnish_selectable = db.Column(db.Boolean, default=False, comment='是否可选葱花香菜')
    multi_spec_enabled = db.Column(db.Boolean, default=False, nullable=False, comment='是否启用自定义规格')
    specifications = db.Column(db.JSON, default=list, nullable=False, comment='自定义规格配置')
    tags = db.Column(db.JSON, default=list, comment='菜品标签')
    monthly_sales = db.Column(db.Integer, default=0, comment='月售数量')
    stock_capacity = db.Column(db.Integer, nullable=True, comment='库存上限')
    # 库存预警
    stock_alert_enabled = db.Column(db.Boolean, default=False, nullable=False, comment='是否启用库存预警')
    stock_alert_threshold = db.Column(db.Integer, nullable=True, comment='库存预警阈值')
    # 折扣设置
    discount_enabled = db.Column(db.Boolean, default=False, nullable=False, comment='是否启用折扣')
    discount_method = db.Column(db.String(20), default='price', comment='折扣方式: price/percentage')
    discount_price = db.Column(db.Numeric(10, 2), nullable=True, comment='折扣价格')
    discount_percentage = db.Column(db.Numeric(10, 2), nullable=True, comment='折扣百分比')
    # 菜品图片
    image_url = db.Column(db.String(255), nullable=True, comment='菜品图片URL')
    # 库存信息（可选）
    stock_quantity = db.Column(db.Integer, nullable=True, comment='库存数量')
    # 时间戳
    created_at = db.Column(db.DateTime, default=datetime.utcnow, comment='创建时间')
    updated_at = db.Column(db.DateTime, default=datetime.utcnow, onupdate=datetime.utcnow, comment='更新时间')
    # 关系：反向引用，一个餐厅对应多个菜品
    restaurant = db.relationship('Restaurant', backref=db.backref('dishes', lazy=True))

    def to_dict(self):
        """转换为字典格式 - 用于API响应"""
        return {
            'dish_id': self.dish_id,
            'restaurant_id': self.restaurant_id,
            'name': self.name,
            'description': self.description,
            'price': float(self.price) if self.price else 0.0,
            'original_price': float(self.original_price) if self.original_price else None,
            'category': self.category,
            'status': self.status,
            'is_spicy_selectable': self.is_spicy_selectable,
            'is_garnish_selectable': self.is_garnish_selectable,
            'multi_spec_enabled': self.multi_spec_enabled,
            'specifications': self.specifications or [],
            'image_url': self.image_url,
            'stock_quantity': self.stock_quantity,
            'tags': self.tags or [],
            'monthly_sales': self.monthly_sales or 0,
            'stock_capacity': self.stock_capacity,
            'stock_alert_enabled': self.stock_alert_enabled or False,
            'stock_alert_threshold': self.stock_alert_threshold,
            'discount': {
                'enable': self.discount_enabled or False,
                'method': self.discount_method or 'price',
                'price': float(self.discount_price) if self.discount_price is not None else None,
                'percentage': float(self.discount_percentage) if self.discount_percentage is not None else None
            },
            'created_at': self.created_at.replace(tzinfo=timezone.utc).isoformat() if self.created_at else None,
            'updated_at': self.updated_at.replace(tzinfo=timezone.utc).isoformat() if self.updated_at else None
        }
    
    def to_public_dict(self):
        """转换为公开的字典格式 - 用于前端显示"""
        data = self.to_dict()
        # 移除后端敏感字段
        data.pop('restaurant_id', None)
        return data

    def to_menu_card(self):
        return {
            'id': self.dish_id,
            'name': self.name,
            'category': self.category,
            'description': self.description,
            'price': float(self.price) if self.price else 0.0,
            'originalPrice': float(self.original_price) if self.original_price else None,
            'monthlySales': self.monthly_sales or 0,
            'stock': {
                'current': self.stock_quantity or 0,
                'cap': self.stock_capacity or self.stock_quantity or 0,
                'alertEnabled': self.stock_alert_enabled or False,
                'alertThreshold': self.stock_alert_threshold,
                'isLowStock': self.is_low_stock()
            },
            'discount': {
                'enable': self.discount_enabled or False,
                'method': self.discount_method or 'price',
                'price': float(self.discount_price) if self.discount_price is not None else None,
                'percentage': float(self.discount_percentage) if self.discount_percentage is not None else None
            },
            'status': self.status,
            'tags': self.tags or [],
            'specifications': self.specifications or [],
            'image': self.image_url,
            'lastUpdated': (self.updated_at or self.created_at).replace(tzinfo=timezone.utc).isoformat() if (self.updated_at or self.created_at) else None
        }

    def is_low_stock(self):
        """判断库存是否低于预警阈值"""
        if not self.stock_alert_enabled or self.stock_alert_threshold is None:
            return False
        current_stock = self.stock_quantity or 0
        return current_stock <= self.stock_alert_threshold

    def update_stock(self, quantity_change, change_type='sales', operator_id=None, note=None, cost=None):
        """Updates stock and status. A positive change increases stock, a negative one decreases it."""
        if self.stock_quantity is None:
            return  # Do nothing if stock is not tracked

        original_stock = self.stock_quantity
        self.stock_quantity += quantity_change

        # 确保库存不为负
        if self.stock_quantity < 0:
            self.stock_quantity = 0

        stock_before = original_stock
        stock_after = self.stock_quantity
    
        # 记录库存变动
        log = StockLog(
            dish_id=self.dish_id,
            restaurant_id=self.restaurant_id,
            change_type=change_type,
            quantity_change=quantity_change,
            stock_before=stock_before,
            stock_after=stock_after,
            cost=cost,
            operator_id=operator_id,
            note=note
        )
        db.session.add(log)
        self.updated_at = datetime.utcnow()

        # --- 关键修复：智能更新状态 ---
        # 1. 如果库存从0变为正数，且状态是'sold_out'，则更新为'available'
        if original_stock == 0 and self.stock_quantity > 0 and self.status == 'sold_out':
            self.status = 'available'
        # 2. 如果库存降为0，则更新为'sold_out'
        elif self.stock_quantity == 0:
            self.status = 'sold_out'

    def is_available(self):
        """Check if the dish is available for ordering."""
        return self.status == 'available'

    @classmethod
    def get_by_restaurant(cls, restaurant_id):
        """根据餐厅ID获取菜品列表"""
        return cls.query.filter_by(restaurant_id=restaurant_id).order_by(cls.created_at.desc()).all()

    @classmethod
    def get_available_dishes(cls, restaurant_id):
        """获取可售菜品列表"""
        return cls.query.filter_by(restaurant_id=restaurant_id, status='available').order_by(cls.created_at.desc()).all()

    @classmethod
    def get_featured_dishes(cls, restaurant_id):
        """获取推荐菜品列表"""
        return cls.query.filter_by(restaurant_id=restaurant_id, is_featured=True).order_by(cls.created_at.desc()).all()

    @classmethod
    def get_by_category(cls, restaurant_id, category):
        """根据分类获取菜品列表"""
        return cls.query.filter_by(restaurant_id=restaurant_id, category=category, status='available').order_by(cls.created_at.desc()).all()

    
class DishLaunchNotification(db.Model):
    """菜品上新自动通知记录"""
    __tablename__ = 'dish_launch_notifications'

    id = db.Column(db.Integer, primary_key=True)
    dish_id = db.Column(db.Integer, db.ForeignKey('dishes.dish_id'), nullable=False)
    restaurant_id = db.Column(db.Integer, db.ForeignKey('restaurants.id'), nullable=False)
    title = db.Column(db.String(150), nullable=False)
    message = db.Column(db.Text, nullable=False)
    audience = db.Column(db.String(30), nullable=False, default='followers')
    dish_snapshot = db.Column(db.JSON, nullable=False, default=dict)
    is_active = db.Column(db.Boolean, nullable=False, default=True)
    created_at = db.Column(db.DateTime, default=datetime.utcnow, nullable=False)
    broadcast_id = db.Column(db.Integer, db.ForeignKey('merchant_broadcasts.id'))

    dish = db.relationship('Dish', backref=db.backref('launch_notifications', lazy=True))
    restaurant = db.relationship('Restaurant', backref=db.backref('dish_launch_notifications', lazy=True))
    broadcast = db.relationship('MerchantBroadcast', backref=db.backref('dish_notification', uselist=False))

    def to_dict(self):
        snapshot = self.dish_snapshot or {}
        return {
            'id': self.id,
            'dish_id': self.dish_id,
            'restaurant_id': self.restaurant_id,
            'restaurant_name': self.restaurant.name if self.restaurant else None,
            'title': self.title,
            'message': self.message,
            'audience': self.audience,
            'dish_snapshot': snapshot,
            'is_active': self.is_active,
            'created_at': self.created_at.replace(tzinfo=timezone.utc).isoformat() if self.created_at else None,
            'broadcast_id': self.broadcast_id,
            'broadcast': self.broadcast.to_dict() if self.broadcast else None
        }


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


class Table(db.Model):
    """桌位表"""
    __tablename__ = 'tables'
    
    id = db.Column(db.Integer, primary_key=True)
    restaurant_id = db.Column(db.Integer, db.ForeignKey('restaurants.id'), nullable=False)
    table_number = db.Column(db.String(20), nullable=False)
    capacity = db.Column(db.Integer, nullable=False)
    table_type = db.Column(db.String(20), default='shared')  # shared: 拼桌, private: 独立
    status = db.Column(db.String(20), default='available')  # available, occupied, reserved
    qr_code = db.Column(db.String(255))
    description = db.Column(db.Text)
    created_at = db.Column(db.DateTime, default=datetime.utcnow)
    updated_at = db.Column(db.DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)
    
    # 关系
    restaurant = db.relationship('Restaurant', backref=db.backref('tables', lazy='dynamic'))
    
    def get_current_occupancy(self, exclude_order_id=None):
        """计算当前桌位的实时占用人数（下单即占桌：pending/confirmed/dining 均计入占用）"""
        from datetime import datetime
        now = datetime.utcnow()
        
        # 查询所有关联该桌位且状态为pending/confirmed/dining的订单
        query = Order.query.filter(
            Order.table_id == self.id,
            Order.status.in_(['pending', 'confirmed', 'dining'])
        )
        
        if exclude_order_id:
            query = query.filter(Order.id != exclude_order_id)
        
        total_occupancy = 0
        for order in query.all():
            # 如果是预约订单，需要检查：1.预约状态已确认 2.当前时间在预约时段内
            if order.reserved_time and order.reserved_end_time:
                # 预约订单：预约状态 pending/confirmed/seated 且当前时间在预约时段内
                if order.reservation_status in ['pending', 'confirmed', 'seated']:
                    if order.reserved_time <= now <= order.reserved_end_time:
                        total_occupancy += order.customer_count
            else:
                # 非预约订单（立即到店），下单即占桌：pending/confirmed/dining 均算占用
                total_occupancy += order.customer_count
        
        return total_occupancy

    def can_accommodate(self, num_of_people, exclude_order_id=None):
        """检查桌位是否能容纳指定人数"""
        current_occupancy = self.get_current_occupancy(exclude_order_id=exclude_order_id)

        # 独立桌：只要已有占用，就不允许再入座/叠加
        if self.table_type == 'private':
            return current_occupancy == 0 and num_of_people <= self.capacity

        # 拼桌：按剩余座位累加判断
        return self.capacity >= current_occupancy + num_of_people

    def get_realtime_status(self):
        """获取桌位的实时状态（只考虑当前时刻）"""
        from datetime import datetime
        
        # 如果是维护状态，直接返回
        if self.status == 'maintenance':
            return 'maintenance'
        
        # 检查当前是否有人使用
        current_occupancy = self.get_current_occupancy()
        if current_occupancy > 0:
            return 'occupied'
        
        # 检查当前时刻是否在某个已确认的预约时段内
        now = datetime.utcnow()
        active_reservation = Order.query.filter(
            Order.table_id == self.id,
            Order.reservation_status.in_(['confirmed', 'seated']),
            Order.reserved_time <= now,
            Order.reserved_end_time >= now
        ).first()
        
        if active_reservation:
            return 'reserved'
        
        return 'available'

    def to_dict(self):
        """转换为字典格式"""
        current_occupancy = self.get_current_occupancy()
        realtime_status = self.get_realtime_status()

        if self.table_type == 'private':
            # 独立桌：可用=整桌可用；不可用=0
            available_seats = self.capacity if realtime_status == 'available' else 0
        else:
            available_seats = self.capacity - current_occupancy
        
        return {
            'id': self.id,
            'restaurant_id': self.restaurant_id,
            'table_number': self.table_number,
            'capacity': self.capacity,
            'current_occupancy': current_occupancy,  # 当前使用人数
            'available_seats': available_seats,  # 剩余可用人数
            'table_type': self.table_type,
            'status': realtime_status,
            
            'qr_code': self.qr_code,
            'description': self.description,
            'created_at': self.created_at.replace(tzinfo=timezone.utc).isoformat() if self.created_at else None,
            'updated_at': self.updated_at.replace(tzinfo=timezone.utc).isoformat() if self.updated_at else None
        }


class Order(db.Model):
    """订单表"""
    __tablename__ = 'orders'
    
    id = db.Column(db.Integer, primary_key=True)
    order_number = db.Column(db.String(50), unique=True, nullable=False)
    user_id = db.Column(db.Integer, db.ForeignKey('users.id'), nullable=False)
    restaurant_id = db.Column(db.Integer, db.ForeignKey('restaurants.id'), nullable=False)
    table_id = db.Column(db.Integer, db.ForeignKey('tables.id'), nullable=True)
    
    customer_count = db.Column(db.Integer, default=1)  # 就餐人数
    order_type = db.Column(db.String(20), default='dine_in')  # dine_in: 堂食, takeout: 外卖
    status = db.Column(db.String(20), default='pending')  # pending, confirmed, dining, completed, cancelled, rejected
    
    # 预约相关字段
    reserved_time = db.Column(db.DateTime, nullable=True)  # 预约到店时间
    reserved_end_time = db.Column(db.DateTime, nullable=True)  # 预计结束时间
    reservation_status = db.Column(db.String(20), default='none')  # none/pending/confirmed/seated/completed/cancelled/no_show
    
    total_price = db.Column(db.Float, default=0.0)
    original_price = db.Column(db.Float, default=0.0)  # 优惠前原价
    discount_amount = db.Column(db.Float, default=0.0)  # 优惠金额
    coupon_id = db.Column(db.Integer, db.ForeignKey('coupon_notifications.id'), nullable=True)  # 使用的优惠券ID
    note = db.Column(db.Text)  # 备注
    pickup_number = db.Column(db.String(10), nullable=True)  # 取单号
    reject_reason = db.Column(db.Text, nullable=True)  # 拒绝理由
    
    # 时间戳
    order_time = db.Column(db.DateTime, default=datetime.utcnow)
    confirmed_time = db.Column(db.DateTime)
    completed_time = db.Column(db.DateTime)
    cancelled_time = db.Column(db.DateTime)
    
    created_at = db.Column(db.DateTime, default=datetime.utcnow)
    updated_at = db.Column(db.DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)
    
    # 关系
    user = db.relationship('User', backref=db.backref('orders', lazy='dynamic'))
    restaurant = db.relationship('Restaurant', backref=db.backref('orders', lazy='dynamic'))
    table = db.relationship('Table', backref='orders')
    coupon = db.relationship('CouponNotification', backref='orders')
    
    def to_dict(self):
        """转换为字典格式"""
        return {
            'id': self.id,
            'order_number': self.order_number,
            'user_id': self.user_id,
            'restaurant_id': self.restaurant_id,
            'restaurant_name': self.restaurant.name if self.restaurant else None,
            'table_id': self.table_id,
            'table_number': self.table.table_number if self.table else None,
            'customer_count': self.customer_count,
            'order_type': self.order_type,
            'status': self.status,
            'reserved_time': self.reserved_time.replace(tzinfo=timezone.utc).isoformat() if self.reserved_time else None,
            'reserved_end_time': self.reserved_end_time.replace(tzinfo=timezone.utc).isoformat() if self.reserved_end_time else None,
            'reservation_status': self.reservation_status,
            'total_price': self.total_price,
            'original_price': self.original_price,
            'discount_amount': self.discount_amount,
            'coupon_id': self.coupon_id,
            'coupon': self.coupon.to_dict() if self.coupon else None,
            'note': self.note,
            'pickup_number': self.pickup_number,
            'reject_reason': self.reject_reason,
            'order_time': self.order_time.replace(tzinfo=timezone.utc).isoformat() if self.order_time else None,
            'confirmed_time': self.confirmed_time.replace(tzinfo=timezone.utc).isoformat() if self.confirmed_time else None,
            'completed_time': self.completed_time.replace(tzinfo=timezone.utc).isoformat() if self.completed_time else None,
            'cancelled_time': self.cancelled_time.replace(tzinfo=timezone.utc).isoformat() if self.cancelled_time else None,
            'created_at': self.created_at.replace(tzinfo=timezone.utc).isoformat() if self.created_at else None,
            'updated_at': self.updated_at.replace(tzinfo=timezone.utc).isoformat() if self.updated_at else None,
            'items': [item.to_dict() for item in self.items] if self.items else []
        }
    
    @staticmethod
    def generate_order_number():
        """生成唯一订单号"""
        timestamp = datetime.utcnow().strftime('%Y%m%d%H%M%S')
        random_num = random.randint(1000, 9999)
        return f"ORD{timestamp}{random_num}"
    
    @staticmethod
    def generate_pickup_number(restaurant_id):
        """
        生成取单号 (4位数字)
        确保在该餐厅的未完成订单中不重复
        """
        max_attempts = 100  # 最多尝试100次
        for _ in range(max_attempts):
            pickup_number = str(random.randint(1000, 9999))
            
            # 检查该餐厅是否有相同取单号的未完成订单
            existing_order = Order.query.filter(
                Order.restaurant_id == restaurant_id,
                Order.pickup_number == pickup_number,
                Order.status.in_(['confirmed', 'dining'])  # 只检查已接单且未完成的订单
            ).first()
            
            if not existing_order:
                return pickup_number
        
        # 如果100次都没生成唯一号码，返回一个带时间戳的号码（理论上不会发生）
        return str(random.randint(1000, 9999))


class OrderItem(db.Model):
    """订单项表"""
    __tablename__ = 'order_items'
    
    id = db.Column(db.Integer, primary_key=True)
    order_id = db.Column(db.Integer, db.ForeignKey('orders.id'), nullable=False)
    dish_id = db.Column(db.Integer, db.ForeignKey('dishes.dish_id'), nullable=False)
    quantity = db.Column(db.Integer, nullable=False, default=1)  # 数量
    unit_price = db.Column(db.Float, nullable=False)  # 单价
    subtotal = db.Column(db.Float, nullable=False)  # 小计
    spiciness = db.Column(db.String(50), nullable=True)  # 辣度
    garnish = db.Column(db.String(50), nullable=True)  # 葱花香菜
    
    # 关系
    order = db.relationship('Order', backref=db.backref('items', lazy='dynamic', cascade='all, delete-orphan'))
    dish = db.relationship('Dish')

    def to_dict(self):
        dish_info = self.dish.to_dict() if self.dish else {}
        return {
            'id': self.id,
            'order_id': self.order_id,
            'dish_id': self.dish_id,
            'dish_name': dish_info.get('name'),
            'dish_image': dish_info.get('image_url'),
            'quantity': self.quantity,
            'unit_price': str(self.unit_price),
            'subtotal': str(self.subtotal),
            'spiciness': self.spiciness,
            'garnish': self.garnish,
            'dish': dish_info  # 添加完整的 dish 对象
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

# 商户申请模型
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
    user = db.relationship('User', foreign_keys=[user_id],backref=db.backref('merchant_applications', lazy='dynamic'))
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


class OrderChangeRequest(db.Model):
    __tablename__ = 'order_change_requests'

    id = db.Column(db.Integer, primary_key=True)
    order_id = db.Column(db.Integer, db.ForeignKey('orders.id'), nullable=False)
    user_id = db.Column(db.Integer, db.ForeignKey('users.id'), nullable=False)
    restaurant_id = db.Column(db.Integer, db.ForeignKey('restaurants.id'), nullable=False)
    request_type = db.Column(db.String(20), nullable=False)  # modify / cancel
    reason = db.Column(db.Text)
    payload = db.Column(db.JSON, nullable=True, default=dict)
    status = db.Column(db.String(20), nullable=False, default='pending')
    admin_note = db.Column(db.Text)
    created_at = db.Column(db.DateTime, default=datetime.utcnow)
    updated_at = db.Column(db.DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)

    order = db.relationship(
        'Order',
        backref=db.backref('change_requests', lazy='dynamic', cascade='all, delete-orphan')
    )

    def to_dict(self):
        return {
            'id': self.id,
            'order_id': self.order_id,
            'user_id': self.user_id,
            'restaurant_id': self.restaurant_id,
            'request_type': self.request_type,
            'reason': self.reason,
            'payload': self.payload or {},
            'status': self.status,
            'admin_note': self.admin_note,
            'created_at': self.created_at.replace(tzinfo=timezone.utc).isoformat() if self.created_at else None,
            'updated_at': self.updated_at.replace(tzinfo=timezone.utc).isoformat() if self.updated_at else None
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
            elif self.file_path.startswith('/'):
                return self.file_path
            else:
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

class Message(db.Model):
    __tablename__ = 'messages'
    
    id = db.Column(db.Integer, primary_key=True)
    order_id = db.Column(db.Integer, db.ForeignKey('orders.id'), nullable=True)
    request_id = db.Column(db.Integer, db.ForeignKey('order_change_requests.id'), nullable=True)
    sender_id = db.Column(db.Integer, nullable=False)
    sender_type = db.Column(db.String(20), nullable=False)  # 'user' or 'merchant'
    text = db.Column(db.Text, nullable=False)
    created_at = db.Column(db.DateTime, default=datetime.utcnow)
    
    # 新增：消息类型字段（normal: 普通消息, action: 特殊操作消息）
    message_type = db.Column(db.String(20), default='normal')
    
    # 关系
    order = db.relationship('Order', backref='messages')
    request = db.relationship('OrderChangeRequest', backref='messages')
    
    def to_dict(self):
        return {
            'id': self.id,
            'order_id': self.order_id,
            'request_id': self.request_id,
            'sender_id': self.sender_id,
            'sender_type': self.sender_type,
            'text': self.text,
            'created_at': self.created_at.replace(tzinfo=timezone.utc).isoformat() if self.created_at else None,
            'message_type': self.message_type  # 新增返回字段
        }

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

class StockLog(db.Model):
    __tablename__ = 'stock_logs'
    
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    dish_id = db.Column(db.Integer, db.ForeignKey('dishes.dish_id'), nullable=False)
    restaurant_id = db.Column(db.Integer, db.ForeignKey('restaurants.id'), nullable=False)
    change_type = db.Column(db.String(20), nullable=False)  # restock, sales, loss, return, check
    quantity_change = db.Column(db.Integer, nullable=False)
    stock_before = db.Column(db.Integer, nullable=False)
    stock_after = db.Column(db.Integer, nullable=False)
    cost = db.Column(db.Float, nullable=True)  # 变动成本
    operator_id = db.Column(db.Integer, db.ForeignKey('users.id'), nullable=True)
    note = db.Column(db.Text, nullable=True)
    created_at = db.Column(db.DateTime, default=datetime.utcnow)
    
    # 关系
    dish = db.relationship('Dish', backref='stock_logs')
    restaurant = db.relationship('Restaurant', backref='stock_logs')
    operator = db.relationship('User', backref='stock_operations')
    
    def to_dict(self):
        return {
            'id': self.id,
            'dish_id': self.dish_id,
            'dish_name': self.dish.name if self.dish else None,
            'restaurant_id': self.restaurant_id,
            'change_type': self.change_type,
            'quantity_change': self.quantity_change,
            'stock_before': self.stock_before,
            'stock_after': self.stock_after,
            'cost': self.cost,
            'operator_id': self.operator_id if self.operator else None,
            'note': self.note,
            'created_at': self.created_at.replace(tzinfo=timezone.utc).isoformat() if self.created_at else None
        }


class DishOffShelfLog(db.Model):
    """菜品下架记录（用于追溯最近一次下架原因）"""
    __tablename__ = 'dish_off_shelf_logs'

    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    restaurant_id = db.Column(db.Integer, db.ForeignKey('restaurants.id'), nullable=False)
    dish_id = db.Column(db.Integer, db.ForeignKey('dishes.dish_id'), nullable=False)
    reason = db.Column(db.String(100), nullable=False, comment='下架原因')
    operator_id = db.Column(db.Integer, db.ForeignKey('users.id'), nullable=True)
    created_at = db.Column(db.DateTime, default=datetime.utcnow, nullable=False)

    restaurant = db.relationship('Restaurant', backref=db.backref('dish_off_shelf_logs', lazy=True))
    dish = db.relationship('Dish', backref=db.backref('off_shelf_logs', lazy=True))
    operator = db.relationship('User', backref=db.backref('dish_off_shelf_operations', lazy=True))

    def to_dict(self):
        return {
            'id': self.id,
            'restaurant_id': self.restaurant_id,
            'dish_id': self.dish_id,
            'dish_name': self.dish.name if self.dish else None,
            'reason': self.reason,
            'operator_id': self.operator.id if self.operator else None,
            'operator_name': self.operator.username if self.operator else None,
            'created_at': self.created_at.replace(tzinfo=timezone.utc).isoformat() if self.created_at else None,
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