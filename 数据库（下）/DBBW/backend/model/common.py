from pydantic import BaseModel
from typing import Optional

# ========== 通用响应 ==========
class MessageResponse(BaseModel):
    """通用消息响应"""
    message: str
    data: Optional[dict] = None