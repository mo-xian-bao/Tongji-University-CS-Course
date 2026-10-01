"""AI assistant routes – thin interface layer, all logic in service/ai_assistant/handlers."""
from flask import Blueprint, jsonify, request, g

from utils import optional_token_required
from service.ai_assistant import handlers

ai_assistant_bp = Blueprint("ai_assistant", __name__, url_prefix="/api/ai")


@ai_assistant_bp.route("/chat", methods=["POST"])
@optional_token_required
def chat_with_assistant():
    data = request.get_json(silent=True) or {}
    question = (data.get("question") or "").strip()
    current_user = g.current_user if hasattr(g, "current_user") else None
    payload, status = handlers.chat(question, current_user)
    return jsonify(payload), status


@ai_assistant_bp.route("/welcome", methods=["GET"])
@optional_token_required
def get_welcome_message():
    current_user = g.current_user if hasattr(g, "current_user") else None
    payload, status = handlers.welcome(current_user)
    return jsonify(payload), status

# Blueprint
ai_assistant_bp = Blueprint('ai_assistant', __name__, url_prefix='/api/ai')
