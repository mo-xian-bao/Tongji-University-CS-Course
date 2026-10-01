"""Tables service handlers — orchestration layer."""
from Models import db
from utils import ApiError, BusinessError, ok

from .logic.validation import ensure_ownership, get_restaurant_or_404, get_table_or_404
from .logic import crud


def get_tables_list(current_user):
    try:
        restaurant = get_restaurant_or_404(current_user)
        tables = crud.get_tables_list(current_user, restaurant)
        return ok({"tables": tables, "success": True}, 200)
    except ApiError:
        raise
    except Exception as exc:
        raise BusinessError("获取桌位列表失败", 500, {"error": str(exc)})


def add_table(current_user, data):
    try:
        restaurant = get_restaurant_or_404(current_user)
        table = crud.add_table(restaurant, data)
        db.session.commit()
        return ok({"message": "桌位添加成功", "table": table.to_dict(), "success": True}, 201)
    except ApiError:
        raise
    except Exception as exc:
        db.session.rollback()
        raise BusinessError("添加桌位失败", 500, {"error": str(exc)})


def update_table(table_id, data):
    try:
        table = get_table_or_404(table_id)
        crud.update_table(table, data)
        db.session.commit()
        return ok({"message": "桌位更新成功", "table": table.to_dict(), "success": True}, 200)
    except ApiError:
        raise
    except Exception as exc:
        db.session.rollback()
        raise BusinessError("更新桌位失败", 500, {"error": str(exc)})


def delete_table(table_id):
    try:
        table = get_table_or_404(table_id)
        crud.delete_table(table)
        db.session.commit()
        return ok({"message": "桌位删除成功", "success": True}, 200)
    except ApiError:
        raise
    except Exception as exc:
        db.session.rollback()
        raise BusinessError("删除桌位失败", 500, {"error": str(exc)})


def get_table_detail(current_user, table_id):
    try:
        table = get_table_or_404(table_id)
        ensure_ownership(current_user, table)
        table_dict = crud.get_table_detail(table, None)
        return ok({"table": table_dict, "success": True}, 200)
    except ApiError:
        raise
    except Exception as exc:
        raise BusinessError("获取桌位详情失败", 500, {"error": str(exc)})
