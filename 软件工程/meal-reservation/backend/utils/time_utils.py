"""Time conversion helpers."""
from datetime import datetime, timedelta, timezone
import time
from zoneinfo import ZoneInfo


def utc_to_local(utc_dt):
    """将UTC时间转换为本地时间"""
    # 如果输入的是naive时间（没有时区信息），先添加UTC时区
    if utc_dt.tzinfo is None:
        utc_dt = utc_dt.replace(tzinfo=datetime.timezone.utc)

    # 转换为本地时间
    local_dt = utc_dt.astimezone()
    return local_dt


def local_to_utc(local_dt):
    """将本地时间转换为UTC时间"""
    # 如果输入的是naive时间，先添加本地时区
    if local_dt.tzinfo is None:
        # 获取本地时区偏移
        local_tz = datetime.timezone(datetime.timedelta(seconds=-time.timezone))
        if time.localtime().tm_isdst:
            # 夏令时调整
            local_tz = datetime.timezone(datetime.timedelta(seconds=-time.altzone))
        local_dt = local_dt.replace(tzinfo=local_tz)

    # 转换为UTC时间
    utc_dt = local_dt.astimezone(datetime.timezone.utc)
    return utc_dt


def safe_zoneinfo(tz_name):
    """Return ZoneInfo for tz_name; fallback to UTC on missing/invalid."""
    try:
        return ZoneInfo(tz_name) if tz_name else timezone.utc
    except Exception:
        return timezone.utc


def localize_iso(value, tz, is_end=False):
    """Parse ISO string from frontend (usually naive local time) into aware datetimes.

    Returns (local_dt, utc_dt). If value is date-only, expands to start/end of day in tz.
    """
    if not value:
        return None, None

    raw = str(value).strip()
    is_date_only = 'T' not in raw

    dt = datetime.fromisoformat(raw)
    if getattr(dt, 'tzinfo', None) is None:
        if is_date_only:
            if is_end:
                dt = dt.replace(hour=23, minute=59, second=59, microsecond=999999)
            else:
                dt = dt.replace(hour=0, minute=0, second=0, microsecond=0)
        local_dt = dt.replace(tzinfo=tz)
    else:
        # If client sent an offset-aware datetime, normalize to requested tz.
        local_dt = dt.astimezone(tz)

    return local_dt, local_dt.astimezone(timezone.utc)


def parse_range_from_frontend(start_str, end_str, tz_name, default_days=7):
    """Interpret frontend date range in tz_name and convert to UTC for DB filtering.

    Returns (tz, local_start, local_end, utc_start, utc_end).
    """
    tz = safe_zoneinfo(tz_name)
    if not start_str or not end_str:
        utc_end = datetime.utcnow().replace(tzinfo=timezone.utc)
        utc_start = utc_end - timedelta(days=default_days)
        return tz, utc_start.astimezone(tz), utc_end.astimezone(tz), utc_start, utc_end

    local_start, utc_start = localize_iso(start_str, tz, is_end=False)
    local_end, utc_end = localize_iso(end_str, tz, is_end=True)

    # Safety: ensure range is valid
    if utc_start and utc_end and utc_end < utc_start:
        utc_start, utc_end = utc_end, utc_start
        local_start, local_end = local_end, local_start

    return tz, local_start, local_end, utc_start, utc_end
