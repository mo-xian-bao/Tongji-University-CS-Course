from pathlib import Path
import shutil
import subprocess
import sys
import tempfile

from src.codegen import CodeGenerator
from src.compiler import Compiler
from src.errors import CompilerError
from src.lexer import Lexer
from src.parser import Parser
from src.ast_nodes import ast_to_dict
from src.semantic import SemanticAnalyzer
from src.tokens import TokenKind


PROJECT_ROOT = Path(__file__).parent


PASS_FILES = [
    PROJECT_ROOT / "examples" / "ok_minimal.rs",
    *sorted(
        p for p in (PROJECT_ROOT / "examples" / "minimum").glob("*.rs")
        if "_error" not in p.stem
    ),
    *sorted((PROJECT_ROOT / "examples" / "extra").glob("*.rs")),
    PROJECT_ROOT / "examples" / "v1_ir.rs",
    PROJECT_ROOT / "examples" / "v2_compare.rs",
    PROJECT_ROOT / "examples" / "course_full.rs",
    *sorted((PROJECT_ROOT / "examples" / "p1").glob("*.rs")),
    *sorted((PROJECT_ROOT / "examples" / "p2").glob("*.rs")),
    *sorted((PROJECT_ROOT / "examples" / "p3").glob("*.rs")),
]

FAIL_FILES = [
    PROJECT_ROOT / "examples" / "err_lex.rs",
    PROJECT_ROOT / "examples" / "err_parse.rs",
    *sorted(
        p for p in (PROJECT_ROOT / "examples" / "minimum").glob("*_error.rs")
    ),
    *sorted((PROJECT_ROOT / "examples" / "semantic_errors").glob("*.rs")),
]


def parse_source(source: str) -> None:
    tokens = Lexer(source).tokenize()
    ast = Parser(tokens, source=source).parse_program()
    SemanticAnalyzer().analyze(ast)
    CodeGenerator().generate_program(ast)


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
    let mut d:i32 = 0;
    let mut c:&mut i32 = &mut d;
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
            and statements[2]["type_name"]["type"] == "RefType"
            and statements[2]["type_name"]["is_mut"] is True
            and statements[2]["initializer"]["type"] == "BorrowExpr"
            and statements[2]["initializer"]["is_mut"] is True
            and statements[3]["initializer"]["type"] == "DerefExpr"
            and statements[4]["target"]["type"] == "DerefExpr"
            and statements[5]["type_name"]["type"] == "ArrayType"
            and statements[5]["initializer"]["type"] == "ArrayExpr"
            and statements[6]["target"]["type"] == "IndexExpr"
            and statements[7]["type_name"]["type"] == "TupleType"
            and statements[7]["initializer"]["type"] == "TupleExpr"
            and statements[8]["target"]["type"] == "FieldExpr"
            and statements[8]["value"]["type"] == "IndexExpr"
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


def generate_ir_text(source: str) -> str:
    tokens = Lexer(source).tokenize()
    ast = Parser(tokens, source=source).parse_program()
    SemanticAnalyzer().analyze(ast)
    ir = CodeGenerator().generate_program(ast)
    return ir.format()


def check_ir_case(name: str, source: str, required_ops: list[str]) -> bool:
    try:
        ir_text = generate_ir_text(source)
    except Exception as exc:
        print(f"[FAIL] ir {name} -> {type(exc).__name__}: {exc}")
        return False

    missing = [op for op in required_ops if f"({op}," not in ir_text]
    if not missing:
        print(f"[PASS] ir {name}")
        return True

    print(f"[FAIL] ir {name} -> missing ops: {missing}")
    print(f"       IR output:\n{ir_text}")
    return False


def run_ir_cases() -> bool:
    # if/else 分支
    if_source = """
fn test_if(mut a:i32) -> i32 {
    if a>0 {
        return 1;
    } else {
        return 0;
    }
}
"""
    # while 循环
    while_source = """
fn test_while(mut n:i32) {
    while n>0 {
        n=n-1;
    }
}
"""
    # for 循环
    for_source = """
fn test_for(mut n:i32) {
    for mut i in 1..n+1 {
        n=n-1;
    }
}
"""
    # 函数调用
    call_source = """
fn callee(mut a:i32) -> i32 {
    return a;
}
fn test_call() {
    let mut x:i32 = callee(42);
}
"""
    # loop + break 表达式
    loop_expr_source = """
fn test_loop_expr() {
    let mut a:i32 = loop {
        break 1;
    };
}
"""
    # if 表达式
    if_expr_source = """
fn test_if_expr(mut a:i32) {
    let mut b:i32 = if a>0 {
        1
    } else {
        0
    };
}
"""

    return all(
        [
            check_ir_case("if_else", if_source, ["jz", "j", "label", "return"]),
            check_ir_case("while_loop", while_source, ["jz", "j", "label"]),
            check_ir_case("for_loop", for_source, ["jz", "j", "label", "<"]),
            check_ir_case("function_call", call_source, ["param", "call"]),
            check_ir_case("loop_expr", loop_expr_source, ["j", "label"]),
            check_ir_case("if_expr", if_expr_source, ["jz", "j", "label"]),
        ]
    )


def check_semantic_error(name: str, source: str) -> bool:
    try:
        parse_source(source)
    except CompilerError:
        print(f"[PASS] semantic {name}")
        return True
    except Exception as exc:
        print(f"[FAIL] semantic {name} -> unexpected {type(exc).__name__}: {exc}")
        return False
    print(f"[FAIL] semantic {name} -> expected an error, got success")
    return False


def run_semantic_cases() -> bool:
    error_cases = {
        "immutable_reassignment": "fn f(){ let a:i32=1; a=2; }",
        "mutable_borrow_conflict": "fn f(){ let mut a:i32=1; let b=&a; let mut c=&mut a; }",
        "mutable_borrow_from_immutable": "fn f(){ let a:i32=1; let mut b=&mut a; }",
        "immutable_reference_write": "fn f(){ let a:i32=1; let b:&i32=&a; *b=2; }",
        "array_constant_oob": "fn f(){ let a=[1,2,3]; let b=a[3]; }",
        "immutable_array_element_write": "fn f(){ let a=[1,2,3]; a[0]=4; }",
        "array_zero_length": "fn f(){ let mut a:[i32;0]; }",
        "empty_array_expression": "fn f(){ let a=[]; }",
        "tuple_field_oob": "fn f(){ let a=(1,2); let b=a.2; }",
        "break_outside_loop": "fn f(){ break; }",
        "continue_outside_loop": "fn f(){ continue; }",
        "missing_return_path": "fn f(mut a:i32)->i32 { if a>0 { return 1; } }",
    }
    ok = all(check_semantic_error(name, source) for name, source in error_cases.items())

    # 不可变变量允许且仅允许首次初始化。
    try:
        parse_source("fn f(){ let a:i32; a=1; }")
    except Exception as exc:
        print(f"[FAIL] semantic immutable_first_initialization -> {type(exc).__name__}: {exc}")
        ok = False
    else:
        print("[PASS] semantic immutable_first_initialization")

    try:
        parse_source("fn f(){ let a:i32=1; let b=&a; let c=&a; }")
    except Exception as exc:
        print(f"[FAIL] semantic multiple_immutable_borrows -> {type(exc).__name__}: {exc}")
        ok = False
    else:
        print("[PASS] semantic multiple_immutable_borrows")
    return ok


def run_streaming_case() -> bool:
    source = "fn first(){} fn second(){}"
    lexer = Lexer(source)
    parser = Parser(lexer, source=source)
    callback_states = []
    parser.parse_program(
        on_function=lambda function: callback_states.append(
            (function.name, lexer.is_finished, len(lexer.emitted_tokens))
        )
    )
    if callback_states and callback_states[0][0] == "first" and not callback_states[0][1]:
        print("[PASS] pipeline lexer_on_demand_and_function_codegen_hook")
        return True
    print(f"[FAIL] pipeline lexer_on_demand_and_function_codegen_hook -> {callback_states}")
    return False


def run_target_case() -> bool:
    gcc = shutil.which("gcc")
    if gcc is None:
        print("[SKIP] target gcc is not installed")
        return True

    source_path = PROJECT_ROOT / "examples" / "course_full.rs"
    try:
        result = Compiler().compile(source_path.read_text(encoding="utf-8"))
        with tempfile.TemporaryDirectory(prefix="rust_like_target_") as temp_dir:
            asm_path = Path(temp_dir) / "course_full.s"
            exe_path = Path(temp_dir) / "course_full.exe"
            asm_path.write_text(result.assembly, encoding="utf-8")
            subprocess.run([gcc, str(asm_path), "-o", str(exe_path)], check=True)
            completed = subprocess.run([str(exe_path)], check=False)
            if completed.returncode != 42:
                print(f"[FAIL] target executable returned {completed.returncode}, expected 42")
                return False
    except Exception as exc:
        print(f"[FAIL] target assemble_and_execute -> {type(exc).__name__}: {exc}")
        return False

    print("[PASS] target assemble_and_execute")
    return True


def main() -> int:
    checks = [
        run_pass_files(),
        run_fail_files(),
        run_lex_cases(),
        run_ast_cases(),
        run_ir_cases(),
        run_semantic_cases(),
        run_streaming_case(),
        run_target_case(),
    ]

    if all(checks):
        print("\nRegression passed.")
        return 0

    print("\nRegression failed.")
    return 1


if __name__ == "__main__":
    sys.exit(main())
