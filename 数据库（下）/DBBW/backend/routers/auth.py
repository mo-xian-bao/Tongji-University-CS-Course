from fastapi import APIRouter, HTTPException, Depends
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
from datetime import datetime, timezone

from database import get_users_collection
from config import settings
from utils.jwt import create_jwt

from model.common import MessageResponse
from model.auth import UserRegisterRequest, UserLoginRequest

from hashlib import sha256
import secrets

# JWT token认证登陆状态用
bearer = HTTPBearer()
# 注册路由
router = APIRouter(prefix="/auth", tags=["auth"])

# 可以放在utils里
def hash_password(plain_password: str, salt: str) -> str:
    return sha256((salt + ":" + plain_password).encode("utf-8")).hexdigest()

# 注册新用户
@router.post("/register", response_model=MessageResponse)
async def register(payload: UserRegisterRequest):
    users = get_users_collection()

    # 生成 salt 并哈希
    salt = secrets.token_hex(16)
    password_hash = hash_password(payload.password, salt)

    doc = {
        "username": payload.username,
        "password_hash": password_hash,
        "salt": salt,
        "created_at": datetime.now(timezone.utc),
    }

    try:
        result = await users.insert_one(doc)
    except Exception as e:
        # 处理唯一索引冲突（重复用户名）
        if "E11000" in str(e):
            raise HTTPException(status_code=400, detail="用户名已存在")
        raise

    return MessageResponse(
            message = "注册成功", 
            data ={ 
                "user_id": str(result.inserted_id)
            }
            )

# 用户登陆，验证用户名密码，发放token
@router.post("/login", response_model=MessageResponse)
async def login(payload: UserLoginRequest):
    users = get_users_collection()# 获取用户表实例

    user = await users.find_one({"username": payload.username})
    if not user:
        raise HTTPException(status_code=401, detail="用户名或密码错误")

    expected_hash = hash_password(payload.password, user["salt"])
    if expected_hash != user["password_hash"]:
        raise HTTPException(status_code=401, detail="用户名或密码错误")

    # 发放 JWT
    token = create_jwt(
        {"sub": payload.username},
        secret=settings.JWT_SECRET,
        expires_minutes=settings.JWT_EXPIRE_MINUTES,
        algorithm=settings.JWT_ALGORITHM,
    )
    
    # 返回是否为管理员
    is_admin = user.get("is_admin", False)
    return MessageResponse(message = "登陆成功", data={"token": token, "token_type": "bearer", "is_admin": is_admin})

# 验证token，判断是否登陆，可直接使用utils/security里的get_current_user
@router.get("/me", response_model=MessageResponse)
async def me(credentials: HTTPAuthorizationCredentials = Depends(bearer)):
    token = credentials.credentials
    from utils.jwt import verify_jwt
    from config import settings
    try:
        payload = verify_jwt(token, secret=settings.JWT_SECRET, algorithms=[settings.JWT_ALGORITHM])
    except Exception:
        raise HTTPException(status_code=401, detail="无效或过期的 Token")
    username = payload.get("sub")
    return MessageResponse(message="OK", data={"username": username})

