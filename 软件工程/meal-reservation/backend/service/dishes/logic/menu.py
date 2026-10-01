"""Dish menu / listing queries."""
from Models import Dish
from utils import ApiError, BusinessError, ok


def list_dishes(restaurant_id=None, status=None):
    query = Dish.query
    if restaurant_id:
        query = query.filter_by(restaurant_id=int(restaurant_id))
    if status:
        query = query.filter_by(status=status)
    dishes = query.order_by(Dish.created_at.desc()).all()
    data = []
    for dish in dishes:
        d = dish.to_dict()
        if "restaurant_name" not in d and dish.restaurant:
            d["restaurant_name"] = dish.restaurant.name
        data.append(d)
    return ok({"success": True, "data": {"dishes": data, "total": len(data)}}, 200)


def get_menu(restaurant_id):
    try:
        dishes = (
            Dish.query.filter_by(restaurant_id=restaurant_id, status="available")
            .order_by(Dish.created_at.desc())
            .all()
        )
        by_cat = {}
        for dish in dishes:
            cat = dish.category or "未分类"
            by_cat.setdefault(cat, []).append(dish.to_public_dict())
        return ok({
            "success": True,
            "data": {"menu": by_cat, "total_dishes": len(dishes), "categories": list(by_cat.keys())},
        }, 200)
    except ApiError:
        raise
    except Exception as exc:
        raise BusinessError("获取菜单失败", 500, {"error": str(exc)})
