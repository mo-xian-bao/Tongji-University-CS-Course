"""Dish query helpers — find-or-raise patterns."""
from Models import Dish, DishOffShelfLog, Restaurant
from database import get_merchant_restaurant
from utils import ForbiddenError, NotFoundError


def get_merchant_rest(current_user):
    """Get current user's restaurant or raise ForbiddenError."""
    rest = get_merchant_restaurant(current_user)
    if not rest:
        raise ForbiddenError("只有商家可以操作菜品")
    return rest


def get_dish(dish_id, restaurant_id=None):
    """Get dish by id, optionally scoped to a restaurant. Raise NotFoundError."""
    filters = dict(dish_id=dish_id)
    if restaurant_id is not None:
        filters["restaurant_id"] = restaurant_id
    dish = Dish.query.filter_by(**filters).first()
    if not dish:
        raise NotFoundError("菜品不存在" if restaurant_id is None else "菜品不存在于指定餐厅")
    return dish


def get_dishes_by_ids(dish_ids, restaurant_id):
    """Get dishes matching a set of ids in a restaurant. Raise if some missing."""
    dishes = Dish.query.filter(
        Dish.dish_id.in_(dish_ids), Dish.restaurant_id == restaurant_id).all()
    if len(dishes) != len(dish_ids):
        raise NotFoundError("部分菜品不存在或无权操作")
    return dishes


def get_restaurant(restaurant_id):
    """Get restaurant by id or raise NotFoundError."""
    rest = Restaurant.query.filter_by(id=restaurant_id).first()
    if not rest:
        raise NotFoundError("餐厅不存在")
    return rest


def get_latest_off_shelf_log(restaurant_id, dish_id):
    return (DishOffShelfLog.query
            .filter_by(restaurant_id=restaurant_id, dish_id=dish_id)
            .order_by(DishOffShelfLog.created_at.desc()).first())


def validate_dish_ownership(current_user, rest):
    """Raise ForbiddenError if user doesn't own the restaurant (unless admin)."""
    if current_user.usertype != 0 and current_user.id != rest.user_id:
        raise ForbiddenError("您没有权限删除该餐厅的菜品")
