from pydantic import BaseModel, Field
from typing import List

class FriendRequest(BaseModel):
    target_username: str = Field(..., min_length=2)

class FriendInfo(BaseModel):
    username: str
    status: str # 'friend', 'pending_sent', 'pending_received'