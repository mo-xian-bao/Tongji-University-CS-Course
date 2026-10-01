"""Merchant service handlers — orchestration layer."""
import logging
from collections import Counter
from datetime import datetime

from Models import Dish, Order, OrderItem, Restaurant, Review, StockLog, Table, User, db
from database import get_merchant_restaurant
from utils import BadRequestError, ForbiddenError, NotFoundError, ok

from .logic import orders, reservations, changes, reviews, statistics, stock, menu as _menu, uploads as _uploads, settlements as _settlements
from .logic._helpers import require_merchant

merchant_logger = logging.getLogger("merchant")


# ── menu ─────────────────────────────────────────────────────────────

def get_menu(current_user):
    return _menu.get_menu(current_user)


# ── orders ───────────────────────────────────────────────────────────

def get_orders(current_user, status_filter=None):
    if current_user.usertype != 1:
        return {"success": False, "message": "只有商家可以访问此接口"}, 403
    rest, order_list = orders.fetch_orders(current_user)
    if not rest:
        return {"success": False, "message": "未找到餐厅信息"}, 404
    if status_filter:
        order_list = [o for o in order_list if o.status == status_filter]
    return ok({"success": True, "data": [orders.enrich_order(o) for o in order_list]}, 200)


def accept_order(current_user, order_id):
    if current_user.usertype != 1:
        return {"success": False, "message": "只有商家可以访问此接口"}, 403
    order, rest, err = orders.get_order_for_merchant(current_user, order_id)
    if err:
        return {"success": False, "message": err}, 404 if "不存在" in err else 400
    if order.status != "pending":
        return {"success": False, "message": "订单状态不允许接单"}, 400
    orders.accept(order, rest)
    return ok({"success": True, "message": "接单成功",
               "data": {"order_id": order.id, "pickup_number": order.pickup_number}}, 200)


def reject_order(current_user, order_id, reason):
    if current_user.usertype != 1:
        return {"success": False, "message": "只有商家可以访问此接口"}, 403
    order, rest, err = orders.get_order_for_merchant(current_user, order_id)
    if err:
        return {"success": False, "message": err}, 404 if "不存在" in err else 400
    if order.status != "pending":
        return {"success": False, "message": "订单状态不允许拒单"}, 400
    ok_flag, err = orders.reject(order, reason, current_user.id)
    if not ok_flag:
        return {"success": False, "message": err}, 400
    return ok({"success": True, "message": "已拒绝订单", "data": {"order_id": order.id}}, 200)


def serve_order(current_user, order_id):
    if current_user.usertype != 1:
        return {"success": False, "message": "只有商家可以操作订单"}, 403
    order, rest, err = orders.get_order_for_merchant(current_user, order_id)
    if err:
        return {"success": False, "message": err}, 404 if "不存在" in err else 400
    if order.status != "confirmed":
        return {"success": False, "message": "仅可对已确认订单出餐"}, 400
    orders.serve(order, current_user.id)
    return ok({"success": True, "message": "出餐成功", "data": order.to_dict()}, 200)


def release_dine_in_order(current_user, order_id):
    if current_user.usertype != 1:
        return {"success": False, "message": "只有商家可以操作订单"}, 403
    order, rest, err = orders.get_order_for_merchant(current_user, order_id)
    if err:
        return {"success": False, "message": err}, 404 if "不存在" in err else 400
    ok_flag, err = orders.release_dine_in(order)
    if not ok_flag:
        return {"success": False, "message": err}, 400
    return ok({"success": True, "message": "座位已释放，订单完成", "data": order.to_dict()}, 200)


# ── reservations ─────────────────────────────────────────────────────

def get_reservations(current_user, date_str=None, status=None, page=1, per_page=20):
    data, pagination = reservations.fetch_reservations(current_user, date_str, status, int(page), int(per_page))
    if data is None:
        return {"success": False, "message": "您不是商家"}, 403
    return ok({
        "success": True,
        "data": {
            "reservations": data,
            "pagination": {"page": pagination.page, "per_page": pagination.per_page,
                           "total_pages": pagination.pages, "total_items": pagination.total},
        },
    }, 200)


def update_reservation_status(current_user, order_id, data):
    order = reservations.update_status(current_user, order_id, data)
    return ok({"success": True, "message": "预约状态更新成功", "data": order.to_dict()}, 200)


def get_table_schedule(current_user, table_id, date_str=None):
    table, schedule = reservations.fetch_table_schedule(current_user, table_id, date_str)
    if table is None:
        return {"success": False, "message": "桌位不存在"}, 404
    fd = date_str if date_str else datetime.utcnow().date().isoformat()
    return ok({"success": True,
               "data": {"table": {"id": table.id, "table_number": table.table_number,
                                  "capacity": table.capacity, "table_type": table.table_type},
                        "date": fd, "schedule": schedule}}, 200)


# ── change requests ──────────────────────────────────────────────────

def list_change_requests(current_user, status_filter=None):
    if current_user.usertype != 1:
        return {"success": False, "message": "只有商家可以访问"}, 403
    rest, result = changes.fetch_change_requests(current_user, status_filter)
    if rest is None:
        return {"success": False, "message": "未找到商家餐厅"}, 404
    return ok({"success": True, "data": result}, 200)


def handle_change_request(current_user, request_id, data):
    if current_user.usertype != 1:
        return {"success": False, "message": "只有商家可以访问"}, 403
    cr, err = changes.process(current_user, request_id, data)
    if err:
        is_404 = "不存在" in err or "无权" in err
        return {"success": False, "message": err}, 404 if is_404 else 400
    return ok({"success": True, "message": "处理完成", "data": cr.to_dict()}, 200)


# ── reviews ──────────────────────────────────────────────────────────

def get_reviews(current_user):
    data, err = reviews.fetch_reviews(current_user)
    if err:
        return {"success": False, "message": err}, 403 if "只有" in err else 404
    return ok({"success": True, "data": {"reviews": data}}, 200)


def reply_review(current_user, review_id, reply):
    rv, err = reviews.save_reply(current_user, review_id, reply)
    if err:
        code = 404 if "不存在" in err else (403 if "只有" in err else 400)
        return {"success": False, "message": err}, code
    return ok({"success": True, "message": "回复已保存", "data": rv.to_dict()}, 200)


def review_wordcloud(current_user, start_date_str, end_date_str, tz_name):
    restaurant = require_merchant(current_user)
    if not restaurant:
        return {"success": False, "message": "未找到餐厅信息"}, 404
    data = reviews.generate_wordcloud(restaurant.id, start_date_str, end_date_str, tz_name)
    return ok({"success": True, "data": {"wordcloud": data}}, 200)


# ── statistics ───────────────────────────────────────────────────────

def statistics_overview(current_user, start_date_str, end_date_str, tz_name):
    restaurant = require_merchant(current_user)
    if not restaurant:
        return {"success": False, "message": "未找到餐厅信息"}, 404
    data = statistics.compute_overview(restaurant, start_date_str, end_date_str, tz_name)
    return ok({"success": True, "data": data}, 200)


def order_trend(current_user, start_date_str, end_date_str, tz_name):
    restaurant = require_merchant(current_user)
    if not restaurant:
        return {"success": False, "message": "未找到餐厅信息"}, 404
    data = statistics.compute_trend(restaurant, start_date_str, end_date_str, tz_name)
    return ok({"success": True, "data": {"trend": data}}, 200)


def peak_hours(current_user, start_date_str, end_date_str, tz_name):
    restaurant = require_merchant(current_user)
    if not restaurant:
        return {"success": False, "message": "未找到餐厅信息"}, 404
    data = statistics.compute_peak_hours(restaurant, start_date_str, end_date_str, tz_name)
    return ok({"success": True, "data": {"peak_hours": data}}, 200)


def top_dishes(current_user, start_date_str, end_date_str, tz_name, limit=10):
    restaurant = require_merchant(current_user)
    if not restaurant:
        return {"success": False, "message": "未找到餐厅信息"}, 404
    data = statistics.compute_top_dishes(restaurant, start_date_str, end_date_str, tz_name, limit)
    return ok({"success": True, "data": {"top_dishes": data}}, 200)


def order_status_distribution(current_user, start_date_str, end_date_str, tz_name):
    restaurant = require_merchant(current_user)
    if not restaurant:
        return {"success": False, "message": "未找到餐厅信息"}, 404
    data = statistics.compute_status_distribution(restaurant, start_date_str, end_date_str, tz_name)
    return ok({"success": True, "data": {"status_distribution": data}}, 200)


def category_share(current_user, start_date_str, end_date_str, tz_name):
    restaurant = require_merchant(current_user)
    if not restaurant:
        return {"success": False, "message": "未找到餐厅信息"}, 404
    data = statistics.compute_category_share(restaurant, start_date_str, end_date_str, tz_name)
    return ok({"success": True, "data": {"category_share": data}}, 200)


def export_statistics(current_user, start_date_str, end_date_str, tz_name):
    restaurant = require_merchant(current_user)
    if not restaurant:
        return {"success": False, "message": "未找到餐厅信息"}, 404
    output, fn = statistics.export_excel(restaurant, start_date_str, end_date_str, tz_name)
    return output, fn


# ── stock ────────────────────────────────────────────────────────────

def stock_options(current_user):
    if current_user.usertype != 1:
        return {"success": False, "message": "只有商家可以访问"}, 403
    rest, data = stock.fetch_categories(current_user)
    if not rest:
        return {"success": False, "message": "未找到餐厅"}, 404
    return ok({"success": True, "data": {"categories": data}}, 200)


def stock_overview(current_user, start_date_str, end_date_str, tz_name, category=None):
    if current_user.usertype != 1:
        return {"success": False, "message": "只有商家可以访问"}, 403
    restaurant = require_merchant(current_user)
    if not restaurant:
        return {"success": False, "message": "未找到餐厅"}, 404
    data = stock.compute_overview(restaurant, start_date_str, end_date_str, tz_name, category)
    if data is None:
        return {"success": False, "message": "日期格式错误"}, 400
    return ok({"success": True, "data": data}, 200)


def stock_trend(current_user, start_date_str, end_date_str, tz_name, category=None):
    if current_user.usertype != 1:
        return {"success": False, "message": "只有商家可以访问"}, 403
    restaurant = require_merchant(current_user)
    if not restaurant:
        return {"success": False, "message": "未找到餐厅"}, 404
    data = stock.compute_trend(restaurant, start_date_str, end_date_str, tz_name, category)
    if data is None:
        return {"success": False, "message": "日期格式错误"}, 400
    return ok({"success": True, "data": data}, 200)


def stock_in_out(current_user, start_date_str, end_date_str, tz_name, category=None):
    if current_user.usertype != 1:
        return {"success": False, "message": "只有商家可以访问"}, 403
    restaurant = require_merchant(current_user)
    if not restaurant:
        return {"success": False, "message": "未找到餐厅"}, 404
    data = stock.compute_in_out(restaurant, start_date_str, end_date_str, tz_name, category)
    if data is None:
        return {"success": False, "message": "日期格式错误"}, 400
    return ok({"success": True, "data": data}, 200)


def stock_cost_distribution(current_user, category=None):
    if current_user.usertype != 1:
        return {"success": False, "message": "只有商家可以访问"}, 403
    restaurant = require_merchant(current_user)
    if not restaurant:
        return {"success": False, "message": "未找到餐厅"}, 404
    data = stock.compute_cost_distribution(restaurant, category)
    return ok({"success": True, "data": data}, 200)


def stock_logs(current_user, start_date_str, end_date_str, tz_name, category=None, page=1, per_page=50):
    if current_user.usertype != 1:
        return {"success": False, "message": "只有商家可以访问"}, 403
    restaurant = require_merchant(current_user)
    if not restaurant:
        return {"success": False, "message": "未找到餐厅"}, 404
    data = stock.fetch_logs(restaurant, start_date_str, end_date_str, tz_name, category, page, per_page)
    return ok({"success": True, "data": data}, 200)


def export_stock_report(current_user, start_date_str, end_date_str, tz_name, category=None):
    if current_user.usertype != 1:
        return {"success": False, "message": "只有商家可以访问"}, 403
    restaurant = require_merchant(current_user)
    if not restaurant:
        return {"success": False, "message": "未找到餐厅"}, 404
    output, fn_or_err = stock.export_report(restaurant, start_date_str, end_date_str, tz_name, category)
    if output is None:
        return {"success": False, "message": fn_or_err}, 400
    return output, fn_or_err


# ── upload / settlements ─────────────────────────────────────────────

def upload_file(current_user, file, form):
    return _uploads.upload_file(current_user, file, form)


def handle_settlements(method, data):
    return _settlements.handle_settlements(method, data)
