"""Merchant settlements (sample data for now)."""
from datetime import datetime

from utils import BadRequestError, ok


def handle_settlements(method, data):
    if method == "GET":
        sample = [
            {"order_id": "ORD1001", "date": datetime.utcnow().isoformat(), "amount": 120.00, "fee": 6.00, "settled": False},
            {"order_id": "ORD1002", "date": datetime.utcnow().isoformat(), "amount": 56.50, "fee": 2.82, "settled": True},
            {"order_id": "ORD1003", "date": datetime.utcnow().isoformat(), "amount": 230.00, "fee": 11.5, "settled": False},
        ]
        return ok({"success": True, "data": {"settlements": sample}}, 200)
    order_id = (data or {}).get("order_id")
    if not order_id:
        raise BadRequestError("缺少 order_id")
    return ok({"success": True, "message": f"订单 {order_id} 标记为已结算"}, 200)
