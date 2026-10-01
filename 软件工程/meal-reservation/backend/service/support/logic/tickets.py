"""Support ticket CRUD and dashboard queries."""
from datetime import datetime

from Models import SupportTicket, db
from utils import BadRequestError


def get_ticket(ticket_id):
    from utils import NotFoundError
    ticket = SupportTicket.query.get(ticket_id)
    if not ticket:
        raise NotFoundError("未找到工单")
    return ticket


def update_ticket(ticket, current_user, data):
    status = data.get("status")
    rating = data.get("rating")
    rating_comment = data.get("rating_comment")

    if current_user.usertype in (0, 100):
        if status:
            ticket.status = status
        if status in ("in_process", "resolved"):
            ticket.assigned_cs_id = current_user.id
        if rating is not None:
            ticket.rating = int(rating) if str(rating).isdigit() else None
        if rating_comment is not None:
            ticket.rating_comment = rating_comment
        ticket.updated_at = datetime.utcnow()
        return ticket.to_dict()

    from utils import ForbiddenError
    if ticket.user_id != current_user.id:
        raise ForbiddenError("无权限更新工单")

    if status in ("closed", "open"):
        ticket.status = status
    if rating is not None:
        if ticket.status != "resolved":
            raise BadRequestError("仅可对已解决工单进行评分")
        ticket.rating = int(rating) if str(rating).isdigit() else None
        if rating_comment is not None:
            ticket.rating_comment = rating_comment
    ticket.updated_at = datetime.utcnow()
    return ticket.to_dict()


def create_ticket(current_user, data):
    ticket_type = data.get("ticket_type")
    subject = data.get("subject")
    content = data.get("content")
    order_id = data.get("order_id")
    attachments = data.get("attachments") or []

    if not subject or not content:
        raise BadRequestError("标题和描述为必填字段")
    if attachments and not isinstance(attachments, list):
        raise BadRequestError("attachments 必须为数组")

    ticket = SupportTicket(
        ticket_number=SupportTicket.generate_ticket_number(),
        user_id=current_user.id,
        ticket_type=ticket_type or "general",
        subject=subject,
        content=content,
        order_id=order_id,
        status="open",
        attachments=attachments,
    )
    db.session.add(ticket)
    return ticket


def list_my_tickets(current_user):
    tickets = (
        SupportTicket.query.filter_by(user_id=current_user.id)
        .order_by(SupportTicket.created_at.desc())
        .all()
    )
    return [t.to_dict() for t in tickets]


def _build_dashboard(current_user):
    open_q = SupportTicket.query.filter_by(status="open").order_by(SupportTicket.created_at.desc()).all()
    open_list = [t.to_dict() for t in open_q]
    my_in_progress, my_today_processed = [], []
    if current_user.usertype == 100:
        my_q = SupportTicket.query.filter_by(assigned_cs_id=current_user.id)
        my_in_progress = [t.to_dict() for t in my_q.filter_by(status="in_process").order_by(SupportTicket.updated_at.desc()).all()]
        today = datetime.utcnow().date()
        start, end = datetime.combine(today, datetime.min.time()), datetime.combine(today, datetime.max.time())
        my_today_processed = [
            t.to_dict()
            for t in my_q.filter(
                SupportTicket.status.in_(["resolved", "closed"]),
                SupportTicket.updated_at >= start,
                SupportTicket.updated_at <= end,
            ).order_by(SupportTicket.updated_at.desc()).all()
        ]
    return open_list, my_in_progress, my_today_processed


def get_dashboard_tickets(current_user):
    open_list, my_in_progress, my_today_processed = _build_dashboard(current_user)
    return {
        "open": open_list,
        "my_in_progress": my_in_progress,
        "my_today_processed": my_today_processed,
    }


def get_all_tickets(current_user):
    open_list, my_in_progress, my_today_processed = _build_dashboard(current_user)
    return open_list + my_in_progress + my_today_processed
