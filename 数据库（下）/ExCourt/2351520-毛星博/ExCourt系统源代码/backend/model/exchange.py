from pydantic import BaseModel, Field
from typing import Optional

class ExchangeRequest(BaseModel):
    """发起交换请求（我想要你的场地）"""
    post_user_name: str = Field(..., min_length=2, max_length=50) # 对方用户名
    court_id: int = Field(..., ge=0, le=1000)
    date: str = Field(..., pattern=r"^\d{4}-\d{2}-\d{2}$") # YYYY-MM-DD
    start_hour: int = Field(..., ge=0, le=23)
    end_hour: int = Field(..., ge=0, le=23)
    points: int = Field(0, ge=0, description="愿意支付的积分")

class ExchangeResponse(BaseModel):
    post_user_name: str
    request_user_name: str
    court_id: int

class DirectExchangeRequest(BaseModel):
    """直接交换请求（我用我的A换你的B）"""
    target_user: str = Field(..., min_length=2, max_length=50)
    
    # 我的场地信息
    my_court_id: int = Field(..., ge=0, le=1000)
    my_date: str = Field(..., pattern=r"^\d{4}-\d{2}-\d{2}$")
    my_start_hour: int = Field(..., ge=0, le=23)
    
    # 对方场地信息
    their_court_id: int = Field(..., ge=0, le=1000)
    their_date: str = Field(..., pattern=r"^\d{4}-\d{2}-\d{2}$")
    their_start_hour: int = Field(..., ge=0, le=23)

class FulfillRequest(BaseModel):
    """直接转让（我有场地，直接给需要的人）"""
    target_user: str = Field(..., min_length=2, max_length=50)
    court_id: int = Field(..., ge=0, le=1000)
    date: str = Field(..., pattern=r"^\d{4}-\d{2}-\d{2}$")
    start_hour: int = Field(..., ge=0, le=23)

class HandleRequest(BaseModel):
    """处理请求"""
    request_id: str = Field(..., min_length=1)