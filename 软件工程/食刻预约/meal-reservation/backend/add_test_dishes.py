"""
为商家添加测试菜品
"""
import sys
import os
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

from app_init import db, app
from Models import Dish, Restaurant
from datetime import datetime

def add_test_dishes(restaurant_id):
    """为指定商家添加测试菜品"""
    
    with app.app_context():
        # 检查商家是否存在
        restaurant = Restaurant.query.get(restaurant_id)
        if not restaurant:
            print(f"错误：找不到ID为 {restaurant_id} 的商家")
            return
        
        print(f"为商家 [{restaurant.name}] 添加测试菜品...")
        
        # 测试菜品数据
        test_dishes = [
            # 主食类
            {"name": "宫保鸡丁", "category": "主菜", "price": 38.0, "description": "经典川菜，鸡肉香嫩，花生酥脆"},
            {"name": "红烧肉", "category": "主菜", "price": 42.0, "description": "肥而不腻，入口即化"},
            {"name": "麻婆豆腐", "category": "主菜", "price": 28.0, "description": "麻辣鲜香，下饭神器"},
            {"name": "鱼香肉丝", "category": "主菜", "price": 32.0, "description": "酸甜可口，色香味俱全"},
            {"name": "水煮鱼", "category": "主菜", "price": 58.0, "description": "麻辣鲜香，鱼肉嫩滑"},
            {"name": "糖醋里脊", "category": "主菜", "price": 36.0, "description": "外酥里嫩，酸甜适口"},
            {"name": "回锅肉", "category": "主菜", "price": 35.0, "description": "四川传统名菜，肥而不腻"},
            
            # 汤类
            {"name": "番茄蛋汤", "category": "汤", "price": 18.0, "description": "清淡爽口，营养丰富"},
            {"name": "酸辣汤", "category": "汤", "price": 20.0, "description": "酸辣开胃，驱寒暖胃"},
            {"name": "紫菜蛋花汤", "category": "汤", "price": 16.0, "description": "清淡营养，老少皆宜"},
            
            # 主食类
            {"name": "白米饭", "category": "主食", "price": 3.0, "description": "精选东北大米"},
            {"name": "炒饭", "category": "主食", "price": 18.0, "description": "粒粒分明，香气扑鼻"},
            {"name": "炒面", "category": "主食", "price": 20.0, "description": "面条劲道，口感极佳"},
            
            # 凉菜
            {"name": "拍黄瓜", "category": "凉菜", "price": 12.0, "description": "清脆爽口，消暑解腻"},
            {"name": "皮蛋豆腐", "category": "凉菜", "price": 15.0, "description": "清凉爽滑，开胃小菜"},
            {"name": "凉拌木耳", "category": "凉菜", "price": 18.0, "description": "爽脆可口，营养健康"},
            
            # 素菜
            {"name": "清炒时蔬", "category": "素菜", "price": 22.0, "description": "新鲜时令蔬菜"},
            {"name": "蒜蓉西兰花", "category": "素菜", "price": 24.0, "description": "营养丰富，清淡健康"},
            {"name": "干煸四季豆", "category": "素菜", "price": 26.0, "description": "外焦里嫩，香气四溢"},
            
            # 饮料
            {"name": "可乐", "category": "饮料", "price": 6.0, "description": "冰镇可乐"},
            {"name": "雪碧", "category": "饮料", "price": 6.0, "description": "冰镇雪碧"},
            {"name": "鲜榨橙汁", "category": "饮料", "price": 15.0, "description": "新鲜现榨，维C丰富"},
        ]
        
        added_count = 0
        
        for dish_data in test_dishes:
            try:
                dish = Dish(
                    name=dish_data["name"],
                    category=dish_data["category"],
                    price=dish_data["price"],
                    description=dish_data["description"],
                    restaurant_id=restaurant_id,
                    status='available',
                    stock_quantity=999,
                    stock_capacity=999,
                    is_spicy_selectable=True if dish_data["category"] in ["主菜", "汤"] else False,
                    is_garnish_selectable=True if dish_data["category"] in ["主菜", "汤"] else False,
                    created_at=datetime.utcnow(),
                    updated_at=datetime.utcnow()
                )
                db.session.add(dish)
                added_count += 1
            except Exception as e:
                print(f"添加菜品 [{dish_data['name']}] 时出错: {str(e)}")
                continue
        
        try:
            db.session.commit()
            print(f"\n✅ 成功添加 {added_count} 个测试菜品！")
            
            # 统计各分类菜品数量
            categories = db.session.query(Dish.category, db.func.count(Dish.dish_id)).filter_by(
                restaurant_id=restaurant_id
            ).group_by(Dish.category).all()
            
            print("\n菜品分类统计：")
            for category, count in categories:
                print(f"  - {category}: {count} 个")
                
        except Exception as e:
            print(f"\n❌ 提交菜品时出错: {str(e)}")
            db.session.rollback()


if __name__ == '__main__':
    import argparse
    
    parser = argparse.ArgumentParser(description='为商家添加测试菜品')
    parser.add_argument('--restaurant-id', type=int, required=True, help='商家ID')
    
    args = parser.parse_args()
    
    add_test_dishes(args.restaurant_id)
