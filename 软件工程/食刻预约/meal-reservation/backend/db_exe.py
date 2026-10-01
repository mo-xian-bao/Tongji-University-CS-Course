"""
数据库更改脚本
"""


from datetime import datetime, timedelta
from typing import Optional, Tuple, Dict, Any
import random

from auxiliary_function import validate_phone, validate_username, validate_password


from flask import current_app


from Models import db,User,Restaurant,UserInfo,Table,Order,OrderItem, MerchantBroadcast,Dish, DishLaunchNotification,MerchantApplication,UserBan,UserAppeal,AppealAttachment
from Models import RestaurantFollow, CouponNotification, CouponUsage

from sms_service import sms_service

def check_table_exists(table_name):
    inspector = db.inspect(db.engine)
    return inspector.has_table(table_name)

def init_database():
    """初始化数据库"""

    # 创建所有表
    existing_tables = db.inspect(db.engine).get_table_names()

    # 检查是否需要创建表
    tables = ['users', 'sms_verifications', 'restaurants', 'restaurant_follows',
              'dishes', 'merchant_applications', 'orders', 
              'order_items', 'user_info','user_bans', 'user_appeals', 
              'appeal_attachments', 'order_change_requests', 
              'reviews', 'review_keywords', 'messages', 'stock_logs','review_likes',
              'merchant_broadcasts','dish_launch_notifications',
                'coupon_notifications','coupon_usages','tables',]
    for table in tables:
        if table not in existing_tables:
            db.create_all()
            print("数据库表创建成功！")
            break
    else:
        print("已存在对应表")

    # 检查是否已有管理员用户
    admin_user = User.query.filter_by(phone='13800138000').first()
    if not admin_user:
        # 创建测试用户
        admin = User(
            phone='13800138000',
            username='admin',
            usertype=0
        )
        support = User(
            phone = '13800138001',
            username = 'customer-service',
            usertype = 100
        )
        merchant=User(
            phone='13600343895',
            username='merchant',
            usertype=1
        )
        Users=User(
            phone='19788953946',
            username='user1',
            usertype=2
        )
        admin.set_password('123456')
        merchant.set_password('123456')
        Users.set_password('123456')

        db.session.add(admin)
        db.session.add(merchant)
        db.session.add(Users)
        
        db.session.commit()

        print("测试用户创建成功！")
        print("手机号: 13800138000")
        print("用户名: admin")
        print("密码: 123456")
        print("手机号: 13600343895")
        print("用户名: merchant")
        print("密码: 123456")
        print("手机号: 19788953946")
        print("用户名: user1")
        print("密码: 123456")
        admin_user = admin
        merchant_user = merchant
        Users_user = Users
    else:
        print("测试用户已存在，跳过创建")
        # 为已存在的用户变量赋值
        admin_user = admin_user
        merchant_user = User.query.filter_by(phone='13600343895').first()
        Users_user = User.query.filter_by(phone='19788953946').first()

    support_user = User.query.filter_by(phone='13800138005').first()
    if not support_user:
        # 创建测试用户
        support = User(
            phone = '13800138005',
            username = 'customer-service',
            usertype = 100
        )

        support.set_password('123456')

        db.session.add(support)
        
        db.session.commit()

        print("测试用户创建成功！")
        print("手机号: 13800138005")
        print("用户名: customer-service")

    # 检查并创建用户扩展信息
    if not admin_user.user_info:
        admin_info = UserInfo(user_id=admin_user.id)
        merchant_info = UserInfo(user_id=merchant_user.id)
        Users_info = UserInfo(user_id=Users_user.id)
        db.session.add(admin_info)
        db.session.add(merchant_info)
        db.session.add(Users_info)
        db.session.commit()

    # 添加示例广播数据
    # if admin_user and not MerchantBroadcast.query.filter_by(merchant_id=admin_user.id).first():
    #     sample_broadcast = MerchantBroadcast(
    #         merchant_id=admin_user.id,
    #         title='本周健康轻食限时优惠',
    #         content='本周购买轻食套餐可享受 8 折优惠，还可获赠营养师一对一咨询券。',
    #         start_time=datetime.utcnow(),
    #         end_time=datetime.utcnow(),
    #         is_active=True
    #     )
    #     db.session.add(sample_broadcast)
    #     db.session.commit()
    #     print("示例广播已创建，供前端联调使用。")

    # 为商人用户创建默认餐厅
    if merchant_user:
        merchant_restaurant = Restaurant.query.filter_by(user_id=merchant_user.id).first()
        if not merchant_restaurant:
            default_restaurant = Restaurant(
                name='默认餐厅',
                address='北京市朝阳区某某街道123号',
                phone='13600343895',  # 使用商人用户的手机号
                opening_hours='09:00-21:00',
                notice='欢迎光临，请提前10分钟下单',
                user_id=merchant_user.id  # 修复：使用商人用户的ID
            )

            db.session.add(default_restaurant)
            db.session.commit()

            print("商人用户默认餐厅创建成功！")
        else:
            print("商人用户餐厅已存在")
    else:
        print("商人用户不存在，无法创建餐厅")
    
    # 生成测试数据
    # generate_test_data()


def generate_test_data():
    """生成测试数据：3个用户，15个商家及餐厅，每个餐厅15个菜品，每个用户对每个餐厅至少3个订单"""
    print("\n开始生成测试数据...")
    
    # 检查是否已经生成过测试数据
    existing_test_users = User.query.filter(User.phone.like('188%')).count()
    if existing_test_users >= 3:
        print("测试数据已存在，跳过生成")
        return
    
    # 1. 创建3个测试用户（usertype=2，普通用户）
    test_users = []
    for i in range(3):
        phone = f'188{str(i).zfill(8)}'
        username = f'测试用户{i+1}'
        
        existing_user = User.query.filter_by(phone=phone).first()
        if not existing_user:
            user = User(
                phone=phone,
                username=username,
                usertype=2
            )
            user.set_password('123456')
            db.session.add(user)
            test_users.append(user)
            print(f"创建测试用户: {username} ({phone})")
        else:
            test_users.append(existing_user)
    
    db.session.commit()
    
    # 为测试用户创建扩展信息
    for user in test_users:
        if not user.user_info:
            user_info = UserInfo(user_id=user.id)
            db.session.add(user_info)
    db.session.commit()
    
    # 2. 创建15个商家用户和餐厅（usertype=1）
    merchants = []
    restaurants = []
    
    restaurant_names = [
        '川香小厨', '粤味轩', '湘菜馆', '东北饺子王', '江南小笼',
        '西北面馆', '火锅天下', '烧烤一条街', '海鲜大排档', '素食斋',
        '甜品屋', '快餐便当', '咖啡厅', '茶餐厅', '日料店'
    ]
    
    for i in range(15):
        phone = f'139{str(i).zfill(8)}'
        username = f'商家{i+1}'
        
        existing_merchant = User.query.filter_by(phone=phone).first()
        if not existing_merchant:
            merchant = User(
                phone=phone,
                username=username,
                usertype=1
            )
            merchant.set_password('123456')
            db.session.add(merchant)
            merchants.append(merchant)
            print(f"创建商家用户: {username} ({phone})")
        else:
            merchants.append(existing_merchant)
    
    db.session.commit()
    
    # 为商家创建扩展信息
    for merchant in merchants:
        if not merchant.user_info:
            merchant_info = UserInfo(user_id=merchant.id)
            db.session.add(merchant_info)
    db.session.commit()
    
    # 为每个商家创建餐厅
    for idx, merchant in enumerate(merchants):
        existing_restaurant = Restaurant.query.filter_by(user_id=merchant.id).first()
        if not existing_restaurant:
            restaurant = Restaurant(
                name=restaurant_names[idx],
                address=f'北京市朝阳区{restaurant_names[idx]}街{idx+1}号',
                phone=merchant.phone,
                opening_hours='09:00-21:00',
                notice=f'欢迎光临{restaurant_names[idx]}！',
                user_id=merchant.id
            )
            db.session.add(restaurant)
            restaurants.append(restaurant)
            print(f"创建餐厅: {restaurant_names[idx]}")
        else:
            restaurants.append(existing_restaurant)
    
    db.session.commit()
    
    # 3. 为每个餐厅创建15个菜品
    dish_templates = [
        {'name': '招牌菜', 'category': '热菜', 'price_range': (38, 88)},
        {'name': '特色炒饭', 'category': '主食', 'price_range': (18, 35)},
        {'name': '精品面条', 'category': '主食', 'price_range': (20, 40)},
        {'name': '凉拌菜', 'category': '凉菜', 'price_range': (15, 30)},
        {'name': '汤品', 'category': '汤', 'price_range': (25, 50)},
        {'name': '海鲜菜', 'category': '热菜', 'price_range': (68, 128)},
        {'name': '肉类菜', 'category': '热菜', 'price_range': (35, 75)},
        {'name': '素菜', 'category': '热菜', 'price_range': (18, 38)},
        {'name': '甜品', 'category': '甜品', 'price_range': (12, 25)},
        {'name': '饮料', 'category': '饮品', 'price_range': (8, 20)},
        {'name': '小吃', 'category': '小吃', 'price_range': (10, 25)},
        {'name': '套餐A', 'category': '套餐', 'price_range': (48, 88)},
        {'name': '套餐B', 'category': '套餐', 'price_range': (58, 98)},
        {'name': '早餐', 'category': '早餐', 'price_range': (8, 20)},
        {'name': '夜宵', 'category': '夜宵', 'price_range': (25, 60)}
    ]
    
    all_dishes = []
    for restaurant in restaurants:
        existing_dishes = Dish.query.filter_by(restaurant_id=restaurant.id).count()
        if existing_dishes < 15:
            for idx, template in enumerate(dish_templates):
                dish_name = f"{restaurant.name}{template['name']}{idx+1}"
                price = random.uniform(*template['price_range'])
                
                # 随机决定是否有折扣 (40%概率)
                discount_enabled = random.random() < 0.4
                discount_method = random.choice(['price', 'percentage']) if discount_enabled else 'price'
                discount_price = None
                discount_percentage = None
                
                if discount_enabled:
                    if discount_method == 'price':
                        discount_price = round(price * random.uniform(0.6, 0.9), 2)
                    else:
                        discount_percentage = round(random.uniform(0.7, 0.95), 2)
                
                dish = Dish(
                    restaurant_id=restaurant.id,
                    name=dish_name,
                    description=f'{dish_name}，精心烹制，美味可口',
                    price=round(price, 2),
                    original_price=round(price * 1.2, 2) if discount_enabled else None,
                    category=template['category'],
                    status='available',
                    is_spicy_selectable=template['category'] in ['热菜', '主食'],
                    is_garnish_selectable=template['category'] in ['热菜', '主食', '汤'],
                    stock_quantity=random.randint(50, 200),
                    stock_capacity=200,
                    stock_alert_enabled=True,
                    stock_alert_threshold=20,
                    monthly_sales=random.randint(10, 500),
                    discount_enabled=discount_enabled,
                    discount_method=discount_method,
                    discount_price=discount_price,
                    discount_percentage=discount_percentage,
                )
                db.session.add(dish)
                all_dishes.append(dish)
            
            print(f"为餐厅 {restaurant.name} 创建了15个菜品")
    
    db.session.commit()
    
    # 4. 为每个餐厅创建8个桌位（增加桌子数量以支持更多订单）
    for restaurant in restaurants:
        existing_tables = Table.query.filter_by(restaurant_id=restaurant.id).count()
        if existing_tables < 8:
            for i in range(8):
                table = Table(
                    restaurant_id=restaurant.id,
                    table_number=f'T{i+1}',
                    capacity=random.choice([4, 6, 8]),  # 所有桌子最小容量为4人，大于订单最大人数
                    table_type='shared' if i < 3 else 'private',  # 前3个为共享桌位，后5个为包间
                    status='available'
                )
                db.session.add(table)
            print(f"为餐厅 {restaurant.name} 创建了8个桌位")
    
    db.session.commit()
    
    # 5. 为每个用户对每个餐厅创建3-5个订单
    order_statuses = ['completed', 'confirmed', 'pending', 'cancelled', 'rejected', 'dining']
    status_weights = [0.5, 0.2, 0.15, 0.1, 0.03, 0.02]  # 调整权重，减少dining状态订单避免桌子冲突
    
    total_orders = 0
    order_counter = 0  # 添加计数器确保订单号唯一

    # 用于跟踪每个餐厅的桌子占用情况
    restaurant_table_status = {restaurant.id: set() for restaurant in restaurants}

    for user in test_users:
        for restaurant in restaurants:
            num_orders = random.randint(3, 5)
            restaurant_dishes = Dish.query.filter_by(restaurant_id=restaurant.id).all()
            restaurant_tables = Table.query.filter_by(restaurant_id=restaurant.id).all()

            for _ in range(num_orders):
                # 随机选择订单状态
                status = random.choices(order_statuses, weights=status_weights)[0]

                # 生成唯一订单号（添加计数器）
                order_counter += 1
                timestamp = datetime.utcnow().strftime('%Y%m%d%H%M%S')
                random_num = random.randint(1000, 9999)
                order_number = f"ORD{timestamp}{random_num}{str(order_counter).zfill(4)}"

                # 桌子分配逻辑
                selected_table_id = None
                if status in ['dining', 'confirmed']:  # 只有dining和confirmed状态需要占用桌子
                    # 找到可用的桌子
                    available_tables = [t for t in restaurant_tables if t.id not in restaurant_table_status[restaurant.id]]
                    if available_tables:
                        selected_table = random.choice(available_tables)
                        selected_table_id = selected_table.id
                        restaurant_table_status[restaurant.id].add(selected_table_id)  # 标记桌子为占用状态
                    else:
                        # 如果没有可用桌子，将状态改为pending或completed
                        status = random.choice(['pending', 'completed'])
                elif restaurant_tables:
                    # 其他状态随机分配桌子（不占用）
                    selected_table_id = random.choice(restaurant_tables).id

                # 创建订单
                order = Order(
                    order_number=order_number,
                    user_id=user.id,
                    restaurant_id=restaurant.id,
                    table_id=selected_table_id,
                    customer_count=random.randint(1, 4),
                    order_type='dine_in',
                    status=status,
                    note=random.choice(['', '少盐', '不要辣', '多加醋', '']),
                    pickup_number=Order.generate_pickup_number(restaurant.id) if status in ['confirmed', 'dining'] else None,
                    order_time=datetime.utcnow() - timedelta(days=random.randint(1, 60)),
                )
                
                # 根据状态设置时间戳
                if status in ['confirmed', 'dining', 'completed']:
                    order.confirmed_time = order.order_time + timedelta(minutes=random.randint(2, 10))
                if status == 'completed':
                    order.completed_time = order.confirmed_time + timedelta(minutes=random.randint(20, 60))
                if status == 'cancelled':
                    order.cancelled_time = order.order_time + timedelta(minutes=random.randint(1, 5))
                if status == 'rejected':
                    order.reject_reason = '菜品已售罄'
                
                db.session.add(order)
                db.session.flush()  # 获取order.id
                
                # 为订单添加2-4个菜品
                num_dishes = random.randint(2, 4)
                selected_dishes = random.sample(restaurant_dishes, min(num_dishes, len(restaurant_dishes)))
                total_price = 0
                
                for dish in selected_dishes:
                    quantity = random.randint(1, 3)
                    
                    # 计算单价（考虑折扣）
                    unit_price = float(dish.price)
                    if dish.discount_enabled:
                        if dish.discount_method == 'price' and dish.discount_price:
                            unit_price = float(dish.discount_price)
                        elif dish.discount_method == 'percentage' and dish.discount_percentage:
                            unit_price = float(dish.price) * float(dish.discount_percentage)
                    
                    subtotal = unit_price * quantity
                    total_price += subtotal
                    
                    order_item = OrderItem(
                        order_id=order.id,
                        dish_id=dish.dish_id,
                        quantity=quantity,
                        unit_price=unit_price,
                        subtotal=subtotal,
                        spiciness=random.choice(['不辣', '微辣', '中辣', '特辣']) if dish.is_spicy_selectable else None,
                        garnish=random.choice(['都要', '不要葱花', '不要香菜', '都不要']) if dish.is_garnish_selectable else None
                    )
                    db.session.add(order_item)
                
                order.total_price = round(total_price, 2)
                total_orders += 1
    
    db.session.commit()
    
    # 6. 为每个餐厅创建优惠券测试数据
    coupon_templates = [
        {'title': '新用户专享优惠', 'discount_type': 'amount', 'amount': 10, 'min_spend': 50},
        {'title': '满减优惠', 'discount_type': 'amount', 'amount': 20, 'min_spend': 100},
        {'title': '周末特惠', 'discount_type': 'percentage', 'amount': 0.8, 'min_spend': 80},
        {'title': '生日折扣', 'discount_type': 'percentage', 'amount': 0.7, 'min_spend': 60},
        {'title': '套餐优惠', 'discount_type': 'amount', 'amount': 15, 'min_spend': 120},
        {'title': '会员专享', 'discount_type': 'percentage', 'amount': 0.85, 'min_spend': 90},
        {'title': '午市特惠', 'discount_type': 'amount', 'amount': 8, 'min_spend': 40},
        {'title': '晚市折扣', 'discount_type': 'percentage', 'amount': 0.9, 'min_spend': 70}
    ]

    all_coupons = []
    for restaurant in restaurants:
        existing_coupons = CouponNotification.query.filter_by(restaurant_id=restaurant.id).count()
        if existing_coupons < 5:  # 每个餐厅创建5个优惠券
            selected_templates = random.sample(coupon_templates, min(5, len(coupon_templates)))

            for template in selected_templates:
                # 随机生成有效期
                valid_from = datetime.utcnow() + timedelta(days=random.randint(-7, 7))
                valid_to = valid_from + timedelta(days=random.randint(15, 60))

                coupon = CouponNotification(
                    restaurant_id=restaurant.id,
                    title=f"{restaurant.name} - {template['title']}",
                    description=f"系统测试优惠券",
                    discount_type=template['discount_type'],
                    amount=template['amount'],
                    min_spend=template['min_spend'],
                    valid_from=valid_from,
                    valid_to=valid_to,
                    total_quantity=random.randint(50, 200),
                    is_active=True,
                    extra_data={'is_system_recommended': True}  # 标记为系统智能推荐
                )
                db.session.add(coupon)
                all_coupons.append(coupon)

            print(f"为餐厅 {restaurant.name} 创建了5个优惠券")

    db.session.commit()

    # 7. 创建少量关注关系用于测试（但推荐不依赖关注关系）
    follow_relationships = 0
    for user in test_users[:2]:  # 只为前2个用户创建少量关注关系
        num_follows = random.randint(1, 2)
        selected_restaurants = random.sample(restaurants, min(num_follows, len(restaurants)))

        for restaurant in selected_restaurants:
            existing_follow = RestaurantFollow.query.filter_by(
                user_id=user.id,
                restaurant_id=restaurant.id
            ).first()

            if not existing_follow:
                follow = RestaurantFollow(user_id=user.id, restaurant_id=restaurant.id)
                db.session.add(follow)
                follow_relationships += 1

    db.session.commit()

    print(f"\n测试数据生成完成！")
    print(f"- 创建了 {len(test_users)} 个测试用户")
    print(f"- 创建了 {len(merchants)} 个商家用户")
    print(f"- 创建了 {len(restaurants)} 个餐厅")
    print(f"- 创建了 {len(all_dishes)} 个菜品")
    print(f"- 创建了 {total_orders} 个订单")
    print(f"- 创建了 {len(all_coupons)} 个优惠券")
    print(f"- 创建了 {follow_relationships} 个关注关系（用于测试）")
    print(f"\n所有测试账号密码均为: 123456")


def add_user(phone, username, password, confirm_password, sms_code=None):
    """
    添加用户

    Args:
        phone (str): 手机号
        username (str): 用户名
        password (str): 密码
        confirm_password (str): 确认密码
        sms_code (str, optional): 短信验证码
        usertype (int): 用户种类

    Returns:
        tuple: (result_dict, status_code)
    """
    # 验证手机号格式
    if not validate_phone(phone):
        return {
            'success': False,
            'message': '请输入正确的手机号格式'
        }, 400

    # 验证短信验证码
    if not sms_code:
        return {
            'success': False,
            'message': '请输入短信验证码'
        }, 400

    # 验证短信验证码有效性
    sms_result = sms_service.verify_code(phone, sms_code, 'register')
    if not sms_result['success']:
        return {
            'success': False,
            'message': sms_result['message']
        }, 400

    # 验证用户名
    if not validate_username(username):
        return {
            'success': False,
            'message': '用户名长度应在2-50个字符之间'
        }, 400

    # 验证密码
    if not validate_password(password):
        return {
            'success': False,
            'message': '密码至少需要6个字符'
        }, 400

    # 验证确认密码
    if password != confirm_password:
        return {
            'success': False,
            'message': '两次输入的密码不一致'
        }, 400

    # 检查手机号是否已存在
    if User.query.filter_by(phone=phone).first():
        return {
            'success': False,
            'message': '该手机号已被注册'
        }, 409

    # 检查用户名是否已存在
    if User.query.filter_by(username=username).first():
        return {
            'success': False,
            'message': '该用户名已被使用'
        }, 409

    # 创建新用户
    user = User(phone=phone, username=username,usertype=2)
    user.set_password(password)

    try:
        db.session.add(user)
        db.session.flush()  # 获取新用户的 ID
        
        # 创建对应的用户扩展信息
        user_info = UserInfo(user_id=user.id)
        db.session.add(user_info)
        
        db.session.commit()

        return {
            'success': True,
            'message': '注册成功',
            'data': {
                'user': user.to_dict()
            }
        }, 201

    except Exception as e:
        db.session.rollback()
        print(f"注册失败: {str(e)}")
        return {
            'success': False,
            'message': f'注册失败: {str(e)}'
        }, 500

def identify_user(identifier, password, sms_code=None, login_type='password'):
        """
        用户登录

        Args:
            identifier (str): 手机号或用户名
            password (str): 密码（密码登录时需要）
            sms_code (str): 短信验证码（短信登录时需要）
            login_type (str): 登录类型 'password' 或 'sms'
        """
        # 查找用户（支持手机号或用户名登录）
        user = None
        if validate_phone(identifier):
            # 手机号登录
            user = User.query.filter_by(phone=identifier).first()
        else:
            # 用户名登录（仅支持密码登录）
            if login_type == 'sms':
                return {
                    'success': False,
                    'message': '短信登录只支持手机号'
                }, 400
            user = User.query.filter_by(username=identifier).first()

        # 验证用户是否存在
        if not user:
            return {
                'success': False,
                'message': '用户不存在'
            }, 401

        # 根据登录类型进行验证
        if login_type == 'password':
            # 密码登录验证
            if not password:
                return {
                    'success': False,
                    'message': '请输入密码'
                }, 400

            if not user.check_password(password):
                return {
                    'success': False,
                    'message': '密码错误'
                }, 401

        elif login_type == 'sms':
            # 短信验证码登录验证
            if not sms_code:
                return {
                    'success': False,
                    'message': '请输入短信验证码'
                }, 400

            # 验证短信验证码
            sms_result = sms_service.verify_code(user.phone, sms_code, 'login')
            if not sms_result['success']:
                return {
                    'success': False,
                    'message': sms_result['message']
                }, 400

        else:
            return {
                'success': False,
                'message': '不支持的登录类型'
            }, 400

        # 检查用户封禁状态
        effective_status = user.get_effective_status()
        if effective_status != 'normal':
            # 获取封禁信息
            active_ban = UserBan.query.filter_by(user_id=user.id).filter(
                UserBan.status.in_(['banned', 'temporarily_banned'])
            ).order_by(UserBan.created_at.desc()).first()

            ban_info = active_ban.to_dict() if active_ban else None

            return {
                'success': False,
                'message': f'账号已被封禁，原因：{ban_info.get("ban_reason_text", "未知原因")}',
                'data': {
                    'ban_info': ban_info,
                    'can_appeal': True
                }
            }, 423  # 423 Locked 表示资源被锁定

        # 更新最后登录时间
        user.updated_at = datetime.utcnow()
        db.session.commit()

        # 登录成功，返回用户信息（JWT 由应用入口统一生成以避免循环导入）
        return {
            'success': True,
            'message': '登录成功',
            'data': {
                'user': user.to_dict(),
                'login_type': login_type
            }
        }, 200


def _parse_datetime(value: Optional[str]) -> Optional[datetime]:
    if not value:
        return None
    try:
        candidate = value.strip()
        if candidate.endswith('Z'):
            candidate = candidate[:-1] + '+00:00'
        return datetime.fromisoformat(candidate)
    except ValueError:
        raise ValueError('时间格式必须为 ISO8601，例如 2024-01-01T08:00:00')


def create_broadcast(
        restaurant_id: int,
        title: str,
        content: str,
        start_time: Optional[str] = None,
        end_time: Optional[str] = None,
        is_active: bool = True
) -> Tuple[Dict[str, Any], int]:
    if not restaurant_id:
        return {'success': False, 'message': '缺少餐厅 ID'}, 400

    restaurant = Restaurant.query.get(restaurant_id)
    if not restaurant:
        return {'success': False, 'message': '指定的餐厅不存在'}, 404

    title = (title or '').strip()
    content = (content or '').strip()
    if not title:
        return {'success': False, 'message': '广播标题不能为空'}, 400
    if len(title) > 100:
        return {'success': False, 'message': '标题长度不能超过 100 字符'}, 400
    if not content:
        return {'success': False, 'message': '广播内容不能为空'}, 400

    try:
        start_dt = _parse_datetime(start_time)
        end_dt = _parse_datetime(end_time)
    except ValueError as exc:
        return {'success': False, 'message': str(exc)}, 400

    if start_dt and end_dt and start_dt > end_dt:
        return {'success': False, 'message': '开始时间不能晚于结束时间'}, 400

    broadcast = MerchantBroadcast(
        restaurant_id=restaurant_id,
        title=title,
        content=content,
        start_time=start_dt,
        end_time=end_dt,
        is_active=is_active
    )
    db.session.add(broadcast)
    db.session.commit()

    return {
        'success': True,
        'message': '广播发布成功',
        'data': broadcast.to_dict()
    }, 201


def _format_price(value):
    if value is None:
        return None
    try:
        return float(value)
    except (TypeError, ValueError):
        return None


def create_dish_launch_notification(dish: Dish, auto_commit: bool = True) -> Optional[DishLaunchNotification]:
    """为新菜品生成自动上新通知及对应广播"""
    if not dish:
        return None

    restaurant = Restaurant.query.get(dish.restaurant_id)
    if not restaurant:
        return None

    try:
        snapshot = {
            'dish_id': dish.dish_id,
            'name': dish.name,
            'description': dish.description,
            'price': _format_price(dish.price),
            'category': dish.category,
            'status': dish.status,
            'image_url': dish.image_url,
            'stock_quantity': dish.stock_quantity,

        }

        message_lines = [f"{restaurant.name} 刚刚上新「{dish.name}」！"]

        if snapshot['price'] is not None:
            message_lines.append(f"价格：¥{snapshot['price']:.2f}")
        if dish.category:
            message_lines.append(f"分类：{dish.category}")
        if dish.stock_quantity is not None:
            message_lines.append(f"限量 {dish.stock_quantity}")
        if dish.description:
            message_lines.append(dish.description.strip())

        message_lines.append('欢迎到店或在线下单品尝。')
        message_body = '\n'.join(filter(None, message_lines))

        notification = DishLaunchNotification(
            dish_id=dish.dish_id,
            restaurant_id=dish.restaurant_id,
            title=f"新品上架：{dish.name}",
            message=message_body,
            audience='followers',
            dish_snapshot=snapshot,
            is_active=True
        )
        db.session.add(notification)
        db.session.flush()

        broadcast = MerchantBroadcast(
            restaurant_id=dish.restaurant_id,
            title=notification.title,
            content=f"【发送对象：关注店铺的用户】\n{message_body}",
            start_time=datetime.utcnow(),
            is_active=True
        )
        db.session.add(broadcast)
        db.session.flush()

        notification.broadcast_id = broadcast.id

        if auto_commit:
            db.session.commit()

        return notification

    except Exception as exc:
        db.session.rollback()
        if current_app:
            current_app.logger.error('自动生成菜品上新通知失败: %s', exc, exc_info=True)
        else:
            print(f"自动生成菜品上新通知失败: {exc}")
        raise


def list_dish_launch_notifications(
        restaurant_id: Optional[int] = None,
        include_inactive: bool = False,
        page: int = 1,
        per_page: int = 20
) -> Tuple[Dict[str, Any], int]:
    page = max(int(page or 1), 1)
    per_page = min(max(int(per_page or 20), 1), 100)

    query = DishLaunchNotification.query.order_by(DishLaunchNotification.created_at.desc())
    if restaurant_id:
        query = query.filter_by(restaurant_id=restaurant_id)
    if not include_inactive:
        query = query.filter(DishLaunchNotification.is_active == True)

    pagination = query.paginate(page=page, per_page=per_page, error_out=False)
    records = [item.to_dict() for item in pagination.items]

    return {
        'success': True,
        'data': {
            'records': records,
            'pagination': {
                'page': pagination.page,
                'per_page': pagination.per_page,
                'total_pages': pagination.pages,
                'total_items': pagination.total
            }
        }
    }, 200


def get_dish_launch_notification(notification_id: int) -> Tuple[Dict[str, Any], int]:
    notification = DishLaunchNotification.query.get(notification_id)
    if not notification:
        return {'success': False, 'message': '通知不存在'}, 404

    return {
        'success': True,
        'data': notification.to_dict()
    }, 200


def _format_datetime(value):
    if not value:
        return None
    if isinstance(value, datetime):
        return value
    try:
        return datetime.fromisoformat(str(value).replace('Z', '+00:00'))
    except Exception:
        return None


def create_coupon_notification(
        restaurant_id: int,
        title: str,
        description: Optional[str] = None,
        discount_type: str = 'amount',
        amount: Optional[Any] = None,
        min_spend: Optional[Any] = None,
        valid_from: Optional[Any] = None,
        valid_to: Optional[Any] = None,
        total_quantity: Optional[int] = None,
        extra_data: Optional[Dict[str, Any]] = None,
        auto_commit: bool = True
) -> Tuple[Dict[str, Any], int]:
    restaurant = Restaurant.query.get(restaurant_id)
    if not restaurant:
        return {'success': False, 'message': '餐厅不存在'}, 404

    title = (title or '').strip()
    if not title:
        return {'success': False, 'message': '优惠券标题不能为空'}, 400

    discount_type = (discount_type or 'amount').strip().lower()
    if discount_type not in {'amount', 'percentage', 'gift'}:
        return {'success': False, 'message': '不支持的优惠券类型'}, 400

    amount_value = _format_price(amount)
    original_amount = amount
    min_spend_value = _format_price(min_spend)

    valid_from_dt = _format_datetime(valid_from)
    valid_to_dt = _format_datetime(valid_to)
    if valid_from_dt and valid_to_dt and valid_from_dt > valid_to_dt:
        return {'success': False, 'message': '有效期开始时间不能晚于结束时间'}, 400

    if total_quantity is not None:
        try:
            total_quantity = int(total_quantity)
        except (TypeError, ValueError):
            return {'success': False, 'message': '优惠券数量必须为整数'}, 400
        if total_quantity < 0:
            return {'success': False, 'message': '优惠券数量不能为负数'}, 400

    try:
        payload_extra = dict(extra_data or {})
        if discount_type == 'gift' and original_amount is not None:
            payload_extra.setdefault('gift_value', original_amount)

        coupon = CouponNotification(
            restaurant_id=restaurant_id,
            title=title,
            description=(description or '').strip() or None,
            discount_type=discount_type,
            amount=amount_value,
            min_spend=min_spend_value,
            valid_from=valid_from_dt,
            valid_to=valid_to_dt,
            total_quantity=total_quantity,
            extra_data=payload_extra
        )
        db.session.add(coupon)
        db.session.flush()

        message_lines = [f"{restaurant.name} 发布了新的优惠券「{title}」！"]
        if discount_type == 'amount' and amount_value is not None:
            message_lines.append(f"优惠金额：¥{amount_value:.2f}")
        elif discount_type == 'percentage' and amount_value is not None:
            message_lines.append(f"折扣力度：{amount_value:.0f}%")
        elif discount_type == 'gift' and original_amount:
            message_lines.append(f"优惠内容：{original_amount}")

        if min_spend_value is not None:
            message_lines.append(f"满 ¥{min_spend_value:.2f} 可用")
        if valid_from_dt and valid_to_dt:
            message_lines.append(f"有效期：{valid_from_dt.strftime('%Y-%m-%d')} - {valid_to_dt.strftime('%Y-%m-%d')}")
        elif valid_to_dt:
            message_lines.append(f"有效期至：{valid_to_dt.strftime('%Y-%m-%d')}")

        if coupon.description:
            message_lines.append(coupon.description)

        message_lines.append('仅限关注本店的用户使用，欢迎尽快领取。')
        message_body = '\n'.join(filter(None, message_lines))

        broadcast = MerchantBroadcast(
            restaurant_id=restaurant_id,
            title=f"优惠券：{title}",
            content=f"【发送对象：关注店铺的用户】\n{message_body}",
            start_time=datetime.utcnow(),
            is_active=True
        )
        db.session.add(broadcast)
        db.session.flush()

        coupon.broadcast_id = broadcast.id

        if auto_commit:
            db.session.commit()

        return {'success': True, 'data': coupon.to_dict(), 'message': '优惠券推送成功'}, 201

    except Exception as exc:
        db.session.rollback()
        if current_app:
            current_app.logger.error('创建优惠券推送失败: %s', exc, exc_info=True)
        else:
            print(f"创建优惠券推送失败: {exc}")
        raise


def list_coupon_notifications(
        restaurant_id: Optional[int] = None,
        include_inactive: bool = False,
        page: int = 1,
        per_page: int = 20,
        follower_user_id: Optional[int] = None,
        exclude_used_by_user_id: Optional[int] = None
) -> Tuple[Dict[str, Any], int]:
    page = max(int(page or 1), 1)
    per_page = min(max(int(per_page or 20), 1), 100)

    query = CouponNotification.query.order_by(CouponNotification.created_at.desc())

    if restaurant_id:
        query = query.filter(CouponNotification.restaurant_id == restaurant_id)
    elif follower_user_id:
        query = query.join(
            RestaurantFollow,
            (RestaurantFollow.restaurant_id == CouponNotification.restaurant_id)
        ).filter(RestaurantFollow.user_id == follower_user_id)

    if not include_inactive:
        query = query.filter(CouponNotification.is_active.is_(True))

    # 排除指定用户已使用的优惠券
    if exclude_used_by_user_id:
        used_coupon_ids_subquery = db.session.query(CouponUsage.coupon_id).filter(
            CouponUsage.user_id == exclude_used_by_user_id
        ).subquery()
        query = query.filter(~CouponNotification.id.in_(used_coupon_ids_subquery))

    pagination = query.paginate(page=page, per_page=per_page, error_out=False)
    records = [item.to_dict() for item in pagination.items]

    return {
        'success': True,
        'data': {
            'records': records,
            'pagination': {
                'page': pagination.page,
                'per_page': pagination.per_page,
                'total_pages': pagination.pages,
                'total_items': pagination.total
            }
        }
    }, 200


def get_coupon_notification(notification_id: int) -> Tuple[Dict[str, Any], int]:
    notification = CouponNotification.query.get(notification_id)
    if not notification:
        return {'success': False, 'message': '优惠券通知不存在'}, 404

    return {'success': True, 'data': notification.to_dict()}, 200


def _follow_payload(follow: RestaurantFollow, include_restaurant: bool = True) -> Dict[str, Any]:
    data = follow.to_dict(include_restaurant=include_restaurant)
    data['is_following'] = True
    return data


def follow_restaurant(user_id: int, restaurant_id: int) -> Tuple[Dict[str, Any], int]:
    if not user_id:
        return {'success': False, 'message': '用户未登录'}, 401

    restaurant = Restaurant.query.get(restaurant_id)
    if not restaurant:
        return {'success': False, 'message': '商铺不存在'}, 404

    existing = RestaurantFollow.query.filter_by(user_id=user_id, restaurant_id=restaurant_id).first()
    if existing:
        return {
            'success': True,
            'message': '已关注该商铺',
            'data': _follow_payload(existing)
        }, 200

    follow = RestaurantFollow(user_id=user_id, restaurant_id=restaurant_id)
    db.session.add(follow)
    db.session.commit()

    return {
        'success': True,
        'message': '关注成功',
        'data': _follow_payload(follow)
    }, 201


def unfollow_restaurant(user_id: int, restaurant_id: int) -> Tuple[Dict[str, Any], int]:
    if not user_id:
        return {'success': False, 'message': '用户未登录'}, 401

    follow = RestaurantFollow.query.filter_by(user_id=user_id, restaurant_id=restaurant_id).first()
    if not follow:
        return {
            'success': True,
            'message': '未关注该商铺',
            'data': {
                'restaurant_id': restaurant_id,
                'is_following': False
            }
        }, 200

    db.session.delete(follow)
    db.session.commit()

    return {
        'success': True,
        'message': '已取消关注',
        'data': {
            'restaurant_id': restaurant_id,
            'is_following': False
        }
    }, 200


def get_follow_status(user_id: int, restaurant_id: int) -> Tuple[Dict[str, Any], int]:
    if not user_id:
        return {'success': False, 'message': '用户未登录'}, 401

    follow = RestaurantFollow.query.filter_by(user_id=user_id, restaurant_id=restaurant_id).first()
    if not follow:
        return {
            'success': True,
            'data': {
                'restaurant_id': restaurant_id,
                'is_following': False
            }
        }, 200

    return {
        'success': True,
        'data': _follow_payload(follow, include_restaurant=False)
    }, 200


def list_followed_restaurants(user_id: int) -> Tuple[Dict[str, Any], int]:
    if not user_id:
        return {'success': False, 'message': '用户未登录'}, 401

    follows = RestaurantFollow.query.filter_by(user_id=user_id).order_by(RestaurantFollow.created_at.desc()).all()
    records = [_follow_payload(item) for item in follows]

    return {
        'success': True,
        'data': {
            'records': records,
            'total': len(records)
        }
    }, 200
def send_sms_code(phone, purpose='register'):
    """
    发送短信验证码

    Args:
        phone (str): 手机号
        purpose (str): 用途 'register' 或 'login' 或 'reset_password' 或 'change_phone'

    Returns:
        tuple: (result_dict, status_code)
    """
    # 验证手机号格式
    if not validate_phone(phone):
        return {
            'success': False,
            'message': '请输入正确的手机号格式'
        }, 400

    # 不同用途的用户存在性验证
    if purpose == 'login' or purpose == 'reset_password':
        user = User.query.filter_by(phone=phone).first()
        if not user:
            return {
                'success': False,
                'message': '该手机号尚未注册'
            }, 404
    
    # change_phone 不需要验证用户是否存在（因为是新手机号）

    # 发送验证码
    result = sms_service.send_verification_code(phone, purpose)

    if result['success']:
        return result, 200
    else:
        return result, 400

def reset_password(phone, sms_code, new_password):
    """
    重置用户密码

    Args:
        phone (str): 手机号
        sms_code (str): 短信验证码
        new_password (str): 新密码

    Returns:
        tuple: (result_dict, status_code)
    """
    # 验证手机号格式
    if not validate_phone(phone):
        return {
            'success': False,
            'message': '请输入正确的手机号格式'
        }, 400

    # 验证新密码格式
    if not validate_password(new_password):
        return {
            'success': False,
            'message': '密码至少需要6个字符'
        }, 400

    # 查找用户
    user = User.query.filter_by(phone=phone).first()
    if not user:
        return {
            'success': False,
            'message': '用户不存在'
        }, 404

    # 验证短信验证码
    sms_result = sms_service.verify_code(phone, sms_code, 'reset_password')
    if not sms_result['success']:
        return {
            'success': False,
            'message': sms_result['message']
        }, 400

    # 更新密码
    user.set_password(new_password)
    user.updated_at = datetime.utcnow()
    db.session.commit()

    return {
        'success': True,
        'message': '密码重置成功'
    }, 200


def list_broadcasts(
        restaurant_id: Optional[int] = None,
        include_inactive: bool = False,
        page: int = 1,
        per_page: int = 20
) -> Tuple[Dict[str, Any], int]:
    page = max(int(page or 1), 1)
    per_page = min(max(int(per_page or 20), 1), 100)

    query = MerchantBroadcast.query.order_by(MerchantBroadcast.created_at.desc())
    if restaurant_id:
        query = query.filter_by(restaurant_id=restaurant_id)
    else:
        # 避免与自动生成的通知重复推送
        query = query.filter(
            ~MerchantBroadcast.dish_notification.has(),
            ~MerchantBroadcast.coupon_notification.has()
        )
    if not include_inactive:
        query = query.filter_by(is_active=True)

    pagination = query.paginate(page=page, per_page=per_page, error_out=False)
    records = [item.to_dict() for item in pagination.items]

    return {
        'success': True,
        'data': {
            'records': records,
            'pagination': {
                'page': pagination.page,
                'per_page': pagination.per_page,
                'total_pages': pagination.pages,
                'total_items': pagination.total
            }
        }
    }, 200


def update_broadcast(
        broadcast_id: int,
        restaurant_id: int,
        data: Dict[str, Any]
) -> Tuple[Dict[str, Any], int]:
    broadcast = MerchantBroadcast.query.get(broadcast_id)
    if not broadcast:
        return {'success': False, 'message': '广播不存在'}, 404

    if broadcast.restaurant_id != restaurant_id:
        return {'success': False, 'message': '无权修改其他餐厅的广播'}, 403

    title = data.get('title')
    if title is not None:
        title = title.strip()
        if not title:
            return {'success': False, 'message': '广播标题不能为空'}, 400
        if len(title) > 100:
            return {'success': False, 'message': '标题长度不能超过 100 字符'}, 400
        broadcast.title = title

    content = data.get('content')
    if content is not None:
        content = content.strip()
        if not content:
            return {'success': False, 'message': '广播内容不能为空'}, 400
        broadcast.content = content

    if 'is_active' in data:
        broadcast.is_active = bool(data['is_active'])

    if 'start_time' in data or 'end_time' in data:
        try:
            start_dt = _parse_datetime(data.get('start_time')) if 'start_time' in data else broadcast.start_time
            end_dt = _parse_datetime(data.get('end_time')) if 'end_time' in data else broadcast.end_time
        except ValueError as exc:
            return {'success': False, 'message': str(exc)}, 400
        if start_dt and end_dt and start_dt > end_dt:
            return {'success': False, 'message': '开始时间不能晚于结束时间'}, 400
        broadcast.start_time = start_dt
        broadcast.end_time = end_dt

    db.session.commit()

    return {
        'success': True,
        'message': '广播更新成功',
        'data': broadcast.to_dict()
    }, 200


def delete_broadcast(broadcast_id: int, restaurant_id: int) -> Tuple[Dict[str, Any], int]:
    broadcast = MerchantBroadcast.query.get(broadcast_id)
    if not broadcast:
        return {'success': False, 'message': '广播不存在'}, 404

    if broadcast.restaurant_id != restaurant_id:
        return {'success': False, 'message': '无权删除其他餐厅的广播'}, 403

    db.session.delete(broadcast)
    db.session.commit()

    return {
        'success': True,
        'message': '广播已删除'
    }, 200


def get_broadcast_detail(broadcast_id: int) -> Tuple[Dict[str, Any], int]:
    broadcast = MerchantBroadcast.query.get(broadcast_id)
    if not broadcast:
        return {'success': False, 'message': '广播不存在'}, 404

    return {
        'success': True,
        'data': broadcast.to_dict()
    }, 200


def create_restaurant(user_id, name, address, phone, opening_hours, notice=None, avatar_url=None):
    """
    创建餐厅信息

    Args:
        user_id (int): 用户ID
        name (str): 餐厅名称
        address (str): 餐厅地址
        phone (str): 联系电话
        opening_hours (str): 营业时间
        notice (str): 餐厅公告
        avatar_url (str): 头像URL

    Returns:
        tuple: (result_dict, status_code)
    """
    try:
        # 检查用户是否存在
        user = User.query.get(user_id)
        if not user:
            return {
                'success': False,
                'message': '用户不存在'
            }, 404

        # 检查用户是否已有关联的餐厅
        if hasattr(user, 'restaurant') and user.restaurant:
            return {
                'success': False,
                'message': '该用户已有关联的餐厅'
            }, 400

        # 创建餐厅
        restaurant = Restaurant(
            name=name,
            address=address,
            phone=phone,
            opening_hours=opening_hours,
            notice=notice,
            avatar_url=avatar_url,
            user_id=user_id
        )

        db.session.add(restaurant)
        db.session.commit()

        return {
            'success': True,
            'message': '餐厅创建成功',
            'data': {
                'restaurant': restaurant.to_dict()
            }
        }, 201

    except Exception as e:
        db.session.rollback()
        return {
            'success': False,
            'message': '创建餐厅失败',
            'error': str(e)
        }, 500


def update_restaurant(restaurant_id, name=None, address=None, phone=None, opening_hours=None, notice=None, avatar_url=None):
    """
    更新餐厅信息

    Args:
        restaurant_id (int): 餐厅ID
        name (str): 餐厅名称
        address (str): 餐厅地址
        phone (str): 联系电话
        opening_hours (str): 营业时间
        notice (str): 餐厅公告
        avatar_url (str): 头像URL

    Returns:
        tuple: (result_dict, status_code)
    """
    try:
        # 查找餐厅
        restaurant = Restaurant.query.get(restaurant_id)
        if not restaurant:
            return {
                'success': False,
                'message': '餐厅不存在'
            }, 404

        # 更新餐厅信息
        if name is not None:
            restaurant.name = name
        if address is not None:
            restaurant.address = address
        if phone is not None:
            restaurant.phone = phone
        if opening_hours is not None:
            restaurant.opening_hours = opening_hours
        if notice is not None:
            restaurant.notice = notice
        if avatar_url is not None:
            restaurant.avatar_url = avatar_url

        restaurant.updated_at = datetime.utcnow()
        db.session.commit()

        return {
            'success': True,
            'message': '餐厅信息更新成功',
            'data': {
                'restaurant': restaurant.to_dict()
            }
        }, 200

    except Exception as e:
        db.session.rollback()
        return {
            'success': False,
            'message': '更新餐厅信息失败',
            'error': str(e)
        }, 500


def get_restaurant_by_user_id(user_id):
    """
    根据用户ID获取餐厅信息

    Args:
        user_id (int): 用户ID

    Returns:
        tuple: (result_dict, status_code)
    """
    try:
        # 查找用户关联的餐厅
        restaurant = Restaurant.query.filter_by(user_id=user_id).first()
        if not restaurant:
            return {
                'success': False,
                'message': '未找到关联的餐厅'
            }, 404

        return {
            'success': True,
            'message': '获取餐厅信息成功',
            'data': {
                'restaurant': restaurant.to_dict()
            }
        }, 200

    except Exception as e:
        return {
            'success': False,
            'message': '获取餐厅信息失败',
            'error': str(e)
        }, 500
    
# ==================== 桌位管理函数 ====================
def create_table(restaurant_id, table_number, capacity, table_type='shared', description=None):
    """创建桌位"""
    try:
        table = Table(
            restaurant_id=restaurant_id,
            table_number=table_number,
            capacity=capacity,
            table_type=table_type,
            description=description,
            status='available'
        )
        db.session.add(table)
        db.session.commit()
        return table
    except Exception as e:
        db.session.rollback()
        raise e

def update_table(table_id, **kwargs):
    """更新桌位信息"""
    try:
        table = Table.query.get(table_id)
        if not table:
            return None
        
        allowed_fields = ['table_number', 'capacity', 'table_type', 'status', 'description']
        for key, value in kwargs.items():
            if key in allowed_fields and hasattr(table, key):
                setattr(table, key, value)
        
        table.updated_at = datetime.utcnow()
        db.session.commit()
        return table
    except Exception as e:
        db.session.rollback()
        raise e

def delete_table(table_id):
    """删除桌位"""
    try:
        table = Table.query.get(table_id)
        if not table:
            return False
        
        db.session.delete(table)
        db.session.commit()
        return True
    except Exception as e:
        db.session.rollback()
        raise e

def get_restaurant_tables(restaurant_id):
    """获取餐厅所有桌位"""
    return Table.query.filter_by(restaurant_id=restaurant_id).all()

def get_available_tables(restaurant_id, capacity=None):
    """获取可用桌位"""
    query = Table.query.filter_by(restaurant_id=restaurant_id, status='available')
    if capacity:
        query = query.filter(Table.capacity >= capacity)
    return query.all()

def get_table_details(table_id):
    """获取桌位详情"""
    return Table.query.get(table_id)

# ==================== 订单管理函数 ====================
def create_order(user_id, restaurant_id, table_id=None, customer_count=1, order_type='dine_in', note=None):
    """创建订单"""
    try:
        order = Order(
            order_number=Order.generate_order_number(),
            user_id=user_id,
            restaurant_id=restaurant_id,
            table_id=table_id,
            customer_count=customer_count,
            order_type=order_type,
            note=note,
            status='pending'
        )
        db.session.add(order)
        db.session.commit()
        return order
    except Exception as e:
        db.session.rollback()
        raise e

def get_order_by_id(order_id):
    """根据ID获取订单"""
    return Order.query.get(order_id)

def get_user_orders(user_id):
    """获取用户所有订单"""
    return Order.query.filter_by(user_id=user_id).order_by(Order.created_at.desc()).all()

def get_restaurant_orders(restaurant_id, status=None):
    """获取餐厅订单"""
    query = Order.query.filter_by(restaurant_id=restaurant_id)
    if status:
        query = query.filter_by(status=status)
    return query.order_by(Order.created_at.desc()).all()

def update_order_status(order_id, status):
    """更新订单状态"""
    try:
        order = Order.query.get(order_id)
        if not order:
            return None
        
        order.status = status
        if status == 'confirmed':
            order.confirmed_time = datetime.utcnow()
        elif status == 'completed':
            order.completed_time = datetime.utcnow()
        elif status == 'cancelled':
            order.cancelled_time = datetime.utcnow()
        
        order.updated_at = datetime.utcnow()
        db.session.commit()
        return order
    except Exception as e:
        db.session.rollback()
        raise e

# ==================== 商户申请审核函数 ====================
def get_all_merchant_applications(status=None, page=1, per_page=20):
    """获取所有商户申请列表"""
    try:
        query = MerchantApplication.query

        if status:
            query = query.filter_by(review_status=status)

        # 按创建时间倒序排列
        applications = query.order_by(MerchantApplication.created_at.desc()).offset((page-1)*per_page).limit(per_page).all()
        total = query.count()

        return {
            'applications': applications,
            'total': total,
            'page': page,
            'per_page': per_page,
            'pages': (total + per_page - 1) // per_page
        }
    except Exception as e:
        raise e

def get_merchant_application_by_id(application_id):
    """根据ID获取商户申请详情"""
    try:
        return MerchantApplication.query.get(application_id)
    except Exception as e:
        raise e

def approve_merchant_application(application_id, reviewer_id):
    """批准商户申请"""
    try:
        # 获取申请信息
        application = MerchantApplication.query.get(application_id)
        if not application:
            return False, "申请不存在"

        if application.review_status != 'pending':
            return False, "申请状态不是待审核"

        # 检查用户是否已经有餐厅
        existing_restaurant = Restaurant.query.filter_by(user_id=application.user_id).first()
        if existing_restaurant:
            return False, "该用户已经有餐厅"

        # 创建餐厅记录
        restaurant = Restaurant(
            name=application.shop_name,
            address=application.address,
            phone=application.phone,
            opening_hours=application.business_hours,
            notice=application.description,
            user_id=application.user_id
        )

        # 更新申请状态
        application.review_status = 'approved'
        application.reviewed_at = datetime.utcnow()
        application.reviewer_id = reviewer_id

        # 更新用户类型为商家
        user = User.query.get(application.user_id)
        if user:
            user.usertype = 1

        # 保存所有更改
        db.session.add(restaurant)

        # 删除该用户的其他申请记录，只保留当前已批准的这条
        other_applications = MerchantApplication.query.filter(
            MerchantApplication.user_id == application.user_id,
            MerchantApplication.id != application_id
        ).all()

        for other_app in other_applications:
            db.session.delete(other_app)

        db.session.commit()

        return True, f"申请已批准，餐厅 {restaurant.name} 创建成功"

    except Exception as e:
        db.session.rollback()
        return False, f"批准申请失败: {str(e)}"

def reject_merchant_application(application_id, reviewer_id, reject_reason):
    """拒绝商户申请"""
    try:
        # 获取申请信息
        application = MerchantApplication.query.get(application_id)
        if not application:
            return False, "申请不存在"

        if application.review_status != 'pending':
            return False, "申请状态不是待审核"

        # 更新申请状态
        application.review_status = 'rejected'
        application.review_note = reject_reason
        application.reviewed_at = datetime.utcnow()
        application.reviewer_id = reviewer_id

        db.session.commit()

        return True, "申请已拒绝"

    except Exception as e:
        db.session.rollback()
        return False, f"拒绝申请失败: {str(e)}"

def delete_user_applications(user_id):
    """删除指定用户的所有申请记录"""
    try:
        # 删除该用户的所有申请
        deleted_count = MerchantApplication.query.filter_by(user_id=user_id).delete()
        db.session.commit()
        return deleted_count
    except Exception as e:
        db.session.rollback()
        raise e

def check_table_availability_for_reservation(table_id, reserved_time, reserved_end_time, customer_count):
    table = Table.query.get(table_id)
    if not table:
        return False, 0

    # 维护中直接不可预约
    if table.status == 'maintenance':
        return False, 0

    # 1) 预约订单冲突（你原来的逻辑）
    conflicting_orders = Order.query.filter(
        Order.table_id == table_id,
        Order.reservation_status.in_(['pending', 'confirmed', 'seated']),
        Order.reserved_time < reserved_end_time,
        Order.reserved_end_time > reserved_time
    ).all()

    # 2) 非预约堂食占用冲突：下单即占桌，status=pending/confirmed/dining 且没有 reserved_time
    DEFAULT_NON_RESERVATION_DURATION_MINUTES = 120
    active_non_reservation_orders = Order.query.filter(
        Order.table_id == table_id,
        Order.status.in_(['pending', 'confirmed', 'dining']),
        Order.reserved_time.is_(None)
    ).all()

    active_non_reservation_occupancy = 0
    for order in active_non_reservation_orders:
        # 下单即占桌：pending/confirmed/dining 都以 order_time 作为起点
        start_time = order.order_time or order.confirmed_time or datetime.utcnow()
        end_time = start_time + timedelta(minutes=DEFAULT_NON_RESERVATION_DURATION_MINUTES)

        # 与预约时段有重叠才算冲突
        if start_time < reserved_end_time and end_time > reserved_time:
            active_non_reservation_occupancy += order.customer_count

    # 独立桌：只要“有冲突预约”或“有占用冲突”就不可用
    if table.table_type == 'private':
        is_available = (len(conflicting_orders) == 0) and (active_non_reservation_occupancy == 0)
        return is_available, table.capacity if is_available else 0

    # 拼桌：预约占座 + 非预约占座一起扣
    occupied_seats = sum(o.customer_count for o in conflicting_orders) + active_non_reservation_occupancy
    available_seats = max(table.capacity - occupied_seats, 0)
    is_available = available_seats >= customer_count
    return is_available, available_seats

def validate_order_items(restaurant_id, items_payload):
    if not items_payload:
        raise ValueError('订单项不能为空')
    validated_items, total_price = [], 0.0
    for item in items_payload:
        dish_id = item.get('dish_id')
        quantity = int(item.get('quantity', 1) or 1)
        if not dish_id or quantity <= 0:
            raise ValueError('存在无效的菜品或数量')
        dish = Dish.query.filter_by(dish_id=dish_id, restaurant_id=restaurant_id).first()
        if not dish:
            raise ValueError(f'菜品 {dish_id} 不存在')
        if not dish.is_available():
            raise ValueError(f'{dish.name} 已售罄或不可售')
        if dish.stock_quantity is not None and dish.stock_quantity < quantity:
            raise ValueError(f'{dish.name} 库存不足')
        spiciness = item.get('spiciness')
        garnish = item.get('garnish')
        if dish.is_spicy_selectable and spiciness and spiciness not in ['不辣','微辣','中辣','特辣','变态辣']:
            raise ValueError(f'{dish.name} 的辣度选项无效')
        if dish.is_garnish_selectable and garnish and garnish not in ['要葱花香菜','要葱花','要香菜','不要葱花不要香菜']:
            raise ValueError(f'{dish.name} 的配菜选项无效')
        unit_price = float(dish.price)
        subtotal = unit_price * quantity
        validated_items.append({
            'dish': dish,
            'quantity': quantity,
            'unit_price': unit_price,
            'subtotal': subtotal,
            'spiciness': spiciness if dish.is_spicy_selectable else None,
            'garnish': garnish if dish.is_garnish_selectable else None
        })
        total_price += subtotal
    return validated_items, total_price

def get_merchant_restaurant(user):
    print(1)
    if not user or user.usertype != 1:
        return None
    return Restaurant.query.filter_by(user_id=user.id).first()

if __name__ == '__main__':
    init_database()