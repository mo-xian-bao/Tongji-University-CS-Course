"""Order and table related models."""
from datetime import datetime, timezone
import random

from app_init import db


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
