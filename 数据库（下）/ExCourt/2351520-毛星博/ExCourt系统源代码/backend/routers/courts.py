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
    SearchWantedResponse,
    TogglePublicRequest # 新增
)
from utils.security import get_current_user

router = APIRouter(prefix="/courts", tags=["courts"])

# 定义东八区时区
CN_TZ = timezone(timedelta(hours=8))

def hour_to_time(hour: int) -> time:
    """将整点小时转换为 time 对象"""
    return time(hour=hour, minute=0, second=0)

# 发布已有场地信息（提交待审核）
@router.post("/owned/post", response_model=MessageResponse)
async def post_owned(payload: PostOwnedRequest, current_user: str = Depends(get_current_user)):
    pending = get_pending_owned_collection()
    owned = get_owned_collection()
    
    # 检查序列号是否已被使用（只检查已通过审核的场地）
    existing_owned = await owned.find_one({"serial_number": payload.serial_number})
    if existing_owned:
        raise HTTPException(status_code=400, detail="该序列号已被使用")
    
    # 用户输入的是东八区时间，转换为 UTC 存储
    start_at_local = datetime.combine(payload.start_date, hour_to_time(payload.start_hour), tzinfo=CN_TZ)
    end_at_local = datetime.combine(payload.start_date, hour_to_time(payload.end_hour), tzinfo=CN_TZ)
    start_at = start_at_local.astimezone(timezone.utc)
    end_at = end_at_local.astimezone(timezone.utc)
    
    # 检查已审核通过的场地中是否存在相同时间相同场地编号
    existing_owned = await owned.find_one({
        "court_id": payload.court_id,
        "start_at": start_at,
        "end_at": end_at
    })
    if existing_owned:
        raise HTTPException(status_code=400, detail="该场地在此时间段已被发布")
    
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
    # 用户传入的是东八区时间
    start_at_local = datetime.combine(date_obj, hour_to_time(start_hour), tzinfo=CN_TZ)
    start_at = start_at_local.astimezone(timezone.utc)
    
    result = await owned.delete_one({
        "username": current_user,
        "court_id": court_id,
        "start_at": start_at
    })
    
    if result.deleted_count == 0:
        raise HTTPException(status_code=404, detail="场地不存在或无权删除")
    
    return MessageResponse(message="删除成功")

# 获取我的所有场地（包括上架和未上架）
@router.get("/owned/mine")
async def get_my_courts(current_user: str = Depends(get_current_user)):
    owned = get_owned_collection()
    now = datetime.now(CN_TZ)
    
    cursor = owned.find({"username": current_user}).sort([("start_at", 1)])
    results = []
    async for d in cursor:
        start_at_val = d.get("start_at")
        end_at_val = d.get("end_at")
        
        # 调试输出
        print(f"[DEBUG] Raw start_at: {start_at_val}, tzinfo: {start_at_val.tzinfo if start_at_val else None}")
        
        # MongoDB 返回的时间是 UTC，但可能没有 tzinfo，需要手动添加
        start_at_local = None
        end_at_local = None
        if start_at_val:
            # 先确保是 UTC 时间，再转换为东八区
            start_at_utc = start_at_val.replace(tzinfo=timezone.utc) if start_at_val.tzinfo is None else start_at_val
            start_at_local = start_at_utc.astimezone(CN_TZ)
            print(f"[DEBUG] UTC: {start_at_utc}, Local: {start_at_local}, Hour: {start_at_local.hour}")
        if end_at_val:
            end_at_utc = end_at_val.replace(tzinfo=timezone.utc) if end_at_val.tzinfo is None else end_at_val
            end_at_local = end_at_utc.astimezone(CN_TZ)
        
        # 判断是否已失效（开始时间已过）
        is_expired = start_at_local <= now if start_at_local else False
        
        # 如果已失效且还在上架状态，自动下架
        if is_expired and d.get("is_public", False):
            await owned.update_one({"_id": d["_id"]}, {"$set": {"is_public": False}})
        
        results.append({
            "court_id": d["court_id"],
            "start_date": start_at_local.date().isoformat() if start_at_local else None,
            "start_hour": start_at_local.hour if start_at_local else 0,
            "end_hour": end_at_local.hour if end_at_local else 0,
            "serial_number": d.get("serial_number", ""),
            "is_public": False if is_expired else d.get("is_public", False),
            "is_expired": is_expired,
        })
    return results

# 获取我的待审核场地
@router.get("/owned/pending")
async def get_my_pending(current_user: str = Depends(get_current_user)):
    pending = get_pending_owned_collection()
    cursor = pending.find({"username": current_user, "status": "pending"}).sort([("created_at", -1)])
    results = []
    async for d in cursor:
        start_at_val = d.get("start_at")
        end_at_val = d.get("end_at")
        
        # MongoDB 返回的时间可能没有 tzinfo，需要先添加 UTC 再转换为东八区
        if start_at_val:
            start_at_utc = start_at_val.replace(tzinfo=timezone.utc) if start_at_val.tzinfo is None else start_at_val
            start_at_val = start_at_utc.astimezone(CN_TZ)
        if end_at_val:
            end_at_utc = end_at_val.replace(tzinfo=timezone.utc) if end_at_val.tzinfo is None else end_at_val
            end_at_val = end_at_utc.astimezone(CN_TZ)
        
        results.append({
            "court_id": d["court_id"],
            "start_date": start_at_val.date().isoformat() if start_at_val else None,
            "start_hour": start_at_val.hour if start_at_val else 0,
            "end_hour": end_at_val.hour if end_at_val else 0,
            "status": d.get("status", "pending"),
            "serial_number": d.get("serial_number", ""),
            "created_at": d.get("created_at").isoformat() if d.get("created_at") else None,
        })
    return results

# 搜索已有场地信息
@router.post("/owned/search", response_model=List[SearchOwnedResponse])
async def search_owned(payload: SearchOwnedRequest, current_user: str = Depends(get_current_user)):
    owned = get_owned_collection()
    q = {}
    
    # 强制只显示公开的场地
    q["is_public"] = True 
    
    # 如果想搜特定的 court_id
    if payload.court_id is not None:
        q["court_id"] = payload.court_id
    
    # 使用东八区时间
    now = datetime.now(CN_TZ)

    # 时间过滤逻辑：确保只显示未来的场地
    if payload.start_date is not None and payload.start_hour is not None:
        # 构造查询时间时也带上时区
        target = datetime.combine(payload.start_date, hour_to_time(payload.start_hour), tzinfo=CN_TZ)
        if target <= now:
            return [] # 搜索时间已过期，直接返回空
        # 数据库存储的是 UTC 时间，所以查询时需要转换回 UTC，或者让 MongoDB 处理
        # 这里为了简单，我们假设数据库存的是带时区的时间或者 UTC 时间
        # 如果数据库存的是 UTC，我们需要把 target 转为 UTC
        q["start_at"] = target.astimezone(timezone.utc)
    elif payload.start_date is not None:
        start_day = datetime.combine(payload.start_date, time.min, tzinfo=CN_TZ)
        next_day = start_day + timedelta(days=1)
        
        # 确保搜索范围在当前时间之后
        actual_start = max(start_day, now)
        if actual_start >= next_day:
            return [] # 整天都已过期
            
        q["start_at"] = {"$gte": actual_start.astimezone(timezone.utc), "$lt": next_day.astimezone(timezone.utc)}
    else:
        # 未指定日期，默认只显示未来
        q["start_at"] = {"$gt": now.astimezone(timezone.utc)}
    
    if payload.end_hour is not None and payload.start_date is not None:
        end_at = datetime.combine(payload.start_date, hour_to_time(payload.end_hour), tzinfo=CN_TZ)
        q["end_at"] = end_at.astimezone(timezone.utc)

    cursor = owned.find(q).sort([("start_at", 1)])
    results = []
    async for d in cursor:
        # 排除自己的场地（可选，看需求）
        # if d["username"] == current_user: continue 
        
        start_at_val = d.get("start_at")
        end_at_val = d.get("end_at")
        
        # MongoDB 返回的时间可能没有 tzinfo，需要先添加 UTC 再转换为东八区
        if start_at_val:
            start_at_utc = start_at_val.replace(tzinfo=timezone.utc) if start_at_val.tzinfo is None else start_at_val
            start_at_val = start_at_utc.astimezone(CN_TZ)
             
        if end_at_val:
            end_at_utc = end_at_val.replace(tzinfo=timezone.utc) if end_at_val.tzinfo is None else end_at_val
            end_at_val = end_at_utc.astimezone(CN_TZ)

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
    # 用户输入的是东八区时间，转换为 UTC 存储
    start_at_local = datetime.combine(payload.start_date, hour_to_time(payload.start_hour), tzinfo=CN_TZ)
    end_at_local = datetime.combine(payload.start_date, hour_to_time(payload.end_hour), tzinfo=CN_TZ)
    start_at = start_at_local.astimezone(timezone.utc)
    end_at = end_at_local.astimezone(timezone.utc)
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
    # 用户传入的是东八区时间
    start_at_local = datetime.combine(date_obj, hour_to_time(start_hour), tzinfo=CN_TZ)
    start_at = start_at_local.astimezone(timezone.utc)
    
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
        
    now = datetime.now(CN_TZ)

    # 时间过滤逻辑：确保只显示未来的需求
    if payload.start_date is not None and payload.start_hour is not None:
        target = datetime.combine(payload.start_date, hour_to_time(payload.start_hour), tzinfo=CN_TZ)
        if target <= now:
            return []
        q["start_at"] = target.astimezone(timezone.utc)
    elif payload.start_date is not None:
        start_day = datetime.combine(payload.start_date, time.min, tzinfo=CN_TZ)
        next_day = start_day + timedelta(days=1)
        
        actual_start = max(start_day, now)
        if actual_start >= next_day:
            return []
            
        q["start_at"] = {"$gte": actual_start.astimezone(timezone.utc), "$lt": next_day.astimezone(timezone.utc)}
    else:
        q["start_at"] = {"$gt": now.astimezone(timezone.utc)}

    if payload.end_hour is not None and payload.start_date is not None:
        end_at = datetime.combine(payload.start_date, hour_to_time(payload.end_hour), tzinfo=CN_TZ)
        q["end_at"] = end_at.astimezone(timezone.utc)

    cursor = wanted.find(q).sort([("start_at", 1)])
    results = []
    async for d in cursor:
        start_at_val = d.get("start_at")
        end_at_val = d.get("end_at")
        
        # MongoDB 返回的时间可能没有 tzinfo，需要先添加 UTC 再转换为东八区
        if start_at_val:
            start_at_utc = start_at_val.replace(tzinfo=timezone.utc) if start_at_val.tzinfo is None else start_at_val
            start_at_val = start_at_utc.astimezone(CN_TZ)
        
        if end_at_val:
            end_at_utc = end_at_val.replace(tzinfo=timezone.utc) if end_at_val.tzinfo is None else end_at_val
            end_at_val = end_at_utc.astimezone(CN_TZ)
        
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

# 新增：切换上下架状态
@router.post("/owned/toggle-public", response_model=MessageResponse)
async def toggle_public(payload: TogglePublicRequest, current_user: str = Depends(get_current_user)):
    owned = get_owned_collection()
    
    # 用户传入的是东八区时间
    start_at_local = datetime.combine(payload.start_date, hour_to_time(payload.start_hour), tzinfo=CN_TZ)
    start_at = start_at_local.astimezone(timezone.utc)
    
    result = await owned.update_one(
        {
            "username": current_user,
            "court_id": payload.court_id,
            "start_at": start_at
        },
        {"$set": {"is_public": payload.is_public}}
    )
    
    if result.matched_count == 0:
        raise HTTPException(status_code=404, detail="场地不存在或无权操作")
        
    action = "发布" if payload.is_public else "下架"
    return MessageResponse(message=f"场地已{action}")

# 新增：获取我的场地列表（包含状态）
@router.get("/owned/my", response_model=List[dict])
async def get_my_owned(current_user: str = Depends(get_current_user)):
    owned = get_owned_collection()
    now = datetime.now(CN_TZ)
    
    cursor = owned.find({"username": current_user}).sort([("start_at", 1)])
    results = []
    async for d in cursor:
        start_at_val = d.get("start_at")
        end_at_val = d.get("end_at")
        
        # MongoDB 返回的时间是 UTC，转换为东八区
        start_at_local = None
        end_at_local = None
        if start_at_val:
            start_at_utc = start_at_val.replace(tzinfo=timezone.utc) if start_at_val.tzinfo is None else start_at_val
            start_at_local = start_at_utc.astimezone(CN_TZ)
        if end_at_val:
            end_at_utc = end_at_val.replace(tzinfo=timezone.utc) if end_at_val.tzinfo is None else end_at_val
            end_at_local = end_at_utc.astimezone(CN_TZ)
        
        # 判断是否已失效（开始时间已过）
        is_expired = start_at_local <= now if start_at_local else False
        
        # 如果已失效且还在上架状态，自动下架
        if is_expired and d.get("is_public", False):
            await owned.update_one({"_id": d["_id"]}, {"$set": {"is_public": False}})
        
        results.append({
            "court_id": d["court_id"],
            "start_date": start_at_local.date().isoformat() if start_at_local else None,
            "start_hour": start_at_local.hour if start_at_local else 0,
            "end_hour": end_at_local.hour if end_at_local else 0,
            "is_public": False if is_expired else d.get("is_public", False),
            "is_expired": is_expired,
            "serial_number": d.get("serial_number", "")
        })
    return results

# ==================== 智慧匹配功能 ====================

@router.post("/match/check-owned")
async def check_matching_owned(payload: PostWantedRequest, current_user: str = Depends(get_current_user)):
    """发布需求前检查是否有匹配的已有场地"""
    owned = get_owned_collection()
    
    # 用户输入的是东八区时间，转换为 UTC
    start_at_local = datetime.combine(payload.start_date, hour_to_time(payload.start_hour), tzinfo=CN_TZ)
    end_at_local = datetime.combine(payload.start_date, hour_to_time(payload.end_hour), tzinfo=CN_TZ)
    start_at = start_at_local.astimezone(timezone.utc)
    end_at = end_at_local.astimezone(timezone.utc)
    
    now = datetime.now(timezone.utc)
    
    # 查找匹配的已上架场地（排除自己的，排除已过期的）
    cursor = owned.find({
        "court_id": payload.court_id,
        "start_at": start_at,
        "end_at": end_at,
        "is_public": True,
        "username": {"$ne": current_user}
    })
    
    matches = []
    async for d in cursor:
        # 转换时间显示
        s = d.get("start_at")
        e = d.get("end_at")
        if s:
            s_local = s.replace(tzinfo=timezone.utc).astimezone(CN_TZ) if s.tzinfo is None else s.astimezone(CN_TZ)
        if e:
            e_local = e.replace(tzinfo=timezone.utc).astimezone(CN_TZ) if e.tzinfo is None else e.astimezone(CN_TZ)
        
        matches.append({
            "username": d["username"],
            "court_id": d["court_id"],
            "start_date": s_local.date().isoformat() if s else None,
            "start_hour": s_local.hour if s else 0,
            "end_hour": e_local.hour if e else 0
        })
    
    return {"matches": matches, "count": len(matches)}

@router.post("/match/check-wanted")
async def check_matching_wanted(court_id: int, start_date: str, start_hour: int, end_hour: int, current_user: str = Depends(get_current_user)):
    """发布场地后检查是否有匹配的需求"""
    wanted = get_wanted_collection()
    
    from datetime import datetime as dt
    date_obj = dt.fromisoformat(start_date).date()
    start_at_local = datetime.combine(date_obj, hour_to_time(start_hour), tzinfo=CN_TZ)
    end_at_local = datetime.combine(date_obj, hour_to_time(end_hour), tzinfo=CN_TZ)
    start_at = start_at_local.astimezone(timezone.utc)
    end_at = end_at_local.astimezone(timezone.utc)
    
    # 查找匹配的需求（排除自己的）
    cursor = wanted.find({
        "court_id": court_id,
        "start_at": start_at,
        "end_at": end_at,
        "username": {"$ne": current_user}
    })
    
    matches = []
    async for d in cursor:
        s = d.get("start_at")
        e = d.get("end_at")
        if s:
            s_local = s.replace(tzinfo=timezone.utc).astimezone(CN_TZ) if s.tzinfo is None else s.astimezone(CN_TZ)
        if e:
            e_local = e.replace(tzinfo=timezone.utc).astimezone(CN_TZ) if e.tzinfo is None else e.astimezone(CN_TZ)
        
        matches.append({
            "username": d["username"],
            "court_id": d["court_id"],
            "start_date": s_local.date().isoformat() if s else None,
            "start_hour": s_local.hour if s else 0,
            "end_hour": e_local.hour if e else 0
        })
    
    return {"matches": matches, "count": len(matches)}

@router.get("/match/mutual")
async def get_mutual_matches(current_user: str = Depends(get_current_user)):
    """获取双向匹配：我有A想要B，对方有B想要A"""
    owned = get_owned_collection()
    wanted = get_wanted_collection()
    now = datetime.now(timezone.utc)
    
    # 获取我的场地和需求
    my_owned = await owned.find({"username": current_user, "start_at": {"$gt": now}}).to_list(100)
    my_wanted = await wanted.find({"username": current_user, "start_at": {"$gt": now}}).to_list(100)
    
    if not my_owned or not my_wanted:
        return {"matches": []}
    
    matches = []
    
    # 对于我的每个需求，找有这个场地的人
    for want in my_wanted:
        # 找谁有我想要的场地
        owners = await owned.find({
            "court_id": want["court_id"],
            "start_at": want["start_at"],
            "end_at": want["end_at"],
            "username": {"$ne": current_user},
            "is_public": True
        }).to_list(100)
        
        for owner in owners:
            # 检查这个人是否需要我的某个场地
            for my_court in my_owned:
                their_want = await wanted.find_one({
                    "username": owner["username"],
                    "court_id": my_court["court_id"],
                    "start_at": my_court["start_at"],
                    "end_at": my_court["end_at"]
                })
                
                if their_want:
                    # 找到双向匹配！
                    # 转换时间
                    def to_local(dt_val):
                        if dt_val is None:
                            return None, 0
                        dt_utc = dt_val.replace(tzinfo=timezone.utc) if dt_val.tzinfo is None else dt_val
                        dt_local = dt_utc.astimezone(CN_TZ)
                        return dt_local.date().isoformat(), dt_local.hour
                    
                    my_want_date, my_want_hour = to_local(want["start_at"])
                    my_court_date, my_court_hour = to_local(my_court["start_at"])
                    
                    matches.append({
                        "target_user": owner["username"],
                        "i_want": {
                            "court_id": want["court_id"],
                            "date": my_want_date,
                            "start_hour": my_want_hour
                        },
                        "i_have": {
                            "court_id": my_court["court_id"],
                            "date": my_court_date,
                            "start_hour": my_court_hour
                        }
                    })
    
    return {"matches": matches, "count": len(matches)}
