"""Health check."""
from utils import ok


def get_health():
    return ok({"status": "healthy", "message": "FoodBook API is running"}, 200)
