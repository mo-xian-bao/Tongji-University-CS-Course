"""Appeal attachment helpers — upload, download, validation."""
import os
import uuid

from Models import AppealAttachment, db
from utils import (
    ALLOWED_EXTENSIONS,
    APPEAL_UPLOAD_FOLDER,
    BACKEND_DIR,
    ApiError,
    BadRequestError,
    BusinessError,
    ForbiddenError,
    NotFoundError,
    allowed_file,
    ok,
)


def upload_attachment(file):
    try:
        if not file or file.filename == "":
            raise BadRequestError("没有找到文件或未选择文件")
        if not allowed_file(file.filename):
            raise BadRequestError(f"不支持的文件类型，支持的类型: {', '.join(ALLOWED_EXTENSIONS)}")

        ext = file.filename.rsplit(".", 1)[1].lower()
        name = f"{uuid.uuid4().hex}.{ext}"
        path = os.path.join(APPEAL_UPLOAD_FOLDER, name)
        os.makedirs(APPEAL_UPLOAD_FOLDER, exist_ok=True)
        file.save(path)
        size = os.path.getsize(path)
        return ok(
            {
            "success": True,
            "message": "文件上传成功",
            "data": {
                "file_name": file.filename,
                "file_path": os.path.relpath(path, BACKEND_DIR).replace("\\", "/"),
                "file_size": size,
                "file_type": ext,
                "mime_type": file.mimetype or "application/octet-stream",
            },
        },
            200,
        )
    except Exception as exc:
        if isinstance(exc, ApiError):
            raise
        raise BusinessError("文件上传失败", 500, {"error": str(exc)})


def download_attachment(current_user, attachment_id, send_file_func):
    try:
        att = AppealAttachment.query.get(attachment_id)
        if not att or not att.is_active():
            raise NotFoundError("附件不存在或已被删除")
        if current_user.usertype != 0 and att.appeal.user_id != current_user.id:
            raise ForbiddenError("无权下载此附件")
        file_path = os.path.join(BACKEND_DIR, att.file_path)
        if not os.path.exists(file_path):
            raise NotFoundError("文件不存在")
        return ok({"file": True, "path": file_path, "name": att.file_name}, None)  # special signal
    except Exception as exc:
        if isinstance(exc, ApiError):
            raise
        raise BusinessError("下载附件失败", 500, {"error": str(exc)})
