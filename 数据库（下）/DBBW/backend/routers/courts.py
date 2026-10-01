from fastapi import APIRouter, Depends, HTTPException
from typing import List
from datetime import datetime, timezone, time, timedelta

from database import (
    get_owned_collection,
    get_wanted_collection,
    get_pending_owned_collection,
)
from model.common import MessageResponse
from model.courts import (
    PostOwnedRequest,
    SearchOwnedRequest,
    SearchOwnedResponse,
    PostWantedRequest,
    SearchWantedRequest,
    SearchWantedResponse
)
from utils.security import get_current_user

router = APIRouter(prefix="/courts", tags=["courts"])

def hour_to_time(hour: int) -> time:
    """将整点小时转换为 time 对象"""
    return time(hour=hour, minute=0, second=0)

# 发布已有场地信息（提交待审核）
@router.post("/owned/post", response_model=MessageResponse)
async def post_owned(payload: PostOwnedRequest, current_user: str = Depends(get_current_user)):
    pending = get_pending_owned_collection()
    
    # 检查序列号是否已被使用
    existing = await pending.find_one({"serial_number": payload.serial_number})
    if existing:
        raise HTTPException(status_code=400, detail="该序列号已被使用")
    
    start_at = datetime.combine(payload.start_date, hour_to_time(payload.start_hour), tzinfo=timezone.utc)
    end_at = datetime.combine(payload.start_date, hour_to_time(payload.end_hour), tzinfo=timezone.utc)
    
    doc = {
        "username": current_user,
        "court_id": payload.court_id,
        "start_at": start_at,
        "end_at": end_at,
        "serial_number": payload.serial_number,
        "status": "pending",
        "created_at": datetime.now(timezone.utc),
    }
    await pending.insert_one(doc)
    return MessageResponse(message="已提交审核，请等待管理员审核")

# 删除已有场地信息
@router.delete("/owned/delete", response_model=MessageResponse)
async def delete_owned(court_id: int, start_date: str, start_hour: int, current_user: str = Depends(get_current_user)):
    owned = get_owned_collection()
    
    from datetime import datetime as dt
    date_obj = dt.fromisoformat(start_date).date()
    start_at = datetime.combine(date_obj, hour_to_time(start_hour), tzinfo=timezone.utc)
    
    result = await owned.delete_one({
        "username": current_user,
        "court_id": court_id,
        "start_at": start_at
    })
    
    if result.deleted_count == 0:
        raise HTTPException(status_code=404, detail="场地不存在或无权删除")
    
    return MessageResponse(message="删除成功")

# 搜索已有场地信息
@router.post("/owned/search", response_model=List[SearchOwnedResponse])
async def search_owned(payload: SearchOwnedRequest):
    owned = get_owned_collection()
    q = {}
    if payload.court_id is not None:
        q["court_id"] = payload.court_id
    
    if payload.start_date is not None and payload.start_hour is not None:
        q["start_at"] = datetime.combine(payload.start_date, hour_to_time(payload.start_hour), tzinfo=timezone.utc)
    elif payload.start_date is not None:
        start_day = datetime.combine(payload.start_date, time.min, tzinfo=timezone.utc)
        next_day = start_day + timedelta(days=1)
        q["start_at"] = {"$gte": start_day, "$lt": next_day}
    
    if payload.end_hour is not None and payload.start_date is not None:
        q["end_at"] = datetime.combine(payload.start_date, hour_to_time(payload.end_hour), tzinfo=timezone.utc)

    cursor = owned.find(q).sort([("start_at", 1)])
    results = []
    async for d in cursor:
        start_at_val = d.get("start_at")
        end_at_val = d.get("end_at")
        results.append(
            SearchOwnedResponse(
                owned_user_name=d["username"],
                court_id=d["court_id"],
                start_date=start_at_val.date() if start_at_val else None,
                start_hour=start_at_val.hour if start_at_val else 0,
                end_hour=end_at_val.hour if end_at_val else 0,
            )
        )
    return results

# 发布需求场地信息
@router.post("/wanted/post", response_model=MessageResponse)
async def post_wanted(payload: PostWantedRequest, current_user: str = Depends(get_current_user)):
    wanted = get_wanted_collection()
    start_at = datetime.combine(payload.start_date, hour_to_time(payload.start_hour), tzinfo=timezone.utc)
    end_at = datetime.combine(payload.start_date, hour_to_time(payload.end_hour), tzinfo=timezone.utc)
    doc = {
        "username": current_user,
        "court_id": payload.court_id,
        "start_at": start_at,
        "end_at": end_at,
        "created_at": datetime.now(timezone.utc),
    }
    await wanted.insert_one(doc)
    return MessageResponse(message="发布需求场地成功")

# 删除需求场地信息
@router.delete("/wanted/delete", response_model=MessageResponse)
async def delete_wanted(court_id: int, start_date: str, start_hour: int, current_user: str = Depends(get_current_user)):
    wanted = get_wanted_collection()
    
    from datetime import datetime as dt
    date_obj = dt.fromisoformat(start_date).date()
    start_at = datetime.combine(date_obj, hour_to_time(start_hour), tzinfo=timezone.utc)
    
    result = await wanted.delete_one({
        "username": current_user,
        "court_id": court_id,
        "start_at": start_at
    })
    
    if result.deleted_count == 0:
        raise HTTPException(status_code=404, detail="需求不存在或无权删除")
    
    return MessageResponse(message="删除成功")

# 搜索需求场地信息
@router.post("/wanted/search", response_model=List[SearchWantedResponse])
async def search_wanted(payload: SearchWantedRequest):
    wanted = get_wanted_collection()
    q = {}
    if payload.court_id is not None:
        q["court_id"] = payload.court_id
    if payload.start_date is not None and payload.start_hour is not None:
        q["start_at"] = datetime.combine(payload.start_date, hour_to_time(payload.start_hour), tzinfo=timezone.utc)
    elif payload.start_date is not None:
        start_day = datetime.combine(payload.start_date, time.min, tzinfo=timezone.utc)
        next_day = start_day + timedelta(days=1)
        q["start_at"] = {"$gte": start_day, "$lt": next_day}
    if payload.end_hour is not None and payload.start_date is not None:
        q["end_at"] = datetime.combine(payload.start_date, hour_to_time(payload.end_hour), tzinfo=timezone.utc)

    cursor = wanted.find(q).sort([("start_at", 1)])
    results = []
    async for d in cursor:
        start_at_val = d.get("start_at")
        end_at_val = d.get("end_at")
        results.append(
            SearchWantedResponse(
                wanted_user_name=d["username"],
                court_id=d["court_id"],
                start_date=start_at_val.date() if start_at_val else None,
                start_hour=start_at_val.hour if start_at_val else 0,
                end_hour=end_at_val.hour if end_at_val else 0,
            )
        )
    return results
