from flask import request, jsonify, g
from datetime import datetime
import os
import uuid

from app_init import app

from Models import (Order,MerchantApplication, Review, ReviewLike, 
                    ReviewKeyword, Message)

from db_exe import (
    db, init_database,
    list_dish_launch_notifications, get_dish_launch_notification,
    list_coupon_notifications, get_coupon_notification,
)

from werkzeug.utils import secure_filename

from auxiliary_function import delete_file_by_url,token_required,g
from ai_assistant_routes import ai_assistant_bp


from auth_routes import auth_bp
from users_routes import users_bp
from restaurant_routes import restaurant_bp, restaurants_bp
from appeal_routes import appeal_bp
from support_routes import support_bp
from admin_routes import admin_bp
from orders_routes import orders_bp
from merchant_routes import merchant_bp
from tables_routes import tables_bp
from dishes_routes import dishes_bp
from coupon_routes import coupon_bp

# 创建数据表
with app.app_context():
    init_database()

# 上传配置
from auxiliary_function import (UPLOAD_FOLDER,MERCHANT_UPLOAD_FOLDER,DISH_UPLOAD_FOLDER,
            APPEAL_UPLOAD_FOLDER,SUPPORT_UPLOAD_FOLDER,allowed_file)

os.makedirs(UPLOAD_FOLDER, exist_ok=True)
os.makedirs(MERCHANT_UPLOAD_FOLDER, exist_ok=True)
os.makedirs(DISH_UPLOAD_FOLDER, exist_ok=True)
os.makedirs(APPEAL_UPLOAD_FOLDER, exist_ok=True)
os.makedirs(SUPPORT_UPLOAD_FOLDER, exist_ok=True)

app.register_blueprint(auth_bp)
app.register_blueprint(users_bp)
app.register_blueprint(restaurant_bp)
app.register_blueprint(restaurants_bp)
app.register_blueprint(appeal_bp)
app.register_blueprint(support_bp)
app.register_blueprint(admin_bp)
app.register_blueprint(orders_bp)
app.register_blueprint(merchant_bp)
app.register_blueprint(tables_bp)
app.register_blueprint(dishes_bp)
app.register_blueprint(coupon_bp)
app.register_blueprint(ai_assistant_bp)

# 暂时禁用定时任务调度器
# init_scheduler(app)

# 错误处理
@app.errorhandler(404)
def not_found(error):
    return jsonify({
        'success': False,
        'message': 'API接口不存在'
    }), 404

@app.errorhandler(500)
def internal_error(error):
    db.session.rollback()
    return jsonify({
        'success': False,
        'message': '服务器内部错误'
    }), 500

# 健康检查
@app.route('/api/health')
def health_check():
    return jsonify({
        'status': 'healthy',
        'message': 'FoodBook API is running'
    })


@app.route('/api/upload', methods=['POST'])
@token_required
def upload_file_api():
    """接收前端上传的图片并保存，返回可访问 URL"""
    if 'file' not in request.files:
        return jsonify({'success': False, 'message': '缺少文件'}), 400

    file = request.files['file']
    if not file or file.filename == '':
        return jsonify({'success': False, 'message': '未选择文件'}), 400

    if not allowed_file(file.filename):
        return jsonify({'success': False, 'message': '不支持的文件类型'}), 400

    filename = secure_filename(file.filename or '')
    # 文件名可能不包含扩展名（例如来自某些 blob url 或未知来源），处理兼容性
    if '.' in filename:
        ext = filename.rsplit('.', 1)[1].lower()
    else:
        # 尝试从文件的 mimetype 推断扩展名，失败时回退到 png
        mimetype = getattr(file, 'mimetype', '') or ''
        if '/' in mimetype:
            ext = mimetype.split('/')[-1].split(';')[0].lower()
        else:
            ext = 'png'
    unique_name = f"{uuid.uuid4().hex}.{ext}"
    save_path = os.path.join(UPLOAD_FOLDER, unique_name)

    try:
        file.save(save_path)
        host = request.host_url.rstrip('/')
        url = f"{host}/static/uploads/avatar/{unique_name}"
        return jsonify({'success': True, 'url': url}), 200
    except Exception as e:
        return jsonify({'success': False, 'message': '保存文件失败', 'error': str(e)}), 500



@app.route('/api/dish-notifications', methods=['GET'])
def get_dish_launch_notifications():
    try:
        restaurant_id = request.args.get('restaurant_id', type=int)
        include_inactive = request.args.get('include_inactive', 'false').lower() == 'true'
        page = request.args.get('page', default=1, type=int)
        per_page = request.args.get('per_page', default=20, type=int)
        response, status_code = list_dish_launch_notifications(
            restaurant_id=restaurant_id,
            include_inactive=include_inactive,
            page=page,
            per_page=per_page
        )
        return jsonify(response), status_code
    except Exception as exc:
        return jsonify({'success': False, 'message': '获取菜品上新通知失败', 'error': str(exc)}), 500


@app.route('/api/dish-notifications/<int:notification_id>', methods=['GET'])
def fetch_dish_launch_notification(notification_id):
    try:
        response, status_code = get_dish_launch_notification(notification_id)
        return jsonify(response), status_code
    except Exception as exc:
        return jsonify({'success': False, 'message': '获取菜品上新通知详情失败', 'error': str(exc)}), 500


@app.route('/api/coupon-notifications', methods=['GET'])
@token_required
def get_coupon_notifications():
    try:
        restaurant_id = request.args.get('restaurant_id', type=int)
        include_inactive = request.args.get('include_inactive', 'false').lower() == 'true'
        page = request.args.get('page', default=1, type=int)
        per_page = request.args.get('per_page', default=20, type=int)

        # 获取当前用户ID，用于排除已使用的优惠券
        current_user_id = None
        if g.current_user and g.current_user.id:
            current_user_id = g.current_user.id

        # 如果没有指定restaurant_id，则只获取用户关注的商家的优惠券
        follower_user_id = current_user_id if not restaurant_id else None

        response, status_code = list_coupon_notifications(
            restaurant_id=restaurant_id,
            include_inactive=include_inactive,
            page=page,
            per_page=per_page,
            follower_user_id=follower_user_id,
            exclude_used_by_user_id=current_user_id
        )
        return jsonify(response), status_code
    except Exception as exc:
        return jsonify({'success': False, 'message': '获取优惠券通知失败', 'error': str(exc)}), 500


@app.route('/api/coupon-notifications/<int:notification_id>', methods=['GET'])
def fetch_coupon_notification(notification_id):
    try:
        response, status_code = get_coupon_notification(notification_id)
        return jsonify(response), status_code
    except Exception as exc:
        return jsonify({'success': False, 'message': '获取优惠券通知详情失败', 'error': str(exc)}), 500




# ===== 商户申请管理 API =====

@app.route('/api/merchant-application', methods=['GET', 'POST'])
@token_required
def handle_merchant_applications():
    """商户申请管理 - GET: 获取申请列表, POST: 创建新申请"""
    try:
        if request.method == 'GET':
            # 获取当前用户的申请列表
            applications = MerchantApplication.get_by_user(g.current_user.id)
            return jsonify({
                'success': True,
                'message': '获取申请列表成功',
                'data': {
                    'applications': [app.to_dict() for app in applications]
                }
            }), 200

        elif request.method == 'POST':
            # 检查是否是FormData（包含文件）
            if request.content_type and 'multipart/form-data' in request.content_type:
                # 处理包含文件的表单数据
                shop_name = request.form.get('shopName', '')
                shop_type = request.form.get('shopType', '')
                business_license = request.form.get('businessLicense', '')
                phone = request.form.get('phone', '')
                address = request.form.get('address', '')
                business_hours = request.form.get('businessHours', '')
                description = request.form.get('description', '')
                status = request.form.get('status', 'draft')

                license_file_url = request.form.get('licenseFile', '')
                id_file_url = request.form.get('idFile', '')


            else:
                # 处理JSON数据
                data = request.get_json()
                if not data:
                    return jsonify({'success': False, 'message': '缺少请求数据'}), 400

                shop_name = data.get('shopName', '')
                shop_type = data.get('shopType', '')
                business_license = data.get('businessLicense', '')
                phone = data.get('phone', '')
                address = data.get('address', '')
                business_hours = data.get('businessHours', '')
                description = data.get('description', '')
                status = data.get('status', 'draft')
                license_file_url = data.get('licenseFile')
                id_file_url = data.get('idFile')

            # 创建商户申请
            application = MerchantApplication(
                user_id=g.current_user.id,
                shop_name=shop_name,
                shop_type=shop_type,
                business_license=business_license,
                phone=phone,
                address=address,
                business_hours=business_hours,
                description=description,
                status=status,  # draft 或 submitted
                license_file_url=license_file_url,
                id_file_url=id_file_url
            )

            db.session.add(application)
            db.session.commit()

            return jsonify({
                'success': True,
                'message': '申请提交成功',
                'data': application.to_dict()
            }), 201

    except Exception as e:
        db.session.rollback()
        return jsonify({'success': False, 'message': '申请操作失败', 'error': str(e)}), 500


@app.route('/api/merchant-application/<int:application_id>', methods=['GET', 'PUT'])
@token_required
def handle_merchant_application(application_id):
    """单个商户申请操作 - GET: 获取申请详情, PUT: 更新申请"""
    try:
        application = MerchantApplication.query.get(application_id)
        if not application:
            return jsonify({'success': False, 'message': '申请不存在'}), 404

        # 验证权限：确保该申请属于当前用户
        if application.user_id != g.current_user.id:
            return jsonify({'success': False, 'message': '无权访问该申请'}), 403

        if request.method == 'GET':
            return jsonify({
                'success': True,
                'data': application.to_dict()
            }), 200

        elif request.method == 'PUT':
            # 检查是否是FormData（包含文件）
            if request.content_type and 'multipart/form-data' in request.content_type:
                # 处理包含文件的表单数据
                application.shop_name = request.form.get('shopName', '')
                application.shop_type = request.form.get('shopType', '')
                application.business_license = request.form.get('businessLicense', '')
                application.phone = request.form.get('phone', '')
                application.address = request.form.get('address', '')
                application.business_hours = request.form.get('businessHours', '')
                application.description = request.form.get('description', '')
                application.status = request.form.get('status', 'draft')
                delete_file_by_url(application.license_file_url)
                delete_file_by_url(application.id_file_url)
                application.license_file_url = request.form.get('licenseFile', '')
                application.id_file_url = request.form.get('idFile', '')


            else:
                # 处理JSON数据
                data = request.get_json()
                if not data:
                    return jsonify({'success': False, 'message': '缺少请求数据'}), 400

                application.shop_name = data.get('shopName', '')
                application.shop_type = data.get('shopType', '')
                application.business_license = data.get('businessLicense', '')
                application.address = data.get('address', '')
                application.business_hours = data.get('businessHours', '')
                application.description = data.get('description', '')
                application.status = data.get('status', 'draft')
                delete_file_by_url(application.license_file_url)
                delete_file_by_url(application.id_file_url)
                application.license_file_url = data.get('licenseFile')
                application.id_file_url = data.get('idFile', '')

            application.updated_at = datetime.utcnow()
            db.session.commit()

            return jsonify({
                'success': True,
                'message': '申请更新成功',
                'data': application.to_dict()
            }), 200

    except Exception as e:
        db.session.rollback()
        return jsonify({'success': False, 'message': '申请操作失败', 'error': str(e)}), 500




# ==================== 评价相关 API ====================
@app.route('/api/reviews', methods=['POST'])
@token_required
def submit_review():
    """用户提交评价
    请求体: { order_id, rating, content, images, food_rating, packaging_rating, service_rating }
    """
    try:
        data = request.get_json() or {}
        current_user = g.current_user

        order_id = data.get('order_id')
        if not order_id:
            return jsonify({'success': False, 'message': '缺少 order_id'}), 400

        order = Order.query.get(int(order_id))
        if not order:
            return jsonify({'success': False, 'message': '订单不存在'}), 404

        # 仅允许订单所属用户评价
        if order.user_id != current_user.id:
            return jsonify({'success': False, 'message': '无权对该订单评价'}), 403

        # 检查是否已有该订单的评价（同一用户）
        existing = Review.query.filter_by(order_id=order.id, user_id=current_user.id).first()
        if existing:
            return jsonify({'success': False, 'message': '该订单已评价'}), 400

        rating = int(data.get('rating', 5) or 5)
        content = (data.get('content') or '').strip()
        images = data.get('images') or []
        food_rating = data.get('food_rating')
        packaging_rating = data.get('packaging_rating')
        service_rating = data.get('service_rating')

        review = Review(
            order_id=order.id,
            restaurant_id=order.restaurant_id,
            user_id=current_user.id,
            rating=rating,
            content=content,
            images=images,
            food_rating=food_rating,
            packaging_rating=packaging_rating,
            service_rating=service_rating,
            status='normal',
            review_status='pending'  # 默认 pending
        )

        # 自动审核关键字：如果命中则直接拒绝
        try:
            keywords = ReviewKeyword.query.all()
            matched = None
            if keywords and content:
                lower = content.lower()
                for k in keywords:
                    if k.keyword and k.keyword in lower:
                        matched = k.keyword
                        break
            if matched:
                review.review_status = 'rejected'
                review.review_reject_reason = f'自动驳回：包含敏感关键词 "{matched}"'
                review.reviewed_at = datetime.utcnow()
                # reviewer_id 保留为 None（系统自动拒绝）
        except Exception as e:
            app.logger.warning(f'自动审核关键词检查失败: {e}')

        db.session.add(review)
        db.session.commit()

        if review.review_status == 'rejected':
            return jsonify({'success': True, 'message': '评论已提交，但包含敏感词已被自动拒绝', 'data': review.to_dict()}), 201

        # 通知用户：评论需要管理员审核后才能在店铺展示
        return jsonify({'success': True, 'message': '评论提交成功，等待管理员审核', 'data': review.to_dict()}), 201

    except Exception as e:
        db.session.rollback()
        print(f"提交评价失败: {e}")
        return jsonify({'success': False, 'message': '提交评价失败', 'error': str(e)}), 500

@app.route('/api/reviews/<int:review_id>/like', methods=['POST'])
@token_required
def like_review(review_id):
    try:
        data = request.get_json() or {}
        action = (data.get('action') or 'like').lower()
        review = Review.query.get(review_id)
        if not review:
            return jsonify({'success': False, 'message': '评价不存在'}), 404

        current_user = g.current_user
        if not current_user:
            return jsonify({'success': False, 'message': '未登录'}), 401

        existing = ReviewLike.query.filter_by(review_id=review_id, user_id=current_user.id).first()

        if action == 'like':
            if not existing:
                # 创建记录并增加计数
                rl = ReviewLike(review_id=review_id, user_id=current_user.id)
                db.session.add(rl)
                review.likes = (review.likes or 0) + 1
                is_liked = True
            else:
                # 已经点赞，保持幂等
                is_liked = True
        else:
            if existing:
                db.session.delete(existing)
                review.likes = max((review.likes or 0) - 1, 0)
                is_liked = False
            else:
                is_liked = False

        review.updated_at = datetime.utcnow()
        db.session.commit()
        return jsonify({'success': True, 'data': {'review_id': review.id, 'likes': review.likes, 'is_liked': is_liked}}), 200
    except Exception as e:
        db.session.rollback()
        print(f"点赞操作失败: {e}")
        return jsonify({'success': False, 'message': '操作失败', 'error': str(e)}), 500

# --- 新增：消息接口，支持按 order_id 或 request_id 查询与发送 ---
@app.route('/api/messages', methods=['GET', 'POST'])
@token_required
def messages_api():
    try:
        current_user = g.current_user

        if request.method == 'POST':
            data = request.get_json(silent=True) or {}
            order_id = data.get('order_id')
            request_id = data.get('request_id')
            text = (data.get('text') or '').strip()

            if not text or (not order_id and not request_id):
                return jsonify({'success': False, 'message': '缺少 order_id/request_id 或 text'}), 400

            # sender_type: merchant if usertype==1 else user
            sender_type = 'merchant' if current_user.usertype == 1 else 'user'
            # 新增：支持 message_type
            message_type = data.get('message_type', 'normal')
            msg = Message(
                order_id=order_id,
                request_id=request_id,
                sender_id=getattr(current_user, 'id', None),
                sender_type=sender_type,
                text=text,
                message_type=message_type  # 新增字段
            )
            db.session.add(msg)
            db.session.commit()
            return jsonify({'success': True, 'data': msg.to_dict()}), 201

        else:  # GET
            order_id = request.args.get('order_id', type=int)
            request_id = request.args.get('request_id', type=int)
            last_id = request.args.get('last_id', type=int)  # 保留 last_id 支持

            query = Message.query
            if order_id:
                query = query.filter_by(order_id=order_id)
            if request_id:
                query = query.filter_by(request_id=request_id)
            if last_id:
                query = query.filter(Message.id > last_id)

            msgs = query.order_by(Message.created_at.asc()).all()
            return jsonify({'success': True, 'data': [m.to_dict() for m in msgs]}), 200

    except Exception as e:
        app.logger.exception(f"消息接口错误: {e}")
        return jsonify({'success': False, 'message': '消息操作失败', 'error': str(e)}), 500
    
if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)
