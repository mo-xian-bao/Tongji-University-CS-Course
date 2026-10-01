from pathlib import Path
import argparse
import sys

from src.main import run_file


PROJECT_ROOT = (
    Path(sys.executable).resolve().parent.parent
    if getattr(sys, "frozen", False)
    else Path(__file__).parent
)
INPUT_FILE = PROJECT_ROOT / "examples" / "course_full.rs"
SHOW_TOKENS = True
SHOW_AST = True
SHOW_IR = True


def parse_args():
    parser = argparse.ArgumentParser(
        description="One-pass Rust-like compiler: lexer, parser, semantics, IR and x86-64 target"
    )
    parser.add_argument(
        "input_file",
        nargs="?",
        default=str(INPUT_FILE),
        help=f"source file to analyze, default: {INPUT_FILE}",
    )
    parser.add_argument("--no-tokens", action="store_true", help="do not print tokens")
    parser.add_argument("--no-ast", action="store_true", help="do not print AST")
    parser.add_argument("--no-semantic", action="store_true", help="skip semantic analysis")
    parser.add_argument("--no-ir", action="store_true", help="do not print V2 quadruple IR")
    parser.add_argument("--show-asm", action="store_true", help="print x86-64 target assembly")
    parser.add_argument("--output-dir", help="output directory, default: <source>/build")
    parser.add_argument("--no-write", action="store_true", help="do not write .ir and .s files")
    parser.add_argument("--assemble", action="store_true", help="invoke gcc to build an executable")
    return parser.parse_args()


if __name__ == "__main__":
    args = parse_args()
    ok = run_file(
        args.input_file,
        show_tokens=SHOW_TOKENS and not args.no_tokens,
        show_ast=SHOW_AST and not args.no_ast,
        run_semantic=not args.no_semantic,
        show_ir=SHOW_IR and not args.no_ir,
        show_assembly=args.show_asm,
        output_dir=args.output_dir,
        write_files=not args.no_write,
        assemble_executable=args.assemble,
    )
    sys.exit(0 if ok else 1)
