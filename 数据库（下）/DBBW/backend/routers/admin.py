from fastapi import APIRouter, Depends, HTTPException
from typing import List
from datetime import datetime, timezone
from bson import ObjectId

from database import (
    get_users_collection,
    get_owned_collection,
    get_pending_owned_collection,
)
from model.common import MessageResponse
from model.admin import PendingOwnedResponse, ReviewRequest
from utils.security import get_current_user

router = APIRouter(prefix="/admin", tags=["admin"])

async def require_admin(current_user: str = Depends(get_current_user)) -> str:
    """验证当前用户是否为管理员"""
    users = get_users_collection()
    user = await users.find_one({"username": current_user})
    if not user or not user.get("is_admin", False):
        raise HTTPException(status_code=403, detail="需要管理员权限")
    return current_user

# 获取待审核列表
@router.get("/pending", response_model=List[PendingOwnedResponse])
async def get_pending_list(admin_user: str = Depends(require_admin)):
    pending = get_pending_owned_collection()
    cursor = pending.find({"status": "pending"}).sort([("created_at", 1)])
    
    results = []
    async for d in cursor:
        start_at = d.get("start_at")
        end_at = d.get("end_at")
        results.append(
            PendingOwnedResponse(
                id=str(d["_id"]),
                username=d["username"],
                court_id=d["court_id"],
                start_date=start_at.date() if start_at else None,
                start_hour=start_at.hour if start_at else 0,
                end_hour=end_at.hour if end_at else 0,
                serial_number=d["serial_number"],
                status=d["status"],
                created_at=d["created_at"].isoformat() if d.get("created_at") else "",
            )
        )
    return results

# 审核场地
@router.post("/review", response_model=MessageResponse)
async def review_pending(payload: ReviewRequest, admin_user: str = Depends(require_admin)):
    pending = get_pending_owned_collection()
    
    try:
        obj_id = ObjectId(payload.pending_id)
    except:
        raise HTTPException(status_code=400, detail="无效的ID格式")
    
    doc = await pending.find_one({"_id": obj_id, "status": "pending"})
    if not doc:
        raise HTTPException(status_code=404, detail="待审核记录不存在或已处理")
    
    if payload.action == "approve":
        # 审核通过：添加到已有场地表
        owned = get_owned_collection()
        owned_doc = {
            "username": doc["username"],
            "court_id": doc["court_id"],
            "start_at": doc["start_at"],
            "end_at": doc["end_at"],
            "created_at": datetime.now(timezone.utc),
        }
        await owned.insert_one(owned_doc)
        
        # 更新待审核状态
        await pending.update_one(
            {"_id": obj_id},
            {"$set": {
                "status": "approved",
                "reviewed_at": datetime.now(timezone.utc),
                "reviewed_by": admin_user
            }}
        )
        return MessageResponse(message="审核通过，已添加到已有场地")
    else:
        # 审核拒绝
        await pending.update_one(
            {"_id": obj_id},
            {"$set": {
                "status": "rejected",
                "reviewed_at": datetime.now(timezone.utc),
                "reviewed_by": admin_user
            }}
        )
        return MessageResponse(message="已拒绝该申请")

# 获取所有审核记录（包括已处理的）
@router.get("/all-pending", response_model=List[PendingOwnedResponse])
async def get_all_pending(admin_user: str = Depends(require_admin)):
    pending = get_pending_owned_collection()
    cursor = pending.find().sort([("created_at", -1)]).limit(100)
    
    results = []
    async for d in cursor:
        start_at = d.get("start_at")
        end_at = d.get("end_at")
        results.append(
            PendingOwnedResponse(
                id=str(d["_id"]),
                username=d["username"],
                court_id=d["court_id"],
                start_date=start_at.date() if start_at else None,
                start_hour=start_at.hour if start_at else 0,
                end_hour=end_at.hour if end_at else 0,
                serial_number=d["serial_number"],
                status=d["status"],
                created_at=d["created_at"].isoformat() if d.get("created_at") else "",
            )
        )
    return results
