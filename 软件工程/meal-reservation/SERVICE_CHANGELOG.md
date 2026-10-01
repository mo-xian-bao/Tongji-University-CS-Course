# Service 层返回与异常处理变更记录

日期：2026-05-24

## 概要
将后端 `service` 层的成功返回统一为 `ok(...)`，并保证业务错误通过 `ApiError`/其子类向上抛出，由全局异常处理器统一格式化返回。此改动旨在让路由层保持轻量、错误处理集中、返回格式一致。

## 变更要点
- 统一成功返回：原先 `return {"success": True, ...}, <status>` 替换为 `return ok({...}, <status>)`。
- 错误仍由服务层抛出：保留 `raise ApiError` 及其子类（如 `BadRequestError`, `NotFoundError` 等）。
- 保留特殊返回：若函数返回文件/流或 `status is None`（例如 `(output, filename)`、`ok(..., None)` 用作特殊信号），不做替换以保持行为不变。
- 向后兼容：继续保留并使用 `coerce_result()` 来兼容旧式 `(payload, status)` 返回（当 status >= 400 时会抛出 `ApiError`）。

