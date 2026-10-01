"""Restaurant table availability and time slot logic."""
from datetime import datetime, timedelta, timezone
from zoneinfo import ZoneInfo

from Models import Restaurant, Table
from database import check_table_availability_for_reservation
from utils import NotFoundError


def get_available_tables(restaurant_id, reserved_time_str, customer_count, duration, time_zone_str):
    rest = Restaurant.query.get(restaurant_id)
    if not rest:
        raise NotFoundError("餐厅不存在")

    tz = ZoneInfo(time_zone_str) if time_zone_str else None
    tables = Table.query.filter_by(restaurant_id=restaurant_id).all()
    result = []

    for table in tables:
        td = {
            "id": table.id,
            "table_number": table.table_number,
            "capacity": table.capacity,
            "table_type": table.table_type,
            "description": table.description,
            "status": table.status,
        }
        if reserved_time_str:
            try:
                rt = datetime.fromisoformat(reserved_time_str.replace("Z", "")).replace(tzinfo=tz)
                if rt.tzinfo is not None:
                    rt = rt.replace(tzinfo=None)
                ret = rt + timedelta(minutes=duration)
                avail, seats = check_table_availability_for_reservation(table.id, rt, ret, customer_count)
                td.update({"is_available": avail, "available_seats": seats, "can_accommodate": avail})
            except ValueError:
                td.update({"is_available": False, "available_seats": 0, "can_accommodate": False})
        else:
            occ = table.get_current_occupancy() if hasattr(table, "get_current_occupancy") else 0
            rts = table.get_realtime_status() if hasattr(table, "get_realtime_status") else table.status
            if getattr(table, "table_type", None) == "private":
                seats = table.capacity if rts == "available" else 0
            else:
                seats = table.capacity - occ
            td.update({"status": rts, "is_available": rts == "available", "available_seats": seats, "can_accommodate": seats >= customer_count})
        result.append(td)

    return result


def get_available_slots(restaurant_id, date_str, days, time_zone_str):
    rest = Restaurant.query.get(restaurant_id)
    if not rest:
        raise NotFoundError("餐厅不存在")

    tz = ZoneInfo(time_zone_str) if time_zone_str else None
    bh = rest.opening_hours or "09:00-21:00"
    try:
        open_time, close_time = bh.split("-")
        oh, om = map(int, open_time.split(":"))
        ch, cm = map(int, close_time.split(":"))
    except Exception:
        oh, om, ch, cm = 9, 0, 21, 0

    if date_str:
        try:
            sd = datetime.strptime(date_str, "%Y-%m-%d")
            sd = sd.replace(tzinfo=tz) if tz else sd
        except Exception:
            sd = datetime.now(tz).date() if tz else datetime.now()
    else:
        sd = datetime.now(tz).date() if tz else datetime.now()

    now = datetime.now(tz) if tz else datetime.now()
    min_adv = timedelta(minutes=30)
    result = []
    days_int = int(days) if days else 7
    day_names = ["周一", "周二", "周三", "周四", "周五", "周六", "周日"]

    for offset in range(days_int):
        cd = sd + timedelta(days=offset)
        day_slots = []
        ct = datetime.combine(cd, datetime.min.time().replace(hour=oh, minute=om))
        et = datetime.combine(cd, datetime.min.time().replace(hour=ch, minute=cm))
        ct = ct.replace(tzinfo=tz) if tz else ct
        et = et.replace(tzinfo=tz) if tz else et
        while ct < et:
            if ct > now + min_adv:
                day_slots.append({"time": ct.strftime("%H:%M"), "datetime": ct.isoformat(), "available": True})
            ct += timedelta(minutes=30)
        result.append({"date": cd.isoformat(), "day_of_week": day_names[cd.weekday()], "slots": day_slots})

    return bh, result
