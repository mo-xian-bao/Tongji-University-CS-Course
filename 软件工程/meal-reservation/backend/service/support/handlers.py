"""Support service handlers — orchestration layer."""
from Models import db
from utils import ApiError, BadRequestError, BusinessError, ForbiddenError, ok

from .logic import conversation, tickets, uploads


def get_ticket(current_user, ticket_id):
    try:
        ticket = tickets.get_ticket(ticket_id)
        if ticket.user_id != current_user.id and current_user.usertype not in (0, 100):
            raise ForbiddenError("无权查看此工单")
        return ok({"success": True, "data": ticket.to_dict()}, 200)
    except ApiError:
        raise
    except Exception as exc:
        raise BusinessError("获取工单失败", 500, {"error": str(exc)})


def update_ticket(current_user, ticket_id, data):
    try:
        ticket = tickets.get_ticket(ticket_id)
        result = tickets.update_ticket(ticket, current_user, data)
        db.session.commit()
        return ok({"success": True, "message": "更新成功", "data": result}, 200)
    except ApiError:
        raise
    except Exception as exc:
        db.session.rollback()
        raise BusinessError("更新工单失败", 500, {"error": str(exc)})


def create_ticket(current_user, data):
    try:
        ticket = tickets.create_ticket(current_user, data)
        db.session.commit()
        return ok({"success": True, "message": "工单创建成功", "data": ticket.to_dict()}, 201)
    except ApiError:
        raise
    except Exception as exc:
        db.session.rollback()
        raise BusinessError("创建工单失败", 500, {"error": str(exc)})


def list_my_tickets(current_user):
    try:
        data = tickets.list_my_tickets(current_user)
        return ok({"success": True, "data": data}, 200)
    except ApiError:
        raise
    except Exception as exc:
        raise BusinessError("获取工单列表失败", 500, {"error": str(exc)})


def upload_files(files, host_url):
    try:
        saved = uploads.upload_files(files, host_url)
        return ok({"success": True, "files": saved}, 200)
    except ApiError:
        raise
    except Exception as exc:
        raise BusinessError("文件上传失败", 500, {"error": str(exc)})


def get_dashboard_tickets(current_user):
    try:
        data = tickets.get_dashboard_tickets(current_user)
        return ok({"success": True, "data": data}, 200)
    except ApiError:
        raise
    except Exception as exc:
        raise BusinessError("获取仪表盘数据失败", 500, {"error": str(exc)})


def get_all_tickets(current_user):
    try:
        data = tickets.get_all_tickets(current_user)
        return ok({"success": True, "data": data}, 200)
    except ApiError:
        raise
    except Exception as exc:
        raise BusinessError("获取工单列表失败", 500, {"error": str(exc)})


def add_internal_note(current_user, ticket_id, text):
    try:
        note = conversation.add_internal_note(current_user, ticket_id, text)
        db.session.commit()
        return ok({"success": True, "message": "内部备注已添加", "note": note}, 201)
    except ApiError:
        raise
    except Exception as exc:
        db.session.rollback()
        raise BusinessError("添加备注失败", 500, {"error": str(exc)})


def add_reply(current_user, ticket_id, data):
    try:
        reply = conversation.add_reply(current_user, ticket_id, data)
        db.session.commit()
        return ok({"success": True, "message": "回复已保存", "reply": reply}, 201)
    except ApiError:
        raise
    except Exception as exc:
        db.session.rollback()
        raise BusinessError("回复失败", 500, {"error": str(exc)})
