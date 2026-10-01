"""Dish recommendation engine."""
from sqlalchemy import func

from Models import Dish, Order, OrderItem, Restaurant, db
from utils import ApiError, BusinessError, ok


def get_recommendations(current_user):
    try:
        history = (
            db.session.query(OrderItem.dish_id, func.sum(OrderItem.quantity).label("total_quantity"))
            .join(Order, OrderItem.order_id == Order.id)
            .filter(Order.user_id == current_user.id)
            .filter(Order.status.notin_(["cancelled", "rejected", "pending"]))
            .group_by(OrderItem.dish_id)
            .all()
        )
        purchase_counts = {h.dish_id: int(h.total_quantity) for h in history}
        purchased_ids = list(purchase_counts.keys())

        cat_weights = {}
        if purchased_ids:
            for d in Dish.query.filter(Dish.dish_id.in_(purchased_ids)).all():
                if d.category:
                    cat_weights[d.category] = cat_weights.get(d.category, 0) + purchase_counts.get(d.dish_id, 0)

        all_dishes = (
            Dish.query.join(Restaurant, Dish.restaurant_id == Restaurant.id)
            .filter(Dish.status == "available", Restaurant.is_open.is_(True))
            .all()
        )

        scored = []
        for dish in all_dishes:
            score = 0
            pc = purchase_counts.get(dish.dish_id, 0)
            if pc > 0:
                score += 1000 + pc * 10
            if dish.category and dish.category in cat_weights:
                score += 100 + cat_weights[dish.category]
            score += (dish.monthly_sales or 0) * 0.1
            scored.append((dish, score))
        scored.sort(key=lambda x: x[1], reverse=True)

        result = []
        for dish, _ in scored[:50]:
            d = dish.to_public_dict()
            d["restaurant_id"] = dish.restaurant_id
            d["restaurant_name"] = dish.restaurant.name if dish.restaurant else None
            result.append(d)
        return ok({"success": True, "data": {"dishes": result}}, 200)
    except ApiError:
        raise
    except Exception as exc:
        raise BusinessError("获取推荐失败", 500, {"error": str(exc)})
