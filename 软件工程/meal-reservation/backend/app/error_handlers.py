"""Central Flask error handlers."""

from flask import jsonify
from werkzeug.exceptions import HTTPException

from utils.api_errors import ApiError


def _build_payload(message, status_code, data=None):
    payload = {
        "success": False,
        "message": message,
    }
    if data is not None:
        payload["data"] = data
    payload["code"] = status_code
    return payload


def register_error_handlers(app, db):
    @app.errorhandler(ApiError)
    def handle_api_error(error):
        return jsonify(_build_payload(error.message, error.status_code, error.data)), error.status_code

    @app.errorhandler(HTTPException)
    def handle_http_exception(error):
        default_messages = {
            400: "请求参数有误",
            401: "未授权访问",
            403: "无权访问",
            404: "API接口不存在",
        }
        message = error.description if error.description not in (None, "", "Not Found", "Bad Request", "Unauthorized", "Forbidden") else default_messages.get(error.code, "请求失败")
        return jsonify(_build_payload(message, error.code)), error.code

    @app.errorhandler(Exception)
    def handle_unexpected_error(error):
        db.session.rollback()
        app.logger.exception("Unhandled server error: %s", error)
        return jsonify(_build_payload("服务器内部错误", 500)), 500