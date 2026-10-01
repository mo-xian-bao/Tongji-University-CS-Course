"""Shared helpers for database operations."""
from datetime import datetime
from typing import Optional

from flask import current_app

from Models import db


def check_table_exists(table_name):
    inspector = db.inspect(db.engine)
    return inspector.has_table(table_name)


def _parse_datetime(value: Optional[str]) -> Optional[datetime]:
    if not value:
        return None
    try:
        candidate = value.strip()
        if candidate.endswith('Z'):
            candidate = candidate[:-1] + '+00:00'
        return datetime.fromisoformat(candidate)
    except ValueError:
        raise ValueError('时间格式必须为 ISO8601，例如 2024-01-01T08:00:00')


def _format_price(value):
    if value is None:
        return None
    try:
        return float(value)
    except (TypeError, ValueError):
        return None


def _format_datetime(value):
    if not value:
        return None
    if isinstance(value, datetime):
        return value
    try:
        return datetime.fromisoformat(str(value).replace('Z', '+00:00'))
    except Exception:
        return None
