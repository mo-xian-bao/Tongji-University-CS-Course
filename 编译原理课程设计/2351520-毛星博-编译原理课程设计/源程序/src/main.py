import json
from pathlib import Path
import subprocess

from src.ast_nodes import ast_to_dict, ast_to_tree
from src.compiler import Compiler, assemble, write_outputs
from src.errors import CompilerError
from src.tokens import TokenKind


def run_file(
    file_path: str,
    show_tokens: bool = True,
    show_ast: bool = True,
    run_semantic: bool = True,
    show_ir: bool = True,
    show_assembly: bool = False,
    output_dir: str | None = None,
    write_files: bool = True,
    assemble_executable: bool = False,
) -> bool:
    """运行一体化编译流程，并可把四元式与目标汇编写入文件。"""
    try:
        source_path = Path(file_path)
        source = source_path.read_text(encoding="utf-8")
        result = Compiler().compile(source, validate_semantics=run_semantic)

        if show_tokens:
            print("=== Token List ===")
            for token in result.tokens:
                if token.kind == TokenKind.EOF:
                    continue
                print(f"{token.line:>3}:{token.column:<3}  {token.kind.name:<10}  {token.lexeme}")
            print()

        if show_ast:
            print("=== AST JSON ===")
            print(json.dumps(ast_to_dict(result.ast), ensure_ascii=False, indent=2))
            print()
            print("=== AST Tree ===")
            print(ast_to_tree(result.ast))
            print()

        if run_semantic:
            print("Semantic analysis passed.")

        if show_ir:
            print()
            print("=== V2 Quadruple IR ===")
            print(result.ir.format())

        if show_assembly:
            print()
            print("=== x86-64 Assembly ===")
            print(result.assembly)

        if write_files:
            target_dir = Path(output_dir) if output_dir else source_path.parent / "build"
            ir_path, asm_path = write_outputs(result, source_path, target_dir)
            print(f"IR written to: {ir_path}")
            print(f"Assembly written to: {asm_path}")
            if assemble_executable:
                executable_path = target_dir / f"{source_path.stem}.exe"
                assemble(asm_path, executable_path)
                print(f"Executable written to: {executable_path}")
        elif assemble_executable:
            raise ValueError("--assemble 需要启用文件输出，不能与 --no-write 同时使用")

        if run_semantic:
            print("Compilation succeeded: lexer, parser, semantic analysis, IR and target code completed.")
        else:
            print("Compilation succeeded: lexer, parser, IR and target code completed.")
        return True

    except (CompilerError, OSError, ValueError, subprocess.CalledProcessError) as exc:
        print(f"Analysis failed: {exc}")
        return False
