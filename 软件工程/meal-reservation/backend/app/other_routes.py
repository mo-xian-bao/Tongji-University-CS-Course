from flask import Blueprint, request, jsonify, g

from utils import token_required
from service.other import handlers  # module import – no name collisions

other_bp = Blueprint("other", __name__, url_prefix="/api")


@other_bp.route("/health")
def health_check():
    resp, code = handlers.get_health()
    return jsonify(resp), code


@other_bp.route("/upload", methods=["POST"])
@token_required
def upload_file_api():
    resp, code = handlers.upload_file(request.files.get("file"), request.host_url)
    return jsonify(resp), code


@other_bp.route("/dish-notifications", methods=["GET"])
def get_dish_launch_notifications():
    resp, code = handlers.list_dish_notifications(
        restaurant_id=request.args.get("restaurant_id", type=int),
        include_inactive=request.args.get("include_inactive", "false").lower() == "true",
        page=request.args.get("page", default=1, type=int),
        per_page=request.args.get("per_page", default=20, type=int),
    )
    return jsonify(resp), code


@other_bp.route("/dish-notifications/<int:notification_id>", methods=["GET"])
def fetch_dish_launch_notification(notification_id):
    resp, code = handlers.fetch_dish_notification(notification_id)
    return jsonify(resp), code


@other_bp.route("/coupon-notifications", methods=["GET"])
@token_required
def get_coupon_notifications():
    current_user_id = g.current_user.id if g.current_user and g.current_user.id else None
    resp, code = handlers.list_coupon_notifications(
        current_user_id=current_user_id,
        restaurant_id=request.args.get("restaurant_id", type=int),
        include_inactive=request.args.get("include_inactive", "false").lower() == "true",
        page=request.args.get("page", default=1, type=int),
        per_page=request.args.get("per_page", default=20, type=int),
    )
    return jsonify(resp), code


@other_bp.route("/coupon-notifications/<int:notification_id>", methods=["GET"])
def fetch_coupon_notification(notification_id):
    resp, code = handlers.fetch_coupon_notification(notification_id)
    return jsonify(resp), code


@other_bp.route("/merchant-application", methods=["GET", "POST"])
@token_required
def handle_merchant_applications():
    resp, code = handlers.list_or_create_merchant_application(
        request.method, request.content_type, request.form,
        request.get_json(silent=True), g.current_user,
    )
    return jsonify(resp), code


@other_bp.route("/merchant-application/<int:application_id>", methods=["GET", "PUT"])
@token_required
def handle_merchant_application(application_id):
    resp, code = handlers.get_or_update_merchant_application(
        request.method, request.content_type, request.form,
        request.get_json(silent=True), g.current_user, application_id,
    )
    return jsonify(resp), code


@other_bp.route("/reviews", methods=["POST"])
@token_required
def submit_review_api():
    resp, code = handlers.submit_review(g.current_user, request.get_json() or {})
    return jsonify(resp), code


@other_bp.route("/reviews/<int:review_id>/like", methods=["POST"])
@token_required
def like_review_api(review_id):
    action = (request.get_json() or {}).get("action")
    resp, code = handlers.like_review(g.current_user, review_id, action)
    return jsonify(resp), code


@other_bp.route("/messages", methods=["GET", "POST"])
@token_required
def messages_route():
    resp, code = handlers.messages_api(
        request.method,
        g.current_user,
        request.get_json(silent=True),
        {
            "order_id": request.args.get("order_id", type=int),
            "request_id": request.args.get("request_id", type=int),
            "last_id": request.args.get("last_id", type=int),
        },
    )
    return jsonify(resp), code
