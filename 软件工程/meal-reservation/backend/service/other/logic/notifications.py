"""Dish and coupon notification thin wrappers."""
from database import (
    list_dish_launch_notifications,
    get_dish_launch_notification,
    list_coupon_notifications as db_list_coupon_notifications,
    get_coupon_notification,
)
from utils import coerce_result


def list_dish_notifications(restaurant_id=None, include_inactive=False, page=1, per_page=20):
    return coerce_result(list_dish_launch_notifications(
        restaurant_id=restaurant_id,
        include_inactive=include_inactive,
        page=page,
        per_page=per_page,
    ))


def fetch_dish_notification(notification_id):
    return coerce_result(get_dish_launch_notification(notification_id))


def list_coupon_notifications(current_user_id, restaurant_id=None, include_inactive=False, page=1, per_page=20):
    follower_user_id = current_user_id if not restaurant_id else None
    return coerce_result(db_list_coupon_notifications(
        restaurant_id=restaurant_id,
        include_inactive=include_inactive,
        page=page,
        per_page=per_page,
        follower_user_id=follower_user_id,
        exclude_used_by_user_id=current_user_id,
    ))


def fetch_coupon_notification(notification_id):
    return coerce_result(get_coupon_notification(notification_id))
