"""Merchant menu management."""
from collections import Counter

from Models import Dish, db
from database import get_merchant_restaurant
from utils import ForbiddenError, ok


def build_menu_dish_payload(dish):
    return dish.to_menu_card() if dish else {}


def get_menu(current_user):
    restaurant = get_merchant_restaurant(current_user)
    if not restaurant:
        raise ForbiddenError("未找到商户餐厅或无权访问")
    dishes = Dish.query.filter_by(restaurant_id=restaurant.id).order_by(Dish.created_at.desc()).all()
    categories = sorted({d.category for d in dishes if d.category})
    status_counter = Counter(d.status for d in dishes)
    return ok({
        "success": True,
        "data": {
            "dishes": [build_menu_dish_payload(d) for d in dishes],
            "categories": categories,
            "status_counts": dict(status_counter),
        },
    }, 200)
