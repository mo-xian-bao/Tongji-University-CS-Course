"""External LLM API client (ModelScope)."""
import os
from typing import Optional, Tuple

import requests


def _call_modelscope_llm(question: str) -> Tuple[Optional[str], Optional[str]]:
    api_key = os.getenv("DASHSCOPE_API_KEY", "")
    if not api_key or "YOUR_" in api_key:
        return None, "API Key not configured"
    url = "https://api-inference.modelscope.cn/v1/chat/completions"
    headers = {"Authorization": f"Bearer {api_key}", "Content-Type": "application/json"}
    payload = {
        "model": "Qwen/Qwen2.5-Coder-32B-Instruct",
        "messages": [
            {
                "role": "system",
                "content": "你是一个负责回答食刻预约餐饮系统问题的小猫娘，请简短且尊敬地回答主人关于系统操作或餐饮管理，点餐的问题。注意加emoji",
            },
            {"role": "user", "content": question},
        ],
        "stream": False,
    }
    try:
        resp = requests.post(url, json=payload, headers=headers, timeout=10)
        if resp.status_code == 200:
            data = resp.json()
            if data.get("choices"):
                return data["choices"][0]["message"]["content"], None
        return None, f"API Error {resp.status_code}"
    except Exception as exc:
        return None, str(exc)
