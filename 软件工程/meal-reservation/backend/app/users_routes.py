"""Users routes – thin interface layer, all logic in service/users/handlers."""
from flask import Blueprint, request, jsonify, g

from utils import token_required
from service.users import handlers  # module import – no name collisions

users_bp = Blueprint("users", __name__, url_prefix="/api/users")


@users_bp.route("/profile", methods=["GET"])
@token_required
def get_profile():
    payload, status = handlers.get_profile(g.current_user)
    return jsonify(payload), status


@users_bp.route("/<int:user_id>", methods=["GET"])
@token_required
def get_user_by_id(user_id):
    payload, status = handlers.get_user_by_id(g.current_user, user_id)
    return jsonify(payload), status


@users_bp.route("/change-password", methods=["POST"])
@token_required
def change_password():
    data = request.get_json() or {}
    payload, status = handlers.change_password(
        g.current_user,
        old_password=data.get("old_password", ""),
        new_password=data.get("new_password", ""),
    )
    return jsonify(payload), status


@users_bp.route("/change-phone", methods=["POST"])
@token_required
def change_phone():
    data = request.get_json() or {}
    payload, status = handlers.change_phone(
        g.current_user,
        new_phone=data.get("new_phone", ""),
        sms_code=data.get("sms_code", ""),
    )
    return jsonify(payload), status


@users_bp.route("/update-profile", methods=["POST"])
@token_required
def update_profile():
    payload, status = handlers.update_profile(
        g.current_user, request.form, request.files
    )
    return jsonify(payload), status


@users_bp.route("/followed-restaurants", methods=["GET"])
@token_required
def fetch_followed_restaurants():
    payload, status = handlers.followed_restaurants(g.current_user)
    return jsonify(payload), status


@users_bp.route("/restaurant", methods=["GET"])
@token_required
def get_user_restaurant():
    payload, status = handlers.user_restaurant(g.current_user)
    return jsonify(payload), status


@users_bp.route("/system-notifications", methods=["GET"])
@token_required
def get_user_system_notifications():
    payload, status = handlers.system_notifications(g.current_user)
    return jsonify(payload), status
