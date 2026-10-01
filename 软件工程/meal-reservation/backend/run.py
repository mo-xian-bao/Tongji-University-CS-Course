"""
Flask应用启动脚本
"""
import os
from utils import (UPLOAD_FOLDER,MERCHANT_UPLOAD_FOLDER,DISH_UPLOAD_FOLDER,
            APPEAL_UPLOAD_FOLDER,SUPPORT_UPLOAD_FOLDER,allowed_file)

from database import init_database

from app_init import app
from app import *

def make_upload_dirs():
    os.makedirs(UPLOAD_FOLDER, exist_ok=True)
    os.makedirs(MERCHANT_UPLOAD_FOLDER, exist_ok=True)
    os.makedirs(DISH_UPLOAD_FOLDER, exist_ok=True)
    os.makedirs(APPEAL_UPLOAD_FOLDER, exist_ok=True)
    os.makedirs(SUPPORT_UPLOAD_FOLDER, exist_ok=True)


def run_app():
    """运行Flask应用"""
    print("正在启动MealReservation API服务...")
    print("服务地址: http://localhost:5000")
    print("API文档: http://localhost:5000/api/health")
    print("按 Ctrl+C 停止服务")
    print("-" * 50)

    # 上传配置
    make_upload_dirs()

    # 创建数据表
    with app.app_context():
        init_database()

    # 运行应用
    app.run(debug=True, host='0.0.0.0', port=5000)

if __name__ == '__main__':
    run_app()