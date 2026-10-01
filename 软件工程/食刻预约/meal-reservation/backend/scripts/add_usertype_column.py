import os
import sys

from sqlalchemy import text

BASE_DIR = os.path.dirname(os.path.dirname(__file__))
if BASE_DIR not in sys.path:
    sys.path.insert(0, BASE_DIR)

from app_init import app, db


def main():
    with app.app_context():
        try:
            db.session.execute(text("ALTER TABLE users ADD COLUMN usertype INTEGER NOT NULL DEFAULT 2"))
            db.session.commit()
            print("usertype 列添加成功")
        except Exception as exc:
            db.session.rollback()
            print(f"添加列时出错: {exc}")


if __name__ == "__main__":
    main()
