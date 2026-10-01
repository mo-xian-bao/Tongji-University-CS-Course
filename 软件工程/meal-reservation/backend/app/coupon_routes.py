"""Coupon routes – thin interface layer, all logic in service/coupon/handlers."""
from flask import Blueprint, request, jsonify, g

from utils import token_required
from service.coupon import handlers

coupon_bp = Blueprint("coupon", __name__, url_prefix="/api/coupons")


@coupon_bp.route("/recommendations", methods=["GET"])
@token_required
def get_coupon_recommendations():
    payload, status = handlers.get_recommendations(g.current_user, request.args.get("limit", 10))
    return jsonify(payload), status


@coupon_bp.route("/<int:coupon_id>/accept", methods=["POST"])
@token_required
def accept_coupon(coupon_id):
    payload, status = handlers.accept_coupon(g.current_user, coupon_id)
    return jsonify(payload), status


@coupon_bp.route("/<int:coupon_id>/reject", methods=["POST"])
@token_required
def reject_coupon(coupon_id):
    payload, status = handlers.reject_coupon(g.current_user, coupon_id)
    return jsonify(payload), status


@coupon_bp.route("/<int:coupon_id>/use", methods=["POST"])
@token_required
def use_coupon(coupon_id):
    payload, status = handlers.use_coupon(g.current_user, coupon_id, request.get_json() or {})
    return jsonify(payload), status


@coupon_bp.route("/my-coupons", methods=["GET"])
@token_required
def get_user_coupons():
    payload, status = handlers.my_coupons(
        g.current_user,
        status=request.args.get("status", "available"),
        page=request.args.get("page", 1),
        per_page=request.args.get("per_page", 20),
    )
    return jsonify(payload), status


@coupon_bp.route("/<int:coupon_id>", methods=["GET"])
@token_required
def get_coupon_detail(coupon_id):
    payload, status = handlers.detail(g.current_user, coupon_id)
    return jsonify(payload), status


@coupon_bp.route("/recommendations/<int:coupon_id>", methods=["GET"])
@token_required
def get_coupon_recommendation_detail(coupon_id):
    payload, status = handlers.recommendation_detail(g.current_user, coupon_id)
    return jsonify(payload), status


@coupon_bp.route("/refresh-recommendations", methods=["POST"])
@token_required
def refresh_recommendations():
    payload, status = handlers.refresh_recommendations(g.current_user)
    return jsonify(payload), status


@coupon_bp.route("/status", methods=["GET"])
@token_required
def get_recommendation_status():
    payload, status = handlers.status(g.current_user)
    return jsonify(payload), status
