from flask import Blueprint
from sqlalchemy import func

from auxiliary_function import token_required,request, jsonify, g
from Models import Restaurant, Table, Order
from datetime import datetime
from app_init import db

tables_bp = Blueprint('tables', __name__, url_prefix='/api/tables')

# ==================== 桌位管理 API ====================
@tables_bp.route('', methods=['GET'])
@token_required
def get_tables_list():
    """获取餐厅桌位列表"""
    try:
        user_id = g.current_user.id
        
        # 获取用户的餐厅信息
        restaurant = Restaurant.query.filter_by(user_id=user_id).first()
        
        if not restaurant:
            return jsonify({
                'message': '请先创建餐厅信息',
                'tables': [],
                'success': False
            }), 200  # 返回 200 但提示用户
        
        # 获取餐厅的所有桌位
        tables = Table.query.filter_by(restaurant_id=restaurant.id).all()
        return jsonify({
            'tables': [table.to_dict() for table in tables],
            'success': True
        }), 200
        
    except Exception as e:
        print(f"获取桌位列表失败: {e}")
        import traceback
        traceback.print_exc()
        return jsonify({
            'message': f'服务器错误: {str(e)}',
            'success': False
        }), 500


@tables_bp.route('', methods=['POST'])
@token_required
def add_new_table():
    """添加桌位"""
    try:
        data = request.get_json()
        user_id = g.current_user.id
        
        # 获取用户的餐厅信息
        restaurant = Restaurant.query.filter_by(user_id=user_id).first()
        
        if not restaurant:
            return jsonify({
                'message': '请先创建餐厅信息',
                'success': False
            }), 400
        
        # 创建桌位
        table = Table(
            restaurant_id=restaurant.id,
            table_number=data.get('table_number'),
            capacity=data.get('capacity'),
            table_type=data.get('table_type', 'shared'),
            description=data.get('description'),
            status='available'
        )
        
        db.session.add(table)
        db.session.commit()
        
        return jsonify({
            'message': '桌位添加成功',
            'table': table.to_dict(),
            'success': True
        }), 201
        
    except Exception as e:
        db.session.rollback()
        print(f"添加桌位失败: {e}")
        import traceback
        traceback.print_exc()
        return jsonify({
            'message': f'添加失败: {str(e)}',
            'success': False
        }), 500


@tables_bp.route('/<int:table_id>', methods=['PUT'])
@token_required
def update_table_info(table_id):
    """更新桌位信息"""
    try:
        data = request.get_json()
        table = Table.query.get(table_id)
        
        if not table:
            return jsonify({
                'message': '桌位不存在',
                'success': False
            }), 404
        
        # 更新字段
        if 'table_number' in data:
            table.table_number = data['table_number']
        if 'capacity' in data:
            table.capacity = data['capacity']
        if 'table_type' in data:
            table.table_type = data['table_type']
        if 'status' in data:
            table.status = data['status']
        if 'description' in data:
            table.description = data['description']
        
        table.updated_at = datetime.utcnow()
        db.session.commit()
        
        return jsonify({
            'message': '桌位更新成功',
            'table': table.to_dict(),
            'success': True
        }), 200
        
    except Exception as e:
        db.session.rollback()
        print(f"更新桌位失败: {e}")
        return jsonify({
            'message': f'更新失败: {str(e)}',
            'success': False
        }), 500


@tables_bp.route('/<int:table_id>', methods=['DELETE'])
@token_required
def delete_table_by_id(table_id):
    """删除桌位"""
    try:
        table = Table.query.get(table_id)
        
        if not table:
            return jsonify({
                'message': '桌位不存在',
                'success': False
            }), 404
        
        db.session.delete(table)
        db.session.commit()
        
        return jsonify({
            'message': '桌位删除成功',
            'success': True
        }), 200
        
    except Exception as e:
        db.session.rollback()
        print(f"删除桌位失败: {e}")
        return jsonify({
            'message': f'删除失败: {str(e)}',
            'success': False
        }), 500

@tables_bp.route('/<int:table_id>', methods=['GET'])
@token_required
def get_table_detail(table_id):
    """获取单个桌位详情"""
    try:
        table = Table.query.get(table_id)
        
        if not table:
            return jsonify({
                'message': '桌位不存在',
                'success': False
            }), 404
        
        # 验证权限：确保该桌位属于当前用户的餐厅
        user_id = g.current_user.id
        restaurant = Restaurant.query.filter_by(user_id=user_id).first()
        
        if not restaurant or table.restaurant_id != restaurant.id:
            return jsonify({
                'message': '无权访问该桌位',
                'success': False
            }), 403
        
        # 获取该桌位的活动订单（可选）
        active_orders = Order.query.filter_by(
            table_id=table_id
        ).filter(
            Order.status.in_(['pending', 'confirmed', 'dining'])
        ).all()
        
        table_dict = table.to_dict()
        table_dict['active_orders'] = [order.to_dict() for order in active_orders]
        
        return jsonify({
            'table': table_dict,
            'success': True
        }), 200
        
    except Exception as e:
        print(f"获取桌位详情失败: {e}")
        import traceback
        traceback.print_exc()
        return jsonify({
            'message': f'服务器错误: {str(e)}',
            'success': False
        }), 500
