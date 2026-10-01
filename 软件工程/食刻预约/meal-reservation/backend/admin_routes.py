from flask import Blueprint
from sqlalchemy import func
import logging

from auxiliary_function import token_required,request, jsonify, g
# 引入 Restaurant 模型
from Models import User, Review, ReviewKeyword, UserBan, UserAppeal, Restaurant
from datetime import datetime, timedelta, date, timezone
from app_init import db
from db_exe import (get_all_merchant_applications, get_merchant_application_by_id, 
                    approve_merchant_application, reject_merchant_application, 
                    delete_user_applications)
import json


admin_bp = Blueprint('admin', __name__, url_prefix='/api/admin')
admin_logger = logging.getLogger('admin')

@admin_bp.route('/reviews', methods=['GET'])
@token_required
def admin_list_reviews():
    try:
        # 仅管理员 (usertype == 0) 可访问
        if g.current_user.usertype != 0:
            return jsonify({'success': False, 'message': '无权限'}), 403

        page = int(request.args.get('page', 1))
        per_page = int(request.args.get('per_page', 50))
        query = Review.query.order_by(Review.created_at.desc())
        total = query.count()
        items = query.offset((page-1)*per_page).limit(per_page).all()
        return jsonify({'success': True, 'data': {'reviews': [r.to_dict() for r in items], 'total': total}}), 200
    except Exception as e:
        print(f"管理员获取评价失败: {e}")
        return jsonify({'success': False, 'message': '获取失败', 'error': str(e)}), 500


@admin_bp.route('/reviews/<int:review_id>', methods=['PATCH'])
@token_required
def admin_update_review(review_id):
    try:
        review = Review.query.get(review_id)
        if not review:
            return jsonify({'success': False, 'message': '评价不存在'}), 404

        data = request.get_json() or {}

        # 限制：只有管理员可操作
        if g.current_user.usertype != 0:
            return jsonify({'success': False, 'message': '无权限'}), 403

        # 如果要更改显示状态（hidden/normal），仅允许 review_status == 'approved'
        if 'status' in data:
            new_status = data['status']
            if new_status in {'hidden', 'normal'} and review.review_status != 'approved':
                return jsonify({'success': False, 'message': '仅可对已通过审核的评论执行隐藏/显示'}), 400
            review.status = new_status

        # 处理其它审核字段（merchant_reply, review_status 等）
        if 'merchant_reply' in data:
            review.merchant_reply = data['merchant_reply']
            review.merchant_reply_time = datetime.utcnow()

        if 'review_status' in data:
            rs = data['review_status']
            if rs not in {'pending', 'approved', 'rejected'}:
                return jsonify({'success': False, 'message': '无效的review_status'}), 400
                    # 拒绝时必须提供驳回理由
            if rs == 'rejected':
                reject_reason = (data.get('review_reject_reason') or '').strip()
                if not reject_reason:
                    return jsonify({'success': False, 'message': '拒绝评论必须填写驳回理由'}), 400
                review.review_reject_reason = reject_reason
                
            review.review_status = rs
            if rs in {'approved', 'rejected'}:
                review.reviewer_id = g.current_user.id
                review.reviewed_at = datetime.utcnow()

        review.updated_at = datetime.utcnow()
        
        # 1. 先提交评论的状态更改
        db.session.commit()

        # 2. --- 新增逻辑：重新计算餐厅评分 ---
        try:
            # 计算该餐厅所有 "已发布(normal)" 且 "审核通过(approved)" 的评论的平均分
            avg_rating = db.session.query(func.avg(Review.rating)).filter(
                Review.restaurant_id == review.restaurant_id,
                Review.status == 'normal',
                Review.review_status == 'approved'
            ).scalar()

            restaurant = Restaurant.query.get(review.restaurant_id)
            if restaurant:
                # 如果有评分则保留1位小数，否则恢复默认值 None
                new_rating = round(float(avg_rating), 1) if avg_rating is not None else None
                
                # 只有评分变化时才更新
                if restaurant.rating != new_rating:
                    restaurant.rating = new_rating
                    db.session.commit()
                    
        except Exception as calc_error:
            print(f"计算评分失败: {calc_error}")
            # 评分计算失败不应影响审核操作的成功返回，但建议记录日志

        return jsonify({'success': True, 'message': '更新成功', 'data': review.to_dict()}), 200
    except Exception as e:
        db.session.rollback()
        print(f"管理员更新评价失败: {e}")
        return jsonify({'success': False, 'message': '更新失败', 'error': str(e)}), 500

# ===== 管理员审核商户申请 API =====

@admin_bp.route('/merchant-applications', methods=['GET'])
@token_required
def admin_get_merchant_applications():
    """管理员获取商户申请列表"""
    try:
        current_user = g.current_user

        # 验证用户是否为管理员
        if current_user.usertype != 0:
            return jsonify({'success': False, 'message': '只有管理员可以访问此接口'}), 403

        # 获取查询参数
        status = request.args.get('status')  # pending, approved, rejected
        page = int(request.args.get('page', 1))
        per_page = int(request.args.get('per_page', 20))

        # 获取申请列表
        result = get_all_merchant_applications(status=status, page=page, per_page=per_page)

        # 转换为字典格式
        applications_data = []
        for application in result['applications']:
            app_dict = application.to_dict()
            # 添加用户信息
            user = User.query.get(application.user_id)
            if user:
                app_dict['user_info'] = {
                    'username': user.username,
                    'phone': user.phone
                }
            applications_data.append(app_dict)

        return jsonify({
            'success': True,
            'message': '获取申请列表成功',
            'data': {
                'applications': applications_data,
                'pagination': {
                    'total': result['total'],
                    'page': result['page'],
                    'per_page': result['per_page'],
                    'pages': result['pages']
                }
            }
        }), 200

    except Exception as e:
        print(f"获取商户申请列表失败: {e}")
        return jsonify({'success': False, 'message': '获取申请列表失败', 'error': str(e)}), 500

@admin_bp.route('/merchant-applications/<int:application_id>', methods=['GET'])
@token_required
def admin_get_merchant_application_detail(application_id):
    """管理员获取商户申请详情"""
    try:
        current_user = g.current_user

        # 验证用户是否为管理员
        if current_user.usertype != 0:
            return jsonify({'success': False, 'message': '只有管理员可以访问此接口'}), 403

        # 获取申请详情
        application = get_merchant_application_by_id(application_id)
        if not application:
            return jsonify({'success': False, 'message': '申请不存在'}), 404

        # 转换为字典格式
        app_dict = application.to_dict()
        # 添加用户信息
        user = User.query.get(application.user_id)
        if user:
            app_dict['user_info'] = {
                'id': user.id,
                'username': user.username,
                'phone': user.phone,
                'usertype': user.usertype
            }

        return jsonify({
            'success': True,
            'message': '获取申请详情成功',
            'data': app_dict
        }), 200

    except Exception as e:
        print(f"获取商户申请详情失败: {e}")
        return jsonify({'success': False, 'message': '获取申请详情失败', 'error': str(e)}), 500

@admin_bp.route('/merchant-applications/<int:application_id>/approve', methods=['POST'])
@token_required
def admin_approve_merchant_application(application_id):
    """管理员批准商户申请"""
    try:
        current_user = g.current_user

        # 验证用户是否为管理员
        if current_user.usertype != 0:
            return jsonify({'success': False, 'message': '只有管理员可以访问此接口'}), 403

        # 批准申请
        success, message = approve_merchant_application(application_id, current_user.id)

        if success:
            return jsonify({
                'success': True,
                'message': message
            }), 200
        else:
            return jsonify({
                'success': False,
                'message': message
            }), 400

    except Exception as e:
        print(f"批准商户申请失败: {e}")
        return jsonify({'success': False, 'message': '批准申请失败', 'error': str(e)}), 500

@admin_bp.route('/merchant-applications/<int:application_id>/reject', methods=['POST'])
@token_required
def admin_reject_merchant_application(application_id):
    """管理员拒绝商户申请"""
    try:
        current_user = g.current_user

        # 验证用户是否为管理员
        if current_user.usertype != 0:
            return jsonify({'success': False, 'message': '只有管理员可以访问此接口'}), 403

        # 获取拒绝理由
        data = request.get_json()
        if not data:
            return jsonify({'success': False, 'message': '缺少请求数据'}), 400

        reject_reason = data.get('reason', '').strip()
        if not reject_reason:
            return jsonify({'success': False, 'message': '请填写拒绝理由'}), 400

        # 拒绝申请
        success, message = reject_merchant_application(application_id, current_user.id, reject_reason)

        if success:
            return jsonify({
                'success': True,
                'message': message
            }), 200
        else:
            return jsonify({
                'success': False,
                'message': message
            }), 400

    except Exception as e:
        print(f"拒绝商户申请失败: {e}")
        return jsonify({'success': False, 'message': '拒绝申请失败', 'error': str(e)}), 500

@admin_bp.route('/merchant-applications/<int:application_id>/cleanup', methods=['DELETE'])
@token_required
def admin_cleanup_user_applications(application_id):
    """管理员清理已审核用户的申请记录"""
    try:
        current_user = g.current_user

        # 验证用户是否为管理员
        if current_user.usertype != 0:
            return jsonify({'success': False, 'message': '只有管理员可以访问此接口'}), 403

        # 获取申请信息
        application = get_merchant_application_by_id(application_id)
        if not application:
            return jsonify({'success': False, 'message': '申请不存在'}), 404

        # 检查申请状态（只能是已批准或已拒绝的申请）
        if application.review_status not in ['approved', 'rejected']:
            return jsonify({'success': False, 'message': '只能清理已审核完成的申请记录'}), 400

        # 删除该用户的所有申请记录
        deleted_count = delete_user_applications(application.user_id)

        return jsonify({
            'success': True,
            'message': f'已清理该用户的 {deleted_count} 条申请记录'
        }), 200

    except Exception as e:
        print(f"清理申请记录失败: {e}")
        return jsonify({'success': False, 'message': '清理申请记录失败', 'error': str(e)}), 500

@admin_bp.route('/reviews/stats', methods=['GET'])
@token_required
def admin_reviews_stats():
    """管理员：评论统计（总数、今日新增、平均评分、待审核数量）"""
    try:
        if g.current_user.usertype != 0:
            return jsonify({'success': False, 'message': '无权限'}), 403

        total_reviews = Review.query.count()

        # 只统计公开且已通过的评论的平均评分（可按需调整）
        avg_rating = db.session.query(func.avg(Review.rating)).filter(
            Review.status == 'normal',
            Review.review_status == 'approved'
        ).scalar() or 0.0
        avg_rating = round(float(avg_rating), 2) if avg_rating is not None else 0.0

        # 今日新增（UTC）
        today = datetime.utcnow().date()
        today_start = datetime(today.year, today.month, today.day)
        today_new = Review.query.filter(Review.created_at >= today_start).count()

        # 待审核评论数量
        pending_reviews = Review.query.filter_by(review_status='pending').count()

        return jsonify({
            'success': True,
            'data': {
                'total_reviews': total_reviews,
                'average_rating': avg_rating,
                'today_new': today_new,
                'pending_reviews': pending_reviews
            }
        }), 200
    except Exception as e:
        admin_logger.error(f'获取评论统计失败: {e}', exc_info=True)
        return jsonify({'success': False, 'message': '获取评论统计失败', 'error': str(e)}), 500

@admin_bp.route('/review-keywords', methods=['GET'])
@token_required
def admin_list_review_keywords():
    if g.current_user.usertype != 0:
        return jsonify({'success': False, 'message': '无权限'}), 403
    kws = ReviewKeyword.query.order_by(ReviewKeyword.created_at.desc()).all()
    return jsonify({'success': True, 'data': {'keywords': [k.to_dict() for k in kws]}}), 200

@admin_bp.route('/review-keywords', methods=['POST'])
@token_required
def admin_add_review_keyword():
    if g.current_user.usertype != 0:
        return jsonify({'success': False, 'message': '无权限'}), 403
    data = request.get_json() or {}
    kw = (data.get('keyword') or '').strip()
    if not kw:
        return jsonify({'success': False, 'message': '关键词不能为空'}), 400
    # 小写存储便于比较
    kw_lower = kw.lower()
    exists = ReviewKeyword.query.filter_by(keyword=kw_lower).first()
    if exists:
        return jsonify({'success': False, 'message': '关键词已存在'}), 400
    rk = ReviewKeyword(keyword=kw_lower, created_by=g.current_user.id)
    db.session.add(rk)
    db.session.commit()
    return jsonify({'success': True, 'message': '添加成功', 'data': rk.to_dict()}), 201

@admin_bp.route('/review-keywords/<int:kw_id>', methods=['DELETE'])
@token_required
def admin_delete_review_keyword(kw_id):
    if g.current_user.usertype != 0:
        return jsonify({'success': False, 'message': '无权限'}), 403
    rk = ReviewKeyword.query.get(kw_id)
    if not rk:
        return jsonify({'success': False, 'message': '关键词未找到'}), 404
    db.session.delete(rk)
    db.session.commit()
    return jsonify({'success': True, 'message': '删除成功'}), 200


# 用户封禁管理API
@admin_bp.route('/users/ban/stats', methods=['GET'])
@token_required
def get_ban_stats():
    """获取封禁统计信息"""
    try:
        current_user = g.current_user

        # 验证用户是否为管理员
        if current_user.usertype != 0:
            return jsonify({'success': False, 'message': '只有管理员可以访问此接口'}), 403

        query = User.query
        query = query.filter(User.usertype != 0)
        # 总用户数
        total_users = query.count()

        # 已封禁用户数（活跃封禁）
        active_banned_count = UserBan.query.filter(
            UserBan.status.in_(['banned', 'temporarily_banned']),
            UserBan.banned_at.isnot(None)
        ).count()

        # 临时封禁用户数
        temp_banned_count = UserBan.query.filter(
            UserBan.status == 'temporarily_banned',
            UserBan.ban_until.isnot(None)
        ).count()

        # 今日封禁数
        today = datetime.utcnow().date()
        today_banned_count = UserBan.query.filter(
            UserBan.status.in_(['banned', 'temporarily_banned']),
            UserBan.banned_at >= today
        ).count()

        return jsonify({
            'success': True,
            'data': {
                'totalUsers': total_users,
                'bannedUsers': active_banned_count,
                'tempBannedUsers': temp_banned_count,
                'todayBanned': today_banned_count
            }
        }), 200

    except Exception as e:
        return jsonify({'success': False, 'message': f'获取统计信息失败: {str(e)}'}), 500


@admin_bp.route('/users/ban/list', methods=['GET'])
@token_required
def get_ban_users_list():
    """获取用户封禁列表"""
    try:
        current_user = g.current_user

        # 验证用户是否为管理员
        if current_user.usertype != 0:
            return jsonify({'success': False, 'message': '只有管理员可以访问此接口'}), 403

        # 获取查询参数
        search_keyword = request.args.get('search', '').strip()
        status_filter = request.args.get('status', 'all').strip()
        type_filter = request.args.get('type', 'all').strip()
        page = int(request.args.get('page', 1))
        per_page = int(request.args.get('per_page', 50))

        # 构建查询
        query = User.query

        # 搜索过滤
        if search_keyword:
            query = query.filter(
                (User.username.ilike(f'%{search_keyword}%')) |
                (User.phone.ilike(f'%{search_keyword}%'))
            )

        # 用户类型过滤
        if type_filter != 'all':
            user_type_map = {'customer': 2, 'merchant': 1}
            if type_filter in user_type_map:
                query = query.filter(User.usertype == user_type_map[type_filter])
            elif type_filter == 'no admin':
                query = query.filter(User.usertype != 0)

        # 分页查询
        users = query.order_by(User.created_at.desc()).paginate(
            page=page,
            per_page=per_page,
            error_out=False
        )

        # 构建返回数据
        users_data = []
        for user in users.items:
            user_data = user.to_dict()

            # 获取用户的封禁信息
            ban_info = UserBan.query.filter_by(user_id=user.id).order_by(UserBan.created_at.desc()).first()
            if ban_info:
                user_data.update({
                    'banReason': ban_info.get_reason_text(),
                    'banUntil': ban_info.ban_until.isoformat() if ban_info.ban_until else None
                })
            else:
                user_data.update({
                    'banReason': None,
                    'banUntil': None
                })

            users_data.append(user_data)

        return jsonify({
            'success': True,
            'data': {
                'users': users_data,
                'total': users.total,
                'page': page,
                'per_page': per_page,
                'total_pages': users.pages
            }
        }), 200

    except Exception as e:
        return jsonify({'success': False, 'message': f'获取用户列表失败: {str(e)}'}), 500


@admin_bp.route('/users/<int:user_id>/ban', methods=['POST'])
@token_required
def ban_user(user_id):
    """封禁用户"""
    try:
        current_user = g.current_user

        # 验证用户是否为管理员
        if current_user.usertype != 0:
            return jsonify({'success': False, 'message': '只有管理员可以访问此接口'}), 403

        data = request.get_json()
        ban_type = data.get('type', 'permanently')
        ban_reason = data.get('reason', '')
        ban_description = data.get('description', '')
        duration = int(data.get('duration', 7))
        notify_user = data.get('notify_user', True)

        # 验证参数
        if not ban_reason:
            return jsonify({'success': False, 'message': '请选择封禁原因'}), 400

        # 获取用户信息
        user = User.query.get(user_id)
        if not user:
            return jsonify({'success': False, 'message': '用户不存在'}), 404

        # 检查用户当前状态
        current_ban = UserBan.query.filter_by(user_id=user_id).order_by(UserBan.created_at.desc()).first()
        if current_ban and current_ban.status in ['banned', 'temporarily_banned']:
            return jsonify({'success': False, 'message': '用户已被封禁，请先解封'}), 400

        # 创建封禁记录
        ban_record = UserBan(
            user_id=user_id,
            status='banned' if ban_type == 'permanently' else 'temporarily_banned',
            ban_type=ban_type,
            ban_reason=ban_reason,
            ban_description=ban_description,
            banned_at=datetime.utcnow(),
            admin_id=current_user.id,
            notify_user=notify_user
        )

        # 如果是临时封禁，设置到期时间
        if ban_type == 'temporarily_banned':
            ban_record.ban_until = datetime.utcnow() + timedelta(days=duration)

        db.session.add(ban_record)
        db.session.commit()

        # 可以在这里添加发送通知的逻辑

        return jsonify({
            'success': True,
            'message': f'用户 {user.username} 已成功封禁',
            'data': ban_record.to_dict()
        }), 200

    except Exception as e:
        db.session.rollback()
        return jsonify({'success': False, 'message': f'封禁用户失败: {str(e)}'}), 500


@admin_bp.route('/users/<int:user_id>/unban', methods=['POST'])
@token_required
def unban_user(user_id):
    """解封用户"""
    try:
        current_user = g.current_user

        # 验证用户是否为管理员
        if current_user.usertype != 0:
            return jsonify({'success': False, 'message': '只有管理员可以访问此接口'}), 403

        # 获取用户信息
        user = User.query.get(user_id)
        if not user:
            return jsonify({'success': False, 'message': '用户不存在'}), 404

        # 获取当前活跃的封禁记录
        active_ban = UserBan.query.filter_by(user_id=user_id).order_by(UserBan.created_at.desc()).first()
        if not active_ban or active_ban.status not in ['banned', 'temporarily_banned']:
            return jsonify({'success': False, 'message': '用户未被封禁'}), 400

        # 解封用户
        active_ban.status = 'normal'
        active_ban.unbanned_at = datetime.utcnow()
        db.session.commit()

        # 可以在这里添加发送通知的逻辑

        return jsonify({
            'success': True,
            'message': f'用户 {user.username} 已成功解封'
        }), 200

    except Exception as e:
        db.session.rollback()
        return jsonify({'success': False, 'message': f'解封用户失败: {str(e)}'}), 500


@admin_bp.route('/users/<int:user_id>/ban/history', methods=['GET'])
@token_required
def get_ban_history(user_id):
    """获取用户封禁历史"""
    try:
        current_user = g.current_user

        # 验证用户是否为管理员
        if current_user.usertype != 0:
            return jsonify({'success': False, 'message': '只有管理员可以访问此接口'}), 403

        # 获取用户封禁历史
        ban_history = UserBan.query.filter_by(user_id=user_id).order_by(UserBan.created_at.desc()).all()

        return jsonify({
            'success': True,
            'data': {
                'user_id': user_id,
                'ban_history': [ban.to_dict() for ban in ban_history]
            }
        }), 200

    except Exception as e:
        return jsonify({'success': False, 'message': f'获取封禁历史失败: {str(e)}'}), 500

# 管理员申诉处理接口

@admin_bp.route('/appeals', methods=['GET'])
@token_required
def get_all_appeals():
    """管理员获取所有申诉列表"""
    try:
        current_user = g.current_user

        # 验证用户是否为管理员
        if current_user.usertype != 0:
            return jsonify({
                'success': False,
                'message': '只有管理员可以访问此接口'
            }), 403

        # 获取查询参数
        status = request.args.get('status', '')
        page = int(request.args.get('page', 1))
        per_page = int(request.args.get('per_page', 20))

        # 构建查询
        query = UserAppeal.query
        if status:
            query = query.filter_by(status=status)

        # 按创建时间倒序排列
        query = query.order_by(UserAppeal.created_at.desc())

        # 分页
        pagination = query.paginate(
            page=page,
            per_page=per_page,
            error_out=False
        )

        # 获取申诉数据
        appeals_data = []
        for appeal in pagination.items:
            appeal_dict = appeal.to_dict()
            appeal_dict['attachments'] = [att.to_dict() for att in appeal.attachments]
            appeals_data.append(appeal_dict)

        return jsonify({
            'success': True,
            'message': '获取申诉列表成功',
            'data': {
                'appeals': appeals_data,
                'pagination': {
                    'current_page': pagination.page,
                    'total_pages': pagination.pages,
                    'per_page': pagination.per_page,
                    'total_items': pagination.total,
                    'has_next': pagination.has_next,
                    'has_prev': pagination.has_prev
                }
            }
        }), 200

    except Exception as e:
        return jsonify({
            'success': False,
            'message': f'获取申诉列表失败: {str(e)}'
        }), 500


@admin_bp.route('/appeal/<int:appeal_id>/process', methods=['POST'])
@token_required
def process_appeal(appeal_id):
    """管理员处理申诉"""
    try:
        current_user = g.current_user

        # 验证用户是否为管理员
        if current_user.usertype != 0:
            return jsonify({
                'success': False,
                'message': '只有管理员可以访问此接口'
            }), 403

        appeal = UserAppeal.query.get(appeal_id)
        if not appeal:
            return jsonify({
                'success': False,
                'message': '申诉不存在'
            }), 404

        if appeal.status not in ['pending', 'processing']:
            return jsonify({
                'success': False,
                'message': '此申诉已被处理，无需重复操作'
            }), 400

        data = request.get_json()
        if not data:
            return jsonify({
                'success': False,
                'message': '请提供处理结果'
            }), 400

        action = data.get('action', '').strip()
        admin_note = data.get('admin_note', '').strip()

        if action not in ['approve', 'reject']:
            return jsonify({
                'success': False,
                'message': '处理操作无效，只能是 approve 或 reject'
            }), 400

        # 更新申诉状态
        if action == 'approve':
            appeal.status = 'approved'
            # 如果申诉通过，解除用户封禁
            if appeal.ban:
                appeal.ban.status = 'normal'
                appeal.ban.unbanned_at = datetime.utcnow()
        else:
            appeal.status = 'rejected'

        appeal.admin_id = current_user.id
        appeal.admin_note = admin_note
        appeal.processed_at = datetime.utcnow()

        db.session.commit()

        action_text = '通过' if action == 'approve' else '拒绝'
        return jsonify({
            'success': True,
            'message': f'申诉已{action_text}',
            'data': appeal.to_dict()
        }), 200

    except Exception as e:
        db.session.rollback()
        return jsonify({
            'success': False,
            'message': f'处理申诉失败: {str(e)}'
        }), 500


@admin_bp.route('/merchant-applications/stats', methods=['GET'])
@token_required
def get_merchant_applications_stats():
    """获取商户申请统计数据"""
    try:
        current_user = g.current_user

        # 验证用户是否为管理员
        if current_user.usertype != 0:
            return jsonify({
                'success': False,
                'message': '只有管理员可以访问此接口'
            }), 403

        from db_exe import MerchantApplication

        # 待处理申请数量
        pending_applications = MerchantApplication.query.filter_by(review_status='pending').count()

        # 今日处理数量
        today = date.today()
        today_start = datetime(today.year, today.month, today.day)
        today_processed = MerchantApplication.query.filter(
            MerchantApplication.reviewed_at >= today_start,
            MerchantApplication.review_status.in_(['approved', 'rejected'])
        ).count()

        # 本月通过率计算
        # 获取本月开始时间
        current_month_start = datetime(today.year, today.month, 1)

        # 本月处理的申请总数
        monthly_total = MerchantApplication.query.filter(
            MerchantApplication.reviewed_at >= current_month_start,
            MerchantApplication.review_status.in_(['approved', 'rejected'])
        ).count()

        # 本月通过的申请数
        monthly_approved = MerchantApplication.query.filter(
            MerchantApplication.reviewed_at >= current_month_start,
            MerchantApplication.review_status == 'approved'
        ).count()

        # 本月拒绝的申请数
        monthly_rejected = MerchantApplication.query.filter(
            MerchantApplication.reviewed_at >= current_month_start,
            MerchantApplication.review_status == 'rejected'
        ).count()

        return jsonify({
            'success': True,
            'message': '获取统计数据成功',
            'data': {
                'pending': pending_applications,
                'todayProcessed': today_processed,
                'monthlyApproved': monthly_approved,
                'monthlyRejected': monthly_rejected
            }
        }), 200

    except Exception as e:
        return jsonify({
            'success': False,
            'message': f'获取统计数据失败: {str(e)}'
        }), 500

# ============ 系统公告管理 ============

@admin_bp.route('/system-notifications', methods=['GET'])
@token_required
def get_system_notifications():
    """获取所有系统公告"""
    try:
        # 仅管理员可访问
        if g.current_user.usertype != 0:
            return jsonify({'success': False, 'message': '无权限'}), 403

        from Models import SystemNotification
        notifications = SystemNotification.query.all()
        return jsonify({
            'success': True,
            'data': [n.to_dict() for n in notifications]
        }), 200
    except Exception as e:
        admin_logger.error(f'获取系统公告失败: {str(e)}')
        return jsonify({'success': False, 'message': '获取系统公告失败'}), 500


@admin_bp.route('/system-notifications', methods=['POST'])
@token_required
def create_system_notification():
    """创建系统公告"""
    try:
        # 仅管理员可访问
        if g.current_user.usertype != 0:
            return jsonify({'success': False, 'message': '无权限'}), 403

        from Models import SystemNotification
        data = request.get_json() or {}
        
        content = data.get('content', '').strip()
        target_audience = data.get('target_audience', 'all')
        
        # 调试日志
        admin_logger.info(f'收到的数据: {data}')
        admin_logger.info(f'target_audience: {target_audience}, type: {type(target_audience)}')
        
        if not content:
            return jsonify({'success': False, 'message': '公告内容不能为空'}), 400
        
        if target_audience not in ['all', 'merchants', 'users']:
            return jsonify({'success': False, 'message': f'发送对象无效: {target_audience}'}), 400
        
        # 检查是否已存在该对象的公告
        existing = SystemNotification.query.filter_by(
            admin_id=g.current_user.id,
            target_audience=target_audience
        ).first()
        
        message_obj = {
            'content': content,
            'timestamp': datetime.now(timezone.utc).isoformat()
        }
        
        if existing:
            # 追加消息
            messages = json.loads(existing.messages) if existing.messages else []
            messages.append(message_obj)
            existing.messages = json.dumps(messages)
            existing.updated_at = datetime.utcnow()
            db.session.commit()
        else:
            # 创建新的公告
            notification = SystemNotification(
                admin_id=g.current_user.id,
                target_audience=target_audience,
                messages=json.dumps([message_obj])
            )
            db.session.add(notification)
            db.session.commit()
        
        return jsonify({
            'success': True,
            'message': '公告发布成功'
        }), 201
    except Exception as e:
        db.session.rollback()
        admin_logger.error(f'创建系统公告失败: {str(e)}')
        return jsonify({'success': False, 'message': '发布公告失败'}), 500


@admin_bp.route('/system-notifications/<int:admin_id>/<target_audience>/<timestamp>', methods=['DELETE'])
@token_required
def delete_system_notification_message(admin_id, target_audience, timestamp):
    """删除系统公告中的单条消息"""
    try:
        # 仅管理员可删除
        if g.current_user.usertype != 0:
            return jsonify({'success': False, 'message': '无权限'}), 403
        
        if g.current_user.id != admin_id and g.current_user.usertype != 0:
            return jsonify({'success': False, 'message': '无权限删除他人的公告'}), 403
        
        from Models import SystemNotification
        notification = SystemNotification.query.filter_by(
            admin_id=admin_id,
            target_audience=target_audience
        ).first()
        
        if not notification:
            return jsonify({'success': False, 'message': '公告不存在'}), 404
        
        messages = json.loads(notification.messages) if notification.messages else []
        
        # 找到并删除指定时间戳的消息
        original_count = len(messages)
        messages = [m for m in messages if m.get('timestamp') != timestamp]
        
        if len(messages) == original_count:
            return jsonify({'success': False, 'message': '消息不存在'}), 404
        
        # 如果没有消息了，删除整条记录
        if not messages:
            db.session.delete(notification)
        else:
            notification.messages = json.dumps(messages)
            notification.updated_at = datetime.utcnow()
        
        db.session.commit()
        
        return jsonify({
            'success': True,
            'message': '消息已删除'
        }), 200
    except Exception as e:
        db.session.rollback()
        admin_logger.error(f'删除系统公告消息失败: {str(e)}')
        return jsonify({'success': False, 'message': '删除消息失败'}), 500


@admin_bp.route('/system-notifications/<int:admin_id>/<target_audience>', methods=['DELETE'])
@token_required
def delete_system_notification(admin_id, target_audience):
    """删除系统公告"""
    try:
        # 仅管理员且是公告发送者可删除
        if g.current_user.usertype != 0:
            return jsonify({'success': False, 'message': '无权限'}), 403
        
        if g.current_user.id != admin_id and g.current_user.usertype != 0:
            return jsonify({'success': False, 'message': '无权限删除他人的公告'}), 403
        
        from Models import SystemNotification
        notification = SystemNotification.query.filter_by(
            admin_id=admin_id,
            target_audience=target_audience
        ).first()
        
        if not notification:
            return jsonify({'success': False, 'message': '公告不存在'}), 404
        
        db.session.delete(notification)
        db.session.commit()
        
        return jsonify({
            'success': True,
            'message': '公告已删除'
        }), 200
    except Exception as e:
        db.session.rollback()
        admin_logger.error(f'删除系统公告失败: {str(e)}')
        return jsonify({'success': False, 'message': '删除公告失败'}), 500


@admin_bp.route('/appeals/stats', methods=['GET'])
@token_required
def get_appeals_stats():
    """获取申诉处理统计数据"""
    try:
        current_user = g.current_user

        # 验证用户是否为管理员
        if current_user.usertype != 0:
            return jsonify({
                'success': False,
                'message': '只有管理员可以访问此接口'
            }), 403

        # 待处理申诉数量
        pending_appeals = UserAppeal.query.filter_by(status='pending').count()

        # 今日处理数量
        today = date.today()
        today_start = datetime(today.year, today.month, today.day)
        today_processed = UserAppeal.query.filter(
            UserAppeal.processed_at >= today_start
        ).count()

        # 本月通过率计算
        # 获取本月开始时间
        current_month_start = datetime(today.year, today.month, 1)

        # 本月处理的申诉总数
        monthly_total = UserAppeal.query.filter(
            UserAppeal.processed_at >= current_month_start
        ).count()

        # 本月通过的申诉数
        monthly_approved = UserAppeal.query.filter(
            UserAppeal.processed_at >= current_month_start,
            UserAppeal.status == 'approved'
        ).count()

        # 计算通过率
        monthly_approval_rate = 0
        if monthly_total > 0:
            monthly_approval_rate = round((monthly_approved / monthly_total) * 100, 1)

        # 平均处理时间（小时）- 计算最近30天内已处理的申诉
        thirty_days_ago = datetime.utcnow() - timedelta(days=30)
        recent_processed_appeals = UserAppeal.query.filter(
            UserAppeal.processed_at >= thirty_days_ago,
            UserAppeal.processed_at.isnot(None),
            UserAppeal.created_at.isnot(None)
        ).all()

        total_process_time = 0
        processed_count = 0
        for appeal in recent_processed_appeals:
            if appeal.processed_at and appeal.created_at:
                # 计算处理时间差（小时）
                time_diff = appeal.processed_at - appeal.created_at
                hours = time_diff.total_seconds() / 3600
                total_process_time += hours
                processed_count += 1

        avg_process_time = 0
        if processed_count > 0:
            avg_process_time = round(total_process_time / processed_count, 1)

        return jsonify({
            'success': True,
            'message': '获取统计数据成功',
            'data': {
                'pendingAppeals': pending_appeals,
                'todayProcessed': today_processed,
                'monthlyApprovalRate': monthly_approval_rate,
                'avgProcessTime': avg_process_time
            }
        }), 200

    except Exception as e:
        return jsonify({
            'success': False,
            'message': f'获取统计数据失败: {str(e)}'
        }), 500
