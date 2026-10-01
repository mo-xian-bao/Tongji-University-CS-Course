from flask import Blueprint
import os
import uuid
from werkzeug.utils import secure_filename
from datetime import datetime,timezone
from sqlalchemy import and_

from auxiliary_function import token_required,request, jsonify, g, allowed_file,data_list,data_text
from Models import SupportTicket
from app_init import db

support_bp = Blueprint('support', __name__, url_prefix='/api/support')

@support_bp.route('/tickets/<int:ticket_id>', methods=['GET'])
@token_required
def get_support_ticket(ticket_id):
    """获取单个工单详情（仅限工单所属用户或客服/管理员访问）"""
    ticket = SupportTicket.query.get(ticket_id)
    if not ticket:
        return jsonify({'success': False, 'message': '未找到工单'}), 404

    # 允许用户查看自己的工单，客服/管理员也可查看（简单实现：usertype 0/100）
    user = g.current_user
    if ticket.user_id != user.id and user.usertype not in (0, 100):
        return jsonify({'success': False, 'message': '无权查看此工单'}), 403

    return jsonify({'success': True, 'data': ticket.to_dict()}), 200


@support_bp.route('/tickets/<int:ticket_id>', methods=['PUT'])
@token_required
def update_support_ticket(ticket_id):
    """更新工单（例如更新状态）。仅允许客服/管理员操作。"""
    ticket = SupportTicket.query.get(ticket_id)
    if not ticket:
        return jsonify({'success': False, 'message': '未找到工单'}), 404

    user = g.current_user
    payload = request.get_json() or {}
    status = payload.get('status')
    rating = payload.get('rating')
    rating_comment = payload.get('rating_comment')

    # 如果是客服/管理员，允许更新任意字段（状态/指派/评分）
    if getattr(user, 'usertype', None) in (0, 100):
        if status:
            ticket.status = status
        if status == 'in_process' or status == 'resolved':
            ticket.assigned_cs_id = user.id
        if rating is not None:
            try:
                ticket.rating = int(rating)
            except Exception:
                ticket.rating = None
        if rating_comment is not None:
            ticket.rating_comment = rating_comment

        ticket.updated_at = datetime.utcnow()
        db.session.commit()
        return jsonify({'success': True, 'message': '更新成功', 'data': ticket.to_dict()}), 200

    # 非客服：仅允许工单发起人对自己的工单进行有限操作（关闭/重新打开/评分）
    if ticket.user_id != user.id:
        return jsonify({'success': False, 'message': '无权限更新工单'}), 403

    # 允许用户关闭或重新打开工单
    if status in ('closed', 'open'):
        ticket.status = status

    # 仅当工单处于 resolved 时允许用户提交评分
    if rating is not None:
        if ticket.status != 'resolved':
            return jsonify({'success': False, 'message': '仅可对已解决工单进行评分'}), 400
        try:
            ticket.rating = int(rating)
        except Exception:
            ticket.rating = None
        if rating_comment is not None:
            ticket.rating_comment = rating_comment

    ticket.updated_at = datetime.utcnow()
    db.session.commit()
    return jsonify({'success': True, 'message': '更新成功', 'data': ticket.to_dict()}), 200


@support_bp.route('/tickets', methods=['GET', 'POST'])
@token_required
def support_tickets_api():
    """用户创建工单或列出当前用户的工单"""
    user = g.current_user
    if request.method == 'POST':
        # 支持 JSON 请求，其中可以包含 attachments: [url1, url2]
        payload = request.get_json() or {}
        ticket_type = payload.get('ticket_type')
        subject = payload.get('subject')
        content = payload.get('content')
        order_id = payload.get('order_id')
        attachments = payload.get('attachments') or []

        if not subject or not content:
            return jsonify({'success': False, 'message': '标题和描述为必填字段'}), 400

        # 简单验证 attachments 为列表
        if attachments and not isinstance(attachments, list):
            return jsonify({'success': False, 'message': 'attachments 必须为数组'}), 400

        ticket_number = SupportTicket.generate_ticket_number()
        ticket = SupportTicket(
            ticket_number=ticket_number,
            user_id=user.id,
            ticket_type=ticket_type or 'general',
            subject=subject,
            content=content,
            order_id=order_id,
            status='open',
            attachments=attachments
        )
        db.session.add(ticket)
        db.session.commit()

        return jsonify({'success': True, 'message': '工单创建成功', 'data': ticket.to_dict()}), 201

    # GET: 返回当前用户的工单列表
    tickets = SupportTicket.query.filter_by(user_id=g.current_user.id).order_by(SupportTicket.created_at.desc()).all()
    return jsonify({'success': True, 'data': [t.to_dict() for t in tickets]}), 200


@support_bp.route('/upload', methods=['POST'])
@token_required
def support_upload():
    """接收前端上传的文件（可多文件），保存到 static/uploads/support/ 并返回 URL 列表"""
    # 使用 request.files.getlist('files') 以支持多文件上传
    files = request.files.getlist('files') if request.files else []
    if not files:
        return jsonify({'success': False, 'message': '未检测到上传文件（字段名请使用 files）'}), 400

    # 限制：最多 5 个文件，每个文件最大 5MB
    MAX_FILES = 5
    MAX_SIZE = 5 * 1024 * 1024
    if len(files) > MAX_FILES:
        files = files[:MAX_FILES]

    saved = []
    support_dir = os.path.join(os.path.dirname(__file__), 'static', 'uploads', 'support')
    os.makedirs(support_dir, exist_ok=True)

    for f in files:
        if not f or f.filename == '':
            continue
        if not allowed_file(f.filename):
            # 返回信息中包含跳过原因
            saved.append({'name': f.filename, 'success': False, 'message': '不支持的文件类型'})
            continue

        # 读取内容以获得大小（安全性：受 MAX_SIZE 限制）
        try:
            content = f.read()
            size = len(content)
        except Exception:
            saved.append({'name': f.filename, 'success': False, 'message': '读取文件失败'})
            continue

        if size == 0:
            saved.append({'name': f.filename, 'success': False, 'message': '空文件'})
            continue
        if size > MAX_SIZE:
            saved.append({'name': f.filename, 'success': False, 'message': '文件超过大小限制 5MB'})
            continue

        filename = secure_filename(f.filename)
        ext = filename.rsplit('.', 1)[1].lower() if '.' in filename else ''
        unique_name = f"{uuid.uuid4().hex}.{ext}" if ext else uuid.uuid4().hex
        save_path = os.path.join(support_dir, unique_name)
        try:
            # 写入文件二进制
            with open(save_path, 'wb') as out_f:
                out_f.write(content)
            host = request.host_url.rstrip('/')
            url = f"{host}/static/uploads/support/{unique_name}"
            saved.append({'name': f.filename, 'success': True, 'url': url})
        except Exception as e:
            saved.append({'name': f.filename, 'success': False, 'message': str(e)})
        finally:
            try:
                # reset stream for safety
                f.stream.seek(0)
            except Exception:
                pass

    # 返回每个文件的处理结果（name, success, url/message）
    return jsonify({'success': True, 'files': saved}), 200

@support_bp.route('/get_tickets', methods=['GET'])
@token_required
def support_get_tickets():
    """返回仪表盘使用的数据：
    - open: 所有处于 open 状态的工单（未分配/待受理）
    - my_in_progress: 当前登录客服（assigned_cs_id==user.id）且 status=='in_progress' 的工单
    - my_today_processed: 当前登录客服在当天变为 resolved/closed 的工单（基于 updated_at）
    """
    try:
        user = g.current_user
        # 所有 open 工单
        open_q = SupportTicket.query.filter_by(status='open').order_by(SupportTicket.created_at.desc()).all()
        open_list = [t.to_dict() for t in open_q]

        my_in_progress_list = []
        my_today_processed_list = []

        # 如果是客服，返回对应 assigned 工单；否则返回空数组
        if user.usertype == 100 :
            # 未处理（in_progress）
            my_list =  SupportTicket.query.filter_by(assigned_cs_id=4)
            my_in_progress_q = my_list.filter_by(status='in_process').order_by(SupportTicket.updated_at.desc()).all()
            my_in_progress_list = [t.to_dict() for t in my_in_progress_q]

            # 当天已处理（resolved or closed）——基于 updated_at 在当天内
            today = datetime.utcnow().date()
            start = datetime.combine(today, datetime.min.time())
            end = datetime.combine(today, datetime.max.time())
            my_today_q = my_list.filter(
                SupportTicket.status.in_(['resolved', 'closed']),
                SupportTicket.updated_at >= start,
                SupportTicket.updated_at <= end
            ).order_by(SupportTicket.updated_at.desc()).all()
            my_today_processed_list = [t.to_dict() for t in my_today_q]

        return jsonify({'success': True, 'data': {
            'open': open_list,
            'my_in_progress': my_in_progress_list,
            'my_today_processed': my_today_processed_list
        }}), 200
    except Exception as e:
        app_init = None
        try:
            from app_init import app as _a
            app_init = _a
            app_init.logger.exception(f"support_dashboard error: {e}")
        except Exception:
            pass
        return jsonify({'success': False, 'message': '获取仪表盘数据失败', 'error': str(e)}), 500

@support_bp.route('/get_alltickets', methods=['GET'])
@token_required
def support_get_alltickets():
    """返回工单列表使用的数据：
    """
    try:
        user = g.current_user
        # 所有 open 工单
        open_q = SupportTicket.query.filter_by(status='open').order_by(SupportTicket.created_at.desc()).all()
        open_list = [t.to_dict() for t in open_q]

        my_in_progress_list = []
        my_today_processed_list = []

        # 如果是客服，返回对应 assigned 工单；否则返回空数组
        if user.usertype == 100 :
            # 未处理（in_progress）
            my_list =  SupportTicket.query.filter_by(assigned_cs_id=4)
            my_in_progress_q = my_list.filter_by(status='in_process').order_by(SupportTicket.updated_at.desc()).all()
            my_in_progress_list = [t.to_dict() for t in my_in_progress_q]

            # 当天已处理（resolved or closed）——基于 updated_at 在当天内
            today = datetime.utcnow().date()
            start = datetime.combine(today, datetime.min.time())
            end = datetime.combine(today, datetime.max.time())
            my_today_q = my_list.filter(
                SupportTicket.status.in_(['resolved', 'closed']),
                SupportTicket.updated_at >= start,
                SupportTicket.updated_at <= end
            ).order_by(SupportTicket.updated_at.desc()).all()
            my_today_processed_list = [t.to_dict() for t in my_today_q]

        return jsonify({'success': True, 'data': 
            open_list+
            my_in_progress_list+
            my_today_processed_list
        }), 200
    except Exception as e:
        app_init = None
        try:
            from app_init import app as _a
            app_init = _a
            app_init.logger.exception(f"support_dashboard error: {e}")
        except Exception:
            pass
        return jsonify({'success': False, 'message': '获取仪表盘数据失败', 'error': str(e)}), 500

@support_bp.route('/tickets/<int:ticket_id>/internal_notes', methods=['POST'])
@token_required
def add_internal_note(ticket_id):
    """添加仅客服可见的内部备注（保存到 ticket.internal_notes）。"""
    ticket = SupportTicket.query.get(ticket_id)
    if not ticket:
        return jsonify({'success': False, 'message': '未找到工单'}), 404

    user = g.current_user
    if getattr(user, 'usertype', None) not in (0, 100):
        return jsonify({'success': False, 'message': '仅客服可添加内部备注'}), 403

    payload = request.get_json() or {}
    text = payload.get('text')
    if not text or not text.strip():
        return jsonify({'success': False, 'message': '备注内容不能为空'}), 400

    note = {
        'text': text.strip(),
        'created_at': datetime.utcnow().isoformat(),
        'author_id': user.id,
        'author_name': user.username
    }
    if ticket.internal_notes:
        notes = data_list(ticket.internal_notes)
        print(notes)
    else:
        notes = []
    # 新的备注放前面
    notes.insert(0, note)
    ticket.internal_notes = data_text(notes)
    ticket.updated_at = datetime.utcnow()
    db.session.commit()

    return jsonify({'success': True, 'message': '内部备注已添加', 'note': note}), 201


@support_bp.route('/tickets/<int:ticket_id>/reply', methods=['POST'])
@token_required
def add_ticket_reply(ticket_id):
    """客服发送回复（或系统/用户回复），保存到 ticket.replies。前端会将 {text, from, created_at} 传过来，created_at 可选。"""
    ticket = SupportTicket.query.get(ticket_id)
    if not ticket:
        return jsonify({'success': False, 'message': '未找到工单'}), 404

    user = g.current_user
    # 允许客服/管理员或工单发起人发送回复
    payload = request.get_json() or {}

    print(payload)
    text = payload.get('text')
    sender = payload.get('from') or (getattr(user, 'username', '客服'))
    if not text or not text.strip():
        return jsonify({'success': False, 'message': '回复内容不能为空'}), 400

    reply = {
        'text': text.strip(),
        'from': sender,
        'created_at': datetime.utcnow().replace(tzinfo=timezone.utc).isoformat(),
        'author_id': user.id,
        'author_name': user.username
    }
    if ticket.replies:
        replies = ticket.replies
        replies = data_list(replies)
    else:
        replies = []
    replies.insert(0, reply)
    ticket.replies = data_text(replies)
    ticket.updated_at = datetime.utcnow()
    db.session.commit()

    return jsonify({'success': True, 'message': '回复已保存', 'reply': reply}), 201

