"""Restaurant CRUD operations."""
from datetime import datetime

from Models import Restaurant, Table, db
from database import (
    create_restaurant as db_create_restaurant,
    get_restaurant_by_user_id as db_get_restaurant_by_user_id,
    update_restaurant as db_update_restaurant,
)
from utils import BadRequestError, ForbiddenError, NotFoundError


def create_restaurant(current_user, data):
    name = (data.get("name") or "").strip()
    address = (data.get("address") or "").strip()
    phone = (data.get("phone") or "").strip()
    opening_hours = (data.get("opening_hours") or "").strip()
    notice = (data.get("notice") or "").strip()
    avatar_url = (data.get("avatar_url") or "").strip()
    if not all([name, address, phone, opening_hours]):
        raise BadRequestError("请填写完整信息")
    return db_create_restaurant(current_user.id, name, address, phone, opening_hours, notice, avatar_url)


def update_restaurant(current_user, restaurant_id, data):
    rest = Restaurant.query.get(restaurant_id)
    if not rest:
        raise NotFoundError("餐厅不存在")
    if rest.user_id != current_user.id:
        raise ForbiddenError("无权修改该餐厅")
    return db_update_restaurant(
        restaurant_id,
        data.get("name"),
        data.get("address"),
        data.get("phone"),
        data.get("opening_hours"),
        data.get("notice"),
        data.get("avatar_url"),
    )


def get_by_user_id(user_id):
    return db_get_restaurant_by_user_id(user_id)


def get_all():
    restaurants = Restaurant.query.all()
    return [r.to_dict() for r in restaurants]


def get_by_id(restaurant_id):
    rest = Restaurant.query.get(restaurant_id)
    if not rest:
        raise NotFoundError("餐厅不存在")
    return rest.to_dict()


def get_restaurant_status(current_user, restaurant_id):
    rest = Restaurant.query.get(restaurant_id)
    if not rest:
        raise NotFoundError("餐厅不存在")
    if rest.user_id != current_user.id:
        raise ForbiddenError("无权访问该餐厅")
    return rest


def set_restaurant_status(current_user, restaurant_id, is_open=None):
    rest = Restaurant.query.get(restaurant_id)
    if not rest:
        raise NotFoundError("餐厅不存在")
    if rest.user_id != current_user.id:
        raise ForbiddenError("无权修改该餐厅")
    if is_open is not None:
        rest.is_open = bool(is_open)
    else:
        rest.is_open = not bool(rest.is_open)
    rest.updated_at = datetime.utcnow()
    return rest


def get_tables_public(restaurant_id):
    rest = Restaurant.query.get(restaurant_id)
    if not rest:
        raise NotFoundError("餐厅不存在")
    tables = Table.query.filter_by(restaurant_id=restaurant_id).all()
    return [t.to_dict() for t in tables]
