"""Users query operations."""
from Models import Restaurant, SystemNotification
from database import list_followed_restaurants as db_list_followed_restaurants
from utils import NotFoundError, coerce_result


def followed_restaurants(current_user):
    return coerce_result(db_list_followed_restaurants(current_user.id))


def user_restaurant(current_user):
    restaurant = Restaurant.query.filter_by(user_id=current_user.id).first()
    if not restaurant:
        raise NotFoundError("未找到餐厅信息")
    return {
        "restaurant_id": restaurant.id,
        "restaurant_name": restaurant.name,
    }


def system_notifications(current_user):
    user_type_map = {0: None, 1: "merchants", 2: "users"}
    targets = ["all"]
    mapped = user_type_map.get(current_user.usertype)
    if mapped:
        targets.append(mapped)
    notifications = SystemNotification.query.filter(
        SystemNotification.target_audience.in_(targets)
    ).all()
    return [n.to_dict() for n in notifications]
