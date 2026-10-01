"""File upload logic."""
import os
import uuid

from werkzeug.utils import secure_filename

from utils import BadRequestError, ok
from utils.uploads import UPLOAD_FOLDER, allowed_file


def upload_file(file, host_url):
    if not file:
        raise BadRequestError("缺少文件")
    if file.filename == "":
        raise BadRequestError("未选择文件")
    if not allowed_file(file.filename):
        raise BadRequestError("不支持的文件类型")

    filename = secure_filename(file.filename or "")
    if "." in filename:
        ext = filename.rsplit(".", 1)[1].lower()
    else:
        mimetype = getattr(file, "mimetype", "") or ""
        if "/" in mimetype:
            ext = mimetype.split("/")[-1].split(";")[0].lower()
        else:
            ext = "png"

    unique_name = f"{uuid.uuid4().hex}.{ext}"
    save_path = os.path.join(UPLOAD_FOLDER, unique_name)
    file.save(save_path)
    host = host_url.rstrip("/")
    url = f"{host}/static/uploads/avatar/{unique_name}"
    return ok({"success": True, "url": url}, 200)
