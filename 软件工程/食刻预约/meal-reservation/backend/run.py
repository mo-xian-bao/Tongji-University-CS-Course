"""
Flask应用启动脚本
"""

from app_init import app
from app import *
def run_app():
    """运行Flask应用"""
    print("正在启动MealReservation API服务...")
    print("服务地址: http://localhost:5000")
    print("API文档: http://localhost:5000/api/health")
    print("按 Ctrl+C 停止服务")
    print("-" * 50)

    # 运行应用
    app.run(debug=True, host='0.0.0.0', port=5000)

if __name__ == '__main__':
    run_app()