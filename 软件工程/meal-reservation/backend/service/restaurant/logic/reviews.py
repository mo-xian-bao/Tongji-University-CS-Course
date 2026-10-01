"""Restaurant reviews query."""
from Models import Review, ReviewLike
from utils import decode_jwt


def get_restaurant_reviews(restaurant_id, page=1, per_page=20, auth_header=""):
    page, per_page = int(page), int(per_page)
    query = Review.query.filter_by(
        restaurant_id=restaurant_id, status="normal", review_status="approved"
    ).order_by(Review.created_at.desc())
    total = query.count()
    items = query.offset((page - 1) * per_page).limit(per_page).all()

    user_id = None
    if auth_header.startswith("Bearer "):
        token = auth_header.split(" ", 1)[1].strip()
        payload = decode_jwt(token)
        if payload:
            uid = payload.get("sub")
            try:
                user_id = int(uid) if uid else None
            except Exception:
                user_id = None

    reviews_list = []
    for r in items:
        d = r.to_dict()
        try:
            d["is_liked"] = bool(user_id and ReviewLike.query.filter_by(review_id=r.id, user_id=user_id).first())
        except Exception:
            d["is_liked"] = False
        reviews_list.append(d)

    return reviews_list, total
