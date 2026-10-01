"""Admin merchant application helpers."""
from database import (
    approve_merchant_application as db_approve,
    delete_user_applications as db_delete_user_apps,
    get_all_merchant_applications,
    get_merchant_application_by_id as db_get_app,
    reject_merchant_application as db_reject,
)
from Models import User
from utils import BadRequestError, NotFoundError


def fetch_applications(status, page, per_page):
    return get_all_merchant_applications(status=status, page=page, per_page=per_page)


def fetch_application(application_id):
    app = db_get_app(application_id)
    if not app:
        raise NotFoundError("申请不存在")
    return app


def enrich_with_user(app):
    app_dict = app.to_dict()
    user = User.query.get(app.user_id)
    if user:
        app_dict["user_info"] = {"username": user.username, "phone": user.phone}
    return app_dict


def enrich_detail_with_user(app):
    app_dict = app.to_dict()
    user = User.query.get(app.user_id)
    if user:
        app_dict["user_info"] = {"id": user.id, "username": user.username, "phone": user.phone, "usertype": user.usertype}
    return app_dict


def approve(application_id, admin_id):
    success, message = db_approve(application_id, admin_id)
    if not success:
        raise BadRequestError(message)
    return message


def reject(application_id, admin_id, reason):
    if not reason:
        raise BadRequestError("请填写拒绝理由")
    success, message = db_reject(application_id, admin_id, reason)
    if not success:
        raise BadRequestError(message)
    return message


def cleanup_for_application(application_id):
    app = db_get_app(application_id)
    if not app:
        raise NotFoundError("申请不存在")
    if app.review_status not in ["approved", "rejected"]:
        raise BadRequestError("只能清理已审核完成的申请记录")
    return db_delete_user_apps(app.user_id)
