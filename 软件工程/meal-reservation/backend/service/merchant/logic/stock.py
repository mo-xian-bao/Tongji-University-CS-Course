"""Merchant stock helpers — queries, stats, export."""
from datetime import datetime, timedelta, timezone
from io import BytesIO

import pandas as pd
from sqlalchemy import func

from Models import Dish, Restaurant, StockLog, db
from utils import safe_zoneinfo


def fetch_categories(current_user):
    restaurant = Restaurant.query.filter_by(user_id=current_user.id).first()
    if not restaurant:
        return None, None
    cats = db.session.query(Dish.category).filter(Dish.restaurant_id == restaurant.id).distinct().all()
    return restaurant, [{"id": c[0], "name": c[0]} for c in cats if c[0]]


def compute_overview(restaurant, start_date_str, end_date_str, tz_name, category=None):
    tz = safe_zoneinfo(tz_name)
    try:
        if not start_date_str or not end_date_str:
            end_date = datetime.utcnow()
            start_date = end_date - timedelta(days=30)
        else:
            start_date = datetime.strptime(start_date_str[:10], "%Y-%m-%d").replace(tzinfo=tz).astimezone(timezone.utc)
            end_date = datetime.strptime(end_date_str[:10], "%Y-%m-%d").replace(
                hour=23, minute=59, second=59).replace(tzinfo=tz).astimezone(timezone.utc)
    except ValueError:
        return None

    df = [Dish.restaurant_id == restaurant.id]
    if category and category.strip():
        df.append(Dish.category == category)
    total_qty = db.session.query(func.sum(Dish.stock_quantity)).filter(*df).scalar() or 0
    total_cost = db.session.query(func.sum(Dish.original_price * Dish.stock_quantity)).filter(*df).scalar() or 0

    rf = [StockLog.restaurant_id == restaurant.id, StockLog.change_type.in_(["restock", "update"]),
          StockLog.created_at >= start_date, StockLog.created_at <= end_date]
    if category and category.strip():
        rf.append(StockLog.dish.has(category=category))
    total_in = db.session.query(func.sum(StockLog.quantity_change)).filter(*rf).scalar() or 0
    cost_in = db.session.query(func.sum(StockLog.cost)).filter(*rf).scalar() or 0

    of_ = [StockLog.restaurant_id == restaurant.id, StockLog.change_type.in_(["sales", "loss"]),
           StockLog.created_at >= start_date, StockLog.created_at <= end_date]
    if category and category.strip():
        of_.append(StockLog.dish.has(category=category))
    total_out = abs(db.session.query(func.sum(StockLog.quantity_change)).filter(*of_).scalar() or 0)

    wf = df + [Dish.stock_quantity <= Dish.stock_alert_threshold, Dish.stock_alert_enabled == True]
    warning = db.session.query(func.count(Dish.dish_id)).filter(*wf).scalar() or 0

    return {"total_quantity": int(total_qty), "total_cost": float(total_cost),
            "total_in": int(total_in), "cost_in": float(cost_in),
            "total_out": int(total_out), "warning_count": int(warning)}


def compute_trend(restaurant, start_date_str, end_date_str, tz_name, category=None):
    tz = safe_zoneinfo(tz_name)
    try:
        if not start_date_str or not end_date_str:
            end_date = datetime.utcnow()
            start_date = end_date - timedelta(days=30)
        else:
            start_date = datetime.strptime(start_date_str[:10], "%Y-%m-%d")
            end_date = datetime.strptime(end_date_str[:10], "%Y-%m-%d").replace(hour=23, minute=59, second=59)
        start_date = start_date.replace(tzinfo=tz).astimezone(timezone.utc)
        end_date = end_date.replace(tzinfo=tz).astimezone(timezone.utc)
    except ValueError:
        return None

    dq = Dish.query.filter(Dish.restaurant_id == restaurant.id)
    if category and category.strip():
        dq = dq.filter(Dish.category == category)
    stock_map = {d.dish_id: (d.stock_quantity if d.stock_quantity is not None else 0) for d in dq.all()}

    lq = StockLog.query.filter(StockLog.restaurant_id == restaurant.id, StockLog.created_at >= start_date)
    if category and category.strip():
        lq = lq.join(Dish, StockLog.dish_id == Dish.dish_id).filter(Dish.category == category)
    all_logs = lq.order_by(StockLog.created_at.desc()).all()

    by_date = {}
    for log in all_logs:
        lt = log.created_at.replace(tzinfo=timezone.utc)
        if lt > end_date and log.dish_id in stock_map:
            stock_map[log.dish_id] -= log.quantity_change
        elif lt <= end_date:
            by_date.setdefault(log.created_at.strftime("%Y-%m-%d"), []).append(log)

    date_list = []
    t = start_date
    while t <= end_date:
        date_list.append(t.strftime("%Y-%m-%d"))
        t += timedelta(days=1)

    result = []
    for day_str in reversed(date_list):
        total = sum(s for s in stock_map.values() if s > 0)
        td = by_date.get(day_str, [])
        restock = sum(l.quantity_change for l in td
                      if l.change_type in ("restock", "return", "update") and l.quantity_change > 0)
        result.append({"date": day_str, "total_stock": int(total), "restock_amount": int(restock)})
        for log in td:
            if log.dish_id in stock_map:
                if log.change_type == "restock" and log.note == "创建菜品初始库存":
                    stock_map[log.dish_id] = 0
                else:
                    stock_map[log.dish_id] -= log.quantity_change
    return result[::-1]


def compute_in_out(restaurant, start_date_str, end_date_str, tz_name, category=None):
    tz = safe_zoneinfo(tz_name)
    try:
        if not start_date_str or not end_date_str:
            end_date = datetime.utcnow()
            start_date = end_date - timedelta(days=30)
        else:
            start_date = datetime.strptime(start_date_str[:10], "%Y-%m-%d").replace(tzinfo=tz).astimezone(timezone.utc)
            end_date = datetime.strptime(end_date_str[:10], "%Y-%m-%d").replace(
                hour=23, minute=59, second=59).replace(tzinfo=tz).astimezone(timezone.utc)
    except ValueError:
        return None

    lf = [StockLog.restaurant_id == restaurant.id,
          StockLog.created_at >= start_date, StockLog.created_at <= end_date]
    query = (db.session.query(Dish.category, StockLog.change_type,
                              func.sum(func.abs(StockLog.quantity_change)).label("qty"))
             .select_from(StockLog).join(Dish, StockLog.dish_id == Dish.dish_id).filter(*lf))
    if category and category.strip():
        query = query.filter(Dish.category == category)
    rows = query.group_by(Dish.category, StockLog.change_type).all()
    cat_data = {}
    for row in rows:
        cn = row.category or "未分类"
        cat_data.setdefault(cn, {"in_qty": 0, "out_qty": 0})
        if row.change_type in ("restock", "return"):
            cat_data[cn]["in_qty"] += int(row.qty or 0)
        elif row.change_type in ("sales", "loss"):
            cat_data[cn]["out_qty"] += int(row.qty or 0)
    return [{"category_name": k, "in_qty": v["in_qty"], "out_qty": v["out_qty"]} for k, v in cat_data.items()]


def compute_cost_distribution(restaurant, category=None):
    df = [Dish.restaurant_id == restaurant.id]
    if category:
        df.append(Dish.category == category)
    rows = (db.session.query(Dish.category, func.sum(Dish.original_price * Dish.stock_quantity).label("cost"))
            .filter(*df).group_by(Dish.category).all())
    return [{"category_name": r.category or "未分类", "cost": float(r.cost or 0)} for r in rows]


def fetch_logs(restaurant, start_date_str, end_date_str, tz_name, category=None, page=1, per_page=50):
    tz = safe_zoneinfo(tz_name)
    query = StockLog.query.filter(StockLog.restaurant_id == restaurant.id)
    if start_date_str:
        try:
            sd = datetime.strptime(start_date_str[:10], "%Y-%m-%d").replace(tzinfo=tz).astimezone(timezone.utc)
            query = query.filter(StockLog.created_at >= sd)
        except ValueError:
            pass
    if end_date_str:
        try:
            ed = datetime.strptime(end_date_str[:10], "%Y-%m-%d").replace(
                hour=23, minute=59, second=59).replace(tzinfo=tz).astimezone(timezone.utc)
            query = query.filter(StockLog.created_at <= ed)
        except ValueError:
            pass
    if category and category.strip():
        query = query.join(Dish, StockLog.dish_id == Dish.dish_id).filter(Dish.category == category)
    pagination = query.order_by(StockLog.created_at.desc()).paginate(
        page=int(page), per_page=int(per_page), error_out=False)
    return [log.to_dict() for log in pagination.items]


def export_report(restaurant, start_date_str, end_date_str, tz_name, category=None):
    tz = safe_zoneinfo(tz_name)
    try:
        if not start_date_str or not end_date_str:
            end_date = datetime.utcnow()
            start_date = end_date - timedelta(days=30)
        else:
            start_date = datetime.strptime(start_date_str[:10], "%Y-%m-%d").replace(tzinfo=tz).astimezone(timezone.utc)
            end_date = datetime.strptime(end_date_str[:10], "%Y-%m-%d").replace(
                hour=23, minute=59, second=59).replace(tzinfo=tz).astimezone(timezone.utc)
    except ValueError:
        return None, "日期格式错误"

    df = [Dish.restaurant_id == restaurant.id]
    if category and category.strip():
        df.append(Dish.category == category)
    total_qty = db.session.query(func.sum(Dish.stock_quantity)).filter(*df).scalar() or 0
    total_cost = db.session.query(func.sum(Dish.price * Dish.stock_quantity)).filter(*df).scalar() or 0
    overview = [
        {"指标": "当前库存总量", "数值": int(total_qty), "单位": "件/kg"},
        {"指标": "库存总成本", "数值": round(float(total_cost), 2), "单位": "元"},
        {"指标": "统计时间段", "数值": f"{start_date.strftime('%Y-%m-%d')} 至 {end_date.strftime('%Y-%m-%d')}", "单位": "-"},
    ]
    lf = [StockLog.restaurant_id == restaurant.id,
          StockLog.created_at >= start_date, StockLog.created_at <= end_date]
    if category and category.strip():
        lf.append(StockLog.dish.has(category=category))
    logs = StockLog.query.filter(*lf).order_by(StockLog.created_at.desc()).all()
    logs_data = [{
        "时间": l.created_at.strftime("%Y-%m-%d %H:%M:%S"), "单号": str(l.id),
        "菜品名称": l.dish.name if l.dish else "已删除菜品", "变动类型": l.change_type,
        "变动数量": l.quantity_change, "变动后库存": l.stock_after, "变动金额": l.cost or 0,
        "操作人": l.operator.username if hasattr(l, "operator") and l.operator else str(l.operator_id or "-"),
        "备注": l.note or "-",
    } for l in logs]
    output = BytesIO()
    writer = pd.ExcelWriter(output, engine="openpyxl")
    pd.DataFrame(overview).to_excel(writer, sheet_name="库存概览", index=False)
    pd.DataFrame(logs_data).to_excel(writer, sheet_name="库存流水", index=False)
    writer.close()
    output.seek(0)
    fn = f"库存报表_{start_date.strftime('%Y%m%d')}_{end_date.strftime('%Y%m%d')}.xlsx"
    return output, fn
