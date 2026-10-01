from pydantic import BaseModel,Field,validator
from typing import Optional
from datetime import date,time

class ExchangeRequest(BaseModel):
    post_user_name: str = Field(..., min_length=2, max_length=50)
    request_user_name: str = Field(..., min_length=2, max_length=50)# 这个可以直接在后端获取当前用户，需要吗
    court_id: int = Field(..., ge=0, le=1000)

class ExchangeResponse(BaseModel):
    post_user_name: str = Field(..., min_length=2, max_length=50)
    request_user_name: str = Field(..., min_length=2, max_length=50)
    court_id: int = Field(..., ge=0, le=1000)

class DirectExchangeRequest(BaseModel):
    """直接交换请求"""
    target_user: str = Field(..., min_length=2, max_length=50)  # 对方用户名
    my_court_id: int = Field(..., ge=0, le=1000)  # 我的场地ID
    their_court_id: int = Field(..., ge=0, le=1000)  # 对方的场地ID

