"""Restaurant follow/unfollow operations."""
from database import (
    follow_restaurant,
    get_follow_status,
    unfollow_restaurant,
)


def handle_follow(user_id, restaurant_id, method):
    if method == "GET":
        return get_follow_status(user_id, restaurant_id)
    elif method == "POST":
        return follow_restaurant(user_id, restaurant_id)
    else:
        return unfollow_restaurant(user_id, restaurant_id)
