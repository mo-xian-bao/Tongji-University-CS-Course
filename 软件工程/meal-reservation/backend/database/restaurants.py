"""Restaurant CRUD helpers."""
from datetime import datetime

from Models import db, User, Restaurant


def create_restaurant(user_id, name, address, phone, opening_hours, notice=None, avatar_url=None):
    """
    创建餐厅信息

    Args:
        user_id (int): 用户ID
        name (str): 餐厅名称
        address (str): 餐厅地址
        phone (str): 联系电话
        opening_hours (str): 营业时间
        notice (str): 餐厅公告
        avatar_url (str): 头像URL

    Returns:
        tuple: (result_dict, status_code)
    """
    try:
        # 检查用户是否存在
        user = User.query.get(user_id)
        if not user:
            return {
                'success': False,
                'message': '用户不存在'
            }, 404

        # 检查用户是否已有关联的餐厅
        if hasattr(user, 'restaurant') and user.restaurant:
            return {
                'success': False,
                'message': '该用户已有关联的餐厅'
            }, 400

        # 创建餐厅
        restaurant = Restaurant(
            name=name,
            address=address,
            phone=phone,
            opening_hours=opening_hours,
            notice=notice,
            avatar_url=avatar_url,
            user_id=user_id
        )

        db.session.add(restaurant)
        db.session.commit()

        return {
            'success': True,
            'message': '餐厅创建成功',
            'data': {
                'restaurant': restaurant.to_dict()
            }
        }, 201

    except Exception as e:
        db.session.rollback()
        return {
            'success': False,
            'message': '创建餐厅失败',
            'error': str(e)
        }, 500


def update_restaurant(restaurant_id, name=None, address=None, phone=None, opening_hours=None, notice=None, avatar_url=None):
    """
    更新餐厅信息

    Args:
        restaurant_id (int): 餐厅ID
        name (str): 餐厅名称
        address (str): 餐厅地址
        phone (str): 联系电话
        opening_hours (str): 营业时间
        notice (str): 餐厅公告
        avatar_url (str): 头像URL

    Returns:
        tuple: (result_dict, status_code)
    """
    try:
        # 查找餐厅
        restaurant = Restaurant.query.get(restaurant_id)
        if not restaurant:
            return {
                'success': False,
                'message': '餐厅不存在'
            }, 404

        # 更新餐厅信息
        if name is not None:
            restaurant.name = name
        if address is not None:
            restaurant.address = address
        if phone is not None:
            restaurant.phone = phone
        if opening_hours is not None:
            restaurant.opening_hours = opening_hours
        if notice is not None:
            restaurant.notice = notice
        if avatar_url is not None:
            restaurant.avatar_url = avatar_url

        restaurant.updated_at = datetime.utcnow()
        db.session.commit()

        return {
            'success': True,
            'message': '餐厅信息更新成功',
            'data': {
                'restaurant': restaurant.to_dict()
            }
        }, 200

    except Exception as e:
        db.session.rollback()
        return {
            'success': False,
            'message': '更新餐厅信息失败',
            'error': str(e)
        }, 500


def get_restaurant_by_user_id(user_id):
    """
    根据用户ID获取餐厅信息

    Args:
        user_id (int): 用户ID

    Returns:
        tuple: (result_dict, status_code)
    """
    try:
        # 查找用户关联的餐厅
        restaurant = Restaurant.query.filter_by(user_id=user_id).first()
        if not restaurant:
            return {
                'success': False,
                'message': '未找到关联的餐厅'
            }, 404

        return {
            'success': True,
            'message': '获取餐厅信息成功',
            'data': {
                'restaurant': restaurant.to_dict()
            }
        }, 200

    except Exception as e:
        return {
            'success': False,
            'message': '获取餐厅信息失败',
            'error': str(e)
        }, 500


def get_merchant_restaurant(user):
    if not user or user.usertype != 1:
        return None
    return Restaurant.query.filter_by(user_id=user.id).first()
