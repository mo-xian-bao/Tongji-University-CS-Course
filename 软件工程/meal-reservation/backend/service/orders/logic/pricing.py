"""Order pricing — item total and coupon discount calculation."""
from datetime import datetime

from .validation import validate_coupon, validate_order_items


def calculate_order(items_data, restaurant_id, coupon_id, current_user_id):
    """Validate items and calculate prices. Returns (validated, original_price, discount_amount, total_price)."""
    validated, original_price = validate_order_items(restaurant_id, items_data)
    discount_amount = 0.0
    if coupon_id:
        discount_amount = validate_coupon(coupon_id, current_user_id, restaurant_id, original_price)
    total_price = original_price - discount_amount
    return validated, original_price, discount_amount, total_price
