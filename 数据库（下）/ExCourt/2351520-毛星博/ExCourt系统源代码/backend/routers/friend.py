from fastapi import APIRouter, Depends, HTTPException
from datetime import datetime, timezone
from database import get_database
from utils.security import get_current_user
from model.common import MessageResponse
from model.friend import FriendRequest, FriendInfo

router = APIRouter(prefix="/friends", tags=["friends"])

@router.post("/request", response_model=MessageResponse)
async def send_friend_request(payload: FriendRequest, current_user: str = Depends(get_current_user)):
    db = get_database()
    friends = db["friends"]
    users = db["users"]

    if current_user == payload.target_username:
        raise HTTPException(400, "不能添加自己为好友")

    # 检查用户是否存在
    target = await users.find_one({"username": payload.target_username})
    if not target:
        raise HTTPException(404, "用户不存在")

    # 检查关系状态
    existing = await friends.find_one({
        "$or": [
            {"requester": current_user, "receiver": payload.target_username},
            {"requester": payload.target_username, "receiver": current_user}
        ]
    })
    
    if existing:
        if existing["status"] == "accepted":
            return MessageResponse(message="你们已经是好友了")
        return MessageResponse(message="好友申请已存在，请勿重复发送")

    await friends.insert_one({
        "requester": current_user,
        "receiver": payload.target_username,
        "status": "pending",
        "created_at": datetime.now(timezone.utc)
    })
    return MessageResponse(message="好友申请已发送")

@router.get("/list", response_model=list[FriendInfo])
async def get_friends(current_user: str = Depends(get_current_user)):
    db = get_database()
    friends = db["friends"]
    
    cursor = friends.find({
        "$or": [{"requester": current_user}, {"receiver": current_user}]
    })
    
    results = []
    async for doc in cursor:
        if doc["status"] == "accepted":
            # 确定对方的名字
            friend_name = doc["receiver"] if doc["requester"] == current_user else doc["requester"]
            results.append(FriendInfo(username=friend_name, status="friend"))
        elif doc["status"] == "pending":
            if doc["requester"] == current_user:
                results.append(FriendInfo(username=doc["receiver"], status="pending_sent"))
            else:
                results.append(FriendInfo(username=doc["requester"], status="pending_received"))
                
    return results

@router.post("/accept", response_model=MessageResponse)
async def accept_friend(payload: FriendRequest, current_user: str = Depends(get_current_user)):
    """接受好友请求（payload.target_username 是发起申请的人）"""
    db = get_database()
    friends = db["friends"]
    
    result = await friends.update_one(
        {
            "requester": payload.target_username, 
            "receiver": current_user,
            "status": "pending"
        },
        {"$set": {"status": "accepted", "accepted_at": datetime.now(timezone.utc)}}
    )
    
    if result.modified_count == 0:
        raise HTTPException(400, "未找到对应的好友申请")
        
    return MessageResponse(message="已添加好友")

@router.post("/delete", response_model=MessageResponse)
async def delete_friend(payload: FriendRequest, current_user: str = Depends(get_current_user)):
    """删除好友"""
    db = get_database()
    friends = db["friends"]
    
    result = await friends.delete_one({
        "$or": [
            {"requester": current_user, "receiver": payload.target_username, "status": "accepted"},
            {"requester": payload.target_username, "receiver": current_user, "status": "accepted"}
        ]
    })
    
    if result.deleted_count == 0:
        raise HTTPException(400, "未找到该好友关系")
        
    return MessageResponse(message="已删除好友")