import os
import sys
import warnings

# 把项目根加入 sys.path，以便能 import backend.app / app_init
TEST_DIR = os.path.dirname(__file__)                     # .../backend/tests
BACKEND_DIR = os.path.abspath(os.path.join(TEST_DIR, '..'))  # .../backend
PROJECT_ROOT = os.path.abspath(os.path.join(BACKEND_DIR, '..'))  # repo 根目录

if PROJECT_ROOT not in sys.path:
    sys.path.insert(0, PROJECT_ROOT)

if BACKEND_DIR not in sys.path:
    sys.path.insert(0, BACKEND_DIR)

# 屏蔽 SQLAlchemy 的 LegacyAPIWarning 输出（测试期间）
warnings.filterwarnings("ignore", message=r".*Query.get.*", category=Warning, module="sqlalchemy.*")

