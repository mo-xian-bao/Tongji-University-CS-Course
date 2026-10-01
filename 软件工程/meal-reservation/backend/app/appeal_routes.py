"""Appeal routes – thin interface layer, all logic in service/appeal/handlers."""
from flask import Blueprint, jsonify, request, send_file

from utils import token_required
from service.appeal import handlers

appeal_bp = Blueprint("appeal", __name__, url_prefix="/api/appeal")


@appeal_bp.route("/", methods=["POST"], strict_slashes=False)
def create_appeal():
    """用户提交申诉"""
    payload, status = handlers.create_appeal(request.get_json() or {})
    return jsonify(payload), status


@appeal_bp.route("/upload", methods=["POST"])
def upload_appeal_attachment():
    """上传申诉附件"""
    payload, status = handlers.upload_attachment(request.files.get("file"))
    return jsonify(payload), status


@appeal_bp.route("/user", methods=["GET"])
@token_required
def get_user_appeals():
    """获取用户自己的申诉列表"""
    from flask import g
    payload, status = handlers.list_user_appeals(g.current_user)
    return jsonify(payload), status


@appeal_bp.route("/<int:appeal_id>", methods=["GET"])
@token_required
def get_appeal_detail(appeal_id):
    """获取用户自己的申诉详情"""
    from flask import g
    payload, status = handlers.get_appeal_detail(g.current_user, appeal_id)
    return jsonify(payload), status


@appeal_bp.route("/<int:attachment_id>/download", methods=["GET"])
@token_required
def download_appeal_attachment(attachment_id):
    """下载申诉附件"""
    from flask import g
    payload, status = handlers.download_attachment(g.current_user, attachment_id, send_file)
    if payload.get("file"):
        return send_file(payload["path"], as_attachment=True, download_name=payload["name"])
    return jsonify(payload), status
