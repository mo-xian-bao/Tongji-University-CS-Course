"""Dishes routes – thin interface layer, all logic in service/dishes/handlers."""
from flask import Blueprint, request, jsonify, g

from utils import token_required
from service.dishes import handlers

dishes_bp = Blueprint("dishes", __name__, url_prefix="/api/dishes")


@dishes_bp.route("/<int:dish_id>/status", methods=["PATCH"])
@token_required
def update_dish_status(dish_id):
    payload, status = handlers.update_dish_status(g.current_user, dish_id, request.get_json() or {})
    return jsonify(payload), status


@dishes_bp.route("/<int:dish_id>/off-shelf-info", methods=["GET"])
@token_required
def get_latest_off_shelf_info(dish_id):
    payload, status = handlers.off_shelf_info(g.current_user, dish_id)
    return jsonify(payload), status


@dishes_bp.route("/batch-status", methods=["POST"])
@token_required
def batch_update_dish_status():
    payload, status = handlers.batch_update_status(g.current_user, request.get_json() or {})
    return jsonify(payload), status


@dishes_bp.route("/batch-tags", methods=["POST"])
@token_required
def batch_append_dish_tag():
    payload, status = handlers.batch_append_tag(g.current_user, request.get_json() or {})
    return jsonify(payload), status


@dishes_bp.route("/recommendations", methods=["GET"])
@token_required
def get_recommendations():
    payload, status = handlers.get_recommendations(g.current_user)
    return jsonify(payload), status


@dishes_bp.route("", methods=["GET", "POST"])
@dishes_bp.route("/", methods=["GET", "POST"])
@token_required
def handle_dishes():
    if request.method == "GET":
        payload, status = handlers.list_dishes(
            restaurant_id=request.args.get("restaurant_id"),
            status=request.args.get("status"),
        )
    else:
        payload, status = handlers.create_dish(g.current_user, request.get_json() or {})
    return jsonify(payload), status


@dishes_bp.route("/<int:dish_id>", methods=["GET", "PUT", "DELETE"])
@token_required
def handle_dish(dish_id):
    if request.method == "GET":
        payload, status = handlers.get_dish(dish_id, request.args.get("restaurant_id", type=int))
    elif request.method == "PUT":
        payload, status = handlers.update_dish(dish_id, request.get_json() or {})
    else:
        payload, status = handlers.delete_dish(
            g.current_user, dish_id, request.args.get("restaurant_id", type=int)
        )
    return jsonify(payload), status


@dishes_bp.route("/upload", methods=["POST"])
@token_required
def upload_dish_image():
    payload, status = handlers.upload_image(g.current_user, request.files.get("file"))
    return jsonify(payload), status


@dishes_bp.route("/menu/<int:restaurant_id>")
def get_restaurant_menu(restaurant_id):
    payload, status = handlers.get_menu(restaurant_id)
    return jsonify(payload), status
