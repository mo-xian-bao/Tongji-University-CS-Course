"""Support file upload operations."""
import os
import uuid

from werkzeug.utils import secure_filename

from utils import BadRequestError, allowed_file

SUPPORT_UPLOAD_DIR = os.path.join(
    os.path.dirname(__file__), "..", "..", "..", "static", "uploads", "support"
)


def upload_files(files, host_url):
    if not files:
        raise BadRequestError("未检测到上传文件")
    MAX_FILES, MAX_SIZE = 5, 5 * 1024 * 1024
    if len(files) > MAX_FILES:
        files = files[:MAX_FILES]

    os.makedirs(SUPPORT_UPLOAD_DIR, exist_ok=True)
    saved = []
    for f in files:
        if not f or f.filename == "":
            continue
        if not allowed_file(f.filename):
            saved.append({"name": f.filename, "success": False, "message": "不支持的文件类型"})
            continue
        try:
            content = f.read()
        except Exception:
            saved.append({"name": f.filename, "success": False, "message": "读取文件失败"})
            continue
        if len(content) == 0:
            saved.append({"name": f.filename, "success": False, "message": "空文件"})
            continue
        if len(content) > MAX_SIZE:
            saved.append({"name": f.filename, "success": False, "message": "文件超过大小限制 5MB"})
            continue
        ext = f.filename.rsplit(".", 1)[1].lower() if "." in (f.filename or "") else ""
        unique_name = f"{uuid.uuid4().hex}.{ext}" if ext else uuid.uuid4().hex
        save_path = os.path.join(SUPPORT_UPLOAD_DIR, unique_name)
        try:
            with open(save_path, "wb") as out:
                out.write(content)
            url = f"{host_url.rstrip('/')}/static/uploads/support/{unique_name}"
            saved.append({"name": f.filename, "success": True, "url": url})
        except Exception as exc:
            saved.append({"name": f.filename, "success": False, "message": str(exc)})
    return saved
