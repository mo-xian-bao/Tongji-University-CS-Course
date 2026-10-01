##此文件用于ci，与项目无关！！！！！
import os
import sys

sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

from app_init import app
from database import init_database

if __name__ == '__main__':
    with app.app_context():
        init_database()