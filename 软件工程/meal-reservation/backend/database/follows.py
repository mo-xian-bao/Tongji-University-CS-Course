"""Restaurant follow helpers."""
from typing import Dict, Any, Tuple

from Models import db, Restaurant, RestaurantFollow


def _follow_payload(follow: RestaurantFollow, include_restaurant: bool = True) -> Dict[str, Any]:
    data = follow.to_dict(include_restaurant=include_restaurant)
    data['is_following'] = True
    return data


def follow_restaurant(user_id: int, restaurant_id: int) -> Tuple[Dict[str, Any], int]:
    if not user_id:
        return {'success': False, 'message': '用户未登录'}, 401

    restaurant = Restaurant.query.get(restaurant_id)
    if not restaurant:
        return {'success': False, 'message': '商铺不存在'}, 404

    existing = RestaurantFollow.query.filter_by(user_id=user_id, restaurant_id=restaurant_id).first()
    if existing:
        return {
            'success': True,
            'message': '已关注该商铺',
            'data': _follow_payload(existing)
        }, 200

    follow = RestaurantFollow(user_id=user_id, restaurant_id=restaurant_id)
    db.session.add(follow)
    db.session.commit()

    return {
        'success': True,
        'message': '关注成功',
        'data': _follow_payload(follow)
    }, 201


def unfollow_restaurant(user_id: int, restaurant_id: int) -> Tuple[Dict[str, Any], int]:
    if not user_id:
        return {'success': False, 'message': '用户未登录'}, 401

    follow = RestaurantFollow.query.filter_by(user_id=user_id, restaurant_id=restaurant_id).first()
    if not follow:
        return {
            'success': True,
            'message': '未关注该商铺',
            'data': {
                'restaurant_id': restaurant_id,
                'is_following': False
            }
        }, 200

    db.session.delete(follow)
    db.session.commit()

    return {
        'success': True,
        'message': '已取消关注',
        'data': {
            'restaurant_id': restaurant_id,
            'is_following': False
        }
    }, 200


def get_follow_status(user_id: int, restaurant_id: int) -> Tuple[Dict[str, Any], int]:
    if not user_id:
        return {'success': False, 'message': '用户未登录'}, 401

    follow = RestaurantFollow.query.filter_by(user_id=user_id, restaurant_id=restaurant_id).first()
    if not follow:
        return {
            'success': True,
            'data': {
                'restaurant_id': restaurant_id,
                'is_following': False
            }
        }, 200

    return {
        'success': True,
        'data': _follow_payload(follow, include_restaurant=False)
    }, 200


def list_followed_restaurants(user_id: int) -> Tuple[Dict[str, Any], int]:
    if not user_id:
        return {'success': False, 'message': '用户未登录'}, 401

    follows = RestaurantFollow.query.filter_by(user_id=user_id).order_by(RestaurantFollow.created_at.desc()).all()
    records = [_follow_payload(item) for item in follows]

    return {
        'success': True,
        'data': {
            'records': records,
            'total': len(records)
        }
    }, 200
