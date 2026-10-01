"""Upload path helpers."""
import os

BACKEND_DIR = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
STATIC_DIR = os.path.join(BACKEND_DIR, "static")

UPLOAD_FOLDER = os.path.join(STATIC_DIR, 'uploads', 'avatar')
MERCHANT_UPLOAD_FOLDER = os.path.join(STATIC_DIR, 'uploads', 'merchant')
DISH_UPLOAD_FOLDER = os.path.join(STATIC_DIR, 'uploads', 'dishes')
APPEAL_UPLOAD_FOLDER = os.path.join(STATIC_DIR, 'uploads', 'appeals')
SUPPORT_UPLOAD_FOLDER = os.path.join(STATIC_DIR, 'uploads', 'support')
ALLOWED_EXTENSIONS = {'png', 'jpg', 'jpeg', 'gif', 'pdf', 'doc', 'docx', 'txt'}


def allowed_file(filename):
    return '.' in filename and filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS


def delete_file_by_url(file_path):
    """
    根据URL删除本地文件

    Args:
        file_url (str): 文件的URL或本地路径

    Returns:
        tuple: (success: bool, message: str)
    """
    try:
        # 检查文件是否存在
        if os.path.exists(file_path):
            # 删除文件
            os.remove(file_path)
            return True, f"文件已成功删除: {file_path}"
        return False, f"文件不存在: {file_path}"

    except Exception as e:
        return False, f"删除文件时出错: {str(e)}"
