from fastapi import APIRouter, Depends, HTTPException
from datetime import datetime, timezone

from model.common import MessageResponse
from model.exchange import ExchangeRequest, ExchangeResponse, DirectExchangeRequest
from utils.security import get_current_user
from database import get_exchange_collection, get_owned_collection, get_wanted_collection


router = APIRouter(prefix="/exchange", tags=["exchange"])

# 暂不清楚存在意义
async def _require_user(current_user: str) -> str:
    return current_user

@router.post("/request", response_model=MessageResponse)
async def ExchangeReq(payload: ExchangeRequest,current_user: str = Depends(get_current_user)):
    username = await _require_user(current_user)
    exchange = get_exchange_collection()
    doc = {
        "post_user_name" : payload.post_user_name,
        "request_user_name" : username,
        "court_id" : payload.court_id,
        "status": "pending",
        "created_at": datetime.now(timezone.utc),
    }
    await exchange.insert_one(doc)
    return MessageResponse(message="发起交换请求成功")

@router.post("/direct", response_model=MessageResponse)
async def DirectExchange(payload: DirectExchangeRequest, current_user: str = Depends(get_current_user)):
    """直接交换：用户A用自己的场地Y交换用户B的场地X（前提是B需要Y）"""
    username = await _require_user(current_user)
    
    # 验证：不能和自己交换
    if username == payload.target_user:
        raise HTTPException(status_code=400, detail="不能与自己交换场地")
    
    owned = get_owned_collection()
    wanted = get_wanted_collection()
    exchange = get_exchange_collection()
    
    # 1. 验证我的场地存在
    my_court = await owned.find_one({
        "username": username,
        "court_id": payload.my_court_id
    })
    if not my_court:
        raise HTTPException(status_code=404, detail="您没有此场地")
    
    # 2. 验证对方的场地存在
    their_court = await owned.find_one({
        "username": payload.target_user,
        "court_id": payload.their_court_id
    })
    if not their_court:
        raise HTTPException(status_code=404, detail="对方没有此场地")
    
    # 3. 验证对方确实需要我的场地（关键验证）
    their_want = await wanted.find_one({
        "username": payload.target_user,
        "court_id": payload.my_court_id,
        "start_at": my_court["start_at"],
        "end_at": my_court["end_at"]
    })
    if not their_want:
        raise HTTPException(status_code=400, detail="对方没有发布对您场地的需求")
    
    # 4. 执行场地交换（修改所有权）
    now = datetime.now(timezone.utc)
    
    # 4.1 更新我的场地 -> 改为对方所有
    await owned.update_one(
        {"_id": my_court["_id"]},
        {"$set": {"username": payload.target_user}}
    )
    
    # 4.2 更新对方的场地 -> 改为我所有
    await owned.update_one(
        {"_id": their_court["_id"]},
        {"$set": {"username": username}}
    )
    
    # 4.3 删除对方对我场地的需求（已被满足）
    await wanted.delete_one({"_id": their_want["_id"]})
    
    # 4.4 如果我也发布了对对方场地的需求，也删除
    my_want = await wanted.find_one({
        "username": username,
        "court_id": payload.their_court_id,
        "start_at": their_court["start_at"],
        "end_at": their_court["end_at"]
    })
    if my_want:
        await wanted.delete_one({"_id": my_want["_id"]})
    
    # 5. 记录双向交换历史
    doc_a_to_b = {
        "post_user_name": payload.target_user,
        "request_user_name": username,
        "court_id": payload.my_court_id,
        "target_court_id": payload.their_court_id,
        "exchange_type": "direct",
        "status": "completed",
        "created_at": now,
    }
    
    doc_b_to_a = {
        "post_user_name": username,
        "request_user_name": payload.target_user,
        "court_id": payload.their_court_id,
        "target_court_id": payload.my_court_id,
        "exchange_type": "direct",
        "status": "completed",
        "created_at": now,
    }
    
    await exchange.insert_many([doc_a_to_b, doc_b_to_a])
    
    return MessageResponse(message=f"交换成功！您的场地{payload.my_court_id}已与{payload.target_user}的场地{payload.their_court_id}完成交换")

@router.get("/upload", response_model=ExchangeResponse)
async def UploadRed(current_user: str = Depends(get_current_user)):
    username = await _require_user(current_user)
    exchange = get_exchange_collection()
    # 查询并返回
    ...

@router.post("/complete", response_model=MessageResponse)
async def CompleteRed(payload: ExchangeRequest,current_user: str = Depends(get_current_user)):
    username = await _require_user(current_user)
    exchange = get_exchange_collection()
    # 查询自己作为post的记录，并修改为complete
    ...

@router.post("/refuse", response_model=MessageResponse)
async def CompleteRed(payload: ExchangeRequest,current_user: str = Depends(get_current_user)):
    username = await _require_user(current_user)
    exchange = get_exchange_collection()
    # 查询自己作为post的记录，并修改为refuse
    ...