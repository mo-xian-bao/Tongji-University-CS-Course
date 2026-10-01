"""Central API exception types."""


class ApiError(Exception):
    """Base class for API-facing errors."""

    def __init__(self, message, status_code=400, data=None):
        super().__init__(message)
        self.message = message
        self.status_code = status_code
        self.data = data


class BadRequestError(ApiError):
    def __init__(self, message="请求参数有误", data=None):
        super().__init__(message, 400, data)


class UnauthorizedError(ApiError):
    def __init__(self, message="未授权访问", data=None):
        super().__init__(message, 401, data)


class ForbiddenError(ApiError):
    def __init__(self, message="无权访问", data=None):
        super().__init__(message, 403, data)


class NotFoundError(ApiError):
    def __init__(self, message="资源不存在", data=None):
        super().__init__(message, 404, data)


class ConflictError(ApiError):
    def __init__(self, message="资源冲突", data=None):
        super().__init__(message, 409, data)


class BusinessError(ApiError):
    """Business-level error, defaulting to 400."""

    def __init__(self, message, status_code=400, data=None):
        super().__init__(message, status_code, data)