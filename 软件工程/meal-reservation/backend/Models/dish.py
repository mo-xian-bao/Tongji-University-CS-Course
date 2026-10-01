"""Dish and stock related models."""
from datetime import datetime, timezone


from app_init import db


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
        if self.stock_quantity == 0:
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
