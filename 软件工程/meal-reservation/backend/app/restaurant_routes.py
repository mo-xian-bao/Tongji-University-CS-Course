"""Restaurant routes – thin interface layer."""
from flask import Blueprint, request, jsonify, g

from utils import token_required
from service.restaurant import handlers

restaurant_bp = Blueprint("restaurant", __name__, url_prefix="/api/restaurant")
restaurants_bp = Blueprint("restaurants", __name__, url_prefix="/api/restaurants")


@restaurant_bp.route("", methods=["POST"])
@restaurant_bp.route("/", methods=["POST"])
@token_required
def create_restaurant_api():
    payload, status = handlers.create_restaurant_api(g.current_user, request.get_json() or {})
    return jsonify(payload), status


@restaurant_bp.route("/<int:restaurant_id>", methods=["PUT"])
@token_required
def update_restaurant_api(restaurant_id):
    payload, status = handlers.update_restaurant_api(g.current_user, restaurant_id, request.get_json() or {})
    return jsonify(payload), status


@restaurant_bp.route("/<int:restaurant_id>/status", methods=["GET"])
@token_required
def get_restaurant_status_api(restaurant_id):
    payload, status = handlers.get_restaurant_status(g.current_user, restaurant_id)
    return jsonify(payload), status


@restaurant_bp.route("/<int:restaurant_id>/status", methods=["PATCH", "PUT"])
@token_required
def set_restaurant_status_api(restaurant_id):
    data = request.get_json() or {}
    payload, status = handlers.set_restaurant_status(g.current_user, restaurant_id, data.get("is_open"))
    return jsonify(payload), status


@restaurant_bp.route("/user/<int:user_id>", methods=["GET"])
def get_restaurant_by_user_id_api(user_id):
    payload, status = handlers.get_by_user_id(user_id)
    return jsonify(payload), status


@restaurants_bp.route("", methods=["GET"])
@restaurants_bp.route("/", methods=["GET"])
def get_all_restaurants():
    payload, status = handlers.get_all()
    return jsonify(payload), status


@restaurants_bp.route("/<int:restaurant_id>", methods=["GET"])
def get_restaurant_by_id(restaurant_id):
    payload, status = handlers.get_by_id(restaurant_id)
    return jsonify(payload), status


@restaurant_bp.route("/<int:restaurant_id>/tables", methods=["GET"])
def get_restaurant_tables_public(restaurant_id):
    payload, status = handlers.get_tables_public(restaurant_id)
    return jsonify(payload), status


@restaurant_bp.route("/<int:restaurant_id>/broadcasts", methods=["POST"])
def create_restaurant_broadcast(restaurant_id):
    payload, status = handlers.create_broadcast_api(restaurant_id, request.get_json() or {})
    return jsonify(payload), status


@restaurant_bp.route("/<int:restaurant_id>/coupons", methods=["POST"])
@token_required
def create_coupon_broadcast(restaurant_id):
    payload, status = handlers.create_coupon_broadcast_api(g.current_user, restaurant_id, request.get_json() or {})
    return jsonify(payload), status


@restaurant_bp.route("/broadcasts", methods=["GET"])
def get_restaurant_broadcasts():
    payload, status = handlers.broadcast_list(
        restaurant_id=request.args.get("restaurant_id", type=int),
        include_inactive=request.args.get("include_inactive", "false").lower() == "true",
        page=request.args.get("page", default=1, type=int),
        per_page=request.args.get("per_page", default=20, type=int),
    )
    return jsonify(payload), status


@restaurant_bp.route("/<int:restaurant_id>/broadcasts/<int:broadcast_id>", methods=["PATCH", "PUT"])
def modify_restaurant_broadcast(restaurant_id, broadcast_id):
    payload, status = handlers.broadcast_update(restaurant_id, broadcast_id, request.get_json() or {})
    return jsonify(payload), status


@restaurant_bp.route("/<int:restaurant_id>/broadcasts/<int:broadcast_id>", methods=["DELETE"])
def remove_restaurant_broadcast(restaurant_id, broadcast_id):
    payload, status = handlers.broadcast_delete(restaurant_id, broadcast_id)
    return jsonify(payload), status


@restaurant_bp.route("/broadcasts/<int:broadcast_id>", methods=["GET"])
def fetch_broadcast_detail(broadcast_id):
    payload, status = handlers.broadcast_detail(broadcast_id)
    return jsonify(payload), status


@restaurants_bp.route("/<int:restaurant_id>/follow", methods=["GET", "POST", "DELETE"])
@token_required
def handle_restaurant_follow(restaurant_id):
    payload, status = handlers.handle_follow(g.current_user.id, restaurant_id, request.method)
    return jsonify(payload), status


@restaurant_bp.route("/<int:restaurant_id>/tables/available", methods=["GET"])
@token_required
def get_available_tables_for_reservation(restaurant_id):
    payload, status = handlers.get_available_tables(
        restaurant_id,
        request.args.get("reserved_time"),
        request.args.get("customer_count", 1, type=int),
        request.args.get("duration", 120, type=int),
        request.args.get("timezone"),
    )
    return jsonify(payload), status


@restaurant_bp.route("/<int:restaurant_id>/available-slots", methods=["GET"])
@token_required
def get_available_time_slots(restaurant_id):
    payload, status = handlers.get_available_slots(
        restaurant_id,
        request.args.get("date"),
        request.args.get("days", 7),
        request.args.get("timezone"),
    )
    return jsonify(payload), status


@restaurant_bp.route("/<int:restaurant_id>/reviews", methods=["GET"])
def get_restaurant_reviews(restaurant_id):
    payload, status = handlers.get_restaurant_reviews(
        restaurant_id,
        page=request.args.get("page", 1),
        per_page=request.args.get("per_page", 20),
        auth_header=request.headers.get("Authorization", ""),
    )
    return jsonify(payload), status
