"""
初始化管理员账号脚本
运行方式: python init_admin.py
"""
import asyncio
from motor.motor_asyncio import AsyncIOMotorClient
from hashlib import sha256
import secrets
from datetime import datetime, timezone

# 配置
MONGODB_URL = "mongodb://localhost:27017"
DATABASE_NAME = "ExCourt"
ADMIN_USERNAME = "admin"
ADMIN_PASSWORD = "123"  # 请在生产环境中修改

def hash_password(plain_password: str, salt: str) -> str:
    return sha256((salt + ":" + plain_password).encode("utf-8")).hexdigest()

async def create_admin():
    client = AsyncIOMotorClient(MONGODB_URL)
    db = client[DATABASE_NAME]
    users = db["users"]
    
    # 检查管理员是否已存在
    existing = await users.find_one({"username": ADMIN_USERNAME})
    if existing:
        if existing.get("is_admin"):
            print(f"✅ 管理员账号 '{ADMIN_USERNAME}' 已存在")
        else:
            # 升级为管理员
            await users.update_one(
                {"username": ADMIN_USERNAME},
                {"$set": {"is_admin": True}}
            )
            print(f"✅ 已将账号 '{ADMIN_USERNAME}' 升级为管理员")
    else:
        # 创建新管理员
        salt = secrets.token_hex(16)
        password_hash = hash_password(ADMIN_PASSWORD, salt)
        
        doc = {
            "username": ADMIN_USERNAME,
            "password_hash": password_hash,
            "salt": salt,
            "is_admin": True,
            "created_at": datetime.now(timezone.utc),
        }
        
        await users.insert_one(doc)
        print(f"✅ 管理员账号创建成功")
        print(f"   用户名: {ADMIN_USERNAME}")
        print(f"   密码: {ADMIN_PASSWORD}")
    
    client.close()

if __name__ == "__main__":
    asyncio.run(create_admin())
