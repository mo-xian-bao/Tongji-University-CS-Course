from fastapi import APIRouter, Depends, HTTPException
from datetime import datetime, timezone, time, timedelta
from bson import ObjectId
from model.exchange import ExchangeRequest, DirectExchangeRequest, FulfillRequest, HandleRequest
from model.common import MessageResponse
from utils.security import get_current_user
from database import get_exchange_collection, get_owned_collection, get_wanted_collection, get_users_collection, send_system_message
import random
import string

router = APIRouter(prefix="/exchange", tags=["exchange"])

# 定义东八区时区
CN_TZ = timezone(timedelta(hours=8))

def generate_serial_number() -> str:
    """生成6位随机序列号"""
    return ''.join(random.choices(string.ascii_uppercase + string.digits, k=6))

async def _require_user(current_user: str) -> str:
    return current_user

def get_datetime(date_str: str, hour: int) -> datetime:
    """将用户输入的东八区时间转换为 UTC 存储"""
    d = datetime.strptime(date_str, "%Y-%m-%d").date()
    # 用户输入的是东八区时间
    local_dt = datetime.combine(d, time(hour=hour), tzinfo=CN_TZ)
    # 转换为 UTC 存储
    return local_dt.astimezone(timezone.utc)

@router.post("/request", response_model=MessageResponse)
async def ExchangeReq(payload: ExchangeRequest, current_user: str = Depends(get_current_user)):
    """发起申请：我想要对方的场地"""
    username = await _require_user(current_user)
    exchange = get_exchange_collection()
    owned = get_owned_collection()
    users = get_users_collection()

    # 0. 检查积分是否足够
    if payload.points > 0:
        user_doc = await users.find_one({"username": username})
        if not user_doc or user_doc.get("points", 0) < payload.points:
            raise HTTPException(400, "您的积分不足")

    start_at = get_datetime(payload.date, payload.start_hour)
    
    # 1. 验证对方是否拥有该场地
    target_court = await owned.find_one({
        "username": payload.post_user_name,
        "court_id": payload.court_id,
        "start_at": start_at
    })
    if not target_court:
        raise HTTPException(404, "对方在该时间段不拥有此场地")

    # 2. 检查是否重复申请
    exists = await exchange.find_one({
        "post_user_name": payload.post_user_name,
        "request_user_name": username,
        "court_id": payload.court_id,
        "start_at": start_at,
        "status": "pending"
    })
    if exists:
        raise HTTPException(400, "您已发起过申请")

    # 3. 创建申请
    doc = {
        "post_user_name": payload.post_user_name,
        "request_user_name": username,
        "court_id": payload.court_id,
        "start_at": start_at,
        "end_at": target_court["end_at"],
        "status": "pending",
        "created_at": datetime.now(timezone.utc),
        "type": "request",
        "offer_points": payload.points
    }
    await exchange.insert_one(doc)
    return MessageResponse(message="申请已发送")

@router.post("/direct", response_model=MessageResponse)
async def DirectExchange(payload: DirectExchangeRequest, current_user: str = Depends(get_current_user)):
    """直接交换：我用A换你的B（双方都同意或符合需求）"""
    username = await _require_user(current_user)
    if username == payload.target_user:
        raise HTTPException(400, "不能与自己交换")

    owned = get_owned_collection()
    wanted = get_wanted_collection()
    exchange = get_exchange_collection()

    my_start = get_datetime(payload.my_date, payload.my_start_hour)
    their_start = get_datetime(payload.their_date, payload.their_start_hour)

    # 1. 验证我的场地
    my_court = await owned.find_one({
        "username": username, 
        "court_id": payload.my_court_id,
        "start_at": my_start
    })
    if not my_court:
        raise HTTPException(404, "您没有该时间段的场地")

    # 2. 验证对方的场地
    their_court = await owned.find_one({
        "username": payload.target_user,
        "court_id": payload.their_court_id,
        "start_at": their_start
    })
    if not their_court:
        raise HTTPException(404, "对方没有该时间段的场地")

    # 3. 验证对方是否需要我的场地
    their_want = await wanted.find_one({
        "username": payload.target_user,
        "court_id": payload.my_court_id,
        "start_at": my_start
    })
    if not their_want:
        # NEW LOGIC: Create exchange offer request
        # Check for existing pending offer
        existing_offer = await exchange.find_one({
            "post_user_name": payload.target_user,
            "request_user_name": username,
            "court_id": payload.their_court_id,
            "start_at": their_start,
            "type": "exchange_offer",
            "status": "pending"
        })
        if existing_offer:
             raise HTTPException(400, "您已发送过交换申请")

        doc = {
            "post_user_name": payload.target_user, # Target (Them)
            "request_user_name": username,         # Requester (Me)
            "court_id": payload.their_court_id,    # Their Court (I want this)
            "start_at": their_start,               # Their Court Time
            "end_at": their_court["end_at"],
            
            "offer_court_id": payload.my_court_id, # My Court (I offer this)
            "offer_start_at": my_start,            # My Court Time
            "offer_end_at": my_court["end_at"],
            
            "status": "pending",
            "created_at": datetime.now(timezone.utc),
            "type": "exchange_offer",
            "offer_points": 0 
        }
        await exchange.insert_one(doc)
        return MessageResponse(message="对方未发布需求，已发送交换申请")

    # 4. 执行交换
    # 4.1 交换所有权
    await owned.update_one({"_id": my_court["_id"]}, {"$set": {"username": payload.target_user}})
    await owned.update_one({"_id": their_court["_id"]}, {"$set": {"username": username}})

    # 4.2 清理需求
    await wanted.delete_one({"_id": their_want["_id"]})
    # 检查我是否也发布了需求
    await wanted.delete_many({
        "username": username,
        "court_id": payload.their_court_id,
        "start_at": their_start
    })

    # 5. 记录历史
    log = {
        "user_a": username,
        "court_a": payload.my_court_id,
        "user_b": payload.target_user,
        "court_b": payload.their_court_id,
        "type": "direct_exchange",
        "status": "completed",
        "created_at": datetime.now(timezone.utc)
    }
    await exchange.insert_one(log)

    # 6. 更新积分 (双方各 +3 分)
    users = get_users_collection()
    await users.update_one({"username": username}, {"$inc": {"points": 3}})
    await users.update_one({"username": payload.target_user}, {"$inc": {"points": 3}})

    # 7. 发送消息通知
    await send_system_message(
        username,
        f"🔄 交换成功！您用场地 {payload.my_court_id} 换取了 {payload.target_user} 的场地 {payload.their_court_id}，积分+3"
    )
    await send_system_message(
        payload.target_user,
        f"🔄 交换成功！{username} 用场地 {payload.my_court_id} 换取了您的场地 {payload.their_court_id}，积分+3"
    )

    return MessageResponse(message="交换成功，积分+3")

@router.post("/fulfill", response_model=MessageResponse)
async def FulfillRequest(payload: FulfillRequest, current_user: str = Depends(get_current_user)):
    """直接转让：我有场地，直接给需要的人"""
    username = await _require_user(current_user)
    owned = get_owned_collection()
    wanted = get_wanted_collection()
    exchange = get_exchange_collection()

    start_at = get_datetime(payload.date, payload.start_hour)

    # 1. 验证我的场地
    my_court = await owned.find_one({
        "username": username,
        "court_id": payload.court_id,
        "start_at": start_at
    })
    if not my_court:
        raise HTTPException(404, "您没有该时间段的场地")

    # 2. 验证对方需求
    their_want = await wanted.find_one({
        "username": payload.target_user,
        "court_id": payload.court_id,
        "start_at": start_at
    })
    if not their_want:
        raise HTTPException(400, "对方并不需要该时间段的场地")

    # 3. 转让
    await owned.update_one({"_id": my_court["_id"]}, {"$set": {"username": payload.target_user}})
    await wanted.delete_one({"_id": their_want["_id"]})

    # 4. 记录
    await exchange.insert_one({
        "from_user": username,
        "to_user": payload.target_user,
        "court_id": payload.court_id,
        "type": "fulfill",
        "status": "completed",
        "created_at": datetime.now(timezone.utc)
    })

    # 5. 更新积分 (赠送方 +10 分)
    users = get_users_collection()
    await users.update_one({"username": username}, {"$inc": {"points": 10}})

    return MessageResponse(message="转让成功，积分+10")

@router.get("/pending", response_model=list[dict])
async def GetPendingRequests(current_user: str = Depends(get_current_user)):
    """获取待处理请求"""
    username = await _require_user(current_user)
    exchange = get_exchange_collection()
    
    cursor = exchange.find({
        "$or": [{"post_user_name": username}, {"request_user_name": username}],
        "status": "pending"
    }).sort("created_at", -1)
    
    results = []
    async for doc in cursor:
        doc["id"] = str(doc["_id"])
        del doc["_id"]
        results.append(doc)
    return results

@router.post("/accept", response_model=MessageResponse)
async def AcceptRequest(payload: HandleRequest, current_user: str = Depends(get_current_user)):
    """同意申请"""
    username = await _require_user(current_user)
    exchange = get_exchange_collection()
    owned = get_owned_collection()
    wanted = get_wanted_collection()
    users = get_users_collection()

    try:
        oid = ObjectId(payload.request_id)
    except:
        raise HTTPException(400, "无效ID")

    req = await exchange.find_one({"_id": oid, "status": "pending"})
    if not req:
        raise HTTPException(404, "请求不存在")
    
    if req["post_user_name"] != username:
        raise HTTPException(403, "无权操作")

    # NEW LOGIC: Handle Exchange Offer
    if req.get("type") == "exchange_offer":
        # 1. Verify I (post_user) still have the court they want (req["court_id"])
        my_court = await owned.find_one({
            "username": username,
            "court_id": req["court_id"],
            "start_at": req["start_at"]
        })
        if not my_court:
             await exchange.update_one({"_id": oid}, {"$set": {"status": "failed", "note": "您的场地已失效"}})
             raise HTTPException(404, "您的场地已失效，无法交换")
             
        # 2. Verify They (request_user) still have the court they offered (req["offer_court_id"])
        their_court = await owned.find_one({
            "username": req["request_user_name"],
            "court_id": req["offer_court_id"],
            "start_at": req["offer_start_at"]
        })
        if not their_court:
             await exchange.update_one({"_id": oid}, {"$set": {"status": "failed", "note": "对方场地已失效"}})
             raise HTTPException(404, "对方场地已失效，无法交换")
             
        # 3. Swap Ownerships
        my_new_serial = generate_serial_number()
        while await owned.find_one({"serial_number": my_new_serial}): my_new_serial = generate_serial_number()
        
        their_new_serial = generate_serial_number()
        while await owned.find_one({"serial_number": their_new_serial}): their_new_serial = generate_serial_number()
        
        # My Court -> Them
        await owned.update_one({"_id": my_court["_id"]}, {"$set": {
            "username": req["request_user_name"],
            "serial_number": my_new_serial,
            "transferred_at": datetime.now(timezone.utc),
            "transferred_from": username
        }})
        
        # Their Court -> Me
        await owned.update_one({"_id": their_court["_id"]}, {"$set": {
            "username": username,
            "serial_number": their_new_serial,
            "transferred_at": datetime.now(timezone.utc),
            "transferred_from": req["request_user_name"]
        }})
        
        # 4. Clean up wants
        await wanted.delete_many({
            "username": req["request_user_name"],
            "court_id": req["court_id"],
            "start_at": req["start_at"]
        })
        await wanted.delete_many({
            "username": username,
            "court_id": req["offer_court_id"],
            "start_at": req["offer_start_at"]
        })
        
        # 5. Update Request Status
        await exchange.update_one({"_id": oid}, {"$set": {"status": "completed", "completed_at": datetime.now(timezone.utc)}})
        
        # 6. Update Points (+3 each)
        await users.update_one({"username": username}, {"$inc": {"points": 3}})
        await users.update_one({"username": req["request_user_name"]}, {"$inc": {"points": 3}})
        
        # 7. 发送消息通知
        await send_system_message(
            username,
            f"🔄 交换成功！您用场地 {req['court_id']} 换取了 {req['request_user_name']} 的场地 {req['offer_court_id']}，积分+3"
        )
        await send_system_message(
            req["request_user_name"],
            f"🔄 交换成功！{username} 同意了您的交换申请，您用场地 {req['offer_court_id']} 换取了场地 {req['court_id']}，积分+3"
        )
        
        return MessageResponse(message="交换成功，双方积分+3")

    # 0. 检查申请者积分是否依然足够
    offer_points = req.get("offer_points", 0)
    if offer_points > 0:
        requester = await users.find_one({"username": req["request_user_name"]})
        if not requester or requester.get("points", 0) < offer_points:
             raise HTTPException(400, "对方积分不足，无法完成交易")

    # 1. 确认场地还在
    my_court = await owned.find_one({
        "username": username,
        "court_id": req["court_id"],
        "start_at": req["start_at"]
    })
    if not my_court:
        await exchange.update_one({"_id": oid}, {"$set": {"status": "failed", "note": "场地已失效"}})
        raise HTTPException(404, "场地已不存在，无法同意")

    # 2. 转移所有权并生成新序列号
    new_serial = generate_serial_number()
    # 确保序列号不重复
    while await owned.find_one({"serial_number": new_serial}):
        new_serial = generate_serial_number()
    
    await owned.update_one({"_id": my_court["_id"]}, {"$set": {
        "username": req["request_user_name"],
        "serial_number": new_serial,
        "transferred_at": datetime.now(timezone.utc),
        "transferred_from": username
    }})

    # 3. 清理对方可能发布的需求
    await wanted.delete_many({
        "username": req["request_user_name"],
        "court_id": req["court_id"],
        "start_at": req["start_at"]
    })

    # 4. 更新请求状态
    await exchange.update_one({"_id": oid}, {"$set": {"status": "completed", "completed_at": datetime.now(timezone.utc)}})

    # 5. 更新积分 (提供方 +10 分 + offer_points)
    # 扣除申请者积分
    if offer_points > 0:
        await users.update_one({"username": req["request_user_name"]}, {"$inc": {"points": -offer_points}})
    
    # 增加提供者积分
    await users.update_one({"username": username}, {"$inc": {"points": 10 + offer_points}})

    # 6. 发送消息通知
    await send_system_message(
        username,
        f"✅ 您同意了 {req['request_user_name']} 的场地申请，场地 {req['court_id']} 已转让，获得 {10 + offer_points} 积分"
    )
    await send_system_message(
        req["request_user_name"],
        f"🎉 {username} 同意了您的场地申请！您已获得场地 {req['court_id']}" + (f"，消耗 {offer_points} 积分" if offer_points > 0 else "")
    )

    return MessageResponse(message=f"已同意交换，获得 {10 + offer_points} 积分")

@router.post("/reject", response_model=MessageResponse)
async def RejectRequest(payload: HandleRequest, current_user: str = Depends(get_current_user)):
    """拒绝申请"""
    username = await _require_user(current_user)
    exchange = get_exchange_collection()
    
    try:
        oid = ObjectId(payload.request_id)
    except:
        raise HTTPException(400, "无效ID")

    req = await exchange.find_one({"_id": oid, "status": "pending"})
    if not req:
        raise HTTPException(404, "请求不存在")
        
    if req["post_user_name"] != username:
        raise HTTPException(403, "无权操作")

    await exchange.update_one({"_id": oid}, {"$set": {"status": "rejected", "completed_at": datetime.now(timezone.utc)}})
    
    return MessageResponse(message="已拒绝该请求")

@router.get("/my-options")
async def get_exchange_options(target_user: str, current_user: str = Depends(get_current_user)):
    """获取我的可用场地用于交换"""
    username = await _require_user(current_user)
    owned = get_owned_collection()
    wanted = get_wanted_collection()
    
    now = datetime.now(timezone.utc)
    
    # 1. 获取我的所有可用场地（未来时间，已上架）
    my_courts_cursor = owned.find({
        "username": username,
        "start_at": {"$gt": now},
        "is_public": True  # 只显示已上架的场地
    })
    my_courts = await my_courts_cursor.to_list(length=100)
    
    # 2. 获取目标用户的需求
    their_wants_cursor = wanted.find({
        "username": target_user,
        "start_at": {"$gt": now}
    })
    their_wants = await their_wants_cursor.to_list(length=100)
    
    # 3. 匹配逻辑
    options = []
    for court in my_courts:
        start_at = court["start_at"]
        end_at = court["end_at"]
        
        # MongoDB 返回的时间可能没有 tzinfo，需要先添加 UTC 再转换为东八区
        if start_at.tzinfo is None:
            start_at = start_at.replace(tzinfo=timezone.utc)
        if end_at.tzinfo is None:
            end_at = end_at.replace(tzinfo=timezone.utc)
        
        # 转换为东八区显示
        start_local = start_at.astimezone(CN_TZ)
        end_local = end_at.astimezone(CN_TZ)
        
        # 检查是否匹配对方需求 (场地ID和时间都匹配)
        is_match = False
        for w in their_wants:
            if (w["court_id"] == court["court_id"] and 
                w["start_at"] == court["start_at"]):
                is_match = True
                break
        
        options.append({
            "court_id": court["court_id"],
            "date": start_local.strftime("%Y-%m-%d"),
            "start_hour": start_local.hour,
            "end_hour": end_local.hour,
            "is_match": is_match
        })
    
    # 排序：匹配的排前面，然后按时间排序
    options.sort(key=lambda x: (not x["is_match"], x["date"], x["start_hour"]))
    
    return options

@router.post("/gift", response_model=MessageResponse)
async def gift_court(payload: FulfillRequest, current_user: str = Depends(get_current_user)):
    """赠予场地给其他用户"""
    username = await _require_user(current_user)
    
    if username == payload.target_user:
        raise HTTPException(400, "不能赠送给自己")
    
    owned = get_owned_collection()
    wanted = get_wanted_collection()
    users = get_users_collection()
    
    # 验证目标用户存在
    target = await users.find_one({"username": payload.target_user})
    if not target:
        raise HTTPException(404, "目标用户不存在")
    
    start_at = get_datetime(payload.date, payload.start_hour)
    
    # 查找我的场地
    my_court = await owned.find_one({
        "username": username,
        "court_id": payload.court_id,
        "start_at": start_at
    })
    
    if not my_court:
        raise HTTPException(404, "您不拥有该场地")
    
    # 生成新的序列号
    new_serial = generate_serial_number()
    # 确保序列号不重复
    while await owned.find_one({"serial_number": new_serial}):
        new_serial = generate_serial_number()
    
    # 转移场地所有权并更新序列号
    await owned.update_one(
        {"_id": my_court["_id"]},
        {"$set": {
            "username": payload.target_user,
            "serial_number": new_serial,
            "transferred_at": datetime.now(timezone.utc),
            "transferred_from": username
        }}
    )
    
    # 删除接收者对应的需求（如果有）
    await wanted.delete_many({
        "username": payload.target_user,
        "court_id": payload.court_id,
        "start_at": start_at
    })
    
    return MessageResponse(message=f"场地已赠送给 {payload.target_user}，新序列号：{new_serial}")
