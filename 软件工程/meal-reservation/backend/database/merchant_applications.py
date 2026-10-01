"""Merchant application helpers."""
from datetime import datetime

from Models import db, MerchantApplication, Restaurant, User


def get_all_merchant_applications(status=None, page=1, per_page=20):
    """获取所有商户申请列表"""
    try:
        query = MerchantApplication.query

        if status:
            query = query.filter_by(review_status=status)

        # 按创建时间倒序排列
        applications = query.order_by(MerchantApplication.created_at.desc()).offset((page - 1) * per_page).limit(per_page).all()
        total = query.count()

        return {
            'applications': applications,
            'total': total,
            'page': page,
            'per_page': per_page,
            'pages': (total + per_page - 1) // per_page
        }
    except Exception as e:
        raise e


def get_merchant_application_by_id(application_id):
    """根据ID获取商户申请详情"""
    try:
        return MerchantApplication.query.get(application_id)
    except Exception as e:
        raise e


def approve_merchant_application(application_id, reviewer_id):
    """批准商户申请"""
    try:
        # 获取申请信息
        application = MerchantApplication.query.get(application_id)
        if not application:
            return False, "申请不存在"

        if application.review_status != 'pending':
            return False, "申请状态不是待审核"

        # 检查用户是否已经有餐厅
        existing_restaurant = Restaurant.query.filter_by(user_id=application.user_id).first()
        if existing_restaurant:
            return False, "该用户已经有餐厅"

        # 创建餐厅记录
        restaurant = Restaurant(
            name=application.shop_name,
            address=application.address,
            phone=application.phone,
            opening_hours=application.business_hours,
            notice=application.description,
            user_id=application.user_id
        )

        # 更新申请状态
        application.review_status = 'approved'
        application.reviewed_at = datetime.utcnow()
        application.reviewer_id = reviewer_id

        # 更新用户类型为商家
        user = User.query.get(application.user_id)
        if user:
            user.usertype = 1

        # 保存所有更改
        db.session.add(restaurant)

        # 删除该用户的其他申请记录，只保留当前已批准的这条
        other_applications = MerchantApplication.query.filter(
            MerchantApplication.user_id == application.user_id,
            MerchantApplication.id != application_id
        ).all()

        for other_app in other_applications:
            db.session.delete(other_app)

        db.session.commit()

        return True, f"申请已批准，餐厅 {restaurant.name} 创建成功"

    except Exception as e:
        db.session.rollback()
        return False, f"批准申请失败: {str(e)}"


def reject_merchant_application(application_id, reviewer_id, reject_reason):
    """拒绝商户申请"""
    try:
        # 获取申请信息
        application = MerchantApplication.query.get(application_id)
        if not application:
            return False, "申请不存在"

        if application.review_status != 'pending':
            return False, "申请状态不是待审核"

        # 更新申请状态
        application.review_status = 'rejected'
        application.review_note = reject_reason
        application.reviewed_at = datetime.utcnow()
        application.reviewer_id = reviewer_id

        db.session.commit()

        return True, "申请已拒绝"

    except Exception as e:
        db.session.rollback()
        return False, f"拒绝申请失败: {str(e)}"


def delete_user_applications(user_id):
    """删除指定用户的所有申请记录"""
    try:
        # 删除该用户的所有申请
        deleted_count = MerchantApplication.query.filter_by(user_id=user_id).delete()
        db.session.commit()
        return deleted_count
    except Exception as e:
        db.session.rollback()
        raise e
