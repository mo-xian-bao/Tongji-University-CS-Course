"""Support ticket conversation — internal notes and replies."""
from datetime import datetime, timezone

from Models import SupportTicket, db
from utils import BadRequestError, ForbiddenError, NotFoundError, data_list, data_text


def add_internal_note(current_user, ticket_id, text):
    ticket = SupportTicket.query.get(ticket_id)
    if not ticket:
        raise NotFoundError("未找到工单")
    if current_user.usertype not in (0, 100):
        raise ForbiddenError("仅客服可添加内部备注")
    if not text or not text.strip():
        raise BadRequestError("备注内容不能为空")

    note = {
        "text": text.strip(),
        "created_at": datetime.utcnow().isoformat(),
        "author_id": current_user.id,
        "author_name": current_user.username,
    }
    notes = data_list(ticket.internal_notes) if ticket.internal_notes else []
    notes.insert(0, note)
    ticket.internal_notes = data_text(notes)
    ticket.updated_at = datetime.utcnow()
    return note


def add_reply(current_user, ticket_id, data):
    ticket = SupportTicket.query.get(ticket_id)
    if not ticket:
        raise NotFoundError("未找到工单")
    text = data.get("text")
    sender = data.get("from") or getattr(current_user, "username", "客服")
    if not text or not text.strip():
        raise BadRequestError("回复内容不能为空")

    reply = {
        "text": text.strip(),
        "from": sender,
        "created_at": datetime.utcnow().replace(tzinfo=timezone.utc).isoformat(),
        "author_id": current_user.id,
        "author_name": current_user.username,
    }
    replies = data_list(ticket.replies) if ticket.replies else []
    replies.insert(0, reply)
    ticket.replies = data_text(replies)
    ticket.updated_at = datetime.utcnow()
    return reply
