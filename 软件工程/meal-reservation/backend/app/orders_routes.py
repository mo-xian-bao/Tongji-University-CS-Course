"""Orders routes – thin interface layer, all logic in service/orders/handlers."""
from flask import Blueprint, request, jsonify, g

from utils import token_required
from service.orders import handlers

orders_bp = Blueprint("orders", __name__, url_prefix="/api/orders")


@orders_bp.route("/create", methods=["POST"])
@token_required
def create_order():
    payload, status = handlers.create_order(g.current_user, request.get_json() or {})
    return jsonify(payload), status


@orders_bp.route("", methods=["GET"])
@token_required
def get_user_orders():
    payload, status = handlers.list_user_orders(g.current_user)
    return jsonify(payload), status


@orders_bp.route("/<int:order_id>", methods=["GET"])
@token_required
def get_order_detail(order_id):
    payload, status = handlers.get_order_detail(g.current_user, order_id)
    return jsonify(payload), status


@orders_bp.route("/<int:order_id>", methods=["PUT"])
@token_required
def update_user_order(order_id):
    payload, status = handlers.update_user_order(g.current_user, order_id, request.get_json() or {})
    return jsonify(payload), status


@orders_bp.route("/<int:order_id>/cancel", methods=["POST"])
@token_required
def cancel_user_order(order_id):
    payload, status = handlers.cancel_user_order(g.current_user, order_id)
    return jsonify(payload), status


@orders_bp.route("/<int:order_id>/request-change", methods=["POST"])
@token_required
def request_order_change(order_id):
    payload, status = handlers.request_order_change(g.current_user, order_id, request.get_json() or {})
    return jsonify(payload), status


@orders_bp.route("/change-requests/<int:request_id>/withdraw", methods=["POST"])
@token_required
def withdraw_change_request(request_id):
    payload, status = handlers.withdraw_change_request(g.current_user, request_id)
    return jsonify(payload), status


@orders_bp.route("/<int:order_id>/review", methods=["GET"])
@token_required
def get_order_review(order_id):
    payload, status = handlers.get_order_review(g.current_user, order_id)
    return jsonify(payload), status


@orders_bp.route("/pickup-notifications", methods=["GET"])
@token_required
def list_pickup_notifications():
    payload, status = handlers.list_pickup_notifications(g.current_user)
    return jsonify(payload), status


@orders_bp.route("/pickup-notifications/<int:notification_id>", methods=["GET"])
@token_required
def get_pickup_notification(notification_id):
    payload, status = handlers.get_pickup_notification(g.current_user, notification_id)
    return jsonify(payload), status
