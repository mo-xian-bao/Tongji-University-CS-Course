"""
优惠券推荐相关API路由
"""

from flask import Blueprint, request, jsonify
from datetime import datetime
import uuid

from Models import (
    db, CouponNotification, CouponUsage, CouponUserChoice, RestaurantFollow,
    User, Restaurant, Order
)

from auxiliary_function import token_required, g
from coupon_recommendation import (
    get_recommended_coupons_for_user,
    record_coupon_user_action
)

# 创建蓝图
coupon_bp = Blueprint('coupon', __name__, url_prefix='/api/coupons')


@coupon_bp.route('/recommendations', methods=['GET'])
@token_required
def get_coupon_recommendations():
    """
    获取用户的智能优惠券推荐

    Query Parameters:
        limit: 推荐数量限制，默认10

    Returns:
        推荐优惠券列表
    """
    try:
        user_id = g.current_user.id
        limit = min(int(request.args.get('limit', 10)), 20)  # 最多20个

        # 获取推荐优惠券
        recommendations = get_recommended_coupons_for_user(user_id, limit)

        return jsonify({
            'success': True,
            'message': '获取推荐成功',
            'data': {
                'recommendations': recommendations,
                'total': len(recommendations)
            }
        }), 200

    except ValueError as e:
        return jsonify({
            'success': False,
            'message': f'参数错误: {str(e)}'
        }), 400
    except Exception as e:
        db.session.rollback()
        return jsonify({
            'success': False,
            'message': f'获取推荐失败: {str(e)}'
        }), 500


@coupon_bp.route('/<int:coupon_id>/accept', methods=['POST'])
@token_required
def accept_coupon(coupon_id):
    """
    用户接受推荐优惠券

    当用户确认接受优惠券时，系统自动关注该餐厅
    """
    try:
        user_id = g.current_user.id

        # 验证优惠券存在且有效
        coupon = CouponNotification.query.get(coupon_id)
        if not coupon:
            return jsonify({
                'success': False,
                'message': '优惠券不存在'
            }), 404

        if not coupon.is_active:
            return jsonify({
                'success': False,
                'message': '优惠券已失效'
            }), 400

        # 检查优惠券是否过期
        now = datetime.utcnow()
        # 只有设置了有效期的优惠券才需要检查
        if coupon.valid_from and coupon.valid_from > now:
            return jsonify({
                'success': False,
                'message': '优惠券尚未生效'
            }), 400

        if coupon.valid_to and coupon.valid_to < now:
            return jsonify({
                'success': False,
                'message': '优惠券已过期'
            }), 400

        # 检查是否已使用
        existing_usage = CouponUsage.query.filter_by(
            user_id=user_id,
            coupon_id=coupon_id
        ).first()

        if existing_usage:
            return jsonify({
                'success': False,
                'message': '您已经使用过该优惠券'
            }), 400

        # 自动关注该餐厅（如果还未关注）
        restaurant = Restaurant.query.get(coupon.restaurant_id)
        if restaurant:
            existing_follow = RestaurantFollow.query.filter_by(
                user_id=user_id,
                restaurant_id=restaurant.id
            ).first()

            if not existing_follow:
                # 创建关注关系
                follow = RestaurantFollow(user_id=user_id, restaurant_id=restaurant.id)
                db.session.add(follow)

                follow_message = f"已自动关注「{restaurant.name}」，您将收到该餐厅的最新动态"
            else:
                follow_message = f"您已经关注了「{restaurant.name}」"
        else:
            follow_message = "关注餐厅失败，餐厅信息不存在"

        # 记录用户接受行为
        record_coupon_user_action(user_id, coupon_id, 'accept')

        db.session.commit()

        return jsonify({
            'success': True,
            'message': f'已接受优惠券推荐！{follow_message}',
            'data': {
                'coupon': coupon.to_dict(),
                'follow_message': follow_message,
                'restaurant_name': restaurant.name if restaurant else None
            }
        }), 200

    except Exception as e:
        db.session.rollback()
        return jsonify({
            'success': False,
            'message': f'接受优惠券失败: {str(e)}'
        }), 500


@coupon_bp.route('/<int:coupon_id>/reject', methods=['POST'])
@token_required
def reject_coupon(coupon_id):
    """
    用户拒绝推荐优惠券
    """
    try:
        user_id = g.current_user.id

        # 验证优惠券存在
        coupon = CouponNotification.query.get(coupon_id)
        if not coupon:
            return jsonify({
                'success': False,
                'message': '优惠券不存在'
            }), 404

        # 记录用户拒绝行为
        record_coupon_user_action(user_id, coupon_id, 'reject')

        return jsonify({
            'success': True,
            'message': '已记录您的选择，我们将优化后续推荐',
            'data': {
                'coupon_id': coupon_id
            }
        }), 200

    except Exception as e:
        return jsonify({
            'success': False,
            'message': f'操作失败: {str(e)}'
        }), 500


@coupon_bp.route('/<int:coupon_id>/use', methods=['POST'])
@token_required
def use_coupon(coupon_id):
    """
    使用优惠券（在下单时使用）
    """
    try:
        user_id = g.current_user.id
        data = request.get_json() or {}
        order_id = data.get('order_id')

        # 验证优惠券存在且有效
        coupon = CouponNotification.query.get(coupon_id)
        if not coupon:
            return jsonify({
                'success': False,
                'message': '优惠券不存在'
            }), 404

        if not coupon.is_active:
            return jsonify({
                'success': False,
                'message': '优惠券已失效'
            }), 400

        # 检查优惠券是否过期
        now = datetime.utcnow()
        # 只有设置了有效期的优惠券才需要检查
        if coupon.valid_from and coupon.valid_from > now:
            return jsonify({
                'success': False,
                'message': '优惠券尚未生效'
            }), 400

        if coupon.valid_to and coupon.valid_to < now:
            return jsonify({
                'success': False,
                'message': '优惠券已过期'
            }), 400

        # 检查是否已使用
        existing_usage = CouponUsage.query.filter_by(
            user_id=user_id,
            coupon_id=coupon_id
        ).first()

        if existing_usage:
            return jsonify({
                'success': False,
                'message': '该优惠券已经使用过了'
            }), 400

        # 如果提供了订单ID，验证订单
        if order_id:
            order = Order.query.get(order_id)
            if not order:
                return jsonify({
                    'success': False,
                    'message': '订单不存在'
                }), 404

            if order.user_id != user_id:
                return jsonify({
                    'success': False,
                    'message': '无权操作此订单'
                }), 403

            # 验证最低消费要求
            if coupon.min_spend and order.total_price < coupon.min_spend:
                return jsonify({
                    'success': False,
                    'message': f'订单金额未达到最低消费要求 ¥{coupon.min_spend}'
                }), 400

            # 验证餐厅匹配
            if order.restaurant_id != coupon.restaurant_id:
                return jsonify({
                    'success': False,
                    'message': '优惠券不适用于此餐厅'
                }), 400

        # 创建使用记录
        usage = CouponUsage(
            user_id=user_id,
            coupon_id=coupon_id,
            order_id=order_id,
            used_at=datetime.utcnow()
        )
        db.session.add(usage)

        # 记录用户使用行为
        record_coupon_user_action(user_id, coupon_id, 'use')

        db.session.commit()

        return jsonify({
            'success': True,
            'message': '优惠券使用成功',
            'data': {
                'coupon': coupon.to_dict(),
                'usage_id': usage.id
            }
        }), 200

    except Exception as e:
        db.session.rollback()
        return jsonify({
            'success': False,
            'message': f'使用优惠券失败: {str(e)}'
        }), 500


@coupon_bp.route('/my-coupons', methods=['GET'])
@token_required
def get_user_coupons():
    """
    获取用户的优惠券列表（可用和已使用的）

    Query Parameters:
        status: 状态筛选 (available/used/all)
        page: 页码，默认1
        per_page: 每页数量，默认20
    """
    try:
        user_id = g.current_user.id
        status = request.args.get('status', 'available')
        page = max(int(request.args.get('page', 1)), 1)
        per_page = min(max(int(request.args.get('per_page', 20)), 1), 100)

        # 获取用户已使用的优惠券ID
        used_coupon_ids = db.session.query(CouponUsage.coupon_id).filter(
            CouponUsage.user_id == user_id
        ).all()
        used_coupon_ids = [item[0] for item in used_coupon_ids]

        if status == 'used':
            # 只显示已使用的
            query = CouponNotification.query.filter(
                CouponNotification.id.in_(used_coupon_ids)
            )
        elif status == 'available':
            # 只显示可用的
            now = datetime.utcnow()
            query = CouponNotification.query.filter(
                CouponNotification.is_active == True,
                CouponNotification.valid_from <= now,
                CouponNotification.valid_to >= now
            ).filter(~CouponNotification.id.in_(used_coupon_ids))
        else:
            # 显示所有
            query = CouponNotification.query

        # 按创建时间倒序排列
        pagination = query.order_by(CouponNotification.created_at.desc()).paginate(
            page=page, per_page=per_page, error_out=False
        )

        coupons = []
        for coupon in pagination.items:
            coupon_data = coupon.to_dict()
            coupon_data['is_used'] = coupon.id in used_coupon_ids
            coupons.append(coupon_data)

        return jsonify({
            'success': True,
            'data': {
                'coupons': coupons,
                'pagination': {
                    'page': pagination.page,
                    'per_page': pagination.per_page,
                    'total_pages': pagination.pages,
                    'total_items': pagination.total
                }
            }
        }), 200

    except ValueError as e:
        return jsonify({
            'success': False,
            'message': f'参数错误: {str(e)}'
        }), 400
    except Exception as e:
        return jsonify({
            'success': False,
            'message': f'获取优惠券列表失败: {str(e)}'
        }), 500


@coupon_bp.route('/<int:coupon_id>', methods=['GET'])
@token_required
def get_coupon_detail(coupon_id):
    """
    获取优惠券详情
    """
    try:
        user_id = g.current_user.id

        coupon = CouponNotification.query.get(coupon_id)
        if not coupon:
            return jsonify({
                'success': False,
                'message': '优惠券不存在'
            }), 404

        # 检查用户是否已使用此优惠券
        usage = CouponUsage.query.filter_by(
            user_id=user_id,
            coupon_id=coupon_id
        ).first()

        coupon_data = coupon.to_dict()
        coupon_data['is_used'] = usage is not None
        coupon_data['used_at'] = usage.used_at.isoformat() if usage else None

        # 获取餐厅信息
        restaurant = Restaurant.query.get(coupon.restaurant_id)
        if restaurant:
            coupon_data['restaurant'] = restaurant.to_dict()

            # 检查用户是否关注该餐厅
            follow = RestaurantFollow.query.filter_by(
                user_id=user_id,
                restaurant_id=restaurant.id
            ).first()
            coupon_data['is_following_restaurant'] = follow is not None

        return jsonify({
            'success': True,
            'data': coupon_data
        }), 200

    except Exception as e:
        return jsonify({
            'success': False,
            'message': f'获取优惠券详情失败: {str(e)}'
        }), 500


@coupon_bp.route('/recommendations/<int:coupon_id>', methods=['GET'])
@token_required
def get_coupon_recommendation_detail(coupon_id):
    """
    获取推荐优惠券的完整详情（包含推荐信息）
    """
    try:
        user_id = g.current_user.id

        # 获取推荐数据
        recommendations = get_recommended_coupons_for_user(user_id, limit=50)
        recommendation_data = None

        for rec in recommendations:
            if rec.get('coupon', {}).get('id') == coupon_id:
                recommendation_data = rec
                break

        if not recommendation_data:
            return jsonify({
                'success': False,
                'message': '该优惠券推荐不存在或已过期'
            }), 404

        return jsonify({
            'success': True,
            'data': recommendation_data
        }), 200

    except Exception as e:
        return jsonify({
            'success': False,
            'message': f'获取推荐详情失败: {str(e)}'
        }), 500


@coupon_bp.route('/refresh-recommendations', methods=['POST'])
@token_required
def refresh_recommendations():
    """
    手动刷新用户的推荐优惠券

    Returns:
        更新后的推荐优惠券列表
    """
    try:
        user_id = g.current_user.id

        # 立即触发推荐更新
        recommendations = get_recommended_coupons_for_user(user_id, limit=10)

        return jsonify({
            'success': True,
            'message': f'推荐已更新，为您找到 {len(recommendations)} 个推荐优惠券',
            'data': {
                'recommendations': recommendations,
                'total': len(recommendations)
            }
        }), 200

    except Exception as e:
        return jsonify({
            'success': False,
            'message': f'更新推荐失败: {str(e)}'
        }), 500


@coupon_bp.route('/status', methods=['GET'])
@token_required
def get_recommendation_status():
    """
    获取推荐系统状态

    Returns:
        推荐系统状态信息
    """
    try:
        user_id = g.current_user.id

        # 获取用户的推荐状态
        recommendations = get_recommended_coupons_for_user(user_id, limit=10)

        # 统计信息
        total_coupons = CouponNotification.query.filter(
            CouponNotification.is_active == True
        ).count()

        used_coupons = CouponUsage.query.filter_by(user_id=user_id).count()

        return jsonify({
            'success': True,
            'data': {
                'user_recommendations_count': len(recommendations),
                'total_available_coupons': total_coupons,
                'user_used_coupons': used_coupons,
                'last_updated': datetime.utcnow().isoformat()
            }
        }), 200

    except Exception as e:
        return jsonify({
            'success': False,
            'message': f'获取状态失败: {str(e)}'
        }), 500