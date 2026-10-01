from fastapi import Depends, HTTPException
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials

from config import settings
from utils.jwt import verify_jwt
from database import get_users_collection


bearer_scheme = HTTPBearer(auto_error=True)


async def get_current_user(credentials: HTTPAuthorizationCredentials = Depends(bearer_scheme)) -> str:
    token = credentials.credentials
    try:
        payload = verify_jwt(token, secret=settings.JWT_SECRET, algorithms=[settings.JWT_ALGORITHM])
    except Exception:
        raise HTTPException(status_code=401, detail="无效或过期的 Token")

    username = payload.get("sub")
    if not username:
        raise HTTPException(status_code=401, detail="Token 缺少主体信息")

    users = get_users_collection()
    user = await users.find_one({"username": username})
    if not user:
        raise HTTPException(status_code=401, detail="用户不存在或已被删除")
    return username


