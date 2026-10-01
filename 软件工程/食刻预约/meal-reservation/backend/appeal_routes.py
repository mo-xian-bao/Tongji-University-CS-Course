from flask import Blueprint, send_file
from werkzeug.security import check_password_hash
import os
import uuid

from auxiliary_function import (token_required,request, jsonify, g,
                    allowed_file, APPEAL_UPLOAD_FOLDER, BASE_DIR, ALLOWED_EXTENSIONS)
from Models import User, UserBan, UserAppeal, AppealAttachment
from app_init import db

appeal_bp = Blueprint('appeal', __name__, url_prefix='/api/appeal')
# 申诉相关API接口

@appeal_bp.route('/', methods=['POST'], strict_slashes=False)
def create_appeal():
    """用户提交申诉"""
    try:
        data = request.get_json()

        # 从请求中获取用户标识信息
        user_identifier = data.get('user_identifier')  # 用户名或手机号
        password = data.get('password')  # 用户密码（用于验证身份）

        if not user_identifier or not password:
            return jsonify({
                'success': False,
                'message': '请提供用户标识和密码'
            }), 400

        # 根据用户标识查找用户
        user = User.query.filter(
            (User.username == user_identifier) | (User.phone == user_identifier)
        ).first()

        if not user:
            return jsonify({
                'success': False,
                'message': '用户不存在'
            }), 400

        # 验证密码
        if not check_password_hash(user.password_hash, password):
            return jsonify({
                'success': False,
                'message': '密码错误'
            }), 401

        # 检查用户是否有活跃的封禁记录
        active_ban = UserBan.query.filter_by(user_id=user.id).filter(
            UserBan.status.in_(['banned', 'temporarily_banned'])
        ).order_by(UserBan.created_at.desc()).first()

        if not active_ban:
            return jsonify({
                'success': False,
                'message': '您当前没有被封禁，无需申诉'
            }), 400

        # 检查是否已有未处理的申诉
        existing_appeal = UserAppeal.query.filter_by(
            user_id=user.id,
            ban_id=active_ban.id
        ).filter(
            UserAppeal.status.in_(['pending', 'processing'])
        ).first()

        if existing_appeal:
            return jsonify({
                'success': False,
                'message': '您已有未处理的申诉，请耐心等待处理结果'
            }), 400

        # 验证必要字段
        appeal_reason = data.get('appeal_reason', '').strip()
        appeal_type = data.get('appeal_type', '').strip()
        contact_info = data.get('contact_info', '').strip()
        additional_info = data.get('additional_info', '').strip()

        if not appeal_reason:
            return jsonify({
                'success': False,
                'message': '申诉理由不能为空'
            }), 400

        if not appeal_type or appeal_type not in ['mistake_ban', 'punishment_too_heavy', 'evidence_provided', 'other']:
            return jsonify({
                'success': False,
                'message': '请选择正确的申诉类型'
            }), 400

        # 创建申诉记录
        appeal = UserAppeal(
            user_id=user.id,
            ban_id=active_ban.id,
            appeal_reason=appeal_reason,
            appeal_type=appeal_type,
            contact_info=contact_info,
            additional_info=additional_info
        )

        db.session.add(appeal)
        db.session.flush()  # 获取申诉ID

        # 处理附件上传
        attachments = data.get('attachments', [])
        for attachment_data in attachments:
            if isinstance(attachment_data, dict):
                file_name = attachment_data.get('file_name', '')
                file_path = attachment_data.get('file_path', '')
                file_size = attachment_data.get('file_size', 0)
                file_type = attachment_data.get('file_type', '')
                mime_type = attachment_data.get('mime_type', '')

                if all([file_name, file_path, file_size, file_type]):
                    attachment = AppealAttachment(
                        appeal_id=appeal.id,
                        file_name=file_name,
                        file_path=file_path,
                        file_size=file_size,
                        file_type=file_type,
                        mime_type=mime_type
                    )
                    db.session.add(attachment)

        db.session.commit()

        return jsonify({
            'success': True,
            'message': '申诉提交成功，请耐心等待处理结果',
            'data': appeal.to_dict()
        }), 201

    except Exception as e:
        db.session.rollback()
        return jsonify({
            'success': False,
            'message': f'申诉提交失败: {str(e)}'
        }), 500


@appeal_bp.route('/upload', methods=['POST'])
def upload_appeal_attachment():
    """上传申诉附件"""
    try:
        if 'file' not in request.files:
            return jsonify({
                'success': False,
                'message': '没有找到文件'
            }), 400

        file = request.files['file']
        if file.filename == '':
            return jsonify({
                'success': False,
                'message': '未选择文件'
            }), 400

        if not allowed_file(file.filename):
            return jsonify({
                'success': False,
                'message': f'不支持的文件类型，支持的类型: {", ".join(ALLOWED_EXTENSIONS)}'
            }), 400

        # 生成唯一文件名
        file_ext = file.filename.rsplit('.', 1)[1].lower()
        unique_filename = f"{uuid.uuid4().hex}.{file_ext}"
        file_path = os.path.join(APPEAL_UPLOAD_FOLDER, unique_filename)

        # 确保上传目录存在
        os.makedirs(APPEAL_UPLOAD_FOLDER, exist_ok=True)

        # 保存文件
        file.save(file_path)

        # 获取文件大小
        file_size = os.path.getsize(file_path)

        # 返回文件信息
        return jsonify({
            'success': True,
            'message': '文件上传成功',
            'data': {
                'file_name': file.filename,
                'file_path': os.path.relpath(file_path, BASE_DIR).replace('\\', '/'),
                'file_size': file_size,
                'file_type': file_ext,
                'mime_type': file.mimetype or 'application/octet-stream'
            }
        }), 200

    except Exception as e:
        return jsonify({
            'success': False,
            'message': f'文件上传失败: {str(e)}'
        }), 500


@appeal_bp.route('/user', methods=['GET'])
@token_required
def get_user_appeals():
    """获取用户自己的申诉列表"""
    try:
        current_user = g.current_user

        appeals = UserAppeal.query.filter_by(user_id=current_user.id).order_by(
            UserAppeal.created_at.desc()
        ).all()

        # 为每个申诉获取附件信息
        appeals_data = []
        for appeal in appeals:
            appeal_dict = appeal.to_dict()
            appeal_dict['attachments'] = [att.to_dict() for att in appeal.attachments]
            appeals_data.append(appeal_dict)

        return jsonify({
            'success': True,
            'message': '获取申诉列表成功',
            'data': appeals_data
        }), 200

    except Exception as e:
        return jsonify({
            'success': False,
            'message': f'获取申诉列表失败: {str(e)}'
        }), 500


@appeal_bp.route('/<int:appeal_id>', methods=['GET'])
@token_required
def get_appeal_detail(appeal_id):
    """获取申诉详情"""
    try:
        current_user = g.current_user
        appeal = UserAppeal.query.get(appeal_id)

        if not appeal:
            return jsonify({
                'success': False,
                'message': '申诉不存在'
            }), 404

        # 普通用户只能查看自己的申诉
        if current_user.usertype != 0 and appeal.user_id != current_user.id:
            return jsonify({
                'success': False,
                'message': '无权查看此申诉'
            }), 403

        appeal_data = appeal.to_dict()
        appeal_data['attachments'] = [att.to_dict() for att in appeal.attachments]

        return jsonify({
            'success': True,
            'message': '获取申诉详情成功',
            'data': appeal_data
        }), 200

    except Exception as e:
        return jsonify({
            'success': False,
            'message': f'获取申诉详情失败: {str(e)}'
        }), 500




@appeal_bp.route('/<int:attachment_id>/download', methods=['GET'])
@token_required
def download_appeal_attachment(attachment_id):
    """下载申诉附件"""
    try:
        current_user = g.current_user
        attachment = AppealAttachment.query.get(attachment_id)

        if not attachment or not attachment.is_active():
            return jsonify({
                'success': False,
                'message': '附件不存在或已被删除'
            }), 404

        appeal = attachment.appeal

        # 检查权限：用户只能下载自己申诉的附件，管理员可以下载所有附件
        if current_user.usertype != 0 and appeal.user_id != current_user.id:
            return jsonify({
                'success': False,
                'message': '无权下载此附件'
            }), 403

        # 构建文件路径
        file_path = os.path.join(BASE_DIR, attachment.file_path)

        if not os.path.exists(file_path):
            return jsonify({
                'success': False,
                'message': '文件不存在'
            }), 404

        return send_file(
            file_path,
            as_attachment=True,
            download_name=attachment.file_name
        )

    except Exception as e:
        return jsonify({
            'success': False,
            'message': f'下载附件失败: {str(e)}'
        }), 500
