"""Table helpers."""
from datetime import datetime, timedelta

from Models import db, Table, Order, Dish


def create_table(restaurant_id, table_number, capacity, table_type='shared', description=None):
    """创建桌位"""
    try:
        table = Table(
            restaurant_id=restaurant_id,
            table_number=table_number,
            capacity=capacity,
            table_type=table_type,
            description=description,
            status='available'
        )
        db.session.add(table)
        db.session.commit()
        return table
    except Exception as e:
        db.session.rollback()
        raise e


def update_table(table_id, **kwargs):
    """更新桌位信息"""
    try:
        table = Table.query.get(table_id)
        if not table:
            return None

        allowed_fields = ['table_number', 'capacity', 'table_type', 'status', 'description']
        for key, value in kwargs.items():
            if key in allowed_fields and hasattr(table, key):
                setattr(table, key, value)

        table.updated_at = datetime.utcnow()
        db.session.commit()
        return table
    except Exception as e:
        db.session.rollback()
        raise e


def delete_table(table_id):
    """删除桌位"""
    try:
        table = Table.query.get(table_id)
        if not table:
            return False

        db.session.delete(table)
        db.session.commit()
        return True
    except Exception as e:
        db.session.rollback()
        raise e


def get_restaurant_tables(restaurant_id):
    """获取餐厅所有桌位"""
    return Table.query.filter_by(restaurant_id=restaurant_id).all()


def get_available_tables(restaurant_id, capacity=None):
    """获取可用桌位"""
    query = Table.query.filter_by(restaurant_id=restaurant_id, status='available')
    if capacity:
        query = query.filter(Table.capacity >= capacity)
    return query.all()


def get_table_details(table_id):
    """获取桌位详情"""
    return Table.query.get(table_id)


def check_table_availability_for_reservation(table_id, reserved_time, reserved_end_time, customer_count):
    table = Table.query.get(table_id)
    if not table:
        return False, 0

    # 维护中直接不可预约
    if table.status == 'maintenance':
        return False, 0

    # 1) 预约订单冲突（你原来的逻辑）
    conflicting_orders = Order.query.filter(
        Order.table_id == table_id,
        Order.reservation_status.in_(['pending', 'confirmed', 'seated']),
        Order.reserved_time < reserved_end_time,
        Order.reserved_end_time > reserved_time
    ).all()

    # 2) 非预约堂食占用冲突：下单即占桌，status=pending/confirmed/dining 且没有 reserved_time
    default_non_reservation_duration_minutes = 120
    active_non_reservation_orders = Order.query.filter(
        Order.table_id == table_id,
        Order.status.in_(['pending', 'confirmed', 'dining']),
        Order.reserved_time.is_(None)
    ).all()

    active_non_reservation_occupancy = 0
    for order in active_non_reservation_orders:
        # 下单即占桌：pending/confirmed/dining 都以 order_time 作为起点
        start_time = order.order_time or order.confirmed_time or datetime.utcnow()
        end_time = start_time + timedelta(minutes=default_non_reservation_duration_minutes)

        # 与预约时段有重叠才算冲突
        if start_time < reserved_end_time and end_time > reserved_time:
            active_non_reservation_occupancy += order.customer_count

    # 独立桌：只要“有冲突预约”或“有占用冲突”就不可用
    if table.table_type == 'private':
        is_available = (len(conflicting_orders) == 0) and (active_non_reservation_occupancy == 0)
        return is_available, table.capacity if is_available else 0

    # 拼桌：预约占座 + 非预约占座一起扣
    occupied_seats = sum(o.customer_count for o in conflicting_orders) + active_non_reservation_occupancy
    available_seats = max(table.capacity - occupied_seats, 0)
    is_available = available_seats >= customer_count
    return is_available, available_seats
