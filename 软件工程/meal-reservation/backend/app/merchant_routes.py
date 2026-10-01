"""Merchant routes – thin interface layer, all logic in service/merchant/handlers."""
from flask import Blueprint, send_file, request, jsonify, g

from utils import token_required
from service.merchant import handlers

merchant_bp = Blueprint("merchant", __name__, url_prefix="/api/merchant")


# ── settlements ──────────────────────────────────────────────────────
@merchant_bp.route("/settlements", methods=["GET", "POST"])
def merchant_settlements():
    payload, status = handlers.handle_settlements(request.method, request.get_json(silent=True))
    return jsonify(payload), status


# ── menu ─────────────────────────────────────────────────────────────
@merchant_bp.route("/menu", methods=["GET"])
@token_required
def get_merchant_menu():
    payload, status = handlers.get_menu(g.current_user)
    return jsonify(payload), status


# ── upload ───────────────────────────────────────────────────────────
@merchant_bp.route("/upload", methods=["POST"])
@token_required
def upload_merchant_file():
    payload, status = handlers.upload_file(g.current_user, request.files.get("file"), request.form)
    return jsonify(payload), status


# ── reservation status ───────────────────────────────────────────────
@merchant_bp.route("/orders/<int:order_id>/reservation-status", methods=["PUT"])
@token_required
def update_reservation_status(order_id):
    payload, status = handlers.update_reservation_status(g.current_user, order_id, request.get_json() or {})
    return jsonify(payload), status


# ── reservations ─────────────────────────────────────────────────────
@merchant_bp.route("/reservations", methods=["GET"])
@token_required
def get_merchant_reservations():
    payload, status = handlers.get_reservations(
        g.current_user,
        date_str=request.args.get("date"),
        status=request.args.get("status"),
        page=request.args.get("page", 1),
        per_page=request.args.get("per_page", 20),
    )
    return jsonify(payload), status


# ── table schedule ───────────────────────────────────────────────────
@merchant_bp.route("/tables/<int:table_id>/schedule", methods=["GET"])
@token_required
def get_table_schedule(table_id):
    payload, status = handlers.get_table_schedule(g.current_user, table_id, date_str=request.args.get("date"))
    return jsonify(payload), status


# ── reviews ──────────────────────────────────────────────────────────
@merchant_bp.route("/reviews", methods=["GET"])
@token_required
def merchant_get_reviews():
    payload, status = handlers.get_reviews(g.current_user)
    return jsonify(payload), status


@merchant_bp.route("/reviews/<int:review_id>/reply", methods=["POST"])
@token_required
def merchant_reply_review(review_id):
    data = request.get_json() or {}
    payload, status = handlers.reply_review(g.current_user, review_id, data.get("reply"))
    return jsonify(payload), status


# ── orders ───────────────────────────────────────────────────────────
@merchant_bp.route("/orders", methods=["GET"])
@token_required
def get_merchant_orders():
    payload, status = handlers.get_orders(g.current_user, status_filter=request.args.get("status"))
    return jsonify(payload), status


@merchant_bp.route("/orders/<int:order_id>/accept", methods=["POST"])
@token_required
def accept_order(order_id):
    payload, status = handlers.accept_order(g.current_user, order_id)
    return jsonify(payload), status


@merchant_bp.route("/orders/<int:order_id>/reject", methods=["POST"])
@token_required
def reject_order(order_id):
    data = request.get_json(silent=True) or {}
    payload, status = handlers.reject_order(g.current_user, order_id, data.get("reason"))
    return jsonify(payload), status


@merchant_bp.route("/orders/<int:order_id>/serve", methods=["POST"])
@token_required
def serve_order(order_id):
    payload, status = handlers.serve_order(g.current_user, order_id)
    return jsonify(payload), status


@merchant_bp.route("/orders/<int:order_id>/release-seat", methods=["POST"])
@token_required
def release_dine_in_order(order_id):
    payload, status = handlers.release_dine_in_order(g.current_user, order_id)
    return jsonify(payload), status


# ── change requests ──────────────────────────────────────────────────
@merchant_bp.route("/orders/change-requests", methods=["GET"])
@token_required
def merchant_list_change_requests():
    payload, status = handlers.list_change_requests(g.current_user, status_filter=request.args.get("status"))
    return jsonify(payload), status


@merchant_bp.route("/orders/change-requests/<int:request_id>", methods=["PATCH"])
@token_required
def merchant_handle_change_request(request_id):
    payload, status = handlers.handle_change_request(g.current_user, request_id, request.get_json() or {})
    return jsonify(payload), status


# ── statistics overview ──────────────────────────────────────────────
@merchant_bp.route("/statistics/overview", methods=["GET"])
@token_required
def get_statistics_overview():
    payload, status = handlers.statistics_overview(
        g.current_user, request.args.get("start_date"), request.args.get("end_date"), request.args.get("timezone")
    )
    return jsonify(payload), status


@merchant_bp.route("/statistics/trend", methods=["GET"])
@token_required
def get_order_trend():
    payload, status = handlers.order_trend(
        g.current_user, request.args.get("start_date"), request.args.get("end_date"), request.args.get("timezone")
    )
    return jsonify(payload), status


@merchant_bp.route("/statistics/peak-hours", methods=["GET"])
@token_required
def get_peak_hours():
    payload, status = handlers.peak_hours(
        g.current_user, request.args.get("start_date"), request.args.get("end_date"), request.args.get("timezone")
    )
    return jsonify(payload), status


@merchant_bp.route("/statistics/top-dishes", methods=["GET"])
@token_required
def get_top_dishes():
    payload, status = handlers.top_dishes(
        g.current_user, request.args.get("start_date"), request.args.get("end_date"), request.args.get("timezone"), limit=request.args.get("limit", 10)
    )
    return jsonify(payload), status


@merchant_bp.route("/statistics/order-status", methods=["GET"])
@token_required
def get_order_status_distribution():
    payload, status = handlers.order_status_distribution(
        g.current_user, request.args.get("start_date"), request.args.get("end_date"), request.args.get("timezone")
    )
    return jsonify(payload), status


@merchant_bp.route("/statistics/category-share", methods=["GET"])
@token_required
def get_category_share():
    payload, status = handlers.category_share(
        g.current_user, request.args.get("start_date"), request.args.get("end_date"), request.args.get("timezone")
    )
    return jsonify(payload), status


@merchant_bp.route("/statistics/review-wordcloud", methods=["GET"])
@token_required
def get_review_wordcloud():
    payload, status = handlers.review_wordcloud(
        g.current_user, request.args.get("start_date"), request.args.get("end_date"), request.args.get("timezone")
    )
    return jsonify(payload), status


@merchant_bp.route("/statistics/export", methods=["GET"])
@token_required
def export_statistics_report():
    result = handlers.export_statistics(
        g.current_user, request.args.get("start_date"), request.args.get("end_date"), request.args.get("timezone")
    )
    if isinstance(result, tuple) and len(result) == 2:
        output, fn = result
        if isinstance(fn, str):
            return send_file(output, mimetype="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet", as_attachment=True, download_name=fn)
        return jsonify(output), fn
    return jsonify(result)


# ── stock options ────────────────────────────────────────────────────
@merchant_bp.route("/stock/options", methods=["GET"])
@token_required
def get_stock_options():
    payload, status = handlers.stock_options(g.current_user)
    return jsonify(payload), status


@merchant_bp.route("/stock/statistics/overview", methods=["GET"])
@token_required
def get_stock_overview():
    payload, status = handlers.stock_overview(
        g.current_user, request.args.get("start_date"), request.args.get("end_date"), request.args.get("timezone"), category=request.args.get("category")
    )
    return jsonify(payload), status


@merchant_bp.route("/stock/statistics/trend", methods=["GET"])
@token_required
def get_stock_trend():
    payload, status = handlers.stock_trend(
        g.current_user, request.args.get("start_date"), request.args.get("end_date"), request.args.get("timezone"), category=request.args.get("category")
    )
    return jsonify(payload), status


@merchant_bp.route("/stock/statistics/in-out", methods=["GET"])
@token_required
def get_stock_in_out():
    payload, status = handlers.stock_in_out(
        g.current_user, request.args.get("start_date"), request.args.get("end_date"), request.args.get("timezone"), category=request.args.get("category")
    )
    return jsonify(payload), status


@merchant_bp.route("/stock/statistics/cost-distribution", methods=["GET"])
@token_required
def get_stock_cost_distribution():
    payload, status = handlers.stock_cost_distribution(g.current_user, category=request.args.get("category"))
    return jsonify(payload), status


@merchant_bp.route("/stock/statistics/logs", methods=["GET"])
@token_required
def get_stock_logs():
    payload, status = handlers.stock_logs(
        g.current_user, request.args.get("start_date"), request.args.get("end_date"), request.args.get("timezone"), category=request.args.get("category"), page=request.args.get("page", 1), per_page=request.args.get("per_page", 50)
    )
    return jsonify(payload), status


@merchant_bp.route("/stock/statistics/export", methods=["GET"])
@token_required
def export_stock_report():
    result = handlers.export_stock_report(
        g.current_user, request.args.get("start_date"), request.args.get("end_date"), request.args.get("timezone"), category=request.args.get("category")
    )
    if isinstance(result, tuple) and len(result) == 2:
        output, fn = result
        if isinstance(fn, str):
            return send_file(output, mimetype="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet", as_attachment=True, download_name=fn)
        return jsonify(output), fn
    return jsonify(result)


