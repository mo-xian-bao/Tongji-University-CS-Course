"""Restaurant broadcasts and coupon notifications."""
from Models import Restaurant
from database import (
    create_broadcast,
    create_coupon_notification,
    delete_broadcast,
    get_broadcast_detail,
    list_broadcasts,
    update_broadcast,
)
from utils import ForbiddenError, NotFoundError


def create_broadcast_api(restaurant_id, data):
    return create_broadcast(
        restaurant_id=restaurant_id,
        title=data.get("title"),
        content=data.get("content"),
        start_time=data.get("start_time"),
        end_time=data.get("end_time"),
        is_active=data.get("is_active", True),
    )


def create_coupon_broadcast_api(current_user, restaurant_id, data):
    if current_user.usertype != 1:
        raise ForbiddenError("只有商家可以推送优惠券")
    rest = Restaurant.query.filter_by(id=restaurant_id, user_id=current_user.id).first()
    if not rest:
        raise NotFoundError("无法访问该餐厅或餐厅不存在")
    return create_coupon_notification(
        restaurant_id=restaurant_id,
        title=data.get("title"),
        description=data.get("description"),
        discount_type=data.get("discount_type"),
        amount=data.get("amount"),
        min_spend=data.get("min_spend"),
        valid_from=data.get("valid_from"),
        valid_to=data.get("valid_to"),
        total_quantity=data.get("total_quantity"),
        extra_data=data.get("extra_data"),
    )


def broadcast_list(restaurant_id, include_inactive, page, per_page):
    return list_broadcasts(
        restaurant_id=restaurant_id,
        include_inactive=include_inactive,
        page=page,
        per_page=per_page,
    )


def broadcast_update(restaurant_id, broadcast_id, data):
    return update_broadcast(broadcast_id=broadcast_id, restaurant_id=restaurant_id, data=data)


def broadcast_delete(restaurant_id, broadcast_id):
    return delete_broadcast(broadcast_id=broadcast_id, restaurant_id=restaurant_id)


def broadcast_detail(broadcast_id):
    return get_broadcast_detail(broadcast_id)
