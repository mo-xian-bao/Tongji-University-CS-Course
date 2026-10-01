from flask import Blueprint
from zoneinfo import ZoneInfo
from datetime import datetime, timedelta,timezone

from auxiliary_function import token_required,request, jsonify, g,decode_jwt
from Models import Restaurant, Table, Review, ReviewLike
from app_init import db
from db_exe import (
    create_restaurant, update_restaurant, get_restaurant_by_user_id,
    check_table_availability_for_reservation,create_broadcast, list_broadcasts, update_broadcast, delete_broadcast, get_broadcast_detail,
    create_coupon_notification,unfollow_restaurant, follow_restaurant, get_follow_status)

restaurant_bp = Blueprint('restaurant', __name__, url_prefix='/api/restaurant')
restaurants_bp = Blueprint('restaurants', __name__, url_prefix='/api/restaurants')

# 餐厅信息API
@restaurant_bp.route('', methods=['POST'])
@restaurant_bp.route('/', methods=['POST'])
@token_required
def create_restaurant_api():
    """创建餐厅信息"""
    try:
        data = request.get_json()
        current_user = g.current_user
        
        name = data.get('name', '').strip()
        address = data.get('address', '').strip()
        phone = data.get('phone', '').strip()
        opening_hours = data.get('opening_hours', '').strip()
        notice = data.get('notice', '').strip()
        avatar_url = data.get('avatar_url', '').strip()

        if not all([name, address, phone, opening_hours]):
            return jsonify({
                'success': False,
                'message': '请填写完整信息'
            }), 400

        # 直接调用函数，不要嵌套内部函数
        dict_return, status_code = create_restaurant(
            current_user.id, name, address, phone, 
            opening_hours, notice, avatar_url
        )
        return jsonify(dict_return), status_code

    except Exception as e:
        db.session.rollback()
        return jsonify({
            'success': False,
            'message': '创建餐厅失败，请稍后重试',
            'error': str(e)
        }), 500

        


@restaurant_bp.route('/<int:restaurant_id>', methods=['PUT'])
@token_required
def update_restaurant_api(restaurant_id):
    """更新餐厅信息"""
    try:
        data = request.get_json()
        current_user = g.current_user

        name = data.get('name')
        address = data.get('address')
        phone = data.get('phone')
        opening_hours = data.get('opening_hours')
        notice = data.get('notice')
        avatar_url = data.get('avatar_url')

        # 检查餐厅是否存在和权限
        rest = Restaurant.query.get(restaurant_id)
        if not rest:
            return jsonify({'success': False, 'message': '餐厅不存在'}), 404
        if rest.user_id != current_user.id:
            return jsonify({'success': False, 'message': '无权修改该餐厅'}), 403

        # 直接调用更新函数
        dict_return, status_code = update_restaurant(restaurant_id, name, address, phone, opening_hours, notice, avatar_url)
        return jsonify(dict_return), status_code

    except Exception as e:
        db.session.rollback()
        return jsonify({
            'success': False,
            'message': '更新餐厅信息失败，请稍后重试',
            'error': str(e)
        }), 500


@restaurant_bp.route('/<int:restaurant_id>/status', methods=['GET'])
@token_required
def get_restaurant_status_api(restaurant_id):
    """查询餐厅营业状态（仅商家本人）"""
    try:
        current_user = g.current_user

        restaurant = Restaurant.query.get(restaurant_id)
        if not restaurant:
            return jsonify({'success': False, 'message': '餐厅不存在'}), 404
        if restaurant.user_id != current_user.id:
            return jsonify({'success': False, 'message': '无权访问该餐厅'}), 403

        return jsonify({
            'success': True,
            'message': '获取营业状态成功',
            'data': {
                'restaurant_id': restaurant.id,
                'is_open': bool(restaurant.is_open)
            }
        }), 200

    except Exception as e:
        return jsonify({
            'success': False,
            'message': '获取营业状态失败，请稍后重试',
            'error': str(e)
        }), 500


@restaurant_bp.route('/<int:restaurant_id>/status', methods=['PATCH', 'PUT'])
@token_required
def set_restaurant_status_api(restaurant_id):
    """设置/切换餐厅营业状态（仅商家本人）

    Body:
    - is_open: bool（可选；不传则切换当前状态）
    """
    try:
        current_user = g.current_user
        data = request.get_json() or {}

        restaurant = Restaurant.query.get(restaurant_id)
        if not restaurant:
            return jsonify({'success': False, 'message': '餐厅不存在'}), 404
        if restaurant.user_id != current_user.id:
            return jsonify({'success': False, 'message': '无权修改该餐厅'}), 403

        if 'is_open' in data:
            restaurant.is_open = bool(data.get('is_open'))
        else:
            restaurant.is_open = not bool(restaurant.is_open)

        restaurant.updated_at = datetime.utcnow()
        db.session.commit()

        return jsonify({
            'success': True,
            'message': '营业状态更新成功',
            'data': {
                'restaurant_id': restaurant.id,
                'is_open': bool(restaurant.is_open)
            }
        }), 200

    except Exception as e:
        db.session.rollback()
        return jsonify({
            'success': False,
            'message': '营业状态更新失败，请稍后重试',
            'error': str(e)
        }), 500


@restaurant_bp.route('/user/<int:user_id>', methods=['GET'])
def get_restaurant_by_user_id_api(user_id):
    """根据用户ID获取餐厅信息"""
    try:
        dict_return, status_code = get_restaurant_by_user_id(user_id)
        return jsonify(dict_return), status_code

    except Exception as e:
        return jsonify({
            'success': False,
            'message': '获取餐厅信息失败，请稍后重试',
            'error': str(e)
        }), 500

@restaurants_bp.route('', methods=['GET'])
@restaurants_bp.route('/', methods=['GET'])
def get_all_restaurants():
    """获取所有餐厅信息"""
    try:
        # 获取所有餐厅
        restaurants = Restaurant.query.all()

        return jsonify({
            'success': True,
            'message': '获取餐厅列表成功',
            'data': {
                'restaurants': [restaurant.to_dict() for restaurant in restaurants]
            }
        }), 200

    except Exception as e:
        return jsonify({
            'success': False,
            'message': '获取餐厅列表失败，请稍后重试',
            'error': str(e)
        }), 500


@restaurants_bp.route('/<int:restaurant_id>', methods=['GET'])
def get_restaurant_by_id(restaurant_id):
    """根据餐厅ID获取单个餐厅信息"""
    try:
        # 获取指定餐厅
        restaurant = Restaurant.query.get(restaurant_id)

        if not restaurant:
            return jsonify({
                'success': False,
                'message': '餐厅不存在'
            }), 404

        return jsonify({
            'success': True,
            'message': '获取餐厅信息成功',
            'data': restaurant.to_dict()
        }), 200

    except Exception as e:
        return jsonify({
            'success': False,
            'message': '获取餐厅信息失败，请稍后重试',
            'error': str(e)
        }), 500
    
@restaurant_bp.route('/<int:restaurant_id>/tables', methods=['GET'])
def get_restaurant_tables_public(restaurant_id):
    """公开API: 获取指定餐厅的桌位列表（用于顾客选择桌位）"""
    try:
        # 验证餐厅是否存在
        restaurant = Restaurant.query.get(restaurant_id)
        if not restaurant:
            return jsonify({
                'message': '餐厅不存在',
                'success': False
            }), 404
        
        # 获取该餐厅的所有桌位
        tables = Table.query.filter_by(restaurant_id=restaurant_id).all()
        
        return jsonify({
            'tables': [table.to_dict() for table in tables],
            'success': True
        }), 200
        
    except Exception as e:
        print(f"获取餐厅桌位列表失败: {e}")
        import traceback
        traceback.print_exc()
        return jsonify({
            'message': f'服务器错误: {str(e)}',
            'success': False
        }), 500

@restaurant_bp.route('/<int:restaurant_id>/broadcasts', methods=['POST'])
def create_restaurant_broadcast(restaurant_id):
    try:
        data = request.get_json() or {}
        response, status_code = create_broadcast(
            restaurant_id=restaurant_id,
            title=data.get('title'),
            content=data.get('content'),
            start_time=data.get('start_time'),
            end_time=data.get('end_time'),
            is_active=data.get('is_active', True)
        )
        return jsonify(response), status_code
    except Exception as exc:
        db.session.rollback()
        return jsonify({'success': False, 'message': '创建广播失败', 'error': str(exc)}), 500


@restaurant_bp.route('/<int:restaurant_id>/coupons', methods=['POST'])
@token_required
def create_coupon_broadcast(restaurant_id):
    try:
        current_user = g.current_user
        if current_user.usertype != 1:
            return jsonify({'success': False, 'message': '只有商家可以推送优惠券'}), 403

        restaurant = Restaurant.query.filter_by(id=restaurant_id, user_id=current_user.id).first()
        if not restaurant:
            return jsonify({'success': False, 'message': '无法访问该餐厅或餐厅不存在'}), 404

        data = request.get_json() or {}
        response, status_code = create_coupon_notification(
            restaurant_id=restaurant_id,
            title=data.get('title'),
            description=data.get('description'),
            discount_type=data.get('discount_type'),
            amount=data.get('amount'),
            min_spend=data.get('min_spend'),
            valid_from=data.get('valid_from'),
            valid_to=data.get('valid_to'),
            total_quantity=data.get('total_quantity'),
            extra_data=data.get('extra_data')
        )
        return jsonify(response), status_code
    except Exception as exc:
        db.session.rollback()
        return jsonify({'success': False, 'message': '推送优惠券失败', 'error': str(exc)}), 500


@restaurant_bp.route('/broadcasts', methods=['GET'])
def get_restaurant_broadcasts():
    try:
        restaurant_id = request.args.get('restaurant_id', type=int)
        include_inactive = request.args.get('include_inactive', 'false').lower() == 'true'
        page = request.args.get('page', default=1, type=int)
        per_page = request.args.get('per_page', default=20, type=int)
        response, status_code = list_broadcasts(
            restaurant_id=restaurant_id,
            include_inactive=include_inactive,
            page=page,
            per_page=per_page
        )
        return jsonify(response), status_code
    except Exception as exc:
        return jsonify({'success': False, 'message': '获取广播信息失败', 'error': str(exc)}), 500


@restaurant_bp.route('/<int:restaurant_id>/broadcasts/<int:broadcast_id>', methods=['PATCH', 'PUT'])
def modify_restaurant_broadcast(restaurant_id, broadcast_id):
    try:
        data = request.get_json() or {}
        response, status_code = update_broadcast(
            broadcast_id=broadcast_id,
            restaurant_id=restaurant_id,
            data=data
        )
        return jsonify(response), status_code
    except Exception as exc:
        db.session.rollback()
        return jsonify({'success': False, 'message': '更新广播失败', 'error': str(exc)}), 500


@restaurant_bp.route('/<int:restaurant_id>/broadcasts/<int:broadcast_id>', methods=['DELETE'])
def remove_restaurant_broadcast(restaurant_id, broadcast_id):
    try:
        response, status_code = delete_broadcast(broadcast_id=broadcast_id, restaurant_id=restaurant_id)
        return jsonify(response), status_code
    except Exception as exc:
        db.session.rollback()
        return jsonify({'success': False, 'message': '删除广播失败', 'error': str(exc)}), 500


@restaurant_bp.route('/broadcasts/<int:broadcast_id>', methods=['GET'])
def fetch_broadcast_detail(broadcast_id):
    try:
        response, status_code = get_broadcast_detail(broadcast_id)
        return jsonify(response), status_code
    except Exception as exc:
        return jsonify({'success': False, 'message': '获取广播详情失败', 'error': str(exc)}), 500


@restaurants_bp.route('/<int:restaurant_id>/follow', methods=['GET', 'POST', 'DELETE'])
@token_required
def handle_restaurant_follow(restaurant_id):
    try:
        user_id = g.current_user.id
        if request.method == 'GET':
            response, status_code = get_follow_status(user_id, restaurant_id)
        elif request.method == 'POST':
            response, status_code = follow_restaurant(user_id, restaurant_id)
        else:
            response, status_code = unfollow_restaurant(user_id, restaurant_id)
        return jsonify(response), status_code
    except Exception as exc:
        db.session.rollback()
        return jsonify({'success': False, 'message': '关注操作失败', 'error': str(exc)}), 500

@restaurant_bp.route('/<int:restaurant_id>/tables/available', methods=['GET'])
@token_required
def get_available_tables_for_reservation(restaurant_id):
    """
    获取指定时段可用的桌位列表
    
    Query参数:
    - reserved_time: 预约时间 (ISO格式)
    - customer_count: 用餐人数
    - duration: 预计用餐时长（分钟，默认120）
    """
    try:
        reserved_time_str = request.args.get('reserved_time')
        customer_count = request.args.get('customer_count', 1, type=int)
        duration = request.args.get('duration', 120, type=int)
        time_zone = request.args.get('timezone')
        time_zone = ZoneInfo(time_zone) if time_zone else None

        # 验证餐厅是否存在
        restaurant = Restaurant.query.get(restaurant_id)
        if not restaurant:
            return jsonify({'success': False, 'message': '餐厅不存在'}), 404
        
        # 获取该餐厅的所有桌位
        tables = Table.query.filter_by(restaurant_id=restaurant_id).all()
        
        result = []
        
        for table in tables:
            table_data = {
                'id': table.id,
                'table_number': table.table_number,
                'capacity': table.capacity,
                'table_type': table.table_type,
                'description': table.description,
                'status': table.status
            }
            
            if reserved_time_str:
                # 有指定预约时间，检查该时段可用性
                try:
                    reserved_time = datetime.fromisoformat(reserved_time_str.replace('Z', '')).replace(tzinfo=time_zone).astimezone(timezone.utc)
                    if reserved_time.tzinfo is not None:
                        reserved_time = reserved_time.replace(tzinfo=None)
                    reserved_end_time = reserved_time + timedelta(minutes=duration)
                    
                    is_available, available_seats = check_table_availability_for_reservation(
                        table.id, reserved_time, reserved_end_time, customer_count
                    )
                    
                    table_data['is_available'] = is_available
                    table_data['available_seats'] = available_seats
                    table_data['can_accommodate'] = is_available
                except ValueError:
                    table_data['is_available'] = False
                    table_data['available_seats'] = 0
                    table_data['can_accommodate'] = False
            else:
                # 没有指定预约时间，返回当前状态
                current_occupancy = table.get_current_occupancy() if hasattr(table, 'get_current_occupancy') else 0
                realtime_status = table.get_realtime_status() if hasattr(table, 'get_realtime_status') else table.status
                if getattr(table, 'table_type', None) == 'private':
                    available_seats = table.capacity if realtime_status == 'available' else 0
                else:
                    available_seats = table.capacity - current_occupancy
                table_data['status'] = realtime_status
                table_data['is_available'] = realtime_status == 'available'
                table_data['available_seats'] = available_seats
                table_data['can_accommodate'] = available_seats >= customer_count
            
            result.append(table_data)
        
        return jsonify({
            'success': True,
            'data': {
                'tables': result
            }
        })
        
    except Exception as e:
        print(f"获取可用桌位失败: {e}")
        return jsonify({'success': False, 'message': '获取可用桌位失败', 'error': str(e)}), 500


@restaurant_bp.route('/<int:restaurant_id>/available-slots', methods=['GET'])
@token_required
def get_available_time_slots(restaurant_id):
    """
    获取餐厅可预约的时间段
    
    Query参数:
    - date: 日期 (YYYY-MM-DD格式，默认今天)
    - days: 获取多少天的时段（默认7天）
    """
    try:
        date_str = request.args.get('date')
        days = request.args.get('days', 7, type=int)
        time_zone = request.args.get('timezone')
        time_zone = ZoneInfo(time_zone) if time_zone else None
        # 验证餐厅是否存在
        restaurant = Restaurant.query.get(restaurant_id)
        if not restaurant:
            return jsonify({'success': False, 'message': '餐厅不存在'}), 404
        
        # 解析营业时间（注意：Restaurant模型中的字段名是 opening_hours）
        business_hours = restaurant.opening_hours or '09:00-21:00'
        try:
            open_time_str, close_time_str = business_hours.split('-')
            open_hour, open_minute = map(int, open_time_str.split(':'))
            close_hour, close_minute = map(int, close_time_str.split(':'))
        except:
            open_hour, open_minute = 9, 0
            close_hour, close_minute = 21, 0
        
        # 确定起始日期
        if date_str:
            try:
                start_date = datetime.strptime(date_str, '%Y-%m-%d')
                start_date = start_date.replace(tzinfo=time_zone) if time_zone else start_date
            except:
                start_date = datetime.now(time_zone).date()if time_zone else datetime.now()
        else:
            start_date = datetime.now(time_zone).date()if time_zone else datetime.now()
        
        now = datetime.now(time_zone) if time_zone else datetime.now()
        min_advance = timedelta(minutes=30)
        
        result = []
        
        for day_offset in range(days):
            current_date = start_date + timedelta(days=day_offset)
            day_slots = []
            
            # 生成当天的时间段（每30分钟一个）
            current_time = datetime.combine(current_date, datetime.min.time().replace(hour=open_hour, minute=open_minute))
            end_time = datetime.combine(current_date, datetime.min.time().replace(hour=close_hour, minute=close_minute))
            current_time = current_time.replace(tzinfo=time_zone) if time_zone else current_date
            end_time = end_time.replace(tzinfo=time_zone) if time_zone else end_time
            
            while current_time < end_time:
                # 检查是否在最小提前量之后
                if current_time > now + min_advance:
                    day_slots.append({
                        'time': current_time.strftime('%H:%M'),
                        'datetime': current_time.isoformat(),
                        'available': True  # 这里可以进一步检查该时段是否还有可用桌位
                    })
                current_time += timedelta(minutes=30)
            
            result.append({
                'date': current_date.isoformat(),
                'day_of_week': ['周一', '周二', '周三', '周四', '周五', '周六', '周日'][current_date.weekday()],
                'slots': day_slots
            })
        
        return jsonify({
            'success': True,
            'data': {
                'business_hours': business_hours,
                'available_days': result
            }
        })
        
    except Exception as e:
        print(f"获取可预约时段失败: {e}")
        return jsonify({'success': False, 'message': '获取可预约时段失败', 'error': str(e)}), 500

@restaurant_bp.route('/<int:restaurant_id>/reviews', methods=['GET'])
def get_restaurant_reviews(restaurant_id):
    try:
        page = int(request.args.get('page', 1))
        per_page = int(request.args.get('per_page', 20))

        # 公开页面仅显示审核通过且未被隐藏/删除的评论
        query = Review.query.filter_by(restaurant_id=restaurant_id, status='normal', review_status='approved').order_by(Review.created_at.desc())
        total = query.count()
        items = query.offset((page-1)*per_page).limit(per_page).all()

        # 可选地识别当前用户，若存在则返回该用户对每条评论是否已点赞
        auth = request.headers.get('Authorization', '')
        user_id = None
        if auth.startswith('Bearer '):
            token = auth.split(' ', 1)[1].strip()
            payload = decode_jwt(token)
            if payload:
                user_id = payload.get('sub')

        reviews_list = []
        for r in items:
            d = r.to_dict()
            try:
                d['is_liked'] = False
                if user_id is not None:
                    # sub may be string; convert to int when possible
                    try:
                        uid = int(user_id)
                    except Exception:
                        uid = None
                    if uid:
                        exists = ReviewLike.query.filter_by(review_id=r.id, user_id=uid).first()
                        d['is_liked'] = bool(exists)
            except Exception:
                d['is_liked'] = False
            reviews_list.append(d)

        return jsonify({'success': True, 'data': {'reviews': reviews_list, 'total': total}}), 200
    except Exception as e:
        print(f"获取餐厅评价失败: {e}")
        return jsonify({'success': False, 'message': '获取评价失败', 'error': str(e)}), 500
