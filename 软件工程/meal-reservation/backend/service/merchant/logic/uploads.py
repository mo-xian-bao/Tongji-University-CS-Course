"""Merchant file upload."""
import os
import uuid
from datetime import datetime

from utils import BadRequestError, MERCHANT_UPLOAD_FOLDER, allowed_file, ok


def upload_file(current_user, file, form):
    if not file or file.filename == "":
        raise BadRequestError("未选择文件")
    if not allowed_file(file.filename):
        raise BadRequestError("不支持的文件类型")
    file_type = form.get("file_type", "license")
    subfolder = os.path.join(MERCHANT_UPLOAD_FOLDER, file_type)
    os.makedirs(subfolder, exist_ok=True)
    ext = file.filename.rsplit(".", 1)[1].lower() if "." in (file.filename or "") else "png"
    unique = f"{current_user.id}_{int(datetime.utcnow().timestamp())}_{uuid.uuid4().hex}.{ext}"
    path = os.path.join(subfolder, unique)
    file.save(path)
    url = f"/static/uploads/merchant/{file_type}/{unique}"
    return ok({"success": True, "url": url, "filename": unique, "file_type": file_type}, 200)
