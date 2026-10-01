from __future__ import annotations

from dataclasses import dataclass
import ctypes
import json
import os
from pathlib import Path
import queue
import re
import shutil
import subprocess
import sys
import tempfile
import threading
import time
import tkinter as tk
from tkinter import filedialog, messagebox, ttk

from src.ast_nodes import ast_to_tree
from src.compiler import CompilationResult, Compiler, write_outputs
from src.errors import (
    CodegenError,
    CompilerError,
    LexerError,
    ParserError,
    SemanticError,
    TargetCodeError,
)
from src.tokens import TokenKind


APP_NAME = "类 Rust 一遍式编译演示器"
AUTO_COMPILE_DELAY_MS = 500
DEFAULT_SOURCE = """fn main() -> i32 {
    let mut answer:i32 = 6;
    answer = answer * 7;
    answer
}
"""

COLORS = {
    "navy": "#12315A",
    "blue": "#0B63CE",
    "blue_dark": "#074EA8",
    "blue_light": "#E8F2FF",
    "blue_pale": "#F4F8FE",
    "canvas": "#EDF4FC",
    "card": "#FFFFFF",
    "border": "#D7E4F3",
    "muted": "#64748B",
    "text": "#172B4D",
    "success": "#138A5B",
    "success_bg": "#E8F8F1",
    "error": "#C43D4B",
    "error_bg": "#FFF0F2",
    "warning": "#B26A00",
    "warning_bg": "#FFF7E8",
    "code_bg": "#F8FBFF",
}


def resource_path(*parts: str) -> Path:
    """Return a bundled resource path in development and PyInstaller builds."""
    base = Path(getattr(sys, "_MEIPASS", Path(__file__).resolve().parent))
    return base.joinpath(*parts)


def _mix_color(start: str, end: str, ratio: float) -> str:
    start_rgb = tuple(int(start[index : index + 2], 16) for index in (1, 3, 5))
    end_rgb = tuple(int(end[index : index + 2], 16) for index in (1, 3, 5))
    values = tuple(round(a + (b - a) * ratio) for a, b in zip(start_rgb, end_rgb))
    return "#" + "".join(f"{value:02x}" for value in values)


def adaptive_font_size(widget: tk.Misc, nominal_size: int, minimum: int = 7) -> int:
    """Keep fixed-layout homepage typography stable at high Windows DPI."""
    try:
        scaling = float(widget.tk.call("tk", "scaling"))
    except (tk.TclError, ValueError):
        scaling = 4 / 3
    return max(minimum, round(nominal_size * (4 / 3) / scaling))


def _friendly_example_name(relative_path: str) -> str:
    names = {
        "course_full.rs": "综合功能",
        "ok_minimal.rs": "基础语法",
        "v1_ir.rs": "表达式与四元式",
        "v2_compare.rs": "比较运算",
        "err_lex.rs": "词法错误（预期失败）",
        "err_parse.rs": "语法错误（预期失败）",
        "minimum/test_4.rs": "条件分支",
        "minimum/test_5.rs": "循环语句",
        "minimum/test_call.rs": "函数调用",
    }
    return names.get(relative_path, "课程规则示例")


def discover_examples() -> tuple[dict[str, Path], dict[str, str]]:
    examples_dir = resource_path("examples")
    choices: dict[str, Path] = {}
    labels_by_relative: dict[str, str] = {}
    if not examples_dir.exists():
        return choices, labels_by_relative

    priority = {
        "course_full.rs": 0,
        "ok_minimal.rs": 1,
        "v1_ir.rs": 2,
        "v2_compare.rs": 3,
        "minimum/test_4.rs": 4,
        "minimum/test_5.rs": 5,
        "minimum/test_call.rs": 6,
        "err_lex.rs": 7,
        "err_parse.rs": 8,
    }
    paths = sorted(
        examples_dir.rglob("*.rs"),
        key=lambda path: (
            priority.get(path.relative_to(examples_dir).as_posix(), 100),
            path.relative_to(examples_dir).as_posix(),
        ),
    )
    for path in paths:
        relative = path.relative_to(examples_dir).as_posix()
        label = f"{_friendly_example_name(relative)}  ·  {relative}"
        choices[label] = path
        labels_by_relative[relative] = label
    return choices, labels_by_relative


@dataclass(frozen=True)
class CompilationView:
    tokens: str
    ast: str
    ir: str
    assembly: str
    token_count: int
    function_count: int
    quad_count: int
    assembly_line_count: int


@dataclass(frozen=True)
class ErrorView:
    stage_name: str
    stage_index: int
    line: int | None
    column: int | None
    message: str


def make_compilation_view(result: CompilationResult) -> CompilationView:
    visible_tokens = [token for token in result.tokens if token.kind != TokenKind.EOF]
    token_lines = [
        f"{'序号':>4}  {'行':>4}  {'列':>4}  {'类型':<12}  词素",
        "─" * 72,
    ]
    for index, token in enumerate(visible_tokens, start=1):
        lexeme = json.dumps(token.lexeme, ensure_ascii=False)
        token_lines.append(
            f"{index:>4}  {token.line:>4}  {token.column:>4}  "
            f"{token.kind.name:<12}  {lexeme}"
        )

    quad_count = sum(len(function.quads) for function in result.ir.functions)
    assembly_lines = len(result.assembly.splitlines())
    return CompilationView(
        tokens="\n".join(token_lines),
        ast=ast_to_tree(result.ast),
        ir=result.ir.format(),
        assembly=result.assembly,
        token_count=len(visible_tokens),
        function_count=len(result.ast.declarations),
        quad_count=quad_count,
        assembly_line_count=assembly_lines,
    )


def classify_error(error: BaseException) -> ErrorView:
    stages = (
        (LexerError, "词法分析", 0),
        (ParserError, "语法分析", 1),
        (CodegenError, "中间代码生成", 2),
        (SemanticError, "语义分析", 3),
        (TargetCodeError, "目标代码生成", 4),
    )
    stage_name, stage_index = "编译器", 0
    for error_type, name, index in stages:
        if isinstance(error, error_type):
            stage_name, stage_index = name, index
            break

    message = str(error)
    match = re.search(r"(?:^|\n)(\d+):(\d+)", message)
    line = int(match.group(1)) if match else None
    column = int(match.group(2)) if match else None
    return ErrorView(stage_name, stage_index, line, column, message)


class OutputPane(tk.Frame):
    def __init__(self, master: tk.Misc, *, wrap: str = "none") -> None:
        super().__init__(master, bg=COLORS["code_bg"])
        self.text = tk.Text(
            self,
            wrap=wrap,
            borderwidth=0,
            highlightthickness=0,
            bg=COLORS["code_bg"],
            fg=COLORS["text"],
            insertbackground=COLORS["blue"],
            selectbackground="#BFD9FA",
            font=("Cascadia Code", 10),
            padx=16,
            pady=14,
            spacing1=1,
            spacing3=1,
            width=1,
            height=1,
            state="disabled",
        )
        y_scroll = ttk.Scrollbar(self, orient="vertical", command=self.text.yview)
        self.text.configure(yscrollcommand=y_scroll.set)
        self.text.grid(row=0, column=0, sticky="nsew")
        y_scroll.grid(row=0, column=1, sticky="ns")

        if wrap == "none":
            x_scroll = ttk.Scrollbar(self, orient="horizontal", command=self.text.xview)
            self.text.configure(xscrollcommand=x_scroll.set)
            x_scroll.grid(row=1, column=0, sticky="ew")

        self.grid_rowconfigure(0, weight=1)
        self.grid_columnconfigure(0, weight=1)
        self.text.tag_configure(
            "headline", font=("Microsoft YaHei UI", 13, "bold"), spacing3=8
        )
        self.text.tag_configure("success", foreground=COLORS["success"])
        self.text.tag_configure("error", foreground=COLORS["error"])
        self.text.tag_configure("warning", foreground=COLORS["warning"])
        self.text.tag_configure("muted", foreground=COLORS["muted"])

    def set_text(self, value: str) -> None:
        self.text.configure(state="normal")
        self.text.delete("1.0", "end")
        self.text.insert("1.0", value)
        self.text.configure(state="disabled")
        self.text.yview_moveto(0)
        self.text.xview_moveto(0)

    def set_message(self, title: str, body: str, level: str = "muted") -> None:
        self.text.configure(state="normal")
        self.text.delete("1.0", "end")
        self.text.insert("end", title + "\n", ("headline", level))
        self.text.insert("end", body)
        self.text.configure(state="disabled")
        self.text.yview_moveto(0)

    def copy_all(self) -> str:
        value = self.text.get("1.0", "end-1c")
        self.clipboard_clear()
        self.clipboard_append(value)
        return value


class CodeEditor(tk.Frame):
    KEYWORDS = (
        "fn",
        "let",
        "mut",
        "if",
        "else",
        "while",
        "for",
        "in",
        "loop",
        "break",
        "continue",
        "return",
    )

    def __init__(self, master: tk.Misc, on_change, on_cursor) -> None:
        super().__init__(master, bg=COLORS["code_bg"])
        self.on_change = on_change
        self.on_cursor = on_cursor
        self._redraw_job: str | None = None

        self.gutter = tk.Canvas(
            self,
            width=52,
            bg="#EEF4FC",
            highlightthickness=0,
            borderwidth=0,
        )
        self.text = tk.Text(
            self,
            undo=True,
            autoseparators=True,
            maxundo=-1,
            wrap="none",
            borderwidth=0,
            highlightthickness=0,
            bg=COLORS["code_bg"],
            fg=COLORS["text"],
            insertbackground=COLORS["blue"],
            selectbackground="#BFD9FA",
            font=("Cascadia Code", 11),
            padx=12,
            pady=12,
            spacing1=1,
            tabs=(32,),
            width=1,
            height=1,
        )
        y_scroll = ttk.Scrollbar(self, orient="vertical", command=self._scroll_y)
        x_scroll = ttk.Scrollbar(self, orient="horizontal", command=self.text.xview)
        self.text.configure(
            yscrollcommand=lambda first, last: self._on_yview(y_scroll, first, last),
            xscrollcommand=x_scroll.set,
        )

        self.gutter.grid(row=0, column=0, sticky="ns")
        self.text.grid(row=0, column=1, sticky="nsew")
        y_scroll.grid(row=0, column=2, sticky="ns")
        x_scroll.grid(row=1, column=1, sticky="ew")
        self.grid_rowconfigure(0, weight=1)
        self.grid_columnconfigure(1, weight=1)

        self.text.tag_configure("current_line", background="#F0F6FF")
        self.text.tag_configure("error_line", background="#FFE4E8")
        self.text.tag_configure("keyword", foreground="#0B63CE", font=("Cascadia Code", 11, "bold"))
        self.text.tag_configure("type", foreground="#007C91", font=("Cascadia Code", 11, "bold"))
        self.text.tag_configure("number", foreground="#B95C00")
        self.text.tag_configure("operator", foreground="#7C3AED")
        self.text.tag_configure("comment", foreground="#5F7A67")
        self.text.tag_raise("error_line")

        self.text.bind("<<Modified>>", self._modified, add="+")
        self.text.bind("<KeyRelease>", self._cursor_moved, add="+")
        self.text.bind("<ButtonRelease-1>", self._cursor_moved, add="+")
        self.text.bind("<MouseWheel>", self._schedule_gutter, add="+")
        self.text.bind("<Configure>", self._schedule_gutter, add="+")
        self.text.edit_modified(False)

    def _on_yview(self, scrollbar: ttk.Scrollbar, first: str, last: str) -> None:
        scrollbar.set(first, last)
        self._schedule_gutter()

    def _scroll_y(self, *args) -> None:
        self.text.yview(*args)
        self._schedule_gutter()

    def _schedule_gutter(self, _event=None) -> None:
        if self._redraw_job is not None:
            self.after_cancel(self._redraw_job)
        self._redraw_job = self.after_idle(self._redraw_gutter)

    def _redraw_gutter(self) -> None:
        self._redraw_job = None
        self.gutter.delete("all")
        index = self.text.index("@0,0")
        while True:
            line_info = self.text.dlineinfo(index)
            if line_info is None:
                break
            y = line_info[1]
            line_number = index.split(".")[0]
            self.gutter.create_text(
                42,
                y,
                anchor="ne",
                text=line_number,
                fill="#8293AA",
                font=("Cascadia Code", 9),
            )
            index = self.text.index(f"{index}+1line")

    def _modified(self, _event=None) -> None:
        if not self.text.edit_modified():
            return
        self.text.edit_modified(False)
        self.highlight()
        self._update_current_line()
        self._schedule_gutter()
        self.on_change()

    def _cursor_moved(self, _event=None) -> None:
        self._update_current_line()
        self._schedule_gutter()
        self.on_cursor()

    def _update_current_line(self) -> None:
        self.text.tag_remove("current_line", "1.0", "end")
        line = self.text.index("insert").split(".")[0]
        self.text.tag_add("current_line", f"{line}.0", f"{line}.0 lineend+1c")
        self.text.tag_lower("current_line")
        self.text.tag_raise("error_line")

    def highlight(self) -> None:
        source = self.get()
        for tag in ("keyword", "type", "number", "operator", "comment"):
            self.text.tag_remove(tag, "1.0", "end")

        def add_matches(tag: str, pattern: str, flags: int = 0) -> None:
            for match in re.finditer(pattern, source, flags):
                self.text.tag_add(
                    tag,
                    f"1.0+{match.start()}c",
                    f"1.0+{match.end()}c",
                )

        keyword_pattern = r"\b(?:" + "|".join(self.KEYWORDS) + r")\b"
        add_matches("keyword", keyword_pattern)
        add_matches("type", r"\bi32\b")
        add_matches("number", r"\b\d+\b")
        add_matches("operator", r"->|==|!=|<=|>=|\.\.|[+\-*/=><&]")
        add_matches("comment", r"//[^\n]*|/\*.*?\*/", re.DOTALL)
        self.text.tag_raise("comment")
        self.text.tag_raise("error_line")

    def get(self) -> str:
        return self.text.get("1.0", "end-1c")

    def set(self, value: str) -> None:
        self.text.delete("1.0", "end")
        self.text.insert("1.0", value)
        self.text.edit_modified(False)
        self.text.edit_reset()
        self.text.mark_set("insert", "1.0")
        self.clear_error()
        self.highlight()
        self._update_current_line()
        self._schedule_gutter()

    def clear_error(self) -> None:
        self.text.tag_remove("error_line", "1.0", "end")

    def show_error(self, line: int | None, column: int | None) -> None:
        self.clear_error()
        if line is None:
            return
        self.text.tag_add("error_line", f"{line}.0", f"{line}.0 lineend+1c")
        self.text.tag_raise("error_line")
        if column is not None:
            self.text.mark_set("insert", f"{line}.{max(0, column - 1)}")
        self.text.see(f"{line}.0")
        self._schedule_gutter()

    def cursor_position(self) -> tuple[int, int]:
        line, column = self.text.index("insert").split(".")
        return int(line), int(column) + 1

    def focus(self) -> None:
        self.text.focus_set()


class FeatureCard(tk.Frame):
    def __init__(self, master, title: str, body: str, action: str, command) -> None:
        super().__init__(
            master,
            bg=COLORS["card"],
            highlightthickness=1,
            highlightbackground="#CFE0F4",
        )
        accent = tk.Frame(self, bg=COLORS["blue"], width=5)
        accent.pack(side="left", fill="y")
        content = tk.Frame(self, bg=COLORS["card"])
        content.pack(side="left", fill="both", expand=True, padx=18, pady=14)
        tk.Label(
            content,
            text=title,
            bg=COLORS["card"],
            fg=COLORS["navy"],
            font=("Microsoft YaHei UI", adaptive_font_size(self, 12), "bold"),
        ).pack(anchor="w")
        tk.Label(
            content,
            text=body,
            bg=COLORS["card"],
            fg=COLORS["muted"],
            font=("Microsoft YaHei UI", adaptive_font_size(self, 9)),
            justify="left",
            wraplength=270,
        ).pack(anchor="w", pady=(5, 8))
        tk.Button(
            content,
            text=action,
            command=command,
            borderwidth=0,
            bg=COLORS["blue_light"],
            fg=COLORS["blue_dark"],
            activebackground="#D4E8FF",
            activeforeground=COLORS["blue_dark"],
            font=("Microsoft YaHei UI", adaptive_font_size(self, 9), "bold"),
            cursor="hand2",
            padx=12,
            pady=4,
        ).pack(anchor="w")


class HomePage(tk.Frame):
    def __init__(self, master, open_example, new_source, open_workspace) -> None:
        super().__init__(master, bg="#F4F9FF")
        self.open_example = open_example
        self.canvas = tk.Canvas(self, highlightthickness=0, borderwidth=0)
        self.canvas.place(relx=0, rely=0, relwidth=1, relheight=1)

        self.workspace_button = tk.Button(
            self,
            text="进入编译工作台",
            command=open_workspace,
            borderwidth=0,
            bg="#FFFFFF",
            fg=COLORS["blue_dark"],
            activebackground="#E7F2FF",
            activeforeground=COLORS["blue_dark"],
            font=("Microsoft YaHei UI", adaptive_font_size(self, 10), "bold"),
            cursor="hand2",
            padx=18,
            pady=9,
        )

        self.tags = tk.Frame(self, bg="#1763BF")
        for text in ("按需词法", "四元式 IR", "x86-64"):
            tk.Label(
                self.tags,
                text=text,
                bg="#2D74C9",
                fg="#EAF4FF",
                font=("Microsoft YaHei UI", adaptive_font_size(self, 9)),
                padx=12,
                pady=5,
            ).pack(side="left", padx=(0, 8))

        self.cta = tk.Frame(self, bg="#1763BF")
        tk.Button(
            self.cta,
            text="载入综合示例",
            command=lambda: open_example("course_full.rs"),
            borderwidth=0,
            bg="#FFFFFF",
            fg=COLORS["blue_dark"],
            activebackground="#E7F2FF",
            activeforeground=COLORS["blue_dark"],
            font=("Microsoft YaHei UI", adaptive_font_size(self, 11), "bold"),
            cursor="hand2",
            padx=24,
            pady=11,
        ).pack(side="left")
        tk.Button(
            self.cta,
            text="新建源程序",
            command=new_source,
            borderwidth=1,
            relief="solid",
            bg="#1763BF",
            fg="#FFFFFF",
            activebackground="#2D74C9",
            activeforeground="#FFFFFF",
            font=("Microsoft YaHei UI", adaptive_font_size(self, 11), "bold"),
            cursor="hand2",
            padx=24,
            pady=10,
        ).pack(side="left", padx=(14, 0))

        self.pipeline = tk.Frame(
            self,
            bg="#FFFFFF",
            highlightthickness=1,
            highlightbackground="#C9DDF4",
        )
        tk.Label(
            self.pipeline,
            text="一遍式编译流程",
            bg="#FFFFFF",
            fg=COLORS["navy"],
            font=("Microsoft YaHei UI", adaptive_font_size(self, 15), "bold"),
        ).pack(anchor="w", padx=24, pady=(22, 5))
        tk.Label(
            self.pipeline,
            text="语法分析器按需驱动词法分析；每完成一个函数，立即生成该函数的中间代码。",
            bg="#FFFFFF",
            fg=COLORS["muted"],
            font=("Microsoft YaHei UI", adaptive_font_size(self, 9)),
            justify="left",
            wraplength=370,
        ).pack(anchor="w", padx=24)
        flow = tk.Frame(self.pipeline, bg="#FFFFFF")
        flow.pack(fill="x", padx=24, pady=20)
        stages = (
            ("01", "源码", "编辑/示例"),
            ("02", "按需分析", "Lexer + Parser"),
            ("03", "四元式", "函数级生成"),
            ("04", "语义检查", "类型/借用"),
            ("05", "x86-64", "目标汇编"),
        )
        for number, title, detail in stages:
            row = tk.Frame(flow, bg="#FFFFFF")
            row.pack(fill="x", pady=4)
            tk.Label(
                row,
                text=number,
                bg=COLORS["blue_light"],
                fg=COLORS["blue"],
                font=("Segoe UI", adaptive_font_size(self, 9), "bold"),
                width=3,
                pady=4,
            ).pack(side="left")
            tk.Label(
                row,
                text=title,
                bg="#FFFFFF",
                fg=COLORS["text"],
                font=("Microsoft YaHei UI", adaptive_font_size(self, 10), "bold"),
                width=10,
                anchor="w",
            ).pack(side="left", padx=(12, 0))
            tk.Label(
                row,
                text=detail,
                bg="#FFFFFF",
                fg=COLORS["muted"],
                font=("Microsoft YaHei UI", adaptive_font_size(self, 9)),
            ).pack(side="left")

        self.cards = (
            FeatureCard(
                self,
                "综合功能演示",
                "函数、循环、数组、元组、借用与表达式，目标程序返回 42。",
                "打开综合示例",
                lambda: open_example("course_full.rs"),
            ),
            FeatureCard(
                self,
                "从最小程序开始",
                "载入短小的正确程序，适合现场修改并观察结果同步变化。",
                "打开基础示例",
                lambda: open_example("ok_minimal.rs"),
            ),
            FeatureCard(
                self,
                "错误定位演示",
                "载入缺少分号的示例，查看行列、源码行和插入符诊断。",
                "打开错误示例",
                lambda: open_example("err_parse.rs"),
            ),
        )
        self.bind("<Configure>", self._layout, add="+")

    def _layout(self, event) -> None:
        width, height = max(event.width, 2), max(event.height, 2)
        self.canvas.delete("art")
        step = 5
        for x in range(0, width, step):
            ratio = min(1.0, x / max(width - 1, 1))
            if ratio < 0.58:
                color = _mix_color("#0B55B8", "#3A83DF", ratio / 0.58)
            else:
                color = _mix_color("#3A83DF", "#F4F9FF", (ratio - 0.58) / 0.42)
            self.canvas.create_rectangle(
                x, 0, min(x + step, width), height, fill=color, outline=color, tags="art"
            )

        self.canvas.create_text(
            70,
            36,
            anchor="w",
            text="RUST-LIKE COMPILER  ·  COURSE DESIGN",
            fill="#EAF4FF",
            font=("Segoe UI", adaptive_font_size(self, 10), "bold"),
            tags="art",
        )
        self.canvas.create_text(
            70,
            135,
            anchor="nw",
            text="类 Rust 一遍式编译器\n可视化演示器",
            fill="#FFFFFF",
            font=("Microsoft YaHei UI", adaptive_font_size(self, 30, minimum=18), "bold"),
            justify="left",
            tags="art",
        )
        self.canvas.create_text(
            72,
            255,
            anchor="nw",
            width=min(510, int(width * 0.39)),
            text="输入或载入类 Rust 源程序，编辑停顿后自动完成词法、语法、语义、四元式与 x86-64 目标代码展示。",
            fill="#DDEEFF",
            font=("Microsoft YaHei UI", adaptive_font_size(self, 11)),
            justify="left",
            tags="art",
        )

        self.workspace_button.place(x=width - 205, y=24, width=155, height=42)
        self.tags.place(x=70, y=322, height=34)
        self.cta.place(x=70, y=377, height=49)

        pipeline_width = min(450, max(390, int(width * 0.34)))
        self.pipeline.place(
            x=width - pipeline_width - 62,
            y=112,
            width=pipeline_width,
            height=335,
        )

        card_gap = 18
        margin = 62
        card_width = max(250, (width - margin * 2 - card_gap * 2) // 3)
        card_y = max(500, height - 190)
        card_height = max(145, height - card_y - 34)
        for index, card in enumerate(self.cards):
            card.place(
                x=margin + index * (card_width + card_gap),
                y=card_y,
                width=card_width,
                height=card_height,
            )


class CompilerWorkbench(tk.Frame):
    STAGES = ("词法 · Token", "语法 · 函数", "IR · 四元式", "语义 · 检查", "x86-64 · 汇编")

    def __init__(self, master, show_home, show_workspace) -> None:
        super().__init__(master, bg=COLORS["canvas"])
        self.show_home = show_home
        self.show_workspace = show_workspace
        self.current_file: Path | None = None
        self.dirty = False
        self.last_result: CompilationResult | None = None
        self.last_view: CompilationView | None = None
        self.last_compiled_source: str | None = None
        self.source_revision = 0
        self.auto_job: str | None = None
        self._setting_source = False
        self._compiled_once = False
        self.run_in_progress = False
        self._closing = threading.Event()
        self._process_lock = threading.Lock()
        self._active_process: subprocess.Popen | None = None
        self.run_queue: queue.Queue = queue.Queue()
        self.examples, self.labels_by_relative = discover_examples()

        self._build_header()
        self._build_toolbar()
        self._build_statusbar()
        self._build_content()
        self._bind_shortcuts()
        self._set_empty_outputs("输入源码或从上方载入示例，结果会自动显示在这里。")
        self.poll_job: str | None = self.after(100, self._poll_run_queue)

    def _build_header(self) -> None:
        header = tk.Frame(self, bg="#0D5ABC", height=74)
        header.pack(fill="x")
        header.pack_propagate(False)
        tk.Button(
            header,
            text="‹  首页",
            command=self.show_home,
            borderwidth=0,
            bg="#0D5ABC",
            fg="#E9F3FF",
            activebackground="#246EC5",
            activeforeground="#FFFFFF",
            font=("Microsoft YaHei UI", adaptive_font_size(self, 10), "bold"),
            cursor="hand2",
            padx=16,
            pady=8,
        ).pack(side="left", padx=(18, 8))
        tk.Frame(header, bg="#74A8E6", width=1, height=42).pack(side="left", padx=(0, 18))
        titles = tk.Frame(header, bg="#0D5ABC")
        titles.pack(side="left", pady=9)
        tk.Label(
            titles,
            text=APP_NAME,
            bg="#0D5ABC",
            fg="#FFFFFF",
            font=("Microsoft YaHei UI", adaptive_font_size(self, 16), "bold"),
        ).pack(anchor="w")
        self.source_title = tk.Label(
            titles,
            text="未命名源程序 · 自动编译已开启",
            bg="#0D5ABC",
            fg="#CFE4FF",
            font=("Microsoft YaHei UI", adaptive_font_size(self, 9)),
        )
        self.source_title.pack(anchor="w", pady=(2, 0))
        self.header_status = tk.Label(
            header,
            text="等待源码",
            bg="#E8F2FF",
            fg=COLORS["blue_dark"],
            font=("Microsoft YaHei UI", adaptive_font_size(self, 9), "bold"),
            padx=15,
            pady=8,
        )
        self.header_status.pack(side="right", padx=24)

    def _build_toolbar(self) -> None:
        toolbar = tk.Frame(
            self,
            bg=COLORS["card"],
            height=96,
            highlightthickness=1,
            highlightbackground=COLORS["border"],
        )
        toolbar.pack(fill="x", padx=20, pady=(14, 10))
        toolbar.pack_propagate(False)

        top_row = tk.Frame(toolbar, bg=COLORS["card"], height=48)
        top_row.pack(fill="x")
        top_row.pack_propagate(False)
        bottom_row = tk.Frame(toolbar, bg=COLORS["card"], height=48)
        bottom_row.pack(fill="x")
        bottom_row.pack_propagate(False)

        left = tk.Frame(top_row, bg=COLORS["card"])
        left.pack(side="left", fill="y", padx=14)
        tk.Label(
            left,
            text="示例",
            bg=COLORS["card"],
            fg=COLORS["muted"],
            font=("Microsoft YaHei UI", 9, "bold"),
        ).pack(side="left", padx=(0, 8))
        self.example_var = tk.StringVar()
        values = list(self.examples)
        self.example_combo = ttk.Combobox(
            left,
            textvariable=self.example_var,
            values=values,
            state="readonly",
            width=29,
            style="Demo.TCombobox",
        )
        self.example_combo.pack(side="left", pady=7)
        if values:
            self.example_var.set(self.labels_by_relative.get("course_full.rs", values[0]))
        ttk.Button(left, text="载入", command=self.load_selected_example).pack(
            side="left", padx=(8, 16), pady=6
        )
        ttk.Button(left, text="新建", command=self.new_source).pack(side="left", padx=3, pady=6)
        ttk.Button(left, text="打开", command=self.open_source).pack(side="left", padx=3, pady=6)
        ttk.Button(left, text="保存", command=self.save_source).pack(side="left", padx=3, pady=6)

        tk.Label(
            bottom_row,
            text="编辑停顿 0.5 秒后自动刷新全部编译结果",
            bg=COLORS["card"],
            fg=COLORS["muted"],
            font=("Microsoft YaHei UI", 8),
        ).pack(side="left", padx=16)
        actions = tk.Frame(bottom_row, bg=COLORS["card"])
        actions.pack(side="right", fill="y", padx=14)
        self.auto_var = tk.BooleanVar(value=True)
        ttk.Checkbutton(
            actions,
            text="实时分析",
            variable=self.auto_var,
            command=self._toggle_auto_compile,
        ).pack(side="left", padx=(0, 10), pady=10)
        ttk.Button(actions, text="导出 IR / 汇编", command=self.export_outputs).pack(
            side="left", padx=3, pady=6
        )
        ttk.Button(
            actions,
            text="立即编译  F5",
            style="Primary.TButton",
            command=lambda: self.compile_now(manual=True),
        ).pack(side="left", padx=3, pady=6)
        self.run_button = ttk.Button(
            actions,
            text="编译并运行",
            style="Run.TButton",
            command=self.compile_and_run,
        )
        self.run_button.pack(side="left", padx=(3, 0), pady=6)

    def _build_content(self) -> None:
        content = ttk.Panedwindow(self, orient="horizontal", style="Demo.TPanedwindow")
        content.pack(fill="both", expand=True, padx=20, pady=(0, 10))
        self.content_pane = content
        self._sash_initialized = False
        self._sash_job: str | None = None
        content.bind("<Configure>", self._schedule_initial_sash, add="+")

        editor_card = tk.Frame(
            content,
            bg=COLORS["card"],
            highlightthickness=1,
            highlightbackground=COLORS["border"],
        )
        analysis_card = tk.Frame(
            content,
            bg=COLORS["card"],
            highlightthickness=1,
            highlightbackground=COLORS["border"],
        )
        content.add(editor_card, weight=46)
        content.add(analysis_card, weight=54)

        editor_head = tk.Frame(editor_card, bg=COLORS["card"], height=48)
        editor_head.pack(fill="x")
        editor_head.pack_propagate(False)
        tk.Label(
            editor_head,
            text="源程序编辑器",
            bg=COLORS["card"],
            fg=COLORS["navy"],
            font=("Microsoft YaHei UI", 11, "bold"),
        ).pack(side="left", padx=16)
        self.cursor_label = tk.Label(
            editor_head,
            text="行 1，列 1",
            bg=COLORS["card"],
            fg=COLORS["muted"],
            font=("Microsoft YaHei UI", 9),
        )
        self.cursor_label.pack(side="right", padx=16)
        tk.Frame(editor_card, bg=COLORS["border"], height=1).pack(fill="x")
        self.editor = CodeEditor(editor_card, self._source_changed, self._cursor_changed)
        self.editor.pack(fill="both", expand=True)

        result_head = tk.Frame(analysis_card, bg=COLORS["card"], height=48)
        result_head.pack(fill="x")
        result_head.pack_propagate(False)
        tk.Label(
            result_head,
            text="编译过程与结果",
            bg=COLORS["card"],
            fg=COLORS["navy"],
            font=("Microsoft YaHei UI", 11, "bold"),
        ).pack(side="left", padx=16)
        ttk.Button(result_head, text="复制当前页", command=self.copy_current_output).pack(
            side="right", padx=12, pady=9
        )

        self.metrics_frame = tk.Frame(analysis_card, bg=COLORS["card"])
        self.metrics_frame.pack(fill="x", padx=12, pady=(0, 10))
        self.metric_cards: list[tuple[tk.Frame, tk.Label, tk.Label]] = []
        for index, title in enumerate(self.STAGES):
            frame = tk.Frame(
                self.metrics_frame,
                bg="#F7FAFE",
                highlightthickness=1,
                highlightbackground=COLORS["border"],
            )
            frame.grid(row=0, column=index, sticky="ew", padx=3)
            value = tk.Label(
                frame,
                text="—",
                bg="#F7FAFE",
                fg=COLORS["muted"],
                font=("Segoe UI", 12, "bold"),
            )
            value.pack(pady=(7, 0))
            caption = tk.Label(
                frame,
                text=title,
                bg="#F7FAFE",
                fg=COLORS["muted"],
                font=("Microsoft YaHei UI", 8),
            )
            caption.pack(pady=(0, 7))
            self.metrics_frame.grid_columnconfigure(index, weight=1)
            self.metric_cards.append((frame, value, caption))

        self.notebook = ttk.Notebook(analysis_card, style="Demo.TNotebook")
        self.notebook.pack(fill="both", expand=True, padx=12, pady=(0, 12))
        self.output_panes = {
            "tokens": OutputPane(self.notebook),
            "ast": OutputPane(self.notebook),
            "ir": OutputPane(self.notebook),
            "assembly": OutputPane(self.notebook),
            "diagnostics": OutputPane(self.notebook, wrap="word"),
        }
        self.tab_order = ("tokens", "ast", "ir", "assembly", "diagnostics")
        tab_titles = ("Token", "AST", "四元式 IR", "x86-64", "诊断 / 语义")
        for key, title in zip(self.tab_order, tab_titles):
            self.notebook.add(self.output_panes[key], text=title)
        self.notebook.select(self.output_panes["ir"])

    def _build_statusbar(self) -> None:
        status = tk.Frame(self, bg="#E2ECF8", height=28)
        status.pack(fill="x", side="bottom")
        status.pack_propagate(False)
        self.status_var = tk.StringVar(value="就绪 · F5 编译 · Ctrl+Enter 编译 · F6 运行")
        tk.Label(
            status,
            textvariable=self.status_var,
            bg="#E2ECF8",
            fg="#50657F",
            font=("Microsoft YaHei UI", 8),
        ).pack(side="left", padx=16)
        tk.Label(
            status,
            text="一遍式 · 四元式 · Windows x86-64",
            bg="#E2ECF8",
            fg="#6B7F98",
            font=("Microsoft YaHei UI", 8),
        ).pack(side="right", padx=16)
        self.status_bar = status

    def _schedule_initial_sash(self, _event=None) -> None:
        if self._sash_initialized:
            return
        if self._sash_job is not None:
            self.after_cancel(self._sash_job)
        self._sash_job = self.after(60, self._position_initial_sash)

    def _position_initial_sash(self) -> None:
        self._sash_job = None
        if self._sash_initialized:
            return
        width = self.content_pane.winfo_width()
        if width > 200:
            self.content_pane.sashpos(0, int(width * 0.46))
            self._sash_initialized = True

    def _bind_shortcuts(self) -> None:
        root = self.winfo_toplevel()
        root.bind("<F5>", lambda _event: self.compile_now(manual=True), add="+")
        root.bind("<F6>", lambda _event: self.compile_and_run(), add="+")
        root.bind("<Control-Return>", lambda _event: self.compile_now(manual=True), add="+")
        root.bind("<Control-o>", lambda _event: self.open_source(), add="+")
        root.bind("<Control-s>", lambda _event: self.save_source(), add="+")
        root.bind("<Control-n>", lambda _event: self.new_source(), add="+")

    def _set_header_status(self, text: str, level: str = "idle") -> None:
        palettes = {
            "idle": (COLORS["blue_light"], COLORS["blue_dark"]),
            "working": (COLORS["warning_bg"], COLORS["warning"]),
            "success": (COLORS["success_bg"], COLORS["success"]),
            "error": (COLORS["error_bg"], COLORS["error"]),
        }
        background, foreground = palettes[level]
        self.header_status.configure(text=text, bg=background, fg=foreground)

    def _set_stage(self, index: int, state: str, value_text: str) -> None:
        frame, value, caption = self.metric_cards[index]
        palettes = {
            "idle": ("#F7FAFE", COLORS["border"], COLORS["muted"]),
            "working": (COLORS["warning_bg"], "#F1D39A", COLORS["warning"]),
            "success": (COLORS["success_bg"], "#B7E3D0", COLORS["success"]),
            "error": (COLORS["error_bg"], "#F0BDC5", COLORS["error"]),
        }
        background, border, foreground = palettes[state]
        frame.configure(bg=background, highlightbackground=border)
        value.configure(text=value_text, bg=background, fg=foreground)
        caption.configure(bg=background, fg=foreground)

    def _set_all_stages(self, state: str = "idle", value: str = "—") -> None:
        for index in range(len(self.metric_cards)):
            self._set_stage(index, state, value)

    def _source_changed(self) -> None:
        if self._setting_source:
            return
        self.source_revision += 1
        self.dirty = True
        self.last_result = None
        self.last_view = None
        self.last_compiled_source = None
        self.editor.clear_error()
        self._refresh_source_title()
        self._set_header_status("源码已修改", "working")
        self._set_all_stages("idle", "待分析")
        self._set_empty_outputs(
            "源码已修改，等待本次分析；旧结果已清除。",
            state_label="待分析",
        )
        self.status_var.set("源码已修改 · 停止输入后自动编译")
        if self.auto_var.get():
            self._schedule_auto_compile()

    def _cursor_changed(self) -> None:
        line, column = self.editor.cursor_position()
        self.cursor_label.configure(text=f"行 {line}，列 {column}")

    def _schedule_auto_compile(self) -> None:
        if self.auto_job is not None:
            self.after_cancel(self.auto_job)
        self.auto_job = self.after(AUTO_COMPILE_DELAY_MS, self._auto_compile)

    def _auto_compile(self) -> None:
        self.auto_job = None
        self.compile_now(manual=False)

    def _toggle_auto_compile(self) -> None:
        self._refresh_source_title()
        if self.auto_var.get() and self.last_compiled_source != self.editor.get():
            self._schedule_auto_compile()
        elif not self.auto_var.get() and self.auto_job is not None:
            self.after_cancel(self.auto_job)
            self.auto_job = None

    def _refresh_source_title(self) -> None:
        name = self.current_file.name if self.current_file else "未命名源程序"
        dirty = " *" if self.dirty else ""
        auto = "自动编译已开启" if self.auto_var.get() else "自动编译已关闭"
        self.source_title.configure(text=f"{name}{dirty} · {auto}")
        self.winfo_toplevel().title(f"{name}{dirty} - {APP_NAME}")

    def set_source(
        self,
        source: str,
        *,
        file_path: Path | None = None,
        dirty: bool = False,
        compile_after: bool = True,
    ) -> None:
        if self.auto_job is not None:
            self.after_cancel(self.auto_job)
            self.auto_job = None
        self._setting_source = True
        self.editor.set(source)
        self._setting_source = False
        self.source_revision += 1
        self.current_file = file_path
        self.dirty = dirty
        self.last_result = None
        self.last_view = None
        self.last_compiled_source = None
        self._refresh_source_title()
        self._cursor_changed()
        if compile_after:
            self.after_idle(lambda: self.compile_now(manual=False))
        self.editor.focus()

    def compile_now(self, *, manual: bool = False) -> bool:
        if self.auto_job is not None:
            self.after_cancel(self.auto_job)
            self.auto_job = None
        source = self.editor.get()
        if not source.strip():
            self.last_result = None
            self.last_view = None
            self.last_compiled_source = None
            self._set_header_status("等待源码")
            self._set_all_stages()
            self._set_empty_outputs("编辑器为空。请输入类 Rust 源程序后再编译。")
            return False

        self._set_header_status("正在分析…", "working")
        self._set_all_stages("working", "分析中")
        self.status_var.set("正在执行按需词法、递归下降语法与代码生成…")
        self.update_idletasks()
        started = time.perf_counter()
        try:
            result = Compiler().compile(source)
            view = make_compilation_view(result)
        except CompilerError as error:
            elapsed_ms = (time.perf_counter() - started) * 1000
            self._apply_compile_error(classify_error(error), elapsed_ms)
            return False
        except Exception as error:  # Keep the GUI alive for unexpected integration failures.
            elapsed_ms = (time.perf_counter() - started) * 1000
            unexpected = ErrorView("编译器内部", 0, None, None, f"{type(error).__name__}: {error}")
            self._apply_compile_error(unexpected, elapsed_ms)
            return False

        elapsed_ms = (time.perf_counter() - started) * 1000
        self.last_result = result
        self.last_view = view
        self.last_compiled_source = source
        self.editor.clear_error()
        self._apply_compile_success(view, elapsed_ms, manual)
        return True

    def _apply_compile_success(
        self, view: CompilationView, elapsed_ms: float, manual: bool
    ) -> None:
        self.output_panes["tokens"].set_text(view.tokens)
        self.output_panes["ast"].set_text(view.ast)
        self.output_panes["ir"].set_text(view.ir)
        self.output_panes["assembly"].set_text(view.assembly)
        source_name = self.current_file.name if self.current_file else "编辑器内存源码"
        mode = "手动编译" if manual else "实时分析"
        body = (
            "按需词法、递归下降语法、语义检查、四元式生成和 x86-64 目标代码生成均已完成。\n\n"
            f"分析方式：{mode}\n"
            f"源码：{source_name}\n"
            f"耗时：{elapsed_ms:.2f} ms\n"
            f"可见 Token：{view.token_count}\n"
            f"函数：{view.function_count}\n"
            f"四元式：{view.quad_count}\n"
            f"汇编行：{view.assembly_line_count}\n\n"
            "提示：修改左侧源码并停顿约 0.5 秒，所有结果会同步刷新；点击“编译并运行”可调用 GCC 验证目标程序退出码。"
        )
        self.output_panes["diagnostics"].set_message("编译成功", body, "success")
        self.notebook.tab(self.output_panes["tokens"], text=f"Token · {view.token_count}")
        self.notebook.tab(self.output_panes["ast"], text=f"AST · {view.function_count}")
        self.notebook.tab(self.output_panes["ir"], text=f"IR · {view.quad_count}")
        self.notebook.tab(
            self.output_panes["assembly"], text=f"x86-64 · {view.assembly_line_count}"
        )
        self.notebook.tab(self.output_panes["diagnostics"], text="诊断 / 语义 · 通过")
        values = (
            str(view.token_count),
            str(view.function_count),
            str(view.quad_count),
            "通过",
            str(view.assembly_line_count),
        )
        for index, value in enumerate(values):
            self._set_stage(index, "success", value)
        self._set_header_status("编译通过", "success")
        self.status_var.set(
            f"编译通过 · {elapsed_ms:.2f} ms · {view.token_count} Token · "
            f"{view.quad_count} 四元式 · {view.assembly_line_count} 汇编行"
        )
        if not self._compiled_once:
            self.notebook.select(self.output_panes["ir"])
            self._compiled_once = True

    def _apply_compile_error(self, error: ErrorView, elapsed_ms: float) -> None:
        self.last_result = None
        self.last_view = None
        self.last_compiled_source = None
        self.editor.show_error(error.line, error.column)
        for index in range(len(self.metric_cards)):
            if index < error.stage_index:
                self._set_stage(index, "success", "通过")
            elif index == error.stage_index:
                self._set_stage(index, "error", "失败")
            else:
                self._set_stage(index, "idle", "未生成")
        if error.stage_index >= 3:
            empty_message = (
                f"本次编译在“{error.stage_name}”阶段失败。上游中间代码已经生成，"
                "但一体化 API 在后续阶段失败时不返回部分结果，因此本次结果已丢弃；旧结果也已清除。"
            )
        else:
            empty_message = (
                f"本次编译在“{error.stage_name}”阶段失败，未返回可展示结果。"
                "旧结果已清除，请修复源码后重试。"
            )
        self._set_empty_outputs(empty_message, diagnostics=False)
        location = ""
        if error.line is not None:
            location = f"\n位置：第 {error.line} 行"
            if error.column is not None:
                location += f"，第 {error.column} 列"
        body = (
            f"失败阶段：{error.stage_name}{location}\n"
            f"耗时：{elapsed_ms:.2f} ms\n\n"
            f"{error.message}\n\n"
            "修复左侧源码后，实时分析会自动重新运行。"
        )
        self.output_panes["diagnostics"].set_message("编译失败", body, "error")
        self.notebook.tab(self.output_panes["tokens"], text="Token")
        self.notebook.tab(self.output_panes["ast"], text="AST")
        self.notebook.tab(self.output_panes["ir"], text="IR · 未生成")
        self.notebook.tab(self.output_panes["assembly"], text="x86-64 · 未生成")
        self.notebook.tab(self.output_panes["diagnostics"], text="诊断 / 语义 · 失败")
        self.notebook.select(self.output_panes["diagnostics"])
        self._set_header_status(f"{error.stage_name}失败", "error")
        self.status_var.set(f"编译失败 · {error.stage_name} · {elapsed_ms:.2f} ms")

    def _set_empty_outputs(
        self,
        message: str,
        *,
        diagnostics: bool = True,
        state_label: str | None = None,
    ) -> None:
        for key in ("tokens", "ast", "ir", "assembly"):
            self.output_panes[key].set_message("暂无本次结果", message, "muted")
        suffix = f" · {state_label}" if state_label else ""
        self.notebook.tab(self.output_panes["tokens"], text="Token" + suffix)
        self.notebook.tab(self.output_panes["ast"], text="AST" + suffix)
        self.notebook.tab(self.output_panes["ir"], text="IR" + suffix)
        self.notebook.tab(self.output_panes["assembly"], text="x86-64" + suffix)
        self.notebook.tab(self.output_panes["diagnostics"], text="诊断 / 语义" + suffix)
        if diagnostics:
            self.output_panes["diagnostics"].set_message(
                "等待分析" if state_label else "准备就绪",
                message + "\n\n快捷键：F5 / Ctrl+Enter 编译，F6 编译并运行，Ctrl+O 打开，Ctrl+S 保存。",
                "muted",
            )

    def copy_current_output(self) -> None:
        current = self.notebook.select()
        for pane in self.output_panes.values():
            if str(pane) == current:
                pane.copy_all()
                self.status_var.set("当前结果已复制到剪贴板")
                return

    def _confirm_replace(self) -> bool:
        if not self.dirty:
            return True
        answer = messagebox.askyesnocancel(
            "源码尚未保存",
            "当前源码有未保存的修改。是否先保存？",
            parent=self.winfo_toplevel(),
        )
        if answer is None:
            return False
        if answer:
            return self.save_source()
        return True

    def new_source(self) -> bool:
        if not self._confirm_replace():
            return False
        self.show_workspace()
        self.set_source(DEFAULT_SOURCE, file_path=None, dirty=False)
        return True

    def load_selected_example(self) -> bool:
        label = self.example_var.get()
        path = self.examples.get(label)
        if path is None:
            messagebox.showwarning("没有可用示例", "未找到所选示例资源。", parent=self)
            return False
        if not self._confirm_replace():
            return False
        try:
            source = path.read_text(encoding="utf-8")
        except OSError as error:
            messagebox.showerror("读取失败", str(error), parent=self)
            return False
        self.show_workspace()
        self.set_source(source, file_path=None, dirty=False)
        return True

    def open_example_by_relative(self, relative_path: str) -> bool:
        label = self.labels_by_relative.get(relative_path)
        if label is None:
            if relative_path == "course_full.rs":
                if not self._confirm_replace():
                    return False
                self.show_workspace()
                self.set_source(DEFAULT_SOURCE, file_path=None, dirty=False)
                return True
            messagebox.showwarning("没有可用示例", f"未找到 {relative_path}。", parent=self)
            return False
        self.example_var.set(label)
        return self.load_selected_example()

    def open_source(self) -> bool:
        if not self._confirm_replace():
            return False
        file_name = filedialog.askopenfilename(
            title="打开类 Rust 源程序",
            filetypes=(("类 Rust 源程序", "*.rs"), ("文本文件", "*.txt"), ("所有文件", "*.*")),
            parent=self.winfo_toplevel(),
        )
        if not file_name:
            return False
        return self.load_path(Path(file_name))

    def load_path(self, path: Path) -> bool:
        try:
            source = path.read_text(encoding="utf-8-sig")
        except (OSError, UnicodeError) as error:
            messagebox.showerror("读取失败", f"无法读取源程序：\n{error}", parent=self)
            return False
        self.show_workspace()
        self.set_source(source, file_path=path, dirty=False)
        return True

    def save_source(self) -> bool:
        target = self.current_file
        if target is None:
            file_name = filedialog.asksaveasfilename(
                title="保存类 Rust 源程序",
                defaultextension=".rs",
                filetypes=(("类 Rust 源程序", "*.rs"), ("所有文件", "*.*")),
                parent=self.winfo_toplevel(),
            )
            if not file_name:
                return False
            target = Path(file_name)
        try:
            target.write_text(self.editor.get(), encoding="utf-8")
        except OSError as error:
            messagebox.showerror("保存失败", str(error), parent=self)
            return False
        self.current_file = target
        self.dirty = False
        self._refresh_source_title()
        self.status_var.set(f"源码已保存：{target}")
        return True

    def export_outputs(self) -> None:
        if self.last_compiled_source != self.editor.get() and not self.compile_now(manual=True):
            return
        if self.last_result is None:
            return
        directory = filedialog.askdirectory(title="选择 IR 与汇编输出目录", parent=self)
        if not directory:
            return
        source_path = self.current_file or Path("rust_like_demo.rs")
        try:
            ir_path, asm_path = write_outputs(self.last_result, source_path, Path(directory))
        except OSError as error:
            messagebox.showerror("导出失败", str(error), parent=self)
            return
        self.status_var.set(f"已导出：{ir_path.name}、{asm_path.name}")
        messagebox.showinfo(
            "导出完成",
            f"四元式：{ir_path}\n目标汇编：{asm_path}",
            parent=self,
        )

    @staticmethod
    def _find_gcc() -> str | None:
        gcc = shutil.which("gcc")
        if gcc:
            return gcc
        candidates = (
            Path("C:/msys64/mingw64/bin/gcc.exe"),
            Path("C:/msys64/ucrt64/bin/gcc.exe"),
            Path("D:/msys2/mingw64/bin/gcc.exe"),
            Path("D:/msys2/ucrt64/bin/gcc.exe"),
        )
        return str(next((path for path in candidates if path.exists()), "")) or None

    def compile_and_run(self) -> None:
        if self.run_in_progress:
            self.status_var.set("已有目标程序正在汇编或运行，请稍候")
            return
        if self.last_compiled_source != self.editor.get() and not self.compile_now(manual=True):
            return
        if self.last_result is None:
            return
        gcc = self._find_gcc()
        if gcc is None:
            self.output_panes["diagnostics"].set_message(
                "未找到 GCC",
                "可视化编译已经完成，IR 与目标汇编仍可正常查看。\n\n"
                "若要生成并运行目标程序，请安装 MSYS2/MinGW-w64 GCC，并确保 gcc.exe 位于 PATH。",
                "warning",
            )
            self.notebook.select(self.output_panes["diagnostics"])
            self.status_var.set("未找到 GCC · 仍可查看 IR 与目标代码")
            return

        revision = self.source_revision
        assembly = self.last_result.assembly
        self.run_in_progress = True
        self.run_button.configure(state="disabled")
        self._set_header_status("正在汇编并运行…", "working")
        self.output_panes["diagnostics"].set_message(
            "正在汇编并运行",
            f"GCC：{gcc}\n正在生成临时目标程序，请稍候…",
            "warning",
        )
        self.notebook.select(self.output_panes["diagnostics"])
        threading.Thread(
            target=self._run_target,
            args=(revision, gcc, assembly),
            daemon=False,
        ).start()

    def _execute_process(
        self,
        arguments: list[str],
        *,
        timeout: float,
        creation_flags: int,
    ) -> subprocess.CompletedProcess:
        with self._process_lock:
            if self._closing.is_set():
                raise RuntimeError("应用程序正在关闭")
            process = subprocess.Popen(
                arguments,
                stdout=subprocess.PIPE,
                stderr=subprocess.PIPE,
                text=True,
                encoding="utf-8",
                errors="replace",
                creationflags=creation_flags,
            )
            self._active_process = process
        try:
            stdout, stderr = process.communicate(timeout=timeout)
        except subprocess.TimeoutExpired:
            process.kill()
            stdout, stderr = process.communicate()
            raise subprocess.TimeoutExpired(arguments, timeout, stdout, stderr)
        finally:
            with self._process_lock:
                if self._active_process is process:
                    self._active_process = None
        return subprocess.CompletedProcess(arguments, process.returncode, stdout, stderr)

    def _run_target(self, revision: int, gcc: str, assembly: str) -> None:
        creation_flags = subprocess.CREATE_NO_WINDOW if os.name == "nt" else 0
        try:
            with tempfile.TemporaryDirectory(prefix="rust_like_gui_") as temp_dir:
                directory = Path(temp_dir)
                asm_path = directory / "demo.s"
                exe_path = directory / "demo.exe"
                asm_path.write_text(assembly, encoding="utf-8")
                build = self._execute_process(
                    [gcc, str(asm_path), "-o", str(exe_path)],
                    timeout=30,
                    creation_flags=creation_flags,
                )
                if build.returncode != 0:
                    self.run_queue.put((revision, False, "GCC 汇编或链接失败", build.stdout, build.stderr, None))
                    return
                target = self._execute_process(
                    [str(exe_path)],
                    timeout=10,
                    creation_flags=creation_flags,
                )
                self.run_queue.put(
                    (
                        revision,
                        True,
                        "目标程序运行完成",
                        target.stdout,
                        target.stderr,
                        target.returncode,
                    )
                )
        except (OSError, RuntimeError, subprocess.SubprocessError) as error:
            self.run_queue.put((revision, False, "运行目标程序失败", "", str(error), None))

    def _poll_run_queue(self) -> None:
        self.poll_job = None
        try:
            while True:
                outcome = self.run_queue.get_nowait()
                self._apply_run_outcome(*outcome)
        except queue.Empty:
            pass
        if self.winfo_exists() and not self._closing.is_set():
            self.poll_job = self.after(100, self._poll_run_queue)

    def _apply_run_outcome(
        self,
        revision: int,
        success: bool,
        title: str,
        stdout: str,
        stderr: str,
        exit_code: int | None,
    ) -> None:
        self.run_in_progress = False
        self.run_button.configure(state="normal")
        if revision != self.source_revision:
            self.status_var.set("先前源码版本的目标程序已运行完成；当前结果未被覆盖")
            return
        details = []
        if exit_code is not None:
            details.append(f"退出码：{exit_code}")
        details.append("\n标准输出：\n" + (stdout.strip() or "<无输出>"))
        details.append("\n标准错误：\n" + (stderr.strip() or "<无输出>"))
        level = "success" if success else "error"
        self.output_panes["diagnostics"].set_message(title, "\n".join(details), level)
        self.notebook.select(self.output_panes["diagnostics"])
        if success:
            self._set_header_status(f"运行完成 · 退出码 {exit_code}", "success")
            self.status_var.set(f"目标程序运行完成 · 退出码 {exit_code}")
        else:
            self._set_header_status("目标程序运行失败", "error")
            self.status_var.set(title)

    def confirm_close(self) -> bool:
        if not self._confirm_replace():
            return False
        self._closing.set()
        for attribute in ("auto_job", "_sash_job", "poll_job"):
            job = getattr(self, attribute, None)
            if job is not None:
                try:
                    self.after_cancel(job)
                except tk.TclError:
                    pass
                setattr(self, attribute, None)
        with self._process_lock:
            process = self._active_process
        if process is not None and process.poll() is None:
            process.kill()
        return True


class CompilerDemoApp:
    def __init__(self, root: tk.Tk) -> None:
        self.root = root
        self._configure_root()
        self.container = tk.Frame(root, bg=COLORS["canvas"])
        self.container.pack(fill="both", expand=True)
        self.workbench = CompilerWorkbench(
            self.container,
            show_home=self.show_home,
            show_workspace=self.show_workspace,
        )
        self.home = HomePage(
            self.container,
            open_example=self.open_example,
            new_source=self.new_source,
            open_workspace=self.open_workspace,
        )
        self.current_page = ""
        self.show_home()
        self.root.protocol("WM_DELETE_WINDOW", self.close)

    def _configure_root(self) -> None:
        self.root.configure(bg=COLORS["canvas"])
        self.root.option_add("*Font", ("Microsoft YaHei UI", 9))
        self.root.option_add("*tearOff", False)
        left, top, right, bottom = get_work_area(self.root)
        work_width = right - left
        work_height = bottom - top
        minimum_width = min(1050, max(900, work_width - 20))
        minimum_height = min(640, max(600, work_height - 20))
        width = min(1480, max(minimum_width, work_width - 40))
        height = min(900, max(minimum_height, work_height - 40))
        x = left + max(0, (work_width - width) // 2)
        y = top + max(0, (work_height - height) // 2)
        self.root.geometry(f"{width}x{height}+{x}+{y}")
        self.root.minsize(minimum_width, minimum_height)
        self.root.title(APP_NAME)

        icon_path = resource_path("assets", "compiler.png")
        if icon_path.exists():
            try:
                self._icon = tk.PhotoImage(file=str(icon_path))
                self.root.iconphoto(True, self._icon)
            except tk.TclError:
                self._icon = None

        style = ttk.Style(self.root)
        style.theme_use("clam")
        style.configure(
            "TButton",
            background="#EDF4FC",
            foreground=COLORS["navy"],
            bordercolor="#C8D9EC",
            lightcolor="#EDF4FC",
            darkcolor="#EDF4FC",
            padding=(11, 7),
            font=("Microsoft YaHei UI", 9),
        )
        style.map(
            "TButton",
            background=[("active", "#DDEBFA"), ("pressed", "#CFE2F7")],
        )
        style.configure(
            "Primary.TButton",
            background=COLORS["blue"],
            foreground="#FFFFFF",
            bordercolor=COLORS["blue"],
            lightcolor=COLORS["blue"],
            darkcolor=COLORS["blue"],
            font=("Microsoft YaHei UI", 9, "bold"),
        )
        style.map(
            "Primary.TButton",
            background=[("active", "#075ABF"), ("pressed", "#064B9D")],
            foreground=[("disabled", "#D9E5F4")],
        )
        style.configure(
            "Run.TButton",
            background="#087A9B",
            foreground="#FFFFFF",
            bordercolor="#087A9B",
            lightcolor="#087A9B",
            darkcolor="#087A9B",
            font=("Microsoft YaHei UI", 9, "bold"),
        )
        style.map(
            "Run.TButton",
            background=[("active", "#066C89"), ("pressed", "#055A72")],
        )
        style.configure(
            "Demo.TNotebook",
            background=COLORS["card"],
            bordercolor=COLORS["border"],
            tabmargins=(0, 0, 0, 0),
        )
        style.configure(
            "Demo.TNotebook.Tab",
            background="#EAF1F9",
            foreground="#52677F",
            padding=(12, 9),
            font=("Microsoft YaHei UI", 9),
            bordercolor=COLORS["border"],
        )
        style.map(
            "Demo.TNotebook.Tab",
            background=[("selected", "#FFFFFF"), ("active", "#F4F8FE")],
            foreground=[("selected", COLORS["blue_dark"])],
        )
        style.configure("Demo.TPanedwindow", background=COLORS["canvas"])
        style.configure("Demo.TCombobox", padding=5)

    def show_home(self) -> None:
        self.workbench.pack_forget()
        self.home.pack(fill="both", expand=True)
        self.current_page = "home"
        self.root.title(APP_NAME)

    def show_workspace(self) -> None:
        self.home.pack_forget()
        self.workbench.pack(fill="both", expand=True)
        self.current_page = "workspace"
        self.workbench._refresh_source_title()
        self.workbench.editor.focus()

    def open_workspace(self) -> None:
        self.show_workspace()
        if not self.workbench.editor.get().strip():
            self.workbench.new_source()

    def new_source(self) -> None:
        if self.workbench.new_source():
            self.show_workspace()

    def open_example(self, relative_path: str) -> None:
        if self.workbench.open_example_by_relative(relative_path):
            self.show_workspace()

    def load_initial_path(self, path: Path) -> bool:
        if self.workbench.load_path(path):
            self.show_workspace()
            return True
        return False

    def close(self) -> None:
        if self.workbench.confirm_close():
            self.root.destroy()


def enable_dpi_awareness() -> None:
    if os.name != "nt":
        return
    try:
        ctypes.windll.shcore.SetProcessDpiAwareness(2)
    except (AttributeError, OSError):
        try:
            ctypes.windll.user32.SetProcessDPIAware()
        except (AttributeError, OSError):
            pass


def get_work_area(root: tk.Tk) -> tuple[int, int, int, int]:
    """Return the usable desktop rectangle, excluding the Windows taskbar."""
    if os.name == "nt":
        class Rect(ctypes.Structure):
            _fields_ = (
                ("left", ctypes.c_long),
                ("top", ctypes.c_long),
                ("right", ctypes.c_long),
                ("bottom", ctypes.c_long),
            )

        rectangle = Rect()
        try:
            if ctypes.windll.user32.SystemParametersInfoW(
                0x0030, 0, ctypes.byref(rectangle), 0
            ):
                return rectangle.left, rectangle.top, rectangle.right, rectangle.bottom
        except (AttributeError, OSError):
            pass
    return 0, 0, root.winfo_screenwidth(), root.winfo_screenheight()


def main(argv: list[str] | None = None) -> int:
    arguments = list(sys.argv[1:] if argv is None else argv)
    smoke_test = "--smoke-test" in arguments
    arguments = [argument for argument in arguments if argument != "--smoke-test"]

    enable_dpi_awareness()
    root = tk.Tk()
    app = CompilerDemoApp(root)

    if smoke_test:
        app.show_workspace()
        app.workbench.set_source("fn main() -> i32 { 1 + 2 * 3 }", compile_after=False)
        root.update_idletasks()
        ok = app.workbench.compile_now(manual=True)
        view = app.workbench.last_view
        valid = bool(
            ok
            and view is not None
            and "(*, 2, 3, t1)" in view.ir
            and ".globl main" in view.assembly
        )
        root.destroy()
        return 0 if valid else 1

    if arguments:
        initial_path = Path(arguments[0]).expanduser()
        if initial_path.exists():
            root.after_idle(lambda: app.load_initial_path(initial_path))
    root.mainloop()
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
