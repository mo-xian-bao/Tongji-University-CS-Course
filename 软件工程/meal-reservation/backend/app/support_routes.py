"""Support routes – thin interface layer, all logic in service/support/handlers."""
from flask import Blueprint, request, jsonify, g

from utils import token_required
from service.support import handlers

support_bp = Blueprint("support", __name__, url_prefix="/api/support")


@support_bp.route("/tickets/<int:ticket_id>", methods=["GET"])
@token_required
def get_support_ticket(ticket_id):
    payload, status = handlers.get_ticket(g.current_user, ticket_id)
    return jsonify(payload), status


@support_bp.route("/tickets/<int:ticket_id>", methods=["PUT"])
@token_required
def update_support_ticket(ticket_id):
    payload, status = handlers.update_ticket(
        g.current_user, ticket_id, request.get_json() or {}
    )
    return jsonify(payload), status


@support_bp.route("/tickets", methods=["GET", "POST"])
@token_required
def support_tickets_api():
    if request.method == "POST":
        payload, status = handlers.create_ticket(
            g.current_user, request.get_json() or {}
        )
    else:
        payload, status = handlers.list_my_tickets(g.current_user)
    return jsonify(payload), status


@support_bp.route("/upload", methods=["POST"])
@token_required
def support_upload():
    payload, status = handlers.upload_files(
        request.files.getlist("files") if request.files else [],
        request.host_url,
    )
    return jsonify(payload), status


@support_bp.route("/get_tickets", methods=["GET"])
@token_required
def support_get_tickets():
    payload, status = handlers.get_dashboard_tickets(g.current_user)
    return jsonify(payload), status


@support_bp.route("/get_alltickets", methods=["GET"])
@token_required
def support_get_alltickets():
    payload, status = handlers.get_all_tickets(g.current_user)
    return jsonify(payload), status


@support_bp.route("/tickets/<int:ticket_id>/internal_notes", methods=["POST"])
@token_required
def add_internal_note(ticket_id):
    data = request.get_json() or {}
    payload, status = handlers.add_internal_note(
        g.current_user, ticket_id, (data.get("text") or "").strip()
    )
    return jsonify(payload), status


@support_bp.route("/tickets/<int:ticket_id>/reply", methods=["POST"])
@token_required
def add_ticket_reply(ticket_id):
    payload, status = handlers.add_reply(
        g.current_user, ticket_id, request.get_json() or {}
    )
    return jsonify(payload), status
import os
import uuid
from werkzeug.utils import secure_filename
