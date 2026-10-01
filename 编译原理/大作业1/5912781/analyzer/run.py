from pathlib import Path

from src.main import run_file


# 为了初学者使用方便，默认输入文件直接写在脚本中。
PROJECT_ROOT = Path(__file__).parent
INPUT_FILE = PROJECT_ROOT / "examples" / "ok_minimal.rs"
SHOW_TOKENS = True
SHOW_AST = True


if __name__ == "__main__":
    run_file(str(INPUT_FILE), show_tokens=SHOW_TOKENS, show_ast=SHOW_AST)
