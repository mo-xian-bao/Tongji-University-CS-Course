import re
import pytest
import importlib
from importlib import import_module
import app_init

# 在导入后端路由前设置内存 DB，避免测试依赖外部 DB
app = app_init.app
app.config['TESTING'] = True
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///:memory:'

# 导入并注册路由（会执行 init_database）
importlib.invalidate_caches()
backend_mod = import_module('backend.app')

from app_init import app as flask_app
from app_init import db

# 可按需调整：跳过明确危险或管理员相关的路由
SKIP_PATTERNS = [
    r'/api/admin',        # 管理后台相关
    r'/api/backup',       # 备份/恢复
    r'/api/delete',       # 明确删除性的路径
    r'/api/pay',          # 支付相关
    r'/api/merchant/upload',  # 需要文件上传，简单测试可能不适用
    r'/static/',          # 静态文件路由
    r'/api/support/upload',
]

# 如需避免执行 DELETE 等破坏性方法，可在这里添加
SKIP_METHODS = set()  # e.g. {'DELETE'}

def should_skip(rule):
    for p in SKIP_PATTERNS:
        if re.search(p, rule):
            return True
    return False

def build_url_from_rule(rule_str):
    # 把 Flask 风格的 <converter:name> 或 <name> 替换为示例值
    def repl(m):
        token = m.group(0)
        if 'int:' in token or token.startswith('<int'):
            return '1'
        if 'float:' in token or token.startswith('<float'):
            return '1.0'
        if 'path:' in token or token.startswith('<path'):
            return 'test/path'
        return 'test'
    return re.sub(r'<[^>]+>', repl, rule_str)

@pytest.fixture(autouse=True)
def init_test_app():
    # 每个测试使用内存 sqlite，确保隔离
    flask_app.config['TESTING'] = True
    flask_app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///:memory:'
    with flask_app.app_context():
        db.create_all()
        # create sample users via db_exe.init_database already ran on import,
        # but ensure tables exist
        yield
        db.session.remove()
        db.drop_all()

def _get_guest_token():
    # 优先使用后端提供的 create_jwt，如果不可用则弱回退（不签名）——后者可能导致 token 验证失败
    try:
        token = getattr(backend_mod, 'create_jwt')(0)
        return token
    except Exception:
        try:
            import jwt
            payload = {'sub': '0'}
            key = flask_app.config.get('SECRET_KEY', 'dev-secret-key-change-in-production')
            tok = jwt.encode(payload, key, algorithm='HS256')
            if isinstance(tok, bytes):
                tok = tok.decode('utf-8')
            return tok
        except Exception:
            # 无法生成 token，返回 None（仍会尝试请求，但某些受保护接口会返回 5xx）
            return None

def test_all_api_routes_no_5xx():
    client = flask_app.test_client()
    token = _get_guest_token()
    auth_header = {'Authorization': f'Bearer {token}'} if token else {}

    errors = []
    api_rules = [r for r in flask_app.url_map.iter_rules() if r.rule.startswith('/api/')]
    assert api_rules, "未检测到任何 /api/ 路由"

    for rule in api_rules:
        rule_str = rule.rule
        if should_skip(rule_str):
            continue

        url = build_url_from_rule(rule_str)
        methods = [m for m in rule.methods if m not in ('OPTIONS', 'HEAD')]

        # 优先测试常见方法顺序
        pref_order = ['GET', 'POST', 'PUT', 'PATCH', 'DELETE']
        for method in pref_order:
            if method not in methods:
                continue
            if method in SKIP_METHODS:
                continue

            json_payload = {} if method in ('POST', 'PUT', 'PATCH') else None
            headers = dict(auth_header)
            if json_payload is not None:
                headers['Content-Type'] = 'application/json'

            try:
                resp = client.open(path=url, method=method, json=json_payload, headers=headers)
                status = resp.status_code
            except Exception as e:
                errors.append({
                    'rule': rule_str,
                    'method': method,
                    'url': url,
                    'exception': repr(e)
                })
                break

            # 允许 1xx/2xx/3xx/4xx，但不允许 5xx
            if 500 <= status <= 599:
                try:
                    body = resp.get_data(as_text=True)
                except Exception:
                    body = '<unreadable>'
                errors.append({
                    'rule': rule_str,
                    'method': method,
                    'url': url,
                    'status': status,
                    'body': body[:400]
                })
                break

    if errors:
        for e in errors:
            print("ERROR:", e)
    assert not errors, f"发现 {len(errors)} 个接口返回 5xx 或抛异常，详见上方输出"