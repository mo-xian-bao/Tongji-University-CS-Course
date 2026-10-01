import base64
import json
import hmac
import hashlib
from datetime import datetime, timedelta, timezone
from typing import Dict, Any, Optional


def _b64url_encode(data: bytes) -> str:
    return base64.urlsafe_b64encode(data).rstrip(b"=").decode("utf-8")


def _b64url_decode(data: str) -> bytes:
    padding = '=' * (-len(data) % 4)
    return base64.urlsafe_b64decode(data + padding)


def create_jwt(payload: Dict[str, Any], secret: str, expires_minutes: int = 60, algorithm: str = "HS256") -> str:
    header = {"typ": "JWT", "alg": algorithm}
    now = datetime.now(timezone.utc)
    exp = now + timedelta(minutes=expires_minutes)
    full_payload = dict(payload)
    full_payload.update({"iat": int(now.timestamp()), "exp": int(exp.timestamp())})

    header_b64 = _b64url_encode(json.dumps(header, separators=(",", ":")).encode("utf-8"))
    payload_b64 = _b64url_encode(json.dumps(full_payload, separators=(",", ":")).encode("utf-8"))
    signing_input = f"{header_b64}.{payload_b64}".encode("utf-8")

    if algorithm != "HS256":
        raise ValueError("Unsupported algorithm")
    signature = hmac.new(secret.encode("utf-8"), signing_input, hashlib.sha256).digest()
    signature_b64 = _b64url_encode(signature)
    return f"{header_b64}.{payload_b64}.{signature_b64}"


def verify_jwt(token: str, secret: str, algorithms: Optional[list[str]] = None) -> Dict[str, Any]:
    algorithms = algorithms or ["HS256"]
    try:
        header_b64, payload_b64, signature_b64 = token.split(".")
    except ValueError:
        raise ValueError("Invalid token format")

    header = json.loads(_b64url_decode(header_b64))
    if header.get("alg") not in algorithms:
        raise ValueError("Unsupported algorithm")

    signing_input = f"{header_b64}.{payload_b64}".encode("utf-8")
    expected_sig = hmac.new(secret.encode("utf-8"), signing_input, hashlib.sha256).digest()
    expected_sig_b64 = _b64url_encode(expected_sig)
    if not hmac.compare_digest(expected_sig_b64, signature_b64):
        raise ValueError("Invalid signature")

    payload = json.loads(_b64url_decode(payload_b64))
    exp = payload.get("exp")
    if exp is not None and int(exp) < int(datetime.now(timezone.utc).timestamp()):
        raise ValueError("Token expired")
    return payload


