"""JSON helpers."""
import json
from typing import Any, List


def data_text(data_list: List[Any], indent: int = None) -> str:
    """
    将列表转换为JSON字符串

    参数:
        data_list: 要转换的列表
        indent: 缩进空格数（None表示紧凑格式）

    返回:
        JSON格式的字符串
    """
    try:
        return json.dumps(data_list, ensure_ascii=False, indent=indent)
    except (TypeError, ValueError) as e:
        raise ValueError(f"无法序列化为JSON: {e}")


def data_list(json_str: str) -> List[Any]:
    """
    将JSON字符串转换回列表

    参数:
        json_str: JSON格式的字符串

    返回:
        列表对象
    """
    try:
        return json.loads(json_str)
    except json.JSONDecodeError as e:
        raise ValueError(f"无效的JSON字符串: {e}")
