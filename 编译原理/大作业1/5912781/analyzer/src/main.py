import json
from pathlib import Path

from src.ast_nodes import ast_to_dict
from src.errors import CompilerError
from src.lexer import Lexer
from src.parser import Parser
from src.tokens import TokenKind


def run_file(file_path: str, show_tokens: bool = True, show_ast: bool = True) -> bool:
    """对单个源文件执行词法分析与语法分析。"""
    try:
        source = Path(file_path).read_text(encoding="utf-8")

        lexer = Lexer(source)
        tokens = lexer.tokenize()

        if show_tokens:
            print("=== 词法分析结果 ===")
            for token in tokens:
                if token.kind == TokenKind.EOF:
                    continue
                print(f"{token.line:>3}:{token.column:<3}  {token.kind.name:<10}  {token.lexeme}")
            print()

        parser = Parser(tokens)
        ast = parser.parse_program()

        if show_ast:
            print("=== 语法分析结果（AST）===")
            print(json.dumps(ast_to_dict(ast), ensure_ascii=False, indent=2))
            print()

        print("分析成功：词法与语法均通过。")
        return True

    except (CompilerError, OSError, ValueError) as exc:
        print(f"分析失败：{exc}")
        return False
