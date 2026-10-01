"""Helpers for service-layer success results."""

from .api_errors import ApiError, BusinessError


class ServiceResult(dict):
    """Dict-like payload that also supports tuple unpacking as (payload, status)."""

    def __init__(self, payload, status_code=200):
        super().__init__(payload)
        self.status_code = status_code

    def __iter__(self):
        yield dict(self)
        yield self.status_code


def ok(payload, status_code=200):
    return ServiceResult(payload, status_code)


def coerce_result(result, default_message="请求失败"):
    """Convert a legacy (payload, status) result into success wrapper or API exception."""
    if isinstance(result, tuple) and len(result) == 2:
        payload, status_code = result
        if status_code is None:
            return payload
        if status_code >= 400:
            if isinstance(payload, dict):
                message = payload.get("message") or default_message
                data = payload.get("data")
            else:
                message = default_message
                data = None
            raise ApiError(message, status_code, data)
        return ok(payload, status_code)
    return result