from fastapi import APIRouter, Depends, HTTPException
from typing import List
from datetime import datetime, timezone
from bson import ObjectId
from collections import Counter

from database import (
    get_users_collection,
    get_owned_collection,
    get_pending_owned_collection,
    get_wanted_collection,
    send_system_message,
)
from model.common import MessageResponse
from model.admin import PendingOwnedResponse, ReviewRequest, BatchRejectRequest, BatchRejectCourtRequest
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
@router.get("/pending")
async def get_pending_list(admin_user: str = Depends(require_admin)):
    pending = get_pending_owned_collection()
    cursor = pending.find({"status": "pending"}).sort([("created_at", 1)])
    
    # 先收集所有待审核记录
    all_pending = []
    async for d in cursor:
        all_pending.append(d)
    
    # 统计每个序列号出现的次数（重复序列号）
    serial_counts = Counter(d["serial_number"] for d in all_pending)
    duplicate_serials = {sn for sn, count in serial_counts.items() if count > 1}
    
    # 统计每个场地+时间段出现的次数（相同场地不同序列号）
    def court_key(d):
        start_at = d.get("start_at")
        end_at = d.get("end_at")
        return (d["court_id"], start_at.isoformat() if start_at else "", end_at.isoformat() if end_at else "")
    
    court_counts = Counter(court_key(d) for d in all_pending)
    conflict_courts = {k for k, count in court_counts.items() if count > 1}
    
    results = []
    for d in all_pending:
        start_at = d.get("start_at")
        end_at = d.get("end_at")
        serial_number = d["serial_number"]
        ck = court_key(d)
        
        # 判断是否是场地冲突（相同场地+时间，不同序列号）
        is_court_conflict = ck in conflict_courts
        court_conflict_count = court_counts[ck] if is_court_conflict else 1
        
        results.append({
            "id": str(d["_id"]),
            "username": d["username"],
            "court_id": d["court_id"],
            "start_date": start_at.date().isoformat() if start_at else None,
            "start_hour": start_at.hour if start_at else 0,
            "end_hour": end_at.hour if end_at else 0,
            "serial_number": serial_number,
            "status": d["status"],
            "created_at": d["created_at"].isoformat() if d.get("created_at") else "",
            # 重复序列号
            "is_duplicate": serial_number in duplicate_serials,
            "duplicate_count": serial_counts[serial_number] if serial_number in duplicate_serials else 1,
            # 场地冲突（相同场地+时间，不同序列号）
            "is_court_conflict": is_court_conflict,
            "court_conflict_count": court_conflict_count
        })
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
        wanted = get_wanted_collection()
        
        owned_doc = {
            "username": doc["username"],
            "court_id": doc["court_id"],
            "start_at": doc["start_at"],
            "end_at": doc["end_at"],
            "serial_number": doc["serial_number"],
            "created_at": datetime.now(timezone.utc),
            "is_public": False  # 默认为下架状态，需用户手动发布
        }
        await owned.insert_one(owned_doc)
        
        # 删除用户对应的需求（如果有）
        await wanted.delete_many({
            "username": doc["username"],
            "court_id": doc["court_id"],
            "start_at": doc["start_at"]
        })
        
        # 检查是否有人需要这个场地，发送通知
        matching_wants = await wanted.find({
            "court_id": doc["court_id"],
            "start_at": doc["start_at"],
            "end_at": doc["end_at"]
        }).to_list(100)
        
        # 给场地发布者发送通知
        if matching_wants:
            await send_system_message(
                doc["username"],
                f"🎉 您的场地 {doc['court_id']} 审核通过！有 {len(matching_wants)} 位用户正在寻找此场地，快去上架吧！"
            )
        else:
            await send_system_message(
                doc["username"],
                f"✅ 您的场地 {doc['court_id']} 审核通过！可以前往主页上架到场地广场。"
            )
        
        # 给需要这个场地的用户发送通知
        for w in matching_wants:
            await send_system_message(
                w["username"],
                f"🔔 您需要的场地 {doc['court_id']} 刚刚有人发布了！发布者：{doc['username']}，快去看看吧！"
            )
        
        # 更新待审核状态
        await pending.update_one(
            {"_id": obj_id},
            {"$set": {
                "status": "approved",
                "reviewed_at": datetime.now(timezone.utc),
                "reviewed_by": admin_user
            }}
        )
        
        # 自动拒绝其他相同序列号的待审核申请
        serial_number = doc["serial_number"]
        reject_serial_result = await pending.update_many(
            {
                "serial_number": serial_number,
                "status": "pending",
                "_id": {"$ne": obj_id}  # 排除当前已通过的
            },
            {"$set": {
                "status": "rejected",
                "reviewed_at": datetime.now(timezone.utc),
                "reviewed_by": admin_user,
                "reject_reason": "相同序列号已被其他用户通过审核"
            }}
        )
        
        # 自动拒绝相同场地+时间段的其他申请（不同序列号）
        reject_court_result = await pending.update_many(
            {
                "court_id": doc["court_id"],
                "start_at": doc["start_at"],
                "end_at": doc["end_at"],
                "status": "pending",
                "_id": {"$ne": obj_id}
            },
            {"$set": {
                "status": "rejected",
                "reviewed_at": datetime.now(timezone.utc),
                "reviewed_by": admin_user,
                "reject_reason": "相同场地和时间段已被其他用户通过审核"
            }}
        )
        
        total_rejected = reject_serial_result.modified_count + reject_court_result.modified_count
        if total_rejected > 0:
            return MessageResponse(message=f"审核通过，已添加到已有场地。同时自动拒绝了 {total_rejected} 个冲突申请")
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

# 批量拒绝相同序列号的申请
@router.post("/batch-reject", response_model=MessageResponse)
async def batch_reject(payload: BatchRejectRequest, admin_user: str = Depends(require_admin)):
    pending = get_pending_owned_collection()
    
    result = await pending.update_many(
        {
            "serial_number": payload.serial_number,
            "status": "pending"
        },
        {"$set": {
            "status": "rejected",
            "reviewed_at": datetime.now(timezone.utc),
            "reviewed_by": admin_user,
            "reject_reason": "批量拒绝重复序列号"
        }}
    )
    
    if result.modified_count == 0:
        raise HTTPException(status_code=404, detail="没有找到待审核的申请")
    
    return MessageResponse(message=f"已批量拒绝 {result.modified_count} 个申请")

# 批量拒绝相同场地+时间的申请
@router.post("/batch-reject-court", response_model=MessageResponse)
async def batch_reject_court(payload: BatchRejectCourtRequest, admin_user: str = Depends(require_admin)):
    pending = get_pending_owned_collection()
    
    from datetime import time
    start_at = datetime.combine(payload.start_date, time(hour=payload.start_hour), tzinfo=timezone.utc)
    end_at = datetime.combine(payload.start_date, time(hour=payload.end_hour), tzinfo=timezone.utc)
    
    result = await pending.update_many(
        {
            "court_id": payload.court_id,
            "start_at": start_at,
            "end_at": end_at,
            "status": "pending"
        },
        {"$set": {
            "status": "rejected",
            "reviewed_at": datetime.now(timezone.utc),
            "reviewed_by": admin_user,
            "reject_reason": "批量拒绝场地冲突"
        }}
    )
    
    if result.modified_count == 0:
        raise HTTPException(status_code=404, detail="没有找到待审核的申请")
    
    return MessageResponse(message=f"已批量拒绝 {result.modified_count} 个申请")

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
