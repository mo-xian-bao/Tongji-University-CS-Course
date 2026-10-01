from fastapi import APIRouter, Depends, HTTPException
from datetime import datetime, timezone
from database import get_database
from utils.security import get_current_user
from model.common import MessageResponse
from model.social import FriendRequest, ChatMessageRequest, ChatMessageResponse

router = APIRouter(prefix="/social", tags=["social"])

# --- 用户搜索 ---

@router.get("/users/search")
async def search_user(username: str, current_user: str = Depends(get_current_user)):
    """搜索用户"""
    db = get_database()
    
    user = await db.users.find_one({"username": username})
    if not user:
        return {"found": False}
    
    # 检查好友关系
    friend_doc = await db.friends.find_one({
        "$or": [
            {"requester": current_user, "receiver": username},
            {"requester": username, "receiver": current_user}
        ]
    })
    
    is_friend = friend_doc and friend_doc.get("status") == "accepted"
    pending = friend_doc and friend_doc.get("status") == "pending"
    
    return {
        "found": True,
        "username": username,
        "is_friend": is_friend,
        "pending": pending
    }

# --- 好友功能 ---

@router.post("/friends/request", response_model=MessageResponse)
async def send_friend_request(payload: FriendRequest, current_user: str = Depends(get_current_user)):
    db = get_database()
    if current_user == payload.target_username:
        raise HTTPException(400, "不能添加自己")
    
    target = await db.users.find_one({"username": payload.target_username})
    if not target:
        raise HTTPException(404, "用户不存在")

    existing = await db.friends.find_one({
        "$or": [
            {"requester": current_user, "receiver": payload.target_username},
            {"requester": payload.target_username, "receiver": current_user}
        ]
    })
    if existing:
        return MessageResponse(message="关系或申请已存在")

    await db.friends.insert_one({
        "requester": current_user,
        "receiver": payload.target_username,
        "status": "pending",
        "created_at": datetime.now(timezone.utc)
    })
    return MessageResponse(message="好友申请已发送")

@router.get("/friends/list")
async def get_friends(current_user: str = Depends(get_current_user)):
    db = get_database()
    cursor = db.friends.find({
        "$or": [{"requester": current_user}, {"receiver": current_user}],
        "status": "accepted"
    })
    friends = []
    async for doc in cursor:
        name = doc["receiver"] if doc["requester"] == current_user else doc["requester"]
        friends.append({"username": name})
    return friends

@router.get("/requests/pending")
async def get_pending_requests(current_user: str = Depends(get_current_user)):
    """获取收到的好友申请"""
    db = get_database()
    cursor = db.friends.find({"receiver": current_user, "status": "pending"})
    reqs = []
    async for doc in cursor:
        reqs.append({"id": str(doc["_id"]), "username": doc["requester"], "type": "friend"})
    return reqs

@router.post("/friends/accept", response_model=MessageResponse)
async def accept_friend(payload: FriendRequest, current_user: str = Depends(get_current_user)):
    db = get_database()
    result = await db.friends.update_one(
        {"requester": payload.target_username, "receiver": current_user, "status": "pending"},
        {"$set": {"status": "accepted", "accepted_at": datetime.now(timezone.utc)}}
    )
    if result.modified_count == 0:
        raise HTTPException(400, "申请不存在")
    return MessageResponse(message="已添加好友")

@router.post("/friends/delete", response_model=MessageResponse)
async def delete_friend(payload: FriendRequest, current_user: str = Depends(get_current_user)):
    """删除好友"""
    db = get_database()
    result = await db.friends.delete_one({
        "$or": [
            {"requester": current_user, "receiver": payload.target_username, "status": "accepted"},
            {"requester": payload.target_username, "receiver": current_user, "status": "accepted"}
        ]
    })
    if result.deleted_count == 0:
        raise HTTPException(400, "未找到该好友关系")
    return MessageResponse(message="已删除好友")

# --- 聊天功能 ---

@router.post("/chat/send", response_model=ChatMessageResponse)
async def send_message(payload: ChatMessageRequest, current_user: str = Depends(get_current_user)):
    db = get_database()
    doc = {
        "sender": current_user,
        "receiver": payload.receiver,
        "content": payload.content,
        "created_at": datetime.now(timezone.utc),
        "read": False
    }
    result = await db.messages.insert_one(doc)
    return ChatMessageResponse(
        id=str(result.inserted_id),
        sender=current_user,
        receiver=payload.receiver,
        content=payload.content,
        created_at=doc["created_at"]
    )

@router.get("/chat/history", response_model=list[ChatMessageResponse])
async def get_history(target_user: str, current_user: str = Depends(get_current_user)):
    db = get_database()
    cursor = db.messages.find({
        "$or": [
            {"sender": current_user, "receiver": target_user},
            {"sender": target_user, "receiver": current_user}
        ]
    }).sort("created_at", 1)
    
    results = []
    async for doc in cursor:
        results.append(ChatMessageResponse(
            id=str(doc["_id"]),
            sender=doc["sender"],
            receiver=doc["receiver"],
            content=doc["content"],
            created_at=doc["created_at"]
        ))
    return results

@router.get("/chat/conversations")
async def get_conversations(current_user: str = Depends(get_current_user)):
    """获取最近会话列表"""
    db = get_database()
    pipeline = [
        {"$match": {"$or": [{"sender": current_user}, {"receiver": current_user}]}},
        {"$sort": {"created_at": -1}},
        {"$group": {
            "_id": {
                "$cond": [{"$eq": ["$sender", current_user]}, "$receiver", "$sender"]
            },
            "last_message": {"$first": "$content"},
            "last_time": {"$first": "$created_at"}
        }}
    ]
    conversations = []
    async for doc in db.messages.aggregate(pipeline):
        last_time = doc["last_time"]
        # 确保时间带有时区信息
        if last_time and last_time.tzinfo is None:
            last_time = last_time.replace(tzinfo=timezone.utc)
        conversations.append({
            "username": doc["_id"],
            "last_message": doc["last_message"],
            "last_time": last_time.isoformat() if last_time else None
        })
    return conversations