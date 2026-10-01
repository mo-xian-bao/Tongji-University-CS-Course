"""AI assistant response builders."""
from typing import Dict, Optional


def _format_user_info(current_user):
    """Convert current_user to a serializable dict."""
    if current_user is None:
        return None
    if hasattr(current_user, "to_dict"):
        return current_user.to_dict()
    return {
        "user_id": getattr(current_user, "user_id", None),
        "username": getattr(current_user, "username", "游客"),
        "phone": getattr(current_user, "phone", None),
        "user_type": getattr(current_user, "user_type", "guest"),
    }


def build_chat_response(answer: str, source: str, score: float, title: str,
                        matched_question: Optional[str], current_user) -> Dict:
    """Build a standard chat response dict."""
    return {
        "success": True,
        "data": {
            "answer": answer,
            "matched_question": matched_question,
            "score": score,
            "title": title,
            "source": source,
            "user": _format_user_info(current_user),
        },
    }
