from flask import Blueprint
from datetime import datetime
import os
from werkzeug.utils import secure_filename

from auxiliary_function import  token_required,request, jsonify, g, UPLOAD_FOLDER,allowed_file
from Models import User , UserInfo, Restaurant
from db_exe import list_followed_restaurants

from app_init import db

users_bp = Blueprint('users', __name__, url_prefix='/api/users')

@users_bp.route('/profile', methods=['GET'])
@token_required  # 使用装饰器而不是内部函数
def get_profile():
    """获取用户信息"""
    user = g.current_user
    return jsonify({
        'success': True,
        'message': '获取用户信息成功',
        'data': {
            'user': user.to_dict()
        }
    })


@users_bp.route('/<int:user_id>', methods=['GET'])
@token_required
def get_user_by_id(user_id):
    """根据用户ID获取用户信息"""
    try:
        user = User.query.get(user_id)
        
        if not user:
            return jsonify({
                'success': False,
                'message': '用户不存在'
            }), 404
        
        # 权限检查：管理员、商家（用于获取顾客信息）或用户自己可以访问
        current_user = g.current_user
        if current_user.usertype == 0 or current_user.usertype == 1 or current_user.id == user_id:
            return jsonify({
                'success': True,
                'data': user.to_dict()
            }), 200
        else:
            return jsonify({
                'success': False,
                'message': '无权访问此用户信息'
            }), 403
    
    except Exception as e:
        return jsonify({
            'success': False,
            'message': '获取用户信息失败',
            'error': str(e)
        }), 500




#登陆后的修改密码，用旧密码修改密码
@users_bp.route('/change-password', methods=['POST'])
@token_required
def change_password():
    """使用旧密码修改密码"""
    try:
        data = request.get_json()
        old_password = data.get('old_password', '').strip()
        new_password = data.get('new_password', '').strip()
        
        # 验证参数
        if not old_password or not new_password:
            return jsonify({
                'success': False,
                'message': '旧密码和新密码不能为空'
            }), 400
        
        # 验证新密码长度
        if len(new_password) < 6:
            return jsonify({
                'success': False,
                'message': '新密码长度至少为6位'
            }), 400
        
        # 验证旧密码是否正确
        if not g.current_user.check_password(old_password):
            return jsonify({
                'success': False,
                'message': '当前密码错误'
            }), 400
        
        # 检查新旧密码是否相同
        if old_password == new_password:
            return jsonify({
                'success': False,
                'message': '新密码不能与当前密码相同'
            }), 400
        
        # 更新密码
        g.current_user.set_password(new_password)
        g.current_user.updated_at = datetime.utcnow()
        db.session.commit()
        
        return jsonify({
            'success': True,
            'message': '密码修改成功'
        })
        
    except Exception as e:
        db.session.rollback()
        print(f"修改密码错误: {str(e)}")
        return jsonify({
            'success': False,
            'message': f'修改失败: {str(e)}'
        }), 500




@users_bp.route('/change-phone', methods=['POST'])
@token_required
def change_phone():
    """修改手机号"""
    try:
        data = request.get_json()
        new_phone = data.get('new_phone', '').strip()
        sms_code = data.get('sms_code', '').strip()
        
        # 验证参数
        if not new_phone or not sms_code:
            return jsonify({
                'success': False,
                'message': '手机号和验证码不能为空'
            }), 400
        
        # 验证手机号格式
        import re
        if not re.match(r'^1[3-9]\d{9}$', new_phone):
            return jsonify({
                'success': False,
                'message': '手机号格式不正确'
            }), 400
        
        # 检查新手机号是否已被使用
        existing_user = User.query.filter_by(phone=new_phone).first()
        if existing_user and existing_user.id != g.current_user.id:
            return jsonify({
                'success': False,
                'message': '该手机号已被其他用户使用'
            }), 400
        
        # 验证短信验证码
        from Models import SMSVerification
        verification = SMSVerification.query.filter_by(
            phone=new_phone,
            code=sms_code,
            purpose='change_phone',
            is_used=False
        ).order_by(SMSVerification.created_at.desc()).first()
        
        if not verification:
            return jsonify({
                'success': False,
                'message': '验证码错误或已失效'
            }), 400
        
        # 检查验证码是否过期
        if verification.is_expired():
            return jsonify({
                'success': False,
                'message': '验证码已过期'
            }), 400
        
        # 更新手机号
        g.current_user.phone = new_phone
        g.current_user.updated_at = datetime.utcnow()
        
        # 标记验证码为已使用
        verification.mark_as_used()
        
        db.session.commit()
        
        return jsonify({
            'success': True,
            'message': '手机号修改成功',
            'data': {
                'user': g.current_user.to_dict()
            }
        })
        
    except Exception as e:
        db.session.rollback()
        print(f"修改手机号错误: {str(e)}")
        return jsonify({
            'success': False,
            'message': f'修改失败: {str(e)}'
        }), 500


@users_bp.route('/update-profile', methods=['POST'])
@token_required
def update_profile():
    """更新用户个人信息"""
    try:
        username = request.form.get('username', '').strip()
        bio = request.form.get('bio', '').strip()
        birthday = request.form.get('birthday', '').strip()
        
        # 验证用户名
        if not username:
            return jsonify({
                'success': False,
                'message': '用户名不能为空'
            }), 400
        
        if len(username) < 2 or len(username) > 20:
            return jsonify({
                'success': False,
                'message': '用户名长度为2-20个字符'
            }), 400
        
        # 检查用户名是否被占用
        if username != g.current_user.username:
            existing_user = User.query.filter_by(username=username).first()
            if existing_user:
                return jsonify({
                    'success': False,
                    'message': '该用户名已被使用'
                }), 400
        
        # 获取或创建用户扩展信息
        user_info = g.current_user.user_info
        if not user_info:
            user_info = UserInfo(user_id=g.current_user.id)
            db.session.add(user_info)
            db.session.flush()  # 确保 user_info 被创建
        
        # 处理头像上传
        if 'avatar' in request.files:
            file = request.files['avatar']
            if file and allowed_file(file.filename):
                filename = secure_filename(f"user_{g.current_user.id}_{int(datetime.now().timestamp())}.{file.filename.rsplit('.', 1)[1].lower()}")
                filepath = os.path.join(UPLOAD_FOLDER, filename)
                file.save(filepath)
                # 保存相对路径，前端访问时加上服务器地址
                user_info.avatar_url = f"/static/uploads/avatar/{filename}"
        
        # 处理生日
        if birthday:
            try:
                from datetime import date
                user_info.birthday = datetime.strptime(birthday, '%Y-%m-%d').date()
            except ValueError:
                return jsonify({
                    'success': False,
                    'message': '生日格式不正确，应为 YYYY-MM-DD'
                }), 400
        
        # 更新用户信息
        g.current_user.username = username
        user_info.bio = bio
        user_info.updated_at = datetime.utcnow()
        g.current_user.updated_at = datetime.utcnow()
        
        db.session.commit()
        
        return jsonify({
            'success': True,
            'message': '更新成功',
            'data': {
                'user': g.current_user.to_dict()
            }
        })
        
    except Exception as e:
        db.session.rollback()
        print(f"更新用户信息错误: {str(e)}")
        import traceback
        traceback.print_exc()
        return jsonify({
            'success': False,
            'message': f'更新失败: {str(e)}'
        }), 500
    
@users_bp.route('/followed-restaurants', methods=['GET'])
@token_required
def fetch_followed_restaurants():
    try:
        response, status_code = list_followed_restaurants(g.current_user.id)
        return jsonify(response), status_code
    except Exception as exc:
        return jsonify({'success': False, 'message': '获取关注列表失败', 'error': str(exc)}), 500
    
@users_bp.route('/restaurant', methods=['GET'])
@token_required
def get_user_restaurant():
    """获取用户的餐厅信息"""
    try:
        user = g.current_user
        user_id = user.id

        # 在Restaurant数据库中查找对应的餐厅
        restaurant = Restaurant.query.filter_by(user_id=user_id).first()

        if not restaurant:
            return jsonify({
                'success': False,
                'message': '未找到餐厅信息',
                'data': {
                    'restaurant_id': None,
                    'restaurant_name': None
                }
            }), 404

        return jsonify({
            'success': True,
            'message': '获取餐厅信息成功',
            'data': {
                'restaurant_id': restaurant.id,
                'restaurant_name': restaurant.name
            }
        })

    except Exception as e:
        return jsonify({
            'success': False,
            'message': '获取餐厅信息失败',
            'error': str(e)
        }), 500


# ============ 系统通知接收 ============

@users_bp.route('/system-notifications', methods=['GET'])
@token_required
def get_user_system_notifications():
    """获取当前用户应该看到的系统通知"""
    try:
        from Models import SystemNotification
        import json
        
        current_user = g.current_user
        
        # 根据用户类型映射
        # usertype: 0=管理员, 1=商家, 2=普通用户
        user_type_map = {
            0: None,  # 管理员看不到用户通知
            1: 'merchants',  # 商家
            2: 'users'  # 普通用户
        }
        
        target_audiences = ['all']  # 所有用户都能看到'all'类型
        
        # 添加针对该用户类型的通知
        if current_user.usertype in user_type_map and user_type_map[current_user.usertype]:
            target_audiences.append(user_type_map[current_user.usertype])
        
        # 查询符合条件的所有通知
        notifications = SystemNotification.query.filter(
            SystemNotification.target_audience.in_(target_audiences)
        ).all()
        
        # 构建响应数据
        result = []
        for notification in notifications:
            n_dict = notification.to_dict()
            result.append(n_dict)
        
        return jsonify({
            'success': True,
            'data': result
        }), 200
        
    except Exception as e:
        return jsonify({
            'success': False,
            'message': f'获取系统通知失败: {str(e)}'
        }), 500
