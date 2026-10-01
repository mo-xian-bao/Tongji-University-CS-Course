"""Merchant review helpers."""
import re
from collections import Counter
from datetime import datetime

import jieba
from sqlalchemy import func

from Models import Order, Restaurant, Review, db
from utils import localize_iso, safe_zoneinfo


def fetch_reviews(current_user):
    if current_user.usertype != 1:
        return None, "只有商家可以访问"
    restaurant = Restaurant.query.filter_by(user_id=current_user.id).first()
    if not restaurant:
        return None, "未找到商家餐厅"
    reviews = Review.query.filter_by(restaurant_id=restaurant.id, status="normal",
                                     review_status="approved").order_by(Review.created_at.desc()).all()
    return [r.to_dict() for r in reviews], None


def save_reply(current_user, review_id, reply_text):
    if current_user.usertype != 1:
        return None, "只有商家可以回复"
    restaurant = Restaurant.query.filter_by(user_id=current_user.id).first()
    if not restaurant:
        return None, "未找到商家餐厅"
    review = Review.query.get(review_id)
    if not review or review.restaurant_id != restaurant.id:
        return None, "评价不存在或无权回复"
    if review.review_status != "approved":
        return None, "仅可回复已通过审核的评论"
    reply = (reply_text or "").strip()
    if not reply:
        return None, "回复内容不能为空"
    review.merchant_reply = reply
    review.merchant_reply_time = datetime.utcnow()
    review.updated_at = datetime.utcnow()
    db.session.commit()
    return review, None


def generate_wordcloud(restaurant_id, start_date_str, end_date_str, tz_name):
    tz = safe_zoneinfo(tz_name)
    query = Review.query.join(Order).filter(
        Order.restaurant_id == restaurant_id, Review.review_status == "approved")
    if start_date_str:
        _, us = localize_iso(start_date_str, tz, False)
        if us:
            query = query.filter(Review.created_at >= us)
    if end_date_str:
        _, ue = localize_iso(end_date_str, tz, True)
        if ue:
            query = query.filter(Review.created_at <= ue)
    text = "".join([r.content for r in query.all() if r.content])
    stop_words = set(
        "的 了 是 就 都 而 及 与 着 或 一个 没有 我们 你们 他们 它 在 有 个 好 我 也 很 不 去 吃 点 来 这 那 吗 吧 啊 呢 嘛 "
        "但是 虽然 因为 所以 如果 而且 还是 或者 不过 只是 比如 例如 像 如 对于 关于 至于 根据 按照 通过 "
        "由于 为了 以便 从而 因此 于是 然后 接着 最后 总之 非常 特别 尤其 极其 相当 十分 比较 稍微 有点 几乎 简直 太 更 最 "
        "！ ？ ， 。 、 ； ： " " ' ' （ ） 【 】 《 》 … — ·  ".split()
    )
    words = jieba.cut(text)
    filtered = [w for w in words if w not in stop_words and len(w) > 1 and not re.match(r"^\d+$", w)]
    return [{"name": w, "value": c} for w, c in Counter(filtered).most_common(100)]
