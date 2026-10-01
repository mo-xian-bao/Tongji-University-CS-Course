"""AI assistant service handlers — orchestration layer.
Flow: DB query → Knowledge Base match → fallback LLM
"""
from typing import Dict, Tuple

from utils import BadRequestError, ok

from .logic.constants import WELCOME_MESSAGE
from .logic.knowledge_base import _find_best_answer
from .logic.llm_client import _call_modelscope_llm
from .logic.db_queries import _query_database
from .logic.response import build_chat_response, _format_user_info


def chat(question: str, current_user=None) -> Tuple[Dict, int]:
    """AI 对话：三级 fallback — 数据库查询 → 知识库匹配 → LLM"""
    if not question:
        raise BadRequestError("缺少 question 字段")
    user_id = current_user.id if current_user and hasattr(current_user, "id") else None

    # 1) 数据库查询
    db_answer, is_db = _query_database(question, user_id)
    if is_db and db_answer:
        return build_chat_response(db_answer, "database", 1.0,
                                   "数据库查询结果", None, current_user), 200

    # 2) 知识库匹配
    result = _find_best_answer(question)
    if result["answer"] and result["score"] >= 0.6:
        return build_chat_response(result["answer"], "knowledge_base",
                                   result["score"], result["title"],
                                   result["matched_question"], current_user), 200

    # 3) 回退 LLM
    external, err = _call_modelscope_llm(question)
    if external:
        return build_chat_response(external, "llm", 0.0,
                                   "AI 智能回复", None, current_user), 200

    return build_chat_response(
        f"暂未找到匹配的知识点，且外部AI响应失败。错误信息: {err}",
        "fallback", result.get("score", 0), result.get("title"),
        result.get("matched_question"), current_user,
    ), 200


def welcome(current_user=None):
    """返回欢迎消息和用户信息"""
    return ok({"success": True,
               "data": {"message": WELCOME_MESSAGE, "user": _format_user_info(current_user)}}, 200)
