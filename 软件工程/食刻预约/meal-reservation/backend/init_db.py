##此文件用于ci，与项目无关！！！！！

from app_init import app
from db_exe import init_database

if __name__ == '__main__':
    with app.app_context():
        init_database()