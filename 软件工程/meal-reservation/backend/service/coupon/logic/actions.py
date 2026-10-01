"""Coupon business actions."""
from Models import Restaurant, RestaurantFollow, db


def auto_follow_restaurant(user_id, restaurant_id):
    """Auto-follow a restaurant when accepting a coupon. Returns (message, restaurant_name)."""
    restaurant = Restaurant.query.get(restaurant_id)
    if not restaurant:
        return "关注餐厅失败，餐厅信息不存在", None

    follow = RestaurantFollow.query.filter_by(user_id=user_id, restaurant_id=restaurant.id).first()
    if not follow:
        db.session.add(RestaurantFollow(user_id=user_id, restaurant_id=restaurant.id))
        return f"已自动关注「{restaurant.name}」，您将收到该餐厅的最新动态", restaurant.name
    return f"您已经关注了「{restaurant.name}」", restaurant.name
