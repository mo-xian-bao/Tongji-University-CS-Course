"""Users profile operations."""
import os
from datetime import datetime

from werkzeug.utils import secure_filename

from Models import User, UserInfo, db
from utils import BadRequestError, UPLOAD_FOLDER, allowed_file


def get_profile(current_user):
    return current_user.to_dict()


def get_user_by_id(current_user, user_id):
    user = User.query.get(user_id)
    if not user:
        from utils import NotFoundError
        raise NotFoundError("用户不存在")
    if current_user.usertype == 0 or current_user.usertype == 1 or current_user.id == user_id:
        return user.to_dict()
    from utils import ForbiddenError
    raise ForbiddenError("无权访问此用户信息")


def update_profile(current_user, form, files):
    username = form.get("username", "").strip()
    bio = form.get("bio", "").strip()
    birthday = form.get("birthday", "").strip()

    if not username:
        raise BadRequestError("用户名不能为空")
    if len(username) < 2 or len(username) > 20:
        raise BadRequestError("用户名长度为2-20个字符")
    if username != current_user.username:
        if User.query.filter_by(username=username).first():
            raise BadRequestError("该用户名已被使用")

    user_info = current_user.user_info
    if not user_info:
        user_info = UserInfo(user_id=current_user.id)
        db.session.add(user_info)
        db.session.flush()

    if "avatar" in files:
        file = files["avatar"]
        if file and allowed_file(file.filename):
            ext = file.filename.rsplit(".", 1)[1].lower() if "." in (file.filename or "") else "png"
            filename = secure_filename(
                f"user_{current_user.id}_{int(datetime.now().timestamp())}.{ext}"
            )
            filepath = os.path.join(UPLOAD_FOLDER, filename)
            file.save(filepath)
            user_info.avatar_url = f"/static/uploads/avatar/{filename}"

    if birthday:
        try:
            user_info.birthday = datetime.strptime(birthday, "%Y-%m-%d").date()
        except ValueError:
            raise BadRequestError("生日格式不正确，应为 YYYY-MM-DD")

    current_user.username = username
    user_info.bio = bio
    user_info.updated_at = datetime.utcnow()
    current_user.updated_at = datetime.utcnow()
    return current_user.to_dict()
