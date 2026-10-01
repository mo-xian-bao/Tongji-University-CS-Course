"""Database initialization and test data."""
from datetime import datetime, timedelta
import random

from Models import (
    db,
    User,
    Restaurant,
    UserInfo,
    Table,
    Order,
    OrderItem,
    Dish,
    MerchantBroadcast,
    DishLaunchNotification,
    MerchantApplication,
    UserBan,
    UserAppeal,
    AppealAttachment,
    RestaurantFollow,
    CouponNotification,
    CouponUsage,
)


def init_database():
    """初始化数据库"""

    # 创建所有表
    existing_tables = db.inspect(db.engine).get_table_names()

    # 检查是否需要创建表
    tables = ['users', 'sms_verifications', 'restaurants', 'restaurant_follows',
              'dishes', 'merchant_applications', 'orders',
              'order_items', 'user_info', 'user_bans', 'user_appeals',
              'appeal_attachments', 'order_change_requests',
              'reviews', 'review_keywords', 'messages', 'stock_logs', 'review_likes',
              'merchant_broadcasts', 'dish_launch_notifications',
              'coupon_notifications', 'coupon_usages', 'tables', ]
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
            phone='13800138001',
            username='customer-service',
            usertype=100
        )
        merchant = User(
            phone='13600343895',
            username='merchant',
            usertype=1
        )
        users = User(
            phone='19788953946',
            username='user1',
            usertype=2
        )
        admin.set_password('123456')
        merchant.set_password('123456')
        users.set_password('123456')

        db.session.add(admin)
        db.session.add(merchant)
        db.session.add(users)

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
        users_user = users
    else:
        print("测试用户已存在，跳过创建")
        # 为已存在的用户变量赋值
        admin_user = admin_user
        merchant_user = User.query.filter_by(phone='13600343895').first()
        users_user = User.query.filter_by(phone='19788953946').first()

    support_user = User.query.filter_by(phone='13800138005').first()
    if not support_user:
        # 创建测试用户
        support = User(
            phone='13800138005',
            username='customer-service',
            usertype=100
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
        users_info = UserInfo(user_id=users_user.id)
        db.session.add(admin_info)
        db.session.add(merchant_info)
        db.session.add(users_info)
        db.session.commit()

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
