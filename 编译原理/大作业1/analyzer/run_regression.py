from pathlib import Path
import sys

from src.errors import CompilerError
from src.lexer import Lexer
from src.parser import Parser
from src.ast_nodes import ast_to_dict
from src.semantic import SemanticAnalyzer
from src.tokens import TokenKind


PROJECT_ROOT = Path(__file__).parent


PASS_FILES = [
    PROJECT_ROOT / "examples" / "ok_minimal.rs",
    *sorted((PROJECT_ROOT / "examples" / "minimum").glob("*.rs")),
    *sorted((PROJECT_ROOT / "examples" / "p1").glob("*.rs")),
    *sorted((PROJECT_ROOT / "examples" / "p2").glob("*.rs")),
    *sorted((PROJECT_ROOT / "examples" / "p3").glob("*.rs")),
]

FAIL_FILES = [
    PROJECT_ROOT / "examples" / "err_lex.rs",
    PROJECT_ROOT / "examples" / "err_parse.rs",
    *sorted((PROJECT_ROOT / "examples" / "semantic_errors").glob("*.rs")),
]


def parse_source(source: str) -> None:
    tokens = Lexer(source).tokenize()
    ast = Parser(tokens, source=source).parse_program()
    SemanticAnalyzer().analyze(ast)


def parse_source_to_dict(source: str):
    tokens = Lexer(source).tokenize()
    ast = Parser(tokens, source=source).parse_program()
    SemanticAnalyzer().analyze(ast)
    return ast_to_dict(ast)


def parse_file(path: Path) -> None:
    parse_source(path.read_text(encoding="utf-8"))


def visible_tokens(source: str) -> list[tuple[TokenKind, str]]:
    return [
        (token.kind, token.lexeme)
        for token in Lexer(source).tokenize()
        if token.kind != TokenKind.EOF
    ]


def check_lex_case(name: str, source: str, expected: list[tuple[TokenKind, str]]) -> bool:
    actual = visible_tokens(source)
    if actual == expected:
        print(f"[PASS] lex {name}")
        return True

    print(f"[FAIL] lex {name}")
    print(f"       expected: {[(kind.name, text) for kind, text in expected]}")
    print(f"       actual:   {[(kind.name, text) for kind, text in actual]}")
    return False


def run_pass_files() -> bool:
    ok = True
    for path in PASS_FILES:
        try:
            parse_file(path)
        except Exception as exc:
            ok = False
            print(f"[FAIL] pass {path.relative_to(PROJECT_ROOT)} -> {type(exc).__name__}: {exc}")
        else:
            print(f"[PASS] pass {path.relative_to(PROJECT_ROOT)}")
    return ok


def run_fail_files() -> bool:
    ok = True
    for path in FAIL_FILES:
        try:
            parse_file(path)
        except (CompilerError, ValueError):
            print(f"[PASS] fail {path.relative_to(PROJECT_ROOT)}")
        except Exception as exc:
            ok = False
            print(f"[FAIL] fail {path.relative_to(PROJECT_ROOT)} -> unexpected {type(exc).__name__}: {exc}")
        else:
            ok = False
            print(f"[FAIL] fail {path.relative_to(PROJECT_ROOT)} -> expected an error, got success")
    return ok


def run_lex_cases() -> bool:
    cases = [
        (
            "if123_is_ident",
            "if123#",
            [
                (TokenKind.IDENT, "if123"),
                (TokenKind.HASH, "#"),
            ],
        ),
        (
            "if_eq_number",
            "if=123#",
            [
                (TokenKind.IF, "if"),
                (TokenKind.EQ, "="),
                (TokenKind.NUMBER, "123"),
                (TokenKind.HASH, "#"),
            ],
        ),
        (
            "new_keywords_and_dots",
            "for in loop break continue . .. #",
            [
                (TokenKind.FOR, "for"),
                (TokenKind.IN, "in"),
                (TokenKind.LOOP, "loop"),
                (TokenKind.BREAK, "break"),
                (TokenKind.CONTINUE, "continue"),
                (TokenKind.DOT, "."),
                (TokenKind.DOTDOT, ".."),
                (TokenKind.HASH, "#"),
            ],
        ),
    ]

    return all(check_lex_case(name, source, expected) for name, source, expected in cases)


def check_ast_case(name: str, source: str, checker, detail: str) -> bool:
    try:
        ast = parse_source_to_dict(source)
    except Exception as exc:
        print(f"[FAIL] ast {name} -> {type(exc).__name__}: {exc}")
        return False

    if checker(ast):
        print(f"[PASS] ast {name}")
        return True

    print(f"[FAIL] ast {name} -> {detail}")
    return False


def run_ast_cases() -> bool:
    p1_source = """
fn p1(mut n:i32) {
    let mut a = 1;
    let mut b:i32 = 2;
    if a > 0 {
        return;
    } else if b > 0 {
        return;
    } else {
        return;
    }
    loop {
        break;
    }
    while n > 0 {
        continue;
    }
    for mut i in 1..n + 1 {
        n = n - 1;
    }
}
#
"""

    p2_source = """
fn p2(mut a:i32, r:&mut i32) {
    let b:& i32 = &a;
    let mut c:&mut i32 = &mut a;
    let x = *r;
    *r = 3;
    let mut xs:[i32;3] = [1,2,3];
    xs[0] = 1;
    let mut pair:(i32,i32) = (1,2);
    pair.0 = xs[0];
}
#
"""

    p3_source = """
fn p3(mut x:i32, mut y:i32) -> i32 {
    let mut z = {
        let mut t = x * x + x;
        t = t + x * y;
        t
    };
    z = if z > 0 {
        z
    } else {
        0
    };
    z = loop {
        break z;
    };
    z
}
#
"""

    def p1_checker(ast) -> bool:
        statements = ast["declarations"][0]["body"]["statements"]
        return (
            statements[0]["type"] == "LetStmt"
            and statements[0]["initializer"]["type"] == "NumberExpr"
            and statements[2]["type"] == "IfStmt"
            and len(statements[2]["else_if_blocks"]) == 1
            and statements[2]["else_if_blocks"][0]["type"] == "ElseIf"
            and statements[3]["type"] == "LoopStmt"
            and statements[3]["body"]["statements"][0]["type"] == "BreakStmt"
            and statements[4]["type"] == "WhileStmt"
            and statements[4]["body"]["statements"][0]["type"] == "ContinueStmt"
            and statements[5]["type"] == "ForStmt"
            and statements[5]["iterable"]["type"] == "RangeExpr"
        )

    def p2_checker(ast) -> bool:
        function = ast["declarations"][0]
        statements = function["body"]["statements"]
        return (
            function["params"][1]["type_name"]["type"] == "RefType"
            and function["params"][1]["type_name"]["is_mut"] is True
            and statements[0]["type_name"]["type"] == "RefType"
            and statements[0]["initializer"]["type"] == "BorrowExpr"
            and statements[0]["initializer"]["is_mut"] is False
            and statements[1]["type_name"]["type"] == "RefType"
            and statements[1]["type_name"]["is_mut"] is True
            and statements[1]["initializer"]["type"] == "BorrowExpr"
            and statements[1]["initializer"]["is_mut"] is True
            and statements[2]["initializer"]["type"] == "DerefExpr"
            and statements[3]["target"]["type"] == "DerefExpr"
            and statements[4]["type_name"]["type"] == "ArrayType"
            and statements[4]["initializer"]["type"] == "ArrayExpr"
            and statements[5]["target"]["type"] == "IndexExpr"
            and statements[6]["type_name"]["type"] == "TupleType"
            and statements[6]["initializer"]["type"] == "TupleExpr"
            and statements[7]["target"]["type"] == "FieldExpr"
            and statements[7]["value"]["type"] == "IndexExpr"
        )

    def p3_checker(ast) -> bool:
        statements = ast["declarations"][0]["body"]["statements"]
        return (
            statements[0]["initializer"]["type"] == "BlockExpr"
            and statements[0]["initializer"]["block"]["result"]["type"] == "IdentifierExpr"
            and statements[1]["value"]["type"] == "IfExpr"
            and statements[1]["value"]["then_block"]["result"]["type"] == "IdentifierExpr"
            and statements[2]["value"]["type"] == "LoopExpr"
            and statements[2]["value"]["body"]["statements"][0]["type"] == "BreakStmt"
            and statements[2]["value"]["body"]["statements"][0]["value"]["type"] == "IdentifierExpr"
            and ast["declarations"][0]["body"]["result"]["type"] == "IdentifierExpr"
        )

    return all(
        [
            check_ast_case(
                "p1_nodes",
                p1_source,
                p1_checker,
                "expected Let initializer, ElseIf, Loop/Break, Continue, For/Range nodes",
            ),
            check_ast_case(
                "p2_nodes",
                p2_source,
                p2_checker,
                "expected Ref/Array/Tuple types and Borrow/Deref/Index/Field expression nodes",
            ),
            check_ast_case(
                "p3_nodes",
                p3_source,
                p3_checker,
                "expected BlockExpr, IfExpr, LoopExpr, break value, and function-body result nodes",
            ),
        ]
    )


def main() -> int:
    checks = [
        run_pass_files(),
        run_fail_files(),
        run_lex_cases(),
        run_ast_cases(),
    ]

    if all(checks):
        print("\nRegression passed.")
        return 0

    print("\nRegression failed.")
    return 1


if __name__ == "__main__":
    sys.exit(main())
