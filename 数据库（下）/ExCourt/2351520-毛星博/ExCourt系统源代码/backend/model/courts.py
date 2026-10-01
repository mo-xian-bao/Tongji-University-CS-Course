from pydantic import BaseModel,Field,validator
from typing import Optional
from datetime import date, time, datetime, timezone, timedelta

# 定义东八区时区
CN_TZ = timezone(timedelta(hours=8))

class SearchCourtRequest(BaseModel):
    """搜索场地请求"""
    court_id: int = Field(..., ge=0, le=1000)

class SearchCourtSingleResponse(BaseModel):
    """搜索场地响应"""
    court_id: int = Field(..., ge=0, le=1000)
    court_name: str = Field(..., min_length=2, max_length=50)
    court_info: str = Field(..., min_length=0, max_length=200)
    open_time: time
    close_time: time


class PostOwnedRequest(BaseModel):
    """发布已有场地请求"""
    court_id: int = Field(..., ge=0, le=1000)
    start_date: date
    start_hour: int = Field(..., ge=0, le=23)  # 整点小时
    end_hour: int = Field(..., ge=0, le=23)    # 整点小时
    serial_number: str = Field(..., min_length=1, max_length=100)  # 序列号

    @validator("start_hour")
    def validate_future_time(cls, v, values):
        start_date = values.get("start_date")
        if start_date:
            # 构造东八区时间进行比较
            dt = datetime.combine(start_date, time(hour=v), tzinfo=CN_TZ)
            if dt < datetime.now(CN_TZ):
                raise ValueError("不能发布过去的时间")
        return v

    @validator("end_hour")
    def validate_end_hour(cls, v, values):
        start_hour = values.get("start_hour")
        if start_hour is not None and v <= start_hour:
            raise ValueError("结束时间要在开始时间之后")
        return v

class UpdateOwnedRequest(BaseModel):
    """更新已有场地请求"""
    court_id: int = Field(..., ge=0, le=1000)
    start_date: date
    start_hour: int = Field(..., ge=0, le=23)
    end_hour: int = Field(..., ge=0, le=23)

    @validator("start_hour")
    def validate_future_time(cls, v, values):
        start_date = values.get("start_date")
        if start_date:
            dt = datetime.combine(start_date, time(hour=v), tzinfo=CN_TZ)
            if dt < datetime.now(CN_TZ):
                raise ValueError("不能更新为过去的时间")
        return v

    @validator("end_hour")
    def validate_end_hour(cls, v, values):
        start_hour = values.get("start_hour")
        if start_hour is not None and v <= start_hour:
            raise ValueError("结束时间要在开始时间之后")
        return v

class SearchOwnedRequest(BaseModel):
    """搜索已有场地请求"""
    court_id: Optional[int] = Field(None, ge=0, le=1000)
    start_date: Optional[date] = None
    start_hour: Optional[int] = Field(None, ge=0, le=23)
    end_hour: Optional[int] = Field(None, ge=0, le=23)

class SearchOwnedResponse(BaseModel):
    """搜索已有场地响应"""
    owned_user_name: str = Field(..., min_length=2, max_length=50)
    court_id: int = Field(..., ge=0, le=1000)
    start_date: date
    start_hour: int
    end_hour: int

class PostWantedRequest(BaseModel):
    """发布需求请求"""
    court_id: int = Field(..., ge=0, le=1000)
    start_date: date
    start_hour: int = Field(..., ge=0, le=23)
    end_hour: int = Field(..., ge=0, le=23)

    @validator("start_hour")
    def validate_future_time(cls, v, values):
        start_date = values.get("start_date")
        if start_date:
            dt = datetime.combine(start_date, time(hour=v), tzinfo=CN_TZ)
            if dt < datetime.now(CN_TZ):
                raise ValueError("不能发布过去的时间")
        return v

    @validator("end_hour")
    def validate_end_hour(cls, v, values):
        start_hour = values.get("start_hour")
        if start_hour is not None and v <= start_hour:
            raise ValueError("结束时间要在开始时间之后")
        return v

class UpdateWantedRequest(BaseModel):
    """更新需求请求"""
    court_id: int = Field(..., ge=0, le=1000)
    start_date: date
    start_hour: int = Field(..., ge=0, le=23)
    end_hour: int = Field(..., ge=0, le=23)

    @validator("start_hour")
    def validate_future_time(cls, v, values):
        start_date = values.get("start_date")
        if start_date:
            dt = datetime.combine(start_date, time(hour=v), tzinfo=CN_TZ)
            if dt < datetime.now(CN_TZ):
                raise ValueError("不能更新为过去的时间")
        return v

    @validator("end_hour")
    def validate_end_hour(cls, v, values):
        start_hour = values.get("start_hour")
        if start_hour is not None and v <= start_hour:
            raise ValueError("结束时间要在开始时间之后")
        return v

class SearchWantedRequest(BaseModel):
    """搜索需求请求"""
    court_id: Optional[int] = Field(None, ge=0, le=1000)
    start_date: Optional[date] = None
    start_hour: Optional[int] = Field(None, ge=0, le=23)
    end_hour: Optional[int] = Field(None, ge=0, le=23)

class SearchWantedResponse(BaseModel):
    """搜索需求响应"""
    wanted_user_name: str = Field(..., min_length=2, max_length=50)
    court_id: int = Field(..., ge=0, le=1000)
    start_date: date
    start_hour: int
    end_hour: int

class TogglePublicRequest(BaseModel):
    """切换场地公开状态请求"""
    court_id: int = Field(..., ge=0, le=1000)
    start_date: date
    start_hour: int = Field(..., ge=0, le=23)
    is_public: bool # True=发布到广场, False=下架