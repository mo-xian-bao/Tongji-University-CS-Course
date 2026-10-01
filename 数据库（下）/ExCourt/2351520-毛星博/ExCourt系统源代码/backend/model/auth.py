from pydantic import BaseModel,Field

class UserRegisterRequest(BaseModel):
    """用户注册请求"""
    username: str = Field(..., min_length=2, max_length=50)
    password: str = Field(..., min_length=6, max_length=100)

class UserLoginRequest(BaseModel):
    """用户登录请求"""
    username: str
    password: str