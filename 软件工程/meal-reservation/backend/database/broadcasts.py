"""Broadcast and notification helpers."""
from datetime import datetime
from typing import Optional, Tuple, Dict, Any

from Models import (
    db,
    Restaurant,
    MerchantBroadcast,
    Dish,
    DishLaunchNotification,
    RestaurantFollow,
    CouponNotification,
    CouponUsage,
)
from .common import _parse_datetime, _format_price, _format_datetime
from flask import current_app


def create_broadcast(
        restaurant_id: int,
        title: str,
        content: str,
        start_time: Optional[str] = None,
        end_time: Optional[str] = None,
        is_active: bool = True
) -> Tuple[Dict[str, Any], int]:
    if not restaurant_id:
        return {'success': False, 'message': '缺少餐厅 ID'}, 400

    restaurant = Restaurant.query.get(restaurant_id)
    if not restaurant:
        return {'success': False, 'message': '指定的餐厅不存在'}, 404

    title = (title or '').strip()
    content = (content or '').strip()
    if not title:
        return {'success': False, 'message': '广播标题不能为空'}, 400
    if len(title) > 100:
        return {'success': False, 'message': '标题长度不能超过 100 字符'}, 400
    if not content:
        return {'success': False, 'message': '广播内容不能为空'}, 400

    try:
        start_dt = _parse_datetime(start_time)
        end_dt = _parse_datetime(end_time)
    except ValueError as exc:
        return {'success': False, 'message': str(exc)}, 400

    if start_dt and end_dt and start_dt > end_dt:
        return {'success': False, 'message': '开始时间不能晚于结束时间'}, 400

    broadcast = MerchantBroadcast(
        restaurant_id=restaurant_id,
        title=title,
        content=content,
        start_time=start_dt,
        end_time=end_dt,
        is_active=is_active
    )
    db.session.add(broadcast)
    db.session.commit()

    return {
        'success': True,
        'message': '广播发布成功',
        'data': broadcast.to_dict()
    }, 201


def list_broadcasts(
        restaurant_id: Optional[int] = None,
        include_inactive: bool = False,
        page: int = 1,
        per_page: int = 20
) -> Tuple[Dict[str, Any], int]:
    page = max(int(page or 1), 1)
    per_page = min(max(int(per_page or 20), 1), 100)

    query = MerchantBroadcast.query.order_by(MerchantBroadcast.created_at.desc())
    if restaurant_id:
        query = query.filter_by(restaurant_id=restaurant_id)
    else:
        # 避免与自动生成的通知重复推送
        query = query.filter(
            ~MerchantBroadcast.dish_notification.has(),
            ~MerchantBroadcast.coupon_notification.has()
        )
    if not include_inactive:
        query = query.filter_by(is_active=True)

    pagination = query.paginate(page=page, per_page=per_page, error_out=False)
    records = [item.to_dict() for item in pagination.items]

    return {
        'success': True,
        'data': {
            'records': records,
            'pagination': {
                'page': pagination.page,
                'per_page': pagination.per_page,
                'total_pages': pagination.pages,
                'total_items': pagination.total
            }
        }
    }, 200


def update_broadcast(
        broadcast_id: int,
        restaurant_id: int,
        data: Dict[str, Any]
) -> Tuple[Dict[str, Any], int]:
    broadcast = MerchantBroadcast.query.get(broadcast_id)
    if not broadcast:
        return {'success': False, 'message': '广播不存在'}, 404

    if broadcast.restaurant_id != restaurant_id:
        return {'success': False, 'message': '无权修改其他餐厅的广播'}, 403

    title = data.get('title')
    if title is not None:
        title = title.strip()
        if not title:
            return {'success': False, 'message': '广播标题不能为空'}, 400
        if len(title) > 100:
            return {'success': False, 'message': '标题长度不能超过 100 字符'}, 400
        broadcast.title = title

    content = data.get('content')
    if content is not None:
        content = content.strip()
        if not content:
            return {'success': False, 'message': '广播内容不能为空'}, 400
        broadcast.content = content

    if 'is_active' in data:
        broadcast.is_active = bool(data['is_active'])

    if 'start_time' in data or 'end_time' in data:
        try:
            start_dt = _parse_datetime(data.get('start_time')) if 'start_time' in data else broadcast.start_time
            end_dt = _parse_datetime(data.get('end_time')) if 'end_time' in data else broadcast.end_time
        except ValueError as exc:
            return {'success': False, 'message': str(exc)}, 400
        if start_dt and end_dt and start_dt > end_dt:
            return {'success': False, 'message': '开始时间不能晚于结束时间'}, 400
        broadcast.start_time = start_dt
        broadcast.end_time = end_dt

    db.session.commit()

    return {
        'success': True,
        'message': '广播更新成功',
        'data': broadcast.to_dict()
    }, 200


def delete_broadcast(broadcast_id: int, restaurant_id: int) -> Tuple[Dict[str, Any], int]:
    broadcast = MerchantBroadcast.query.get(broadcast_id)
    if not broadcast:
        return {'success': False, 'message': '广播不存在'}, 404

    if broadcast.restaurant_id != restaurant_id:
        return {'success': False, 'message': '无权删除其他餐厅的广播'}, 403

    db.session.delete(broadcast)
    db.session.commit()

    return {
        'success': True,
        'message': '广播已删除'
    }, 200


def get_broadcast_detail(broadcast_id: int) -> Tuple[Dict[str, Any], int]:
    broadcast = MerchantBroadcast.query.get(broadcast_id)
    if not broadcast:
        return {'success': False, 'message': '广播不存在'}, 404

    return {
        'success': True,
        'data': broadcast.to_dict()
    }, 200


def create_dish_launch_notification(dish: Dish, auto_commit: bool = True) -> Optional[DishLaunchNotification]:
    """为新菜品生成自动上新通知及对应广播"""
    if not dish:
        return None

    restaurant = Restaurant.query.get(dish.restaurant_id)
    if not restaurant:
        return None

    try:
        snapshot = {
            'dish_id': dish.dish_id,
            'name': dish.name,
            'description': dish.description,
            'price': _format_price(dish.price),
            'category': dish.category,
            'status': dish.status,
            'image_url': dish.image_url,
            'stock_quantity': dish.stock_quantity,

        }

        message_lines = [f"{restaurant.name} 刚刚上新「{dish.name}」！"]

        if snapshot['price'] is not None:
            message_lines.append(f"价格：¥{snapshot['price']:.2f}")
        if dish.category:
            message_lines.append(f"分类：{dish.category}")
        if dish.stock_quantity is not None:
            message_lines.append(f"限量 {dish.stock_quantity}")
        if dish.description:
            message_lines.append(dish.description.strip())

        message_lines.append('欢迎到店或在线下单品尝。')
        message_body = '\n'.join(filter(None, message_lines))

        notification = DishLaunchNotification(
            dish_id=dish.dish_id,
            restaurant_id=dish.restaurant_id,
            title=f"新品上架：{dish.name}",
            message=message_body,
            audience='followers',
            dish_snapshot=snapshot,
            is_active=True
        )
        db.session.add(notification)
        db.session.flush()

        broadcast = MerchantBroadcast(
            restaurant_id=dish.restaurant_id,
            title=notification.title,
            content=f"【发送对象：关注店铺的用户】\n{message_body}",
            start_time=datetime.utcnow(),
            is_active=True
        )
        db.session.add(broadcast)
        db.session.flush()

        notification.broadcast_id = broadcast.id

        if auto_commit:
            db.session.commit()

        return notification

    except Exception as exc:
        db.session.rollback()
        if current_app:
            current_app.logger.error('自动生成菜品上新通知失败: %s', exc, exc_info=True)
        else:
            print(f"自动生成菜品上新通知失败: {exc}")
        raise


def list_dish_launch_notifications(
        restaurant_id: Optional[int] = None,
        include_inactive: bool = False,
        page: int = 1,
        per_page: int = 20
) -> Tuple[Dict[str, Any], int]:
    page = max(int(page or 1), 1)
    per_page = min(max(int(per_page or 20), 1), 100)

    query = DishLaunchNotification.query.order_by(DishLaunchNotification.created_at.desc())
    if restaurant_id:
        query = query.filter_by(restaurant_id=restaurant_id)
    if not include_inactive:
        query = query.filter(DishLaunchNotification.is_active == True)

    pagination = query.paginate(page=page, per_page=per_page, error_out=False)
    records = [item.to_dict() for item in pagination.items]

    return {
        'success': True,
        'data': {
            'records': records,
            'pagination': {
                'page': pagination.page,
                'per_page': pagination.per_page,
                'total_pages': pagination.pages,
                'total_items': pagination.total
            }
        }
    }, 200


def get_dish_launch_notification(notification_id: int) -> Tuple[Dict[str, Any], int]:
    notification = DishLaunchNotification.query.get(notification_id)
    if not notification:
        return {'success': False, 'message': '通知不存在'}, 404

    return {
        'success': True,
        'data': notification.to_dict()
    }, 200


def create_coupon_notification(
        restaurant_id: int,
        title: str,
        description: Optional[str] = None,
        discount_type: str = 'amount',
        amount: Optional[Any] = None,
        min_spend: Optional[Any] = None,
        valid_from: Optional[Any] = None,
        valid_to: Optional[Any] = None,
        total_quantity: Optional[int] = None,
        extra_data: Optional[Dict[str, Any]] = None,
        auto_commit: bool = True
) -> Tuple[Dict[str, Any], int]:
    restaurant = Restaurant.query.get(restaurant_id)
    if not restaurant:
        return {'success': False, 'message': '餐厅不存在'}, 404

    title = (title or '').strip()
    if not title:
        return {'success': False, 'message': '优惠券标题不能为空'}, 400

    discount_type = (discount_type or 'amount').strip().lower()
    if discount_type not in {'amount', 'percentage', 'gift'}:
        return {'success': False, 'message': '不支持的优惠券类型'}, 400

    amount_value = _format_price(amount)
    original_amount = amount
    min_spend_value = _format_price(min_spend)

    valid_from_dt = _format_datetime(valid_from)
    valid_to_dt = _format_datetime(valid_to)
    if valid_from_dt and valid_to_dt and valid_from_dt > valid_to_dt:
        return {'success': False, 'message': '有效期开始时间不能晚于结束时间'}, 400

    if total_quantity is not None:
        try:
            total_quantity = int(total_quantity)
        except (TypeError, ValueError):
            return {'success': False, 'message': '优惠券数量必须为整数'}, 400
        if total_quantity < 0:
            return {'success': False, 'message': '优惠券数量不能为负数'}, 400

    try:
        payload_extra = dict(extra_data or {})
        if discount_type == 'gift' and original_amount is not None:
            payload_extra.setdefault('gift_value', original_amount)

        coupon = CouponNotification(
            restaurant_id=restaurant_id,
            title=title,
            description=(description or '').strip() or None,
            discount_type=discount_type,
            amount=amount_value,
            min_spend=min_spend_value,
            valid_from=valid_from_dt,
            valid_to=valid_to_dt,
            total_quantity=total_quantity,
            extra_data=payload_extra
        )
        db.session.add(coupon)
        db.session.flush()

        message_lines = [f"{restaurant.name} 发布了新的优惠券「{title}」！"]
        if discount_type == 'amount' and amount_value is not None:
            message_lines.append(f"优惠金额：¥{amount_value:.2f}")
        elif discount_type == 'percentage' and amount_value is not None:
            message_lines.append(f"折扣力度：{amount_value:.0f}%")
        elif discount_type == 'gift' and original_amount:
            message_lines.append(f"优惠内容：{original_amount}")

        if min_spend_value is not None:
            message_lines.append(f"满 ¥{min_spend_value:.2f} 可用")
        if valid_from_dt and valid_to_dt:
            message_lines.append(f"有效期：{valid_from_dt.strftime('%Y-%m-%d')} - {valid_to_dt.strftime('%Y-%m-%d')}")
        elif valid_to_dt:
            message_lines.append(f"有效期至：{valid_to_dt.strftime('%Y-%m-%d')}")

        if coupon.description:
            message_lines.append(coupon.description)

        message_lines.append('仅限关注本店的用户使用，欢迎尽快领取。')
        message_body = '\n'.join(filter(None, message_lines))

        broadcast = MerchantBroadcast(
            restaurant_id=restaurant_id,
            title=f"优惠券：{title}",
            content=f"【发送对象：关注店铺的用户】\n{message_body}",
            start_time=datetime.utcnow(),
            is_active=True
        )
        db.session.add(broadcast)
        db.session.flush()

        coupon.broadcast_id = broadcast.id

        if auto_commit:
            db.session.commit()

        return {'success': True, 'data': coupon.to_dict(), 'message': '优惠券推送成功'}, 201

    except Exception as exc:
        db.session.rollback()
        if current_app:
            current_app.logger.error('创建优惠券推送失败: %s', exc, exc_info=True)
        else:
            print(f"创建优惠券推送失败: {exc}")
        raise


def list_coupon_notifications(
        restaurant_id: Optional[int] = None,
        include_inactive: bool = False,
        page: int = 1,
        per_page: int = 20,
        follower_user_id: Optional[int] = None,
        exclude_used_by_user_id: Optional[int] = None
) -> Tuple[Dict[str, Any], int]:
    page = max(int(page or 1), 1)
    per_page = min(max(int(per_page or 20), 1), 100)

    query = CouponNotification.query.order_by(CouponNotification.created_at.desc())

    if restaurant_id:
        query = query.filter(CouponNotification.restaurant_id == restaurant_id)
    elif follower_user_id:
        query = query.join(
            RestaurantFollow,
            (RestaurantFollow.restaurant_id == CouponNotification.restaurant_id)
        ).filter(RestaurantFollow.user_id == follower_user_id)

    if not include_inactive:
        query = query.filter(CouponNotification.is_active.is_(True))

    # 排除指定用户已使用的优惠券
    if exclude_used_by_user_id:
        used_coupon_ids_subquery = db.session.query(CouponUsage.coupon_id).filter(
            CouponUsage.user_id == exclude_used_by_user_id
        ).subquery()
        query = query.filter(~CouponNotification.id.in_(used_coupon_ids_subquery))

    pagination = query.paginate(page=page, per_page=per_page, error_out=False)
    records = [item.to_dict() for item in pagination.items]

    return {
        'success': True,
        'data': {
            'records': records,
            'pagination': {
                'page': pagination.page,
                'per_page': pagination.per_page,
                'total_pages': pagination.pages,
                'total_items': pagination.total
            }
        }
    }, 200


def get_coupon_notification(notification_id: int) -> Tuple[Dict[str, Any], int]:
    notification = CouponNotification.query.get(notification_id)
    if not notification:
        return {'success': False, 'message': '优惠券通知不存在'}, 404

    return {'success': True, 'data': notification.to_dict()}, 200
