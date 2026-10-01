from pathlib import Path
import sys
import time
import tkinter as tk

from gui import (
    CompilerDemoApp,
    classify_error,
    discover_examples,
    enable_dpi_awareness,
    make_compilation_view,
)
from src.compiler import Compiler
from src.errors import CodegenError, LexerError, ParserError, SemanticError


PROJECT_ROOT = Path(__file__).resolve().parent


def check(name: str, condition: bool, detail: str = "") -> bool:
    if condition:
        print(f"[PASS] gui {name}")
        return True
    suffix = f" -> {detail}" if detail else ""
    print(f"[FAIL] gui {name}{suffix}")
    return False


def run_view_model_cases() -> bool:
    source = (PROJECT_ROOT / "examples" / "course_full.rs").read_text(encoding="utf-8")
    view = make_compilation_view(Compiler().compile(source))
    ok = check(
        "course_full_metrics",
        (view.token_count, view.function_count, view.quad_count, view.assembly_line_count)
        == (262, 3, 98, 286),
        repr((view.token_count, view.function_count, view.quad_count, view.assembly_line_count)),
    )

    simple = make_compilation_view(Compiler().compile("fn main() -> i32 { 1 + 2 * 3 }"))
    ok &= check(
        "custom_source_ir",
        "(*, 2, 3, t1)" in simple.ir
        and "(+, 1, t1, t2)" in simple.ir
        and ".globl main" in simple.assembly,
    )
    ok &= check(
        "token_table_hides_eof",
        "EOF" not in simple.tokens and "NUMBER" in simple.tokens,
    )
    return ok


def run_diagnostic_cases() -> bool:
    cases = (
        (LexerError("2:3 非法字符"), "词法分析", 0, 2, 3),
        (ParserError("4:5 缺少分号"), "语法分析", 1, 4, 5),
        (CodegenError("未声明变量"), "中间代码生成", 2, None, None),
        (SemanticError("不能给不可变左值赋值"), "语义分析", 3, None, None),
    )
    ok = True
    for error, name, index, line, column in cases:
        view = classify_error(error)
        ok &= check(
            f"diagnostic_{index}",
            (view.stage_name, view.stage_index, view.line, view.column)
            == (name, index, line, column),
            repr(view),
        )
    return ok


def run_resource_case() -> bool:
    examples, labels = discover_examples()
    return check(
        "bundled_examples",
        "course_full.rs" in labels
        and "err_parse.rs" in labels
        and examples[labels["course_full.rs"]].exists(),
    )


def run_widget_case() -> bool:
    enable_dpi_awareness()
    root = tk.Tk()
    root.withdraw()
    app = CompilerDemoApp(root)
    app.show_workspace()
    root.geometry("1286x688+-2400+10")
    root.deiconify()
    root.update()
    root.after(100, root.quit)
    root.mainloop()
    workbench = app.workbench
    try:
        statusbar_visible = (
            workbench.status_bar.winfo_ismapped()
            and workbench.status_bar.winfo_height() == 28
        )
        pane_width = workbench.content_pane.winfo_width()
        pane_ratio = workbench.content_pane.sashpos(0) / pane_width
        pane_split_correct = 0.44 <= pane_ratio <= 0.48
        workbench.set_source("@", compile_after=False)
        failed_as_expected = not workbench.compile_now(manual=True)
        ir_after_error = workbench.output_panes["ir"].text.get("1.0", "end-1c")
        no_stale_result = workbench.last_result is None and "未返回可展示结果" in ir_after_error

        workbench.set_source("fn main() -> i32 { 42 }", compile_after=False)
        recovered = workbench.compile_now(manual=True)
        ir_after_fix = workbench.output_panes["ir"].text.get("1.0", "end-1c")
        workbench.auto_var.set(False)
        workbench.editor.text.delete("1.0", "end")
        workbench.editor.text.insert("1.0", "fn main() -> i32 { 43 }")
        root.update()
        pending_diagnostic = workbench.output_panes["diagnostics"].text.get("1.0", "end-1c")
        pending_tabs = [workbench.notebook.tab(index, "text") for index in range(5)]
        pending_status = workbench.header_status.cget("text")
        pending_preserved = (
            "编译成功" not in pending_diagnostic
            and all("通过" not in title and "42" not in title for title in pending_tabs)
        )

        workbench._apply_run_outcome(
            workbench.source_revision - 1,
            True,
            "旧版本运行完成",
            "",
            "",
            42,
        )
        stale_run_ignored = workbench.header_status.cget("text") == pending_status

        workbench.run_in_progress = True
        workbench.compile_and_run()
        concurrent_run_blocked = "已有目标程序" in workbench.status_var.get()
        workbench.run_in_progress = False

        workbench.auto_var.set(True)
        workbench._toggle_auto_compile()
        root.after(700, root.quit)
        root.mainloop()
        dynamic_ir = workbench.last_view.ir if workbench.last_view else ""
        result = check(
            "error_clear_and_recovery",
            failed_as_expected
            and no_stale_result
            and recovered
            and "(return, 42, _, _)" in ir_after_fix
            and "(return, 43, _, _)" in dynamic_ir
            and statusbar_visible
            and pane_split_correct
            and pending_preserved
            and stale_run_ignored
            and concurrent_run_blocked,
            repr(
                {
                    "failed": failed_as_expected,
                    "cleared": no_stale_result,
                    "recovered": recovered,
                    "dynamic": "(return, 43, _, _)" in dynamic_ir,
                    "statusbar": statusbar_visible,
                    "pane_ratio": pane_ratio,
                    "pending": pending_preserved,
                    "stale_run": stale_run_ignored,
                    "run_gate": concurrent_run_blocked,
                }
            ),
        )
    finally:
        workbench.dirty = False
        workbench.confirm_close()
        root.destroy()
    return result


def run_target_case() -> bool:
    enable_dpi_awareness()
    root = tk.Tk()
    root.withdraw()
    app = CompilerDemoApp(root)
    app.show_workspace()
    root.geometry("1100x680+-2400+10")
    root.deiconify()
    root.update()
    workbench = app.workbench
    gcc = workbench._find_gcc()
    if gcc is None:
        root.destroy()
        print("[SKIP] gui compile_and_run gcc is not installed")
        return True

    source = (PROJECT_ROOT / "examples" / "course_full.rs").read_text(encoding="utf-8")
    workbench.set_source(source, compile_after=False)
    workbench.compile_and_run()
    deadline = time.monotonic() + 20
    while workbench.run_in_progress and time.monotonic() < deadline:
        root.update()
        time.sleep(0.02)
    root.update()
    diagnostic = workbench.output_panes["diagnostics"].text.get("1.0", "end-1c")
    result = check(
        "compile_and_run_exit_42",
        not workbench.run_in_progress and "退出码：42" in diagnostic,
        diagnostic[:300],
    )
    workbench.confirm_close()
    root.destroy()
    return result


def main() -> int:
    checks = (
        run_view_model_cases(),
        run_diagnostic_cases(),
        run_resource_case(),
        run_widget_case(),
        run_target_case(),
    )
    if all(checks):
        print("\nGUI tests passed.")
        return 0
    print("\nGUI tests failed.")
    return 1


if __name__ == "__main__":
    sys.exit(main())
