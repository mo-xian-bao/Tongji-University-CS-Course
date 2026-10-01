from pydantic import BaseModel, Field
from typing import Optional
from datetime import date

class PendingOwnedResponse(BaseModel):
    """待审核场地响应"""
    id: str  # MongoDB _id
    username: str
    court_id: int
    start_date: date
    start_hour: int
    end_hour: int
    serial_number: str
    status: str
    created_at: str

class ReviewRequest(BaseModel):
    """审核请求"""
    pending_id: str = Field(..., min_length=1)
    action: str = Field(..., pattern="^(approve|reject)$")  # approve 或 reject
