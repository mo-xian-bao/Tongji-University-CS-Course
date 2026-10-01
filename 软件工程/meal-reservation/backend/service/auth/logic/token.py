"""Auth token helpers."""
from Models import User
from utils import create_jwt, decode_jwt


def attach_jwt_to_payload(payload):
    """If payload contains a user dict with id, attach a JWT token."""
    if payload.get("success") and payload.get("data") and payload["data"].get("user"):
        user_id = payload["data"]["user"].get("id")
        if user_id:
            payload["data"]["token"] = create_jwt(user_id)
    return payload


def resolve_user_from_auth_header(auth_header):
    """Parse Bearer token from Authorization header, return User or None."""
    if not auth_header.startswith("Bearer "):
        return None
    token = auth_header.split(" ", 1)[1].strip()
    payload = decode_jwt(token)
    if not payload:
        return None
    user_id = payload.get("sub")
    if not user_id or user_id == "0":
        return None
    return User.query.get(int(user_id))
