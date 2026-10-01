from motor.motor_asyncio import AsyncIOMotorClient
from motor.motor_asyncio import AsyncIOMotorCollection
from config import settings

# MongoDB 客户端
client = None
database = None

async def connect_to_mongo():
    """连接到 MongoDB"""
    global client, database
    try:
        client = AsyncIOMotorClient(
            settings.MONGODB_URL,
            serverSelectionTimeoutMS=5000  # 5秒超时
        )
        # 测试连接
        await client.admin.command('ping')
        database = client[settings.DATABASE_NAME]
        print(f"✅ 成功连接到 MongoDB: {settings.DATABASE_NAME}")
        # 初始化索引
        await _ensure_indexes()
    except Exception as e:
        print(f"⚠️  MongoDB 连接失败: {e}")
        print("⚠️  服务器将继续运行，但数据库功能将不可用")
        client = None
        database = None

async def close_mongo_connection():
    """关闭 MongoDB 连接"""
    global client
    if client:
        client.close()
        print("✅ MongoDB 连接已关闭")

def get_database():
    """获取数据库实例"""
    if database is None:
        raise Exception("数据库未连接，请先启动 MongoDB 服务")
    return database


def get_users_collection() -> AsyncIOMotorCollection:
    """获取 users 表"""
    """表结构
    {
        (_id: ObjectId)
        username: str,
        password_hash: str,
        salt: str,
        is_admin: bool,  # 是否管理员
        created_at: datetime
    }
    """
    db = get_database()
    return db["users"]


def get_owned_collection() -> AsyncIOMotorCollection:
    """获取 owned_courts 表"""
    """表结构
    {
        (_id: ObjectId)
        owned_user_name: str, 
        court_id: int,
        start_at: datetime,
        end_at: datetime,
        created_at: datetime
    }
    """
    db = get_database()
    return db["owned_courts"]


def get_wanted_collection() -> AsyncIOMotorCollection:
    """获取 wanted_courts 表"""
    """表结构
    {
        (_id: ObjectId)
        wanted_user_name: str, 
        court_id: int,
        start_at: datetime,
        end_at: datetime,
        created_at: datetime
    }
    """
    db = get_database()
    return db["wanted_courts"]

def get_exchange_collection() -> AsyncIOMotorCollection:
    """获取 exchange_requests 表"""
    """表结构
    {
        (_id: ObjectId)
        post_user_name: str,
        request_user_name: str,
        court_id: int,
        status: str,  # pending, completed, refused
        created_at: datetime
    }
    """
    db = get_database()
    return db["exchange_requests"]

def get_pending_owned_collection() -> AsyncIOMotorCollection:
    """获取 pending_owned 待审核场地表"""
    """表结构
    {
        (_id: ObjectId)
        username: str,
        court_id: int,
        start_at: datetime,
        end_at: datetime,
        serial_number: str,  # 学校体育网站生成的序列号
        status: str,  # pending, approved, rejected
        created_at: datetime,
        reviewed_at: datetime (可选),
        reviewed_by: str (可选)
    }
    """
    db = get_database()
    return db["pending_owned"]

async def _ensure_indexes() -> None:
    """初始化集合索引（只在启动时调用）"""
    users = get_users_collection()
    # 唯一用户名索引
    await users.create_index("username", unique=True)
    # 便于查询的复合索引
    owned = get_owned_collection()
    await owned.create_index([("court_id", 1), ("start_at", 1)])
    wanted = get_wanted_collection()
    await wanted.create_index([("court_id", 1), ("start_at", 1)])
    # 待审核场地索引
    pending = get_pending_owned_collection()
    await pending.create_index([("status", 1), ("created_at", 1)])
    # 序列号索引（非唯一，允许多人提交相同序列号待审核）
    await pending.create_index("serial_number")


# 系统消息发送工具
async def send_system_message(receiver: str, content: str):
    """发送系统通知消息"""
    from datetime import datetime, timezone
    db = get_database()
    doc = {
        "sender": "系统通知",
        "receiver": receiver,
        "content": content,
        "created_at": datetime.now(timezone.utc),
        "read": False,
        "is_system": True
    }
    await db.messages.insert_one(doc)
