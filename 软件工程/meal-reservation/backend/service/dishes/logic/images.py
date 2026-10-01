"""Dish image upload helper."""
import os
import uuid
from datetime import datetime

from database import get_merchant_restaurant
from utils import BadRequestError, BusinessError, ForbiddenError, DISH_UPLOAD_FOLDER, allowed_file, ok


def upload_image(current_user, file):
    if not file or file.filename == "":
        raise BadRequestError("未选择文件")
    if not allowed_file(file.filename):
        raise BadRequestError(f"不支持的文件类型：{file.filename}")
    try:
        file.seek(0, os.SEEK_END)
        sz = file.tell()
        file.seek(0)
        if sz > 5 * 1024 * 1024:
            raise BadRequestError("文件大小不能超过5MB")
    except Exception:
        raise BusinessError("无法获取文件大小", 400)

    restaurant = get_merchant_restaurant(current_user)
    if not restaurant:
        raise ForbiddenError("未找到商户餐厅信息")

    folder = os.path.join(DISH_UPLOAD_FOLDER, str(restaurant.id))
    os.makedirs(folder, exist_ok=True)
    ext = file.filename.rsplit(".", 1)[1].lower() if "." in (file.filename or "") else "png"
    unique = f"{int(datetime.utcnow().timestamp())}_{uuid.uuid4().hex}.{ext}"
    path = os.path.join(folder, unique)
    file.save(path)
    url = f"/static/uploads/dishes/{restaurant.id}/{unique}"
    return ok({"success": True, "url": url, "filename": unique, "restaurant_id": restaurant.id}, 200)
