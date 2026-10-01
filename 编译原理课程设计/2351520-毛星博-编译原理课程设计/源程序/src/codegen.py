from dataclasses import dataclass
from typing import Optional

from src.ast_nodes import (
    ArrayExpr,
    AssignStmt,
    BinaryExpr,
    Block,
    BlockExpr,
    BorrowExpr,
    BreakStmt,
    CallExpr,
    ContinueStmt,
    DerefExpr,
    ElseIf,
    EmptyStmt,
    ExprStmt,
    FieldExpr,
    ForStmt,
    FunctionDecl,
    IdentifierExpr,
    IfExpr,
    IfStmt,
    IndexExpr,
    LetStmt,
    LoopExpr,
    LoopStmt,
    NumberExpr,
    Program,
    RangeExpr,
    ReturnStmt,
    TupleExpr,
    WhileStmt,
    type_to_text,
)
from src.errors import CodegenError
from src.ir import IRBuilder, IRFunction, IRProgram


@dataclass
class LoopContext:
    """循环上下文，用于 break/continue 跳转目标。"""
    start_label: str                # continue 跳转到此
    end_label: str                  # break 跳转到此
    break_target: Optional[str]     # loop 表达式中 break 值存放的临时变量


class CodeGenerator:
    """从 AST 生成四元式中间代码。

    支持控制流（if/else/while/loop/for/break/continue）、
    函数调用、引用与借用、数组与元组、块表达式与控制流表达式。
    """

    SUPPORTED_BINARY_OPS = {"+", "-", "*", "/", "<", "<=", ">", ">=", "==", "!="}

    def __init__(self):
        self.loop_stack: list[LoopContext] = []
        self.scopes: list[dict[str, str]] = []
        self.local_id = 0

    def generate_program(self, program: Program) -> IRProgram:
        return IRProgram(
            functions=[self.generate_function(function) for function in program.declarations]
        )

    def generate_function(self, function: FunctionDecl) -> IRFunction:
        """在函数声明完成时立即生成该函数的四元式。"""
        self.loop_stack = []
        self.scopes = [{}]
        self.local_id = 0
        return self._generate_function(function)

    def _generate_function(self, function: FunctionDecl) -> IRFunction:
        builder = IRBuilder()
        params = [self._declare_name(param.name) for param in function.params]
        result_place = self._generate_block(function.body, builder, create_scope=False)
        # 函数体末尾的结果表达式（规则 7.2）产生 return
        if result_place is not None:
            builder.emit("return", result_place)
        return IRFunction(
            name=function.name,
            params=params,
            quads=builder.quads,
        )

    # ------------------------------------------------------------------ #
    #  Block
    # ------------------------------------------------------------------ #

    def _generate_block(
        self,
        block: Block,
        builder: IRBuilder,
        create_scope: bool = True,
    ) -> Optional[str]:
        """生成语句块代码。返回结果表达式的 place（若有）。"""
        if create_scope:
            self.scopes.append({})
        try:
            for statement in block.statements:
                self._generate_statement(statement, builder)
            if block.result is not None:
                return self._generate_expr(block.result, builder)
            return None
        finally:
            if create_scope:
                self.scopes.pop()

    # ------------------------------------------------------------------ #
    #  Statements
    # ------------------------------------------------------------------ #

    def _generate_statement(self, statement, builder: IRBuilder) -> None:
        if isinstance(statement, EmptyStmt):
            return

        if isinstance(statement, LetStmt):
            self._generate_let(statement, builder)
            return

        if isinstance(statement, AssignStmt):
            self._generate_assign(statement, builder)
            return

        if isinstance(statement, ReturnStmt):
            self._generate_return(statement, builder)
            return

        if isinstance(statement, ExprStmt):
            self._generate_expr(statement.expr, builder)
            return

        if isinstance(statement, IfStmt):
            self._generate_if_stmt(statement, builder)
            return

        if isinstance(statement, WhileStmt):
            self._generate_while_stmt(statement, builder)
            return

        if isinstance(statement, LoopStmt):
            self._generate_loop_stmt(statement, builder)
            return

        if isinstance(statement, ForStmt):
            self._generate_for_stmt(statement, builder)
            return

        if isinstance(statement, BreakStmt):
            self._generate_break_stmt(statement, builder)
            return

        if isinstance(statement, ContinueStmt):
            self._generate_continue_stmt(builder)
            return

        self._error(f"不支持的语句类型: {type(statement).__name__}")

    # -- let 声明 -------------------------------------------------------- #

    def _generate_let(self, statement: LetStmt, builder: IRBuilder) -> None:
        type_text = type_to_text(statement.type_name) if statement.type_name is not None else "unknown"
        internal_name = self._new_local_name(statement.name)
        builder.emit("decl", type_text, None, internal_name)

        if statement.initializer is not None:
            value_place = self._generate_expr(statement.initializer, builder)
            builder.emit("=", value_place, None, internal_name)
        self.scopes[-1][statement.name] = internal_name

    # -- 赋值 ------------------------------------------------------------ #

    def _generate_assign(self, statement: AssignStmt, builder: IRBuilder) -> None:
        value_place = self._generate_expr(statement.value, builder)
        self._generate_lvalue_store(statement.target, value_place, builder)

    def _generate_lvalue_store(self, target, value_place: str, builder: IRBuilder) -> None:
        """将 value_place 存储到左值 target 中。"""
        if isinstance(target, IdentifierExpr):
            builder.emit("=", value_place, None, self._resolve_name(target.name))
            return

        if isinstance(target, DerefExpr):
            ref_place = self._generate_expr(target.value, builder)
            builder.emit("*=", value_place, None, ref_place)
            return

        if isinstance(target, IndexExpr):
            arr_place = self._generate_expr(target.collection, builder)
            idx_place = self._generate_expr(target.index, builder)
            builder.emit("[]=", value_place, idx_place, arr_place)
            return

        if isinstance(target, FieldExpr):
            tuple_place = self._generate_expr(target.target, builder)
            builder.emit(".=", value_place, str(target.field), tuple_place)
            return

        self._error(f"不支持的左值类型: {type(target).__name__}")

    # -- return ---------------------------------------------------------- #

    def _generate_return(self, statement: ReturnStmt, builder: IRBuilder) -> None:
        value_place = None
        if statement.value is not None:
            value_place = self._generate_expr(statement.value, builder)
        builder.emit("return", value_place)

    # -- if 语句 ---------------------------------------------------------- #

    def _generate_if_stmt(self, statement: IfStmt, builder: IRBuilder) -> None:
        l_end = builder.new_label()

        # if 条件
        cond_place = self._generate_expr(statement.condition, builder)
        if statement.else_if_blocks or statement.else_block is not None:
            l_next = builder.new_label()
        else:
            l_next = l_end
        builder.emit("jz", cond_place, None, l_next)

        # then 块
        self._generate_block(statement.then_block, builder)
        if statement.else_if_blocks or statement.else_block is not None:
            builder.emit("j", None, None, l_end)

        # else if 链
        for i, else_if in enumerate(statement.else_if_blocks):
            builder.emit_label(l_next)
            l_next = builder.new_label()
            elif_cond = self._generate_expr(else_if.condition, builder)
            remaining = (i < len(statement.else_if_blocks) - 1) or (statement.else_block is not None)
            if remaining:
                next_label = builder.new_label()
            else:
                next_label = l_end
            builder.emit("jz", elif_cond, None, next_label)
            self._generate_block(else_if.block, builder)
            if remaining:
                builder.emit("j", None, None, l_end)
            l_next = next_label

        # else 块
        if statement.else_block is not None:
            builder.emit_label(l_next)
            self._generate_block(statement.else_block, builder)

        builder.emit_label(l_end)

    # -- while 循环 ------------------------------------------------------- #

    def _generate_while_stmt(self, statement: WhileStmt, builder: IRBuilder) -> None:
        l_start = builder.new_label()
        l_end = builder.new_label()

        self.loop_stack.append(LoopContext(start_label=l_start, end_label=l_end, break_target=None))

        builder.emit_label(l_start)
        cond_place = self._generate_expr(statement.condition, builder)
        builder.emit("jz", cond_place, None, l_end)
        self._generate_block(statement.body, builder)
        builder.emit("j", None, None, l_start)
        builder.emit_label(l_end)

        self.loop_stack.pop()

    # -- loop 循环 -------------------------------------------------------- #

    def _generate_loop_stmt(self, statement: LoopStmt, builder: IRBuilder) -> None:
        l_start = builder.new_label()
        l_end = builder.new_label()

        self.loop_stack.append(LoopContext(start_label=l_start, end_label=l_end, break_target=None))

        builder.emit_label(l_start)
        self._generate_block(statement.body, builder)
        builder.emit("j", None, None, l_start)
        builder.emit_label(l_end)

        self.loop_stack.pop()

    # -- for 循环 (展开为 while 模式) -------------------------------------- #

    def _generate_for_stmt(self, statement: ForStmt, builder: IRBuilder) -> None:
        self.scopes.append({})
        try:
            self._generate_for_in_scope(statement, builder)
        finally:
            self.scopes.pop()

    def _generate_for_in_scope(self, statement: ForStmt, builder: IRBuilder) -> None:
        l_start = builder.new_label()
        l_continue = builder.new_label()
        l_end = builder.new_label()

        # 处理可迭代结构（范围表达式 start..end 或数组）
        if isinstance(statement.iterable, RangeExpr):
            start_place = self._generate_expr(statement.iterable.start, builder)
            end_place = self._generate_expr(statement.iterable.end, builder)

            # 声明循环变量并初始化
            type_text = type_to_text(statement.type_name) if statement.type_name is not None else "i32"
            loop_name = self._declare_name(statement.name)
            builder.emit("decl", type_text, None, loop_name)
            builder.emit("=", start_place, None, loop_name)

            self.loop_stack.append(LoopContext(start_label=l_continue, end_label=l_end, break_target=None))

            # 循环头：判断 i < end
            builder.emit_label(l_start)
            cond_temp = builder.new_temp()
            builder.emit("<", loop_name, end_place, cond_temp)
            builder.emit("jz", cond_temp, None, l_end)

            # 循环体
            self._generate_block(statement.body, builder, create_scope=False)

            # 递增: i = i + 1
            builder.emit_label(l_continue)
            inc_temp = builder.new_temp()
            builder.emit("+", loop_name, "1", inc_temp)
            builder.emit("=", inc_temp, None, loop_name)
            builder.emit("j", None, None, l_start)
            builder.emit_label(l_end)

            self.loop_stack.pop()
        else:
            # 数组迭代: for i in arr { ... }
            arr_place = self._generate_expr(statement.iterable, builder)
            idx_name = builder.new_temp()
            len_name = builder.new_temp()

            builder.emit("decl", "i32", None, idx_name)
            builder.emit("=", "0", None, idx_name)
            builder.emit("len", arr_place, None, len_name)

            type_text = type_to_text(statement.type_name) if statement.type_name is not None else "unknown"
            loop_name = self._declare_name(statement.name)
            builder.emit("decl", type_text, None, loop_name)

            self.loop_stack.append(LoopContext(start_label=l_continue, end_label=l_end, break_target=None))

            builder.emit_label(l_start)
            cond_temp = builder.new_temp()
            builder.emit("<", idx_name, len_name, cond_temp)
            builder.emit("jz", cond_temp, None, l_end)

            # 取当前元素
            builder.emit("[]", arr_place, idx_name, loop_name)

            self._generate_block(statement.body, builder, create_scope=False)

            # 递增索引
            builder.emit_label(l_continue)
            inc_temp = builder.new_temp()
            builder.emit("+", idx_name, "1", inc_temp)
            builder.emit("=", inc_temp, None, idx_name)
            builder.emit("j", None, None, l_start)
            builder.emit_label(l_end)

            self.loop_stack.pop()

    # -- break / continue ------------------------------------------------- #

    def _generate_break_stmt(self, statement: BreakStmt, builder: IRBuilder) -> None:
        if not self.loop_stack:
            self._error("break 只能出现在循环内部")
        context = self.loop_stack[-1]
        if statement.value is not None:
            value_place = self._generate_expr(statement.value, builder)
            if context.break_target is not None:
                builder.emit("=", value_place, None, context.break_target)
        builder.emit("j", None, None, context.end_label)

    def _generate_continue_stmt(self, builder: IRBuilder) -> None:
        if not self.loop_stack:
            self._error("continue 只能出现在循环内部")
        context = self.loop_stack[-1]
        builder.emit("j", None, None, context.start_label)

    # ------------------------------------------------------------------ #
    #  Expressions — 返回表示结果值的 place (str)
    # ------------------------------------------------------------------ #

    def _generate_expr(self, expr, builder: IRBuilder) -> str:
        if isinstance(expr, NumberExpr):
            return str(expr.value)

        if isinstance(expr, IdentifierExpr):
            return self._resolve_name(expr.name)

        if isinstance(expr, BinaryExpr):
            return self._generate_binary(expr, builder)

        if isinstance(expr, CallExpr):
            return self._generate_call(expr, builder)

        if isinstance(expr, BorrowExpr):
            return self._generate_borrow(expr, builder)

        if isinstance(expr, DerefExpr):
            return self._generate_deref(expr, builder)

        if isinstance(expr, ArrayExpr):
            return self._generate_array(expr, builder)

        if isinstance(expr, TupleExpr):
            return self._generate_tuple(expr, builder)

        if isinstance(expr, IndexExpr):
            return self._generate_index(expr, builder)

        if isinstance(expr, FieldExpr):
            return self._generate_field(expr, builder)

        if isinstance(expr, RangeExpr):
            # 范围表达式通常只在 for 循环中使用，此处作为表达式仅求值两端
            self._generate_expr(expr.start, builder)
            return self._generate_expr(expr.end, builder)

        if isinstance(expr, BlockExpr):
            result = self._generate_block(expr.block, builder)
            return result if result is not None else "_"

        if isinstance(expr, IfExpr):
            return self._generate_if_expr(expr, builder)

        if isinstance(expr, LoopExpr):
            return self._generate_loop_expr(expr, builder)

        self._error(f"不支持的表达式类型: {type(expr).__name__}")

    # -- 二元运算 ---------------------------------------------------------- #

    def _generate_binary(self, expr: BinaryExpr, builder: IRBuilder) -> str:
        if expr.op not in self.SUPPORTED_BINARY_OPS:
            self._error(f"不支持的二元运算符: {expr.op!r}")
        left_place = self._generate_expr(expr.left, builder)
        right_place = self._generate_expr(expr.right, builder)
        result = builder.new_temp()
        builder.emit(expr.op, left_place, right_place, result)
        return result

    # -- 函数调用 ---------------------------------------------------------- #

    def _generate_call(self, expr: CallExpr, builder: IRBuilder) -> str:
        arg_places = [self._generate_expr(arg, builder) for arg in expr.arguments]
        for arg_place in arg_places:
            builder.emit("param", None, None, arg_place)
        result = builder.new_temp()
        builder.emit("call", expr.callee, str(len(arg_places)), result)
        return result

    # -- 引用与借用 -------------------------------------------------------- #

    def _generate_borrow(self, expr: BorrowExpr, builder: IRBuilder) -> str:
        value_place = self._generate_expr(expr.value, builder)
        result = builder.new_temp()
        op = "ref_mut" if expr.is_mut else "ref"
        builder.emit(op, value_place, None, result)
        return result

    def _generate_deref(self, expr: DerefExpr, builder: IRBuilder) -> str:
        value_place = self._generate_expr(expr.value, builder)
        result = builder.new_temp()
        builder.emit("deref", value_place, None, result)
        return result

    # -- 数组 -------------------------------------------------------------- #

    def _generate_array(self, expr: ArrayExpr, builder: IRBuilder) -> str:
        arr_temp = builder.new_temp()
        size = len(expr.elements)
        builder.emit("decl", f"[_;{size}]", None, arr_temp)
        for i, element in enumerate(expr.elements):
            elem_place = self._generate_expr(element, builder)
            builder.emit("[]=", elem_place, str(i), arr_temp)
        return arr_temp

    def _generate_index(self, expr: IndexExpr, builder: IRBuilder) -> str:
        collection_place = self._generate_expr(expr.collection, builder)
        index_place = self._generate_expr(expr.index, builder)
        result = builder.new_temp()
        builder.emit("[]", collection_place, index_place, result)
        return result

    # -- 元组 -------------------------------------------------------------- #

    def _generate_tuple(self, expr: TupleExpr, builder: IRBuilder) -> str:
        if not expr.elements:
            return "()"
        tuple_temp = builder.new_temp()
        count = len(expr.elements)
        builder.emit("decl", f"(_;{count})", None, tuple_temp)
        for i, element in enumerate(expr.elements):
            elem_place = self._generate_expr(element, builder)
            builder.emit(".=", elem_place, str(i), tuple_temp)
        return tuple_temp

    def _generate_field(self, expr: FieldExpr, builder: IRBuilder) -> str:
        target_place = self._generate_expr(expr.target, builder)
        result = builder.new_temp()
        builder.emit(".", target_place, str(expr.field), result)
        return result

    # -- if 表达式 --------------------------------------------------------- #

    def _generate_if_expr(self, expr: IfExpr, builder: IRBuilder) -> str:
        result_temp = builder.new_temp()
        l_end = builder.new_label()

        # if 条件
        cond_place = self._generate_expr(expr.condition, builder)
        l_next = builder.new_label()
        builder.emit("jz", cond_place, None, l_next)

        # then 分支
        then_place = self._generate_block(expr.then_block, builder)
        if then_place is not None:
            builder.emit("=", then_place, None, result_temp)
        builder.emit("j", None, None, l_end)

        # else if 链
        for i, else_if in enumerate(expr.else_if_blocks):
            builder.emit_label(l_next)
            l_next = builder.new_label()
            elif_cond = self._generate_expr(else_if.condition, builder)
            builder.emit("jz", elif_cond, None, l_next)
            elif_place = self._generate_block(else_if.block, builder)
            if elif_place is not None:
                builder.emit("=", elif_place, None, result_temp)
            builder.emit("j", None, None, l_end)

        # else 分支（if 表达式中 else 必须存在）
        builder.emit_label(l_next)
        else_place = self._generate_block(expr.else_block, builder)
        if else_place is not None:
            builder.emit("=", else_place, None, result_temp)

        builder.emit_label(l_end)
        return result_temp

    # -- loop 表达式 ------------------------------------------------------- #

    def _generate_loop_expr(self, expr: LoopExpr, builder: IRBuilder) -> str:
        result_temp = builder.new_temp()
        l_start = builder.new_label()
        l_end = builder.new_label()

        self.loop_stack.append(LoopContext(
            start_label=l_start,
            end_label=l_end,
            break_target=result_temp,
        ))

        builder.emit_label(l_start)
        self._generate_block(expr.body, builder)
        builder.emit("j", None, None, l_start)
        builder.emit_label(l_end)

        self.loop_stack.pop()
        return result_temp

    # ------------------------------------------------------------------ #
    #  Error
    # ------------------------------------------------------------------ #

    def _error(self, message: str):
        raise CodegenError(message)

    def _new_local_name(self, source_name: str) -> str:
        self.local_id += 1
        return f"v{self.local_id}_{source_name}"

    def _declare_name(self, source_name: str) -> str:
        internal_name = self._new_local_name(source_name)
        self.scopes[-1][source_name] = internal_name
        return internal_name

    def _resolve_name(self, source_name: str) -> str:
        for scope in reversed(self.scopes):
            if source_name in scope:
                return scope[source_name]
        self._error(f"生成中间代码时发现未声明变量: {source_name}")
