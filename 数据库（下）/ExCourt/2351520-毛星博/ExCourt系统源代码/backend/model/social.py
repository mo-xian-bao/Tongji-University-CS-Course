from pydantic import BaseModel, Field
from datetime import datetime
from typing import Optional

class FriendRequest(BaseModel):
    target_username: str = Field(..., min_length=2)

class ChatMessageRequest(BaseModel):
    receiver: str = Field(..., min_length=1)
    content: str = Field(..., min_length=1)

class ChatMessageResponse(BaseModel):
    id: str
    sender: str
    receiver: str
    content: str
    created_at: datetime