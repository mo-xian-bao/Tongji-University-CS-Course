"""
优惠券智能推荐算法
基于用户行为、偏好、消费习惯等多维度数据为用户推荐合适的优惠券
"""

import random
from datetime import datetime, timedelta
from typing import List, Dict, Any, Optional
from Models import (
    User, CouponNotification, CouponUsage, CouponUserChoice, Order, OrderItem,
    Dish, RestaurantFollow, Restaurant, db
)


class CouponRecommendationEngine:
    """优惠券智能推荐引擎"""

    def __init__(self):
        self.recommendation_cache = {}
        self.cache_expire_minutes = 30  # 缓存30分钟

    def get_user_recommendations(self, user_id: int, limit: int = 10) -> List[Dict[str, Any]]:
        """
        为用户获取智能推荐的优惠券

        Args:
            user_id: 用户ID
            limit: 推荐数量限制

        Returns:
            推荐优惠券列表，包含推荐理由和置信度
        """
        # 检查缓存
        cache_key = f"user_{user_id}_recommendations"
        if self._is_cache_valid(cache_key):
            return self.recommendation_cache[cache_key]['data']

        try:
            user = User.query.get(user_id)
            if not user:
                return []

            # 获取用户相关数据
            user_profile = self._build_user_profile(user_id)

            # 获取所有可用的优惠券
            available_coupons = self._get_available_coupons(user_id)

            # 为每个优惠券计算推荐分数
            scored_coupons = []
            for coupon in available_coupons:
                score, reasons = self._calculate_recommendation_score(coupon, user_profile)
                if score > 0:  # 只推荐有意义的优惠券
                    scored_coupons.append({
                        'coupon': coupon.to_dict(),
                        'recommendation_score': score,
                        'recommendation_reasons': reasons,
                        'confidence_level': self._get_confidence_level(score)
                    })

            # 按推荐分数排序并限制数量
            scored_coupons.sort(key=lambda x: x['recommendation_score'], reverse=True)
            recommendations = scored_coupons[:limit]

            # 缓存结果
            self.recommendation_cache[cache_key] = {
                'data': recommendations,
                'timestamp': datetime.utcnow()
            }

            return recommendations

        except Exception as e:
            print(f"推荐算法错误: {str(e)}")
            return []

    def _build_user_profile(self, user_id: int) -> Dict[str, Any]:
        """构建用户画像"""
        profile = {
            'user_id': user_id,
            'order_history': [],
            'favorite_categories': {},
            'price_sensitivity': 'medium',
            'preferred_restaurants': set(),
            'usage_frequency': 'low',
            'last_order_date': None,
            'total_spent': 0,
            'avg_order_value': 0
        }

        # 获取用户订单历史
        orders = Order.query.filter_by(user_id=user_id).filter(
            Order.status.in_(['completed', 'confirmed'])
        ).order_by(Order.created_at.desc()).limit(20).all()

        if not orders:
            return profile

        # 分析订单历史
        total_spent = 0
        category_counts = {}
        restaurant_counts = {}

        for order in orders:
            total_spent += order.total_price

            # 统计餐厅偏好
            if order.restaurant_id:
                restaurant_counts[order.restaurant_id] = restaurant_counts.get(order.restaurant_id, 0) + 1

            # 分析菜品类别偏好
            for item in order.items:
                if item.dish and item.dish.category:
                    category = item.dish.category
                    category_counts[category] = category_counts.get(category, 0) + item.quantity

        # 更新用户画像
        profile['order_history'] = [order.to_dict() for order in orders]
        profile['total_spent'] = total_spent
        profile['avg_order_value'] = total_spent / len(orders) if orders else 0
        profile['last_order_date'] = orders[0].created_at if orders else None

        # 计算使用频率（基于最近30天的订单数）
        thirty_days_ago = datetime.utcnow() - timedelta(days=30)
        recent_orders = [o for o in orders if o.created_at > thirty_days_ago]
        if len(recent_orders) >= 5:
            profile['usage_frequency'] = 'high'
        elif len(recent_orders) >= 2:
            profile['usage_frequency'] = 'medium'
        else:
            profile['usage_frequency'] = 'low'

        # 价格敏感度分析
        if profile['avg_order_value'] < 50:
            profile['price_sensitivity'] = 'high'
        elif profile['avg_order_value'] > 150:
            profile['price_sensitivity'] = 'low'
        else:
            profile['price_sensitivity'] = 'medium'

        # 偏好类别（按频次排序）
        profile['favorite_categories'] = dict(
            sorted(category_counts.items(), key=lambda x: x[1], reverse=True)[:5]
        )

        # 偏好餐厅
        profile['preferred_restaurants'] = set(
            [rid for rid, count in sorted(restaurant_counts.items(), key=lambda x: x[1], reverse=True)[:3]]
        )

        return profile

    def _get_available_coupons(self, user_id: int) -> List[CouponNotification]:
        """获取用户可用的优惠券（排除已使用和已拒绝的）"""
        # 获取用户已使用的优惠券ID
        used_coupon_ids = db.session.query(CouponUsage.coupon_id).filter(
            CouponUsage.user_id == user_id
        ).all()
        used_coupon_ids = [item[0] for item in used_coupon_ids]

        # 获取用户已拒绝的优惠券ID
        rejected_coupon_ids = db.session.query(CouponUserChoice.coupon_id).filter(
            CouponUserChoice.user_id == user_id,
            CouponUserChoice.choice == 'reject'
        ).all()
        rejected_coupon_ids = [item[0] for item in rejected_coupon_ids]

        # 获取用户已接受的优惠券ID（避免重复推荐）
        accepted_coupon_ids = db.session.query(CouponUserChoice.coupon_id).filter(
            CouponUserChoice.user_id == user_id,
            CouponUserChoice.choice == 'accept'
        ).all()
        accepted_coupon_ids = [item[0] for item in accepted_coupon_ids]

        # 合并所有需要排除的优惠券ID
        excluded_coupon_ids = set(used_coupon_ids + rejected_coupon_ids + accepted_coupon_ids)

        # 获取有效且未被处理的优惠券
        now = datetime.utcnow()
        available_coupons = CouponNotification.query.filter(
            CouponNotification.is_active == True,
            db.or_(
                CouponNotification.valid_from.is_(None),
                CouponNotification.valid_from <= now
            ),
            db.or_(
                CouponNotification.valid_to.is_(None),
                CouponNotification.valid_to >= now
            )
        ).filter(~CouponNotification.id.in_(excluded_coupon_ids)).all()

        return available_coupons

    def _calculate_recommendation_score(self, coupon: CouponNotification, user_profile: Dict[str, Any]) -> tuple:
        """
        计算优惠券推荐分数

        Returns:
            (score, reasons): 分数和推荐理由列表
        """
        score = 0.0
        reasons = []

        # 1. 基础分数（优惠券本身价值）
        base_score = self._calculate_base_value_score(coupon)
        score += base_score
        if base_score > 30:
            reasons.append("高价值优惠券")

        # 2. 用户消费水平匹配
        price_match_score = self._calculate_price_match_score(coupon, user_profile)
        score += price_match_score
        if price_match_score > 20:
            reasons.append("符合您的消费水平")
        elif price_match_score > 10:
            reasons.append("优惠力度适中")

        # 3. 餐厅偏好匹配
        restaurant_score = self._calculate_restaurant_preference_score(coupon, user_profile)
        score += restaurant_score
        if restaurant_score > 25:
            reasons.append("您可能喜欢的餐厅")
        elif restaurant_score > 15:
            reasons.append("推荐优质餐厅")

        # 4. 时间因素
        time_score = self._calculate_time_factor_score(coupon)
        score += time_score
        if time_score > 10:
            reasons.append("限时优惠即将过期")

        # 5. 用户活跃度奖励
        activity_bonus = self._calculate_activity_bonus(user_profile)
        score += activity_bonus
        if activity_bonus > 5:
            reasons.append("活跃用户专享推荐")

        # 6. 随机因子（增加多样性）
        diversity_bonus = random.uniform(0, 10)
        score += diversity_bonus

        return min(score, 100), reasons  # 限制最高分100

    def _calculate_base_value_score(self, coupon: CouponNotification) -> float:
        """计算优惠券基础价值分数"""
        score = 0

        if coupon.discount_type == 'amount' and coupon.amount:
            # 立减优惠券：金额越高分数越高
            score = min(coupon.amount * 2, 40)  # 最高40分
        elif coupon.discount_type == 'percentage' and coupon.amount:
            # 折扣优惠券：折扣越低分数越高
            discount_percentage = (1 - coupon.amount) * 100
            score = min(discount_percentage * 0.8, 35)  # 最高35分

        # 如果有最低消费要求，适当降低分数
        if coupon.min_spend:
            score = max(score - coupon.min_spend * 0.05, 5)

        return score

    def _calculate_price_match_score(self, coupon: CouponNotification, user_profile: Dict[str, Any]) -> float:
        """计算价格匹配分数"""
        if not user_profile.get('avg_order_value'):
            return 10  # 新用户给基础分

        avg_order = user_profile['avg_order_value']
        min_spend = coupon.min_spend or 0

        # 如果最低消费接近用户平均消费水平，给更高分数
        if avg_order >= min_spend:
            if min_spend > 0:
                ratio = avg_order / min_spend
                if 1 <= ratio <= 1.5:  # 刚好符合或稍高
                    return 25
                elif 1.5 < ratio <= 2.5:
                    return 20
                else:  # 消费远超最低要求
                    return 15
            else:
                return 20  # 无门槛优惠券
        else:
            # 用户平均消费未达到最低要求
            return max(5, 20 - (min_spend - avg_order) * 0.2)

    def _calculate_restaurant_preference_score(self, coupon: CouponNotification, user_profile: Dict[str, Any]) -> float:
        """计算餐厅偏好分数"""
        restaurant_id = coupon.restaurant_id
        preferred_restaurants = user_profile.get('preferred_restaurants', set())

        # 如果是用户偏好的餐厅
        if restaurant_id in preferred_restaurants:
            return 30

        # 检查是否有类似类型的订单历史
        order_history = user_profile.get('order_history', [])
        if order_history:
            # 这里可以根据餐厅类型、菜系等进行更复杂的匹配
            # 简化处理：如果用户有订单历史，给基础分
            return 15

        # 新用户给探索分
        return 10

    def _calculate_time_factor_score(self, coupon: CouponNotification) -> float:
        """计算时间因子分数"""
        # 如果没有设置有效期，给基础分数
        if not coupon.valid_to:
            return 5

        now = datetime.utcnow()
        days_until_expiry = (coupon.valid_to - now).days

        # 即将过期的优惠券给更高分
        if days_until_expiry <= 3:
            return 15
        elif days_until_expiry <= 7:
            return 10
        elif days_until_expiry <= 14:
            return 5
        else:
            return 2

    def _calculate_activity_bonus(self, user_profile: Dict[str, Any]) -> float:
        """计算用户活跃度奖励分数"""
        frequency = user_profile.get('usage_frequency', 'low')

        if frequency == 'high':
            return 10
        elif frequency == 'medium':
            return 5
        else:
            return 2

    def _get_confidence_level(self, score: float) -> str:
        """根据分数确定推荐置信度"""
        if score >= 80:
            return "强烈推荐"
        elif score >= 60:
            return "推荐"
        elif score >= 40:
            return "可能适合"
        else:
            return "试试看"

    def _is_cache_valid(self, cache_key: str) -> bool:
        """检查缓存是否有效"""
        if cache_key not in self.recommendation_cache:
            return False

        cache_time = self.recommendation_cache[cache_key]['timestamp']
        expire_time = cache_time + timedelta(minutes=self.cache_expire_minutes)

        return datetime.utcnow() < expire_time

    def clear_user_cache(self, user_id: int):
        """清除用户推荐缓存"""
        cache_key = f"user_{user_id}_recommendations"
        if cache_key in self.recommendation_cache:
            del self.recommendation_cache[cache_key]

    def record_user_action(self, user_id: int, coupon_id: int, action: str):
        """
        记录用户对优惠券的行为

        Args:
            user_id: 用户ID
            coupon_id: 优惠券ID
            action: 行为类型 ('accept', 'reject', 'use')
        """
        try:
            # 只记录接受和拒绝行为，使用行为由CouponUsage表记录
            if action in ['accept', 'reject']:
                # 检查是否已有选择记录
                existing_choice = CouponUserChoice.query.filter_by(
                    user_id=user_id,
                    coupon_id=coupon_id
                ).first()

                if not existing_choice:
                    # 创建新的选择记录
                    choice_record = CouponUserChoice(
                        user_id=user_id,
                        coupon_id=coupon_id,
                        choice=action,
                        recommendation_context={
                            'timestamp': datetime.utcnow().isoformat(),
                            'action_source': 'recommendation'
                        }
                    )
                    db.session.add(choice_record)
                    db.session.commit()
                    print(f"记录用户 {user_id} 对优惠券 {coupon_id} 的选择：{action}")
                else:
                    print(f"用户 {user_id} 已对优惠券 {coupon_id} 做过选择：{existing_choice.choice}")

            # 清除该用户的推荐缓存，以便更新推荐结果
            self.clear_user_cache(user_id)

        except Exception as e:
            db.session.rollback()
            print(f"记录用户行为失败: {str(e)}")


# 创建全局推荐引擎实例
recommendation_engine = CouponRecommendationEngine()


def get_recommended_coupons_for_user(user_id: int, limit: int = 10) -> List[Dict[str, Any]]:
    """
    为用户获取推荐优惠券的便捷函数

    Args:
        user_id: 用户ID
        limit: 推荐数量限制

    Returns:
        推荐优惠券列表
    """
    return recommendation_engine.get_user_recommendations(user_id, limit)


def record_coupon_user_action(user_id: int, coupon_id: int, action: str):
    """
    记录用户对优惠券行为的便捷函数

    Args:
        user_id: 用户ID
        coupon_id: 优惠券ID
        action: 行为类型
    """
    recommendation_engine.record_user_action(user_id, coupon_id, action)