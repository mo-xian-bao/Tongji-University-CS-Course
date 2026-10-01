# backend/tests/test_api_surface.py
# (create file at backend/tests/test_api_surface.py)
# Language: python
from importlib import import_module, reload
import re
import importlib
import app_init

# 在导入后端路由文件前设置测试配置（确保 init_database 使用内存 DB）
app = app_init.app
app.config['TESTING'] = True
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///:memory:'

# 导入后端路由（会在 app 上注册 route）
importlib.invalidate_caches()
backend_app_mod = import_module('backend.app')  # 触发路由注册

from flask import Flask
import pytest

def _normalize_pattern(pattern: str) -> str:
    import re
    regex = re.sub(r'<[^>]+>', r'[^/]+', pattern)
    return '^' + regex + '$'

def _any_rule_matches(app, pattern: str) -> bool:
    import re
    regex = re.compile(_normalize_pattern(pattern))
    for rule in app.url_map.iter_rules():
        if regex.match(rule.rule):
            return True
    return False

def test_app_importable():
    """App should be importable and expose a Flask app instance"""
    from app_init import app as flask_app
    assert isinstance(flask_app, Flask)

def test_expected_api_routes_registered():
    """检查若干关键路由是否被注册（非穷举，只做表面检查）"""
    from app_init import app as flask_app
    expected_patterns = [
        '/api/health',
        '/api/sms/send',
        '/api/register',
        '/api/login',
        '/api/auth/validate',
        '/api/check-phone',
        '/api/check-username',
        '/api/users/profile',
        '/api/restaurant',
        '/api/restaurants',
        '/api/dishes',
        '/api/orders',
        '/api/orders/create',
        '/api/merchant-application',
        '/api/merchant/upload',
        '/api/support/tickets',
        '/api/support/upload',
        '/api/support/get_tickets',
        '/api/support/get_alltickets',
    ]
    missing = []
    for pat in expected_patterns:
        if not _any_rule_matches(flask_app, pat):
            missing.append(pat)
    assert not missing, f"Missing expected route patterns: {missing}"

# backend/tests/__init__.py
# (create empty file to make tests package)
# Language: python
# empty file

# Optional pytest.ini (create at repo root if needed)
# Language: ini
# pytest.ini content:
# [pytest]
# testpaths = backend/tests
# python_files = test_*.py