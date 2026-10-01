"""
批量生成测试订单数据
用于测试数据统计功能
"""
import sys
import os
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

from app_init import db, app
from Models import Order, OrderItem, Restaurant, Dish, User
from datetime import datetime, timedelta
import random

def generate_test_orders(restaurant_id, num_orders=50):
    """
    为指定商家生成测试订单
    
    Args:
        restaurant_id: 商家ID
        num_orders: 生成订单数量，默认50个
    """
    with app.app_context():
        # 检查商家是否存在
        restaurant = Restaurant.query.get(restaurant_id)
        if not restaurant:
            print(f"错误：找不到ID为 {restaurant_id} 的商家")
            return
        
        print(f"开始为商家 [{restaurant.name}] 生成 {num_orders} 个测试订单...")
        
        # 获取该商家的所有菜品
        dishes = Dish.query.filter_by(restaurant_id=restaurant_id).all()
        if not dishes:
            print(f"错误：商家 [{restaurant.name}] 还没有菜品")
            return
        
        print(f"找到 {len(dishes)} 个菜品")
        
        # 获取一个测试用户（或创建一个）
        test_user = User.query.filter_by(usertype=2).first()
        if not test_user:
            print("错误：找不到顾客用户，请先创建用户")
            return
        
        # 订单状态分布
        status_distribution = {
            'completed': 0.7,    # 70% 已完成
            'confirmed': 0.15,   # 15% 已确认
            'dining': 0.08,      # 8% 就餐中
            'cancelled': 0.05,   # 5% 已取消
            'pending': 0.02      # 2% 待确认
        }
        
        # 订单类型分布
        order_type_distribution = {
            'dine_in': 0.7,      # 70% 堂食
            'takeout': 0.3       # 30% 外卖
        }
        
        # 生成过去30天的订单
        end_date = datetime.utcnow()
        start_date = end_date - timedelta(days=30)
        
        orders_created = 0
        
        for i in range(num_orders):
            try:
                # 随机生成订单时间（过去30天内）
                random_days = random.uniform(0, 30)
                order_date = end_date - timedelta(days=random_days)
                
                # 随机时间段（营业时间 10:00-22:00）
                hour = random.randint(10, 21)
                minute = random.randint(0, 59)
                order_time = order_date.replace(hour=hour, minute=minute, second=0, microsecond=0)
                
                # 随机订单类型
                order_type = random.choices(
                    list(order_type_distribution.keys()),
                    weights=list(order_type_distribution.values())
                )[0]
                
                # 随机订单状态
                status = random.choices(
                    list(status_distribution.keys()),
                    weights=list(status_distribution.values())
                )[0]
                
                # 创建订单
                order = Order(
                    order_number=Order.generate_order_number(),
                    user_id=test_user.id,
                    restaurant_id=restaurant_id,
                    customer_count=random.randint(1, 6),
                    order_type=order_type,
                    status=status,
                    order_time=order_time,
                    created_at=order_time,
                    updated_at=order_time
                )
                
                # 设置时间戳
                if status in ['confirmed', 'dining', 'completed']:
                    order.confirmed_time = order_time + timedelta(minutes=random.randint(2, 10))
                    order.pickup_number = Order.generate_pickup_number(restaurant_id)
                
                if status == 'completed':
                    order.completed_time = order_time + timedelta(minutes=random.randint(30, 90))
                
                if status == 'cancelled':
                    order.cancelled_time = order_time + timedelta(minutes=random.randint(1, 30))
                
                # 添加订单项（随机选择1-5个菜品）
                num_items = random.randint(1, 5)
                selected_dishes = random.sample(dishes, min(num_items, len(dishes)))
                
                total_price = 0
                for dish in selected_dishes:
                    quantity = random.randint(1, 3)
                    unit_price = dish.price
                    subtotal = unit_price * quantity
                    total_price += subtotal
                    
                    order_item = OrderItem(
                        dish_id=dish.dish_id,
                        quantity=quantity,
                        unit_price=unit_price,
                        subtotal=subtotal,
                        spiciness=random.choice(['不辣', '微辣', '中辣', '特辣', None]),
                        garnish=random.choice(['都要', '不要葱', '不要香菜', '都不要', None])
                    )
                    order.items.append(order_item)
                
                order.total_price = total_price
                
                db.session.add(order)
                orders_created += 1
                
                # 每10个订单提交一次
                if orders_created % 10 == 0:
                    db.session.commit()
                    print(f"已生成 {orders_created}/{num_orders} 个订单...")
            
            except Exception as e:
                print(f"生成第 {i+1} 个订单时出错: {str(e)}")
                db.session.rollback()
                continue
        
        # 提交剩余的订单
        try:
            db.session.commit()
            print(f"\n✅ 成功生成 {orders_created} 个测试订单！")
            print(f"\n订单统计：")
            print(f"  - 时间范围: {start_date.strftime('%Y-%m-%d')} 至 {end_date.strftime('%Y-%m-%d')}")
            
            # 统计各状态订单数量
            status_counts = {}
            for status in status_distribution.keys():
                count = Order.query.filter_by(restaurant_id=restaurant_id, status=status).count()
                status_counts[status] = count
            
            status_names = {
                'completed': '已完成',
                'confirmed': '已确认',
                'dining': '就餐中',
                'cancelled': '已取消',
                'pending': '待确认'
            }
            
            for status, count in status_counts.items():
                print(f"  - {status_names[status]}: {count} 个")
            
            # 计算总营业额（已完成订单）
            total_revenue = db.session.query(db.func.sum(Order.total_price)).filter(
                Order.restaurant_id == restaurant_id,
                Order.status == 'completed'
            ).scalar() or 0
            
            print(f"  - 总营业额: ¥{total_revenue:.2f}")
            
        except Exception as e:
            print(f"\n❌ 提交订单时出错: {str(e)}")
            db.session.rollback()


def list_restaurants():
    """列出所有商家"""
    with app.app_context():
        restaurants = Restaurant.query.all()
        
        if not restaurants:
            print("当前没有商家")
            return
        
        print("\n可用的商家列表：")
        print("-" * 60)
        for r in restaurants:
            dish_count = Dish.query.filter_by(restaurant_id=r.id).count()
            order_count = Order.query.filter_by(restaurant_id=r.id).count()
            print(f"ID: {r.id} | 名称: {r.name} | 菜品数: {dish_count} | 订单数: {order_count}")
        print("-" * 60)


if __name__ == '__main__':
    import argparse
    
    parser = argparse.ArgumentParser(description='批量生成测试订单')
    parser.add_argument('--list', action='store_true', help='列出所有商家')
    parser.add_argument('--restaurant-id', type=int, help='商家ID')
    parser.add_argument('--count', type=int, default=50, help='生成订单数量（默认50）')
    
    args = parser.parse_args()
    
    if args.list:
        list_restaurants()
    elif args.restaurant_id:
        generate_test_orders(args.restaurant_id, args.count)
    else:
        print("使用方法：")
        print("  查看商家列表：python generate_test_orders.py --list")
        print("  生成订单：python generate_test_orders.py --restaurant-id <商家ID> --count <数量>")
        print("\n示例：")
        print("  python generate_test_orders.py --list")
        print("  python generate_test_orders.py --restaurant-id 1 --count 100")
