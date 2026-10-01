from pathlib import Path
import argparse
import sys

from src.main import run_file


# 为了初学者使用方便，默认输入文件直接写在脚本中。
PROJECT_ROOT = Path(__file__).parent
INPUT_FILE = PROJECT_ROOT / "examples" / "ok_minimal.rs"
SHOW_TOKENS = True
SHOW_AST = True


def parse_args():
    parser = argparse.ArgumentParser(description="类 Rust 词法、语法与语义分析器")
    parser.add_argument(
        "input_file",
        nargs="?",
        default=str(INPUT_FILE),
        help=f"待分析源码文件，默认 {INPUT_FILE}",
    )
    parser.add_argument("--no-tokens", action="store_true", help="不输出 token 列表")
    parser.add_argument("--no-ast", action="store_true", help="不输出 AST")
    parser.add_argument("--no-semantic", action="store_true", help="只执行词法和语法分析")
    return parser.parse_args()


if __name__ == "__main__":
    args = parse_args()
    ok = run_file(
        args.input_file,
        show_tokens=SHOW_TOKENS and not args.no_tokens,
        show_ast=SHOW_AST and not args.no_ast,
        run_semantic=not args.no_semantic,
    )
    sys.exit(0 if ok else 1)
