"""Tables routes – thin interface layer, all logic in service/tables/handlers."""
from flask import Blueprint, request, jsonify, g

from utils import token_required
from service.tables import handlers

tables_bp = Blueprint("tables", __name__, url_prefix="/api/tables")


@tables_bp.route("", methods=["GET"])
@token_required
def get_tables_list():
    """获取餐厅桌位列表"""
    payload, status = handlers.get_tables_list(g.current_user)
    return jsonify(payload), status


@tables_bp.route("", methods=["POST"])
@token_required
def add_new_table():
    """添加新桌位"""
    payload, status = handlers.add_table(g.current_user, request.get_json() or {})
    return jsonify(payload), status


@tables_bp.route("/<int:table_id>", methods=["PUT"])
@token_required
def update_table_info(table_id):
    """更新桌位信息"""
    payload, status = handlers.update_table(table_id, request.get_json() or {})
    return jsonify(payload), status


@tables_bp.route("/<int:table_id>", methods=["DELETE"])
@token_required
def delete_table_by_id(table_id):
    """删除桌位"""
    payload, status = handlers.delete_table(table_id)
    return jsonify(payload), status


@tables_bp.route("/<int:table_id>", methods=["GET"])
@token_required
def get_table_detail(table_id):
    """获取单个桌位详情"""
    payload, status = handlers.get_table_detail(g.current_user, table_id)
    return jsonify(payload), status
