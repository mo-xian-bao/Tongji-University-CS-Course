"""Tables CRUD operations."""
from datetime import datetime

from Models import Order, Table, db
from utils import BadRequestError


def get_tables_list(current_user, restaurant):
    tables = Table.query.filter_by(restaurant_id=restaurant.id).all()
    return [t.to_dict() for t in tables]


def add_table(restaurant, data):
    table = Table(
        restaurant_id=restaurant.id,
        table_number=data.get("table_number"),
        capacity=data.get("capacity"),
        table_type=data.get("table_type", "shared"),
        description=data.get("description"),
        status="available",
    )
    db.session.add(table)
    return table


def update_table(table, data):
    for field in ["table_number", "capacity", "table_type", "status", "description"]:
        if field in data:
            setattr(table, field, data[field])
    table.updated_at = datetime.utcnow()
    return table


def delete_table(table):
    db.session.delete(table)


def get_table_detail(table, restaurant):
    active_orders = Order.query.filter_by(table_id=table.id).filter(
        Order.status.in_(["pending", "confirmed", "dining"])
    ).all()
    table_dict = table.to_dict()
    table_dict["active_orders"] = [o.to_dict() for o in active_orders]
    return table_dict
