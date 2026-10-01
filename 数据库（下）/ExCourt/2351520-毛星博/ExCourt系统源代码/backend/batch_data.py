"""
批量添加测试数据脚本
用法: python backend/batch_data.py
"""

import asyncio
from datetime import datetime, timezone, timedelta, time
from motor.motor_asyncio import AsyncIOMotorClient
import random
import string

# 配置
MONGODB_URL = "mongodb://localhost:27017"
DATABASE_NAME = "ExCourt"

# 东八区
CN_TZ = timezone(timedelta(hours=8))

def generate_serial():
    return ''.join(random.choices(string.ascii_uppercase + string.digits, k=6))

def to_utc(date_str: str, hour: int) -> datetime:
    """将东八区时间转为UTC"""
    d = datetime.strptime(date_str, "%Y-%m-%d").date()
    local_dt = datetime.combine(d, time(hour=hour), tzinfo=CN_TZ)
    return local_dt.astimezone(timezone.utc)

async def get_all_users(db):
    users = db["users"]
    return await users.find({}).to_list(100)

async def add_owned_courts(db, username, count, base_date, court_id_min, court_id_max, is_public):
    """批量添加场地"""
    owned = db["owned_courts"]
    added = 0
    
    for i in range(count):
        base = datetime.strptime(base_date, "%Y-%m-%d")
        date = (base + timedelta(days=random.randint(0, 7))).strftime("%Y-%m-%d")
        
        court_id = random.randint(court_id_min, court_id_max)
        start_hour = random.randint(8, 20)
        end_hour = start_hour + 1
        
        start_at = to_utc(date, start_hour)
        end_at = to_utc(date, end_hour)
        
        exists = await owned.find_one({
            "username": username,
            "court_id": court_id,
            "start_at": start_at
        })
        if exists:
            continue
        
        doc = {
            "username": username,
            "court_id": court_id,
            "start_at": start_at,
            "end_at": end_at,
            "serial_number": generate_serial(),
            "is_public": is_public,
            "created_at": datetime.now(timezone.utc)
        }
        await owned.insert_one(doc)
        added += 1
        print(f"  ✓ 场地 {court_id} | {date} {start_hour}:00-{end_hour}:00")
    
    return added

async def add_wanted_courts(db, username, count, base_date, court_id_min, court_id_max):
    """批量添加需求"""
    wanted = db["wanted_courts"]
    added = 0
    
    for i in range(count):
        base = datetime.strptime(base_date, "%Y-%m-%d")
        date = (base + timedelta(days=random.randint(0, 7))).strftime("%Y-%m-%d")
        
        court_id = random.randint(court_id_min, court_id_max)
        start_hour = random.randint(8, 20)
        end_hour = start_hour + 1
        
        start_at = to_utc(date, start_hour)
        end_at = to_utc(date, end_hour)
        
        exists = await wanted.find_one({
            "username": username,
            "court_id": court_id,
            "start_at": start_at
        })
        if exists:
            continue
        
        doc = {
            "username": username,
            "court_id": court_id,
            "start_at": start_at,
            "end_at": end_at,
            "created_at": datetime.now(timezone.utc)
        }
        await wanted.insert_one(doc)
        added += 1
        print(f"  ✓ 需求 {court_id} | {date} {start_hour}:00-{end_hour}:00")
    
    return added

async def create_mutual_match(db, user_a, user_b, date, court_a, court_b, hour_a, hour_b):
    """创建双向匹配测试数据"""
    owned = db["owned_courts"]
    wanted = db["wanted_courts"]
    
    start_a = to_utc(date, hour_a)
    end_a = to_utc(date, hour_a + 1)
    start_b = to_utc(date, hour_b)
    end_b = to_utc(date, hour_b + 1)
    
    # A 的场地
    await owned.update_one(
        {"username": user_a, "court_id": court_a, "start_at": start_a},
        {"$set": {
            "username": user_a,
            "court_id": court_a,
            "start_at": start_a,
            "end_at": end_a,
            "serial_number": generate_serial(),
            "is_public": True,
            "created_at": datetime.now(timezone.utc)
        }},
        upsert=True
    )
    print(f"  ✓ {user_a} 拥有场地 {court_a} ({date} {hour_a}:00)")
    
    # A 的需求
    await wanted.update_one(
        {"username": user_a, "court_id": court_b, "start_at": start_b},
        {"$set": {
            "username": user_a,
            "court_id": court_b,
            "start_at": start_b,
            "end_at": end_b,
            "created_at": datetime.now(timezone.utc)
        }},
        upsert=True
    )
    print(f"  ✓ {user_a} 需要场地 {court_b} ({date} {hour_b}:00)")
    
    # B 的场地
    await owned.update_one(
        {"username": user_b, "court_id": court_b, "start_at": start_b},
        {"$set": {
            "username": user_b,
            "court_id": court_b,
            "start_at": start_b,
            "end_at": end_b,
            "serial_number": generate_serial(),
            "is_public": True,
            "created_at": datetime.now(timezone.utc)
        }},
        upsert=True
    )
    print(f"  ✓ {user_b} 拥有场地 {court_b} ({date} {hour_b}:00)")
    
    # B 的需求
    await wanted.update_one(
        {"username": user_b, "court_id": court_a, "start_at": start_a},
        {"$set": {
            "username": user_b,
            "court_id": court_a,
            "start_at": start_a,
            "end_at": end_a,
            "created_at": datetime.now(timezone.utc)
        }},
        upsert=True
    )
    print(f"  ✓ {user_b} 需要场地 {court_a} ({date} {hour_a}:00)")

async def show_stats(db):
    """显示统计"""
    owned = db["owned_courts"]
    wanted = db["wanted_courts"]
    
    owned_count = await owned.count_documents({})
    wanted_count = await wanted.count_documents({})
    
    print(f"\n📊 数据统计:")
    print(f"   场地总数: {owned_count}")
    print(f"   需求总数: {wanted_count}")
    
    pipeline = [{"$group": {"_id": "$username", "count": {"$sum": 1}}}]
    
    print("\n   场地分布:")
    async for doc in owned.aggregate(pipeline):
        print(f"     {doc['_id']}: {doc['count']} 个")
    
    print("\n   需求分布:")
    async for doc in wanted.aggregate(pipeline):
        print(f"     {doc['_id']}: {doc['count']} 个")

async def clear_data(db):
    """清空数据"""
    owned = db["owned_courts"]
    wanted = db["wanted_courts"]
    r1 = await owned.delete_many({})
    r2 = await wanted.delete_many({})
    print(f"\n✅ 已删除 {r1.deleted_count} 个场地，{r2.deleted_count} 个需求")

def main():
    client = AsyncIOMotorClient(MONGODB_URL)
    db = client[DATABASE_NAME]
    
    loop = asyncio.new_event_loop()
    asyncio.set_event_loop(loop)
    
    print("=" * 50)
    print("ExCourt 批量数据工具")
    print("=" * 50)
    
    # 获取用户
    all_users = loop.run_until_complete(get_all_users(db))
    if not all_users:
        print("❌ 没有找到用户，请先注册一些用户")
        return
    
    usernames = [u['username'] for u in all_users]
    print(f"\n现有用户: {usernames}")
    
    while True:
        print("\n请选择操作:")
        print("1. 批量添加场地（跳过审核）")
        print("2. 批量添加需求")
        print("3. 创建双向匹配测试数据")
        print("4. 查看当前数据统计")
        print("5. 清空所有场地和需求数据")
        print("0. 退出")
        
        choice = input("\n请输入选项: ").strip()
        
        if choice == "0":
            break
            
        elif choice == "1":
            print("\n--- 批量添加场地 ---")
            print(f"可用用户: {usernames}")
            username = input("输入用户名 (留空随机选择): ").strip()
            if not username:
                username = random.choice(usernames)
            elif username not in usernames:
                print(f"❌ 用户 {username} 不存在")
                continue
            
            count = input("添加数量 (默认5): ").strip()
            count = int(count) if count else 5
            
            base_date = input("起始日期 (默认今天): ").strip()
            if not base_date:
                base_date = datetime.now().strftime("%Y-%m-%d")
            
            court_ids = input("场地ID范围 (默认 100-110): ").strip()
            if not court_ids:
                court_id_min, court_id_max = 100, 110
            else:
                court_id_min, court_id_max = map(int, court_ids.split("-"))
            
            is_public = input("是否上架 (y/n, 默认y): ").strip().lower() != 'n'
            
            added = loop.run_until_complete(
                add_owned_courts(db, username, count, base_date, court_id_min, court_id_max, is_public)
            )
            print(f"\n✅ 成功添加 {added} 个场地给 {username}")
            
        elif choice == "2":
            print("\n--- 批量添加需求 ---")
            print(f"可用用户: {usernames}")
            username = input("输入用户名 (留空随机选择): ").strip()
            if not username:
                username = random.choice(usernames)
            elif username not in usernames:
                print(f"❌ 用户 {username} 不存在")
                continue
            
            count = input("添加数量 (默认5): ").strip()
            count = int(count) if count else 5
            
            base_date = input("起始日期 (默认今天): ").strip()
            if not base_date:
                base_date = datetime.now().strftime("%Y-%m-%d")
            
            court_ids = input("场地ID范围 (默认 100-110): ").strip()
            if not court_ids:
                court_id_min, court_id_max = 100, 110
            else:
                court_id_min, court_id_max = map(int, court_ids.split("-"))
            
            added = loop.run_until_complete(
                add_wanted_courts(db, username, count, base_date, court_id_min, court_id_max)
            )
            print(f"\n✅ 成功添加 {added} 个需求给 {username}")
            
        elif choice == "3":
            print("\n--- 创建双向匹配 ---")
            if len(usernames) < 2:
                print("❌ 需要至少2个用户才能创建双向匹配")
                continue
            
            print(f"可用用户: {usernames}")
            
            user_a = input(f"用户A (默认 {usernames[0]}): ").strip() or usernames[0]
            if user_a not in usernames:
                print(f"❌ 用户 {user_a} 不存在")
                continue
                
            user_b = input(f"用户B (默认 {usernames[1]}): ").strip() or usernames[1]
            if user_b not in usernames:
                print(f"❌ 用户 {user_b} 不存在")
                continue
            
            if user_a == user_b:
                print("❌ 两个用户不能相同")
                continue
            
            date = input("日期 (默认明天): ").strip()
            if not date:
                date = (datetime.now() + timedelta(days=1)).strftime("%Y-%m-%d")
            
            court_a = input("用户A的场地ID (默认 101): ").strip()
            court_a = int(court_a) if court_a else 101
            
            court_b = input("用户B的场地ID (默认 102): ").strip()
            court_b = int(court_b) if court_b else 102
            
            hour_a = input("用户A场地的小时 (默认 10): ").strip()
            hour_a = int(hour_a) if hour_a else 10
            
            hour_b = input("用户B场地的小时 (默认 14): ").strip()
            hour_b = int(hour_b) if hour_b else 14
            
            loop.run_until_complete(
                create_mutual_match(db, user_a, user_b, date, court_a, court_b, hour_a, hour_b)
            )
            
            print(f"\n✅ 双向匹配创建成功！")
            print(f"   {user_a}: 有场地{court_a}，想要场地{court_b}")
            print(f"   {user_b}: 有场地{court_b}，想要场地{court_a}")
            print(f"   两人登录主页都会看到匹配提示")
            
        elif choice == "4":
            loop.run_until_complete(show_stats(db))
            
        elif choice == "5":
            confirm = input("\n⚠️  确定要清空所有场地和需求数据吗？(输入 yes 确认): ").strip()
            if confirm == "yes":
                loop.run_until_complete(clear_data(db))
            else:
                print("已取消")
        else:
            print("无效选项")
    
    client.close()
    loop.close()
    print("\n再见！")

if __name__ == "__main__":
    main()
