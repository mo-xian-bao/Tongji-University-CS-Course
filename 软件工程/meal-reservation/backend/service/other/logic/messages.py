"""Message send and list operations."""
from Models import Message, db
from utils import BadRequestError, ok


def send_message(current_user, data):
    order_id = data.get("order_id")
    request_id = data.get("request_id")
    text = (data.get("text") or "").strip()

    if not text or (not order_id and not request_id):
        raise BadRequestError("缺少 order_id/request_id 或 text")

    sender_type = "merchant" if current_user.usertype == 1 else "user"
    message_type = data.get("message_type", "normal")
    msg = Message(
        order_id=order_id,
        request_id=request_id,
        sender_id=getattr(current_user, "id", None),
        sender_type=sender_type,
        text=text,
        message_type=message_type,
    )
    db.session.add(msg)
    return msg


def list_messages(query_params):
    order_id = query_params.get("order_id")
    request_id = query_params.get("request_id")
    last_id = query_params.get("last_id")

    query = Message.query
    if order_id:
        query = query.filter_by(order_id=order_id)
    if request_id:
        query = query.filter_by(request_id=request_id)
    if last_id:
        query = query.filter(Message.id > last_id)

    msgs = query.order_by(Message.created_at.asc()).all()
    return [m.to_dict() for m in msgs]
