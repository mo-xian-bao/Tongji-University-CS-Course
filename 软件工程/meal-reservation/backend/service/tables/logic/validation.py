"""Tables validation and lookup helpers."""
from Models import Restaurant, Table
from utils import BadRequestError, ForbiddenError, NotFoundError


def get_restaurant_or_404(current_user):
    restaurant = Restaurant.query.filter_by(user_id=current_user.id).first()
    if not restaurant:
        raise NotFoundError("请先创建餐厅信息")
    return restaurant


def get_table_or_404(table_id):
    table = Table.query.get(table_id)
    if not table:
        raise NotFoundError("桌位不存在")
    return table


def ensure_ownership(current_user, table):
    restaurant = Restaurant.query.filter_by(user_id=current_user.id).first()
    if not restaurant or table.restaurant_id != restaurant.id:
        raise ForbiddenError("无权访问该桌位")
    return restaurant
