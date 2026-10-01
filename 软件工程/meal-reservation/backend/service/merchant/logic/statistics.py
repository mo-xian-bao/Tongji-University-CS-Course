"""Merchant statistics helpers — each function returns data for a specific stat endpoint."""
import logging
from datetime import datetime, timedelta, timezone
from io import BytesIO

import pandas as pd
from sqlalchemy import func

from Models import Dish, Order, OrderItem, Restaurant, db
from utils import parse_range_from_frontend

merchant_logger = logging.getLogger("merchant")


def _growth(current, previous):
    if previous == 0:
        return 100 if current > 0 else 0
    return ((current - previous) / previous) * 100


def compute_overview(restaurant, start_date_str, end_date_str, tz_name):
    tz, ls, le, utc_start, utc_end = parse_range_from_frontend(start_date_str, end_date_str, tz_name, 7)
    bq = Order.query.filter(Order.restaurant_id == restaurant.id,
                            Order.order_time >= utc_start, Order.order_time <= utc_end)
    total_orders = bq.count()
    completed = bq.filter(Order.status == "completed").all()
    completed_count = len(completed)
    revenue = sum(o.total_price for o in completed) if completed else 0
    avg = revenue / completed_count if completed_count else 0
    cancelled = bq.filter(Order.status.in_(["cancelled", "rejected"])).count()
    cancel_rate = (cancelled / total_orders * 100) if total_orders else 0
    dur = utc_end - utc_start
    if dur.total_seconds() <= 0:
        dur = timedelta(days=1)
    prev_start = utc_start - dur
    pq = Order.query.filter(Order.restaurant_id == restaurant.id,
                            Order.order_time >= prev_start, Order.order_time < utc_start)
    prev_total = pq.count()
    prev_comp = pq.filter(Order.status == "completed").all()
    prev_rev = sum(o.total_price for o in prev_comp) if prev_comp else 0
    return {
        "total_orders": total_orders, "total_revenue": round(revenue, 2),
        "avg_order_value": round(avg, 2), "cancellation_rate": round(cancel_rate, 2),
        "active_dishes": Dish.query.filter_by(restaurant_id=restaurant.id, status="available").count(),
        "completed_orders": completed_count,
        "orders_growth": round(_growth(total_orders, prev_total), 2),
        "revenue_growth": round(_growth(revenue, prev_rev), 2),
        "period": {"start": (ls.isoformat() if ls else utc_start.isoformat()),
                   "end": (le.isoformat() if le else utc_end.isoformat()),
                   "timezone": str(tz_name or "UTC")},
    }


def compute_trend(restaurant, start_date_str, end_date_str, tz_name):
    tz, ls, le, utc_start, utc_end = parse_range_from_frontend(start_date_str, end_date_str, tz_name, 30)
    orders = Order.query.filter(Order.restaurant_id == restaurant.id,
                                Order.order_time >= utc_start, Order.order_time <= utc_end).all()
    trend = {}
    for o in orders:
        ot = o.order_time
        if ot is None:
            continue
        if getattr(ot, "tzinfo", None) is None:
            ot = ot.replace(tzinfo=timezone.utc)
        lt = ot.astimezone(tz)
        dk = lt.strftime("%Y-%m-%d")
        trend.setdefault(dk, {"date": dk, "order_count": 0, "revenue": 0, "completed_count": 0})
        trend[dk]["order_count"] += 1
        if o.status == "completed":
            trend[dk]["completed_count"] += 1
            trend[dk]["revenue"] += o.total_price
    fill_start = (ls.date() if ls else utc_start.astimezone(tz).date())
    fill_end = (le.date() if le else utc_end.astimezone(tz).date())
    cd = fill_start
    while cd <= fill_end:
        dk = cd.strftime("%Y-%m-%d")
        trend.setdefault(dk, {"date": dk, "order_count": 0, "revenue": 0, "completed_count": 0})
        cd += timedelta(days=1)
    return sorted(trend.values(), key=lambda x: x["date"])


def compute_peak_hours(restaurant, start_date_str, end_date_str, tz_name):
    tz, _, _, utc_start, utc_end = parse_range_from_frontend(start_date_str, end_date_str, tz_name, 7)
    orders = Order.query.filter(Order.restaurant_id == restaurant.id,
                                Order.order_time >= utc_start, Order.order_time <= utc_end).all()
    stats = {h: 0 for h in range(24)}
    for o in orders:
        ot = o.order_time
        if ot is None:
            continue
        if getattr(ot, "tzinfo", None) is None:
            ot = ot.replace(tzinfo=timezone.utc)
        stats[ot.astimezone(tz).hour] += 1
    return [{"hour": f"{h:02d}:00", "order_count": c} for h, c in sorted(stats.items())]


def compute_top_dishes(restaurant, start_date_str, end_date_str, tz_name, limit=10):
    _, _, _, utc_start, utc_end = parse_range_from_frontend(start_date_str, end_date_str, tz_name, 7)
    rows = (db.session.query(OrderItem.dish_id, Dish.name, Dish.category,
                             func.sum(OrderItem.quantity).label("qty"),
                             func.sum(OrderItem.subtotal).label("rev"))
            .join(Order, OrderItem.order_id == Order.id)
            .join(Dish, OrderItem.dish_id == Dish.dish_id)
            .filter(Order.restaurant_id == restaurant.id,
                    Order.order_time >= utc_start, Order.order_time <= utc_end,
                    Order.status == "completed")
            .group_by(OrderItem.dish_id, Dish.name, Dish.category)
            .order_by(func.sum(OrderItem.quantity).desc()).limit(limit).all())
    return [{"dish_id": r.dish_id, "dish_name": r.name, "category": r.category or "未分类",
             "sales_count": int(r.qty), "revenue": round(float(r.rev), 2)} for r in rows]


def compute_status_distribution(restaurant, start_date_str, end_date_str, tz_name):
    _, _, _, utc_start, utc_end = parse_range_from_frontend(start_date_str, end_date_str, tz_name, 30)
    rows = (db.session.query(Order.status, func.count(Order.id).label("count"))
            .filter(Order.restaurant_id == restaurant.id,
                    Order.order_time >= utc_start, Order.order_time <= utc_end)
            .group_by(Order.status).all())
    names = {"pending": "待接单", "confirmed": "已接单", "dining": "用餐中",
             "completed": "已完成", "cancelled": "已取消", "rejected": "已拒绝"}
    return [{"status": r.status, "status_name": names.get(r.status, r.status), "count": r.count} for r in rows]


def compute_category_share(restaurant, start_date_str, end_date_str, tz_name):
    _, _, _, utc_start, utc_end = parse_range_from_frontend(start_date_str, end_date_str, tz_name, 30)
    rows = (db.session.query(Dish.category, func.sum(OrderItem.quantity).label("qty"),
                             func.sum(OrderItem.subtotal).label("rev"))
            .join(Order, OrderItem.order_id == Order.id)
            .join(Dish, OrderItem.dish_id == Dish.dish_id)
            .filter(Order.restaurant_id == restaurant.id,
                    Order.order_time >= utc_start, Order.order_time <= utc_end,
                    Order.status == "completed")
            .group_by(Dish.category).all())
    return [{"category": r.category or "未分类", "sales_count": int(r.qty),
             "revenue": round(float(r.rev), 2)} for r in rows]


def export_excel(restaurant, start_date_str, end_date_str, tz_name):
    tz, _, _, utc_start, utc_end = parse_range_from_frontend(start_date_str, end_date_str, tz_name, 30)
    orders = Order.query.filter(Order.restaurant_id == restaurant.id,
                                Order.order_time >= utc_start, Order.order_time <= utc_end).all()
    orders_data = []
    for o in orders:
        ot = o.order_time
        if ot and getattr(ot, "tzinfo", None) is None:
            ot = ot.replace(tzinfo=timezone.utc)
        lt = ot.astimezone(tz) if ot else None
        orders_data.append({
            "订单号": o.order_number,
            "订单时间": lt.strftime("%Y-%m-%d %H:%M:%S") if lt else "",
            "订单类型": "堂食" if o.order_type in ("dinein", "dine_in", "dine-in") else "外带",
            "桌号": o.table.table_number if o.table else "-",
            "就餐人数": o.customer_count, "订单状态": o.status,
            "订单金额": o.total_price, "备注": o.note or "",
        })
    dish_rows = (db.session.query(Dish.name, Dish.category,
                                  func.sum(OrderItem.quantity).label("qty"),
                                  func.sum(OrderItem.subtotal).label("rev"))
                 .join(Order, OrderItem.order_id == Order.id)
                 .join(Dish, OrderItem.dish_id == Dish.dish_id)
                 .filter(Order.restaurant_id == restaurant.id,
                         Order.order_time >= utc_start, Order.order_time <= utc_end,
                         Order.status == "completed")
                 .group_by(Dish.name, Dish.category)
                 .order_by(func.sum(OrderItem.quantity).desc()).all())
    trend = {}
    for o in orders:
        dk = o.order_time.strftime("%Y-%m-%d")
        trend.setdefault(dk, {"日期": dk, "订单总数": 0, "完成订单": 0, "取消订单": 0, "营业额": 0})
        trend[dk]["订单总数"] += 1
        if o.status == "completed":
            trend[dk]["完成订单"] += 1
            trend[dk]["营业额"] += o.total_price
        elif o.status in ("cancelled", "rejected"):
            trend[dk]["取消订单"] += 1
    output = BytesIO()
    writer = pd.ExcelWriter(output, engine="openpyxl")
    pd.DataFrame(orders_data).to_excel(writer, sheet_name="订单明细", index=False)
    pd.DataFrame([{"菜品名称": r.name, "分类": r.category or "未分类",
                   "销售数量": int(r.qty), "销售金额": round(float(r.rev), 2)} for r in dish_rows]
                 ).to_excel(writer, sheet_name="菜品销售统计", index=False)
    sorted_trend = sorted(trend.values(), key=lambda x: x["日期"])
    if sorted_trend:
        pd.DataFrame(sorted_trend).to_excel(writer, sheet_name="每日汇总", index=False)
    writer.close()
    output.seek(0)
    fn = f"{restaurant.name}_统计报表_{utc_start.strftime('%Y%m%d')}_{utc_end.strftime('%Y%m%d')}.xlsx"
    return output, fn
