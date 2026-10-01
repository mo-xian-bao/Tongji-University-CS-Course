from dataclasses import dataclass
from pathlib import Path
import subprocess

from src.ast_nodes import Program
from src.codegen import CodeGenerator
from src.ir import IRProgram
from src.lexer import Lexer
from src.parser import Parser
from src.semantic import SemanticAnalyzer
from src.target import AssemblyGenerator
from src.tokens import Token


@dataclass
class CompilationResult:
    tokens: list[Token]
    ast: Program
    ir: IRProgram
    assembly: str


class Compiler:
    """一次语法扫描的一体化编译入口。"""

    def compile(self, source: str, validate_semantics: bool = True) -> CompilationResult:
        lexer = Lexer(source)
        parser = Parser(lexer, source=source)
        code_generator = CodeGenerator()
        ir_functions = []

        # 每完成一个函数的语法分析就立即生成该函数的中间代码。
        ast = parser.parse_program(
            on_function=lambda function: ir_functions.append(
                code_generator.generate_function(function)
            )
        )
        if validate_semantics:
            SemanticAnalyzer().analyze(ast)

        ir = IRProgram(functions=ir_functions)
        assembly = AssemblyGenerator().generate(ir)
        return CompilationResult(
            tokens=list(parser.tokens),
            ast=ast,
            ir=ir,
            assembly=assembly,
        )


def write_outputs(result: CompilationResult, source_path: Path, output_dir: Path) -> tuple[Path, Path]:
    output_dir.mkdir(parents=True, exist_ok=True)
    ir_path = output_dir / f"{source_path.stem}.ir"
    asm_path = output_dir / f"{source_path.stem}.s"
    ir_path.write_text(result.ir.format() + "\n", encoding="utf-8")
    asm_path.write_text(result.assembly, encoding="utf-8")
    return ir_path, asm_path


def assemble(asm_path: Path, executable_path: Path, compiler: str = "gcc") -> None:
    subprocess.run(
        [compiler, str(asm_path), "-o", str(executable_path)],
        check=True,
        text=True,
    )
