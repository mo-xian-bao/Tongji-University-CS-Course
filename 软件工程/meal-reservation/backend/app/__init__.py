"""App package exports the Flask app and routes."""

import os
import sys
BASE_DIR = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
sys.path.append(BASE_DIR)

from app_init import app, db
from .error_handlers import register_error_handlers

from .other_routes import other_bp
from .ai_assistant_routes import ai_assistant_bp
from .auth_routes import auth_bp
from .users_routes import users_bp
from .restaurant_routes import restaurant_bp, restaurants_bp
from .appeal_routes import appeal_bp
from .support_routes import support_bp
from .admin_routes import admin_bp
from .orders_routes import orders_bp
from .merchant_routes import merchant_bp
from .tables_routes import tables_bp
from .dishes_routes import dishes_bp
from .coupon_routes import coupon_bp

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
app.register_blueprint(other_bp)

register_error_handlers(app, db)

__all__ = ["app"]
