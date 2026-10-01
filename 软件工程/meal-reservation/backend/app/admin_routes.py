"""Admin routes – thin interface layer, all logic in service/admin/handlers."""
from flask import Blueprint, request, jsonify, g

from utils import token_required
from service.admin import handlers  # module import – no name collisions

admin_bp = Blueprint("admin", __name__, url_prefix="/api/admin")


# ── reviews ──────────────────────────────────────────────────────────
@admin_bp.route("/reviews", methods=["GET"])
@token_required
def admin_list_reviews():
    payload, status = handlers.list_reviews(
        g.current_user,
        page=request.args.get("page", 1),
        per_page=request.args.get("per_page", 50),
    )
    return jsonify(payload), status


@admin_bp.route("/reviews/<int:review_id>", methods=["PATCH"])
@token_required
def admin_update_review(review_id):
    payload, status = handlers.update_review(
        g.current_user, review_id, request.get_json() or {}
    )
    return jsonify(payload), status


# ── merchant applications ────────────────────────────────────────────
@admin_bp.route("/merchant-applications", methods=["GET"])
@token_required
def admin_get_merchant_applications():
    payload, status = handlers.list_merchant_applications(
        g.current_user,
        status=request.args.get("status"),
        page=request.args.get("page", 1),
        per_page=request.args.get("per_page", 20),
    )
    return jsonify(payload), status


@admin_bp.route("/merchant-applications/<int:application_id>", methods=["GET"])
@token_required
def admin_get_merchant_application_detail(application_id):
    payload, status = handlers.get_merchant_application_detail(g.current_user, application_id)
    return jsonify(payload), status


@admin_bp.route("/merchant-applications/<int:application_id>/approve", methods=["POST"])
@token_required
def admin_approve_merchant_application(application_id):
    payload, status = handlers.approve_application(g.current_user, application_id)
    return jsonify(payload), status


@admin_bp.route("/merchant-applications/<int:application_id>/reject", methods=["POST"])
@token_required
def admin_reject_merchant_application(application_id):
    data = request.get_json() or {}
    reason = (data.get("reason") or "").strip()
    if not data:
        return jsonify({"success": False, "message": "缺少请求数据"}), 400
    payload, status = handlers.reject_application(g.current_user, application_id, reason)
    return jsonify(payload), status


@admin_bp.route("/merchant-applications/<int:application_id>/cleanup", methods=["DELETE"])
@token_required
def admin_cleanup_user_applications(application_id):
    payload, status = handlers.cleanup_user_applications(g.current_user, application_id)
    return jsonify(payload), status


# ── review stats / keywords ──────────────────────────────────────────
@admin_bp.route("/reviews/stats", methods=["GET"])
@token_required
def admin_reviews_stats():
    payload, status = handlers.reviews_stats(g.current_user)
    return jsonify(payload), status


@admin_bp.route("/review-keywords", methods=["GET"])
@token_required
def admin_list_review_keywords():
    payload, status = handlers.list_review_keywords(g.current_user)
    return jsonify(payload), status


@admin_bp.route("/review-keywords", methods=["POST"])
@token_required
def admin_add_review_keyword():
    data = request.get_json() or {}
    keyword = (data.get("keyword") or "").strip()
    payload, status = handlers.add_review_keyword(g.current_user, keyword)
    return jsonify(payload), status


@admin_bp.route("/review-keywords/<int:kw_id>", methods=["DELETE"])
@token_required
def admin_delete_review_keyword(kw_id):
    payload, status = handlers.delete_review_keyword(g.current_user, kw_id)
    return jsonify(payload), status


# ── user ban ─────────────────────────────────────────────────────────
@admin_bp.route("/users/ban/stats", methods=["GET"])
@token_required
def get_ban_stats():
    payload, status = handlers.ban_stats(g.current_user)
    return jsonify(payload), status


@admin_bp.route("/users/ban/list", methods=["GET"])
@token_required
def get_ban_users_list():
    payload, status = handlers.ban_users_list(
        g.current_user,
        search=request.args.get("search", "").strip(),
        status_filter=request.args.get("status", "all").strip(),
        type_filter=request.args.get("type", "all").strip(),
        page=request.args.get("page", 1),
        per_page=request.args.get("per_page", 50),
    )
    return jsonify(payload), status


@admin_bp.route("/users/<int:user_id>/ban", methods=["POST"])
@token_required
def ban_user(user_id):
    data = request.get_json() or {}
    payload, status = handlers.ban_user_op(
        g.current_user,
        user_id,
        ban_type=data.get("type", "permanently"),
        reason=data.get("reason", ""),
        description=data.get("description", ""),
        duration=data.get("duration", 7),
        notify=data.get("notify_user", True),
    )
    return jsonify(payload), status


@admin_bp.route("/users/<int:user_id>/unban", methods=["POST"])
@token_required
def unban_user(user_id):
    payload, status = handlers.unban_user_op(g.current_user, user_id)
    return jsonify(payload), status


@admin_bp.route("/users/<int:user_id>/ban/history", methods=["GET"])
@token_required
def get_ban_history(user_id):
    payload, status = handlers.ban_history(g.current_user, user_id)
    return jsonify(payload), status


# ── appeals ──────────────────────────────────────────────────────────
@admin_bp.route("/appeals", methods=["GET"])
@token_required
def get_all_appeals():
    payload, status = handlers.list_appeals(
        g.current_user,
        status=request.args.get("status", ""),
        page=request.args.get("page", 1),
        per_page=request.args.get("per_page", 20),
    )
    return jsonify(payload), status


@admin_bp.route("/appeal/<int:appeal_id>/process", methods=["POST"])
@token_required
def process_appeal(appeal_id):
    data = request.get_json()
    if not data:
        payload, status = {"success": False, "message": "请提供处理结果"}, 400
    else:
        payload, status = handlers.process_appeal(
            g.current_user,
            appeal_id,
            action=data.get("action", "").strip(),
            admin_note=data.get("admin_note", "").strip(),
        )
    return jsonify(payload), status


# ── merchant applications stats ──────────────────────────────────────
@admin_bp.route("/merchant-applications/stats", methods=["GET"])
@token_required
def get_merchant_applications_stats():
    payload, status = handlers.merchant_applications_stats(g.current_user)
    return jsonify(payload), status


# ── system notifications ─────────────────────────────────────────────
@admin_bp.route("/system-notifications", methods=["GET"])
@token_required
def get_system_notifications():
    payload, status = handlers.list_system_notifications(g.current_user)
    return jsonify(payload), status


@admin_bp.route("/system-notifications", methods=["POST"])
@token_required
def create_system_notification():
    data = request.get_json() or {}
    payload, status = handlers.create_system_notification(
        g.current_user,
        content=data.get("content", ""),
        target_audience=data.get("target_audience", "all"),
    )
    return jsonify(payload), status


@admin_bp.route(
    "/system-notifications/<int:admin_id>/<target_audience>/<timestamp>",
    methods=["DELETE"],
)
@token_required
def delete_system_notification_message(admin_id, target_audience, timestamp):
    payload, status = handlers.delete_system_notification_message(
        g.current_user, admin_id, target_audience, timestamp
    )
    return jsonify(payload), status


@admin_bp.route(
    "/system-notifications/<int:admin_id>/<target_audience>", methods=["DELETE"]
)
@token_required
def delete_system_notification(admin_id, target_audience):
    payload, status = handlers.delete_system_notification(
        g.current_user, admin_id, target_audience
    )
    return jsonify(payload), status


# ── appeals stats ────────────────────────────────────────────────────
@admin_bp.route("/appeals/stats", methods=["GET"])
@token_required
def get_appeals_stats():
    payload, status = handlers.appeals_stats(g.current_user)
    return jsonify(payload), status
