"""
测试优惠券推荐API
"""
import sys
import os
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

from app_init import app
from Models import db, User, CouponNotification

def test_coupon_api():
    """测试优惠券推荐API"""
    with app.app_context():
        # 检查数据库中是否有测试用户
        users = User.query.filter_by(usertype=2).limit(5).all()
        print(f"找到 {len(users)} 个普通用户")

        # 检查是否有优惠券
        coupons = CouponNotification.query.filter_by(is_active=True).limit(5).all()
        print(f"找到 {len(coupons)} 个活跃优惠券")

        if users:
            user = users[0]
            print(f"测试用户: {user.username} (ID: {user.id})")

            # 模拟API调用
            try:
                from coupon_recommendation import get_recommended_coupons_for_user
                recommendations = get_recommended_coupons_for_user(user.id, limit=5)
                print(f"推荐成功! 获得 {len(recommendations)} 个推荐")

                for i, rec in enumerate(recommendations):
                    coupon = rec.get('coupon', {})
                    print(f"  推荐 {i+1}: {coupon.get('title', 'Unknown')} (分数: {rec.get('recommendation_score', 0):.1f})")

            except Exception as e:
                print(f"推荐失败: {str(e)}")
                import traceback
                traceback.print_exc()

if __name__ == '__main__':
    test_coupon_api()