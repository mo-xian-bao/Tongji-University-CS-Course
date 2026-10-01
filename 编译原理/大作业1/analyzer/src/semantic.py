from dataclasses import dataclass
from typing import Optional

from src.ast_nodes import (
    ArrayExpr,
    ArrayType,
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
    Expr,
    ExprStmt,
    FieldExpr,
    ForStmt,
    FunctionDecl,
    I32Type,
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
    RefType,
    ReturnStmt,
    TupleExpr,
    TupleType,
    TypeNode,
    WhileStmt,
)
from src.errors import SemanticError


@dataclass
class FunctionSymbol:
    name: str
    params: list[TypeNode]
    return_type: Optional[TypeNode]


@dataclass
class VariableSymbol:
    name: str
    type_name: Optional[TypeNode]
    is_mut: bool


@dataclass
class RangeType:
    element_type: TypeNode


@dataclass
class LValueInfo:
    type_name: Optional[TypeNode]
    writable: bool


@dataclass
class LoopContext:
    allow_break_value: bool
    break_types: list[Optional[TypeNode]]


class SemanticAnalyzer:
    """基于 AST 做基础符号表、类型和可变性检查。"""

    def __init__(self):
        self.functions: dict[str, FunctionSymbol] = {}
        self.scopes: list[dict[str, VariableSymbol]] = []
        self.current_return_type: Optional[TypeNode] = None
        self.loop_stack: list[LoopContext] = []

    def analyze(self, program: Program) -> None:
        self._collect_functions(program)
        for function in program.declarations:
            self._analyze_function(function)

    def _collect_functions(self, program: Program) -> None:
        for function in program.declarations:
            if function.name in self.functions:
                self._error(f"函数重复定义: {function.name}")
            self.functions[function.name] = FunctionSymbol(
                name=function.name,
                params=[param.type_name for param in function.params],
                return_type=function.return_type,
            )

    def _analyze_function(self, function: FunctionDecl) -> None:
        self.current_return_type = function.return_type
        self._push_scope()
        try:
            for param in function.params:
                self._define_variable(param.name, param.type_name, param.is_mut)

            body_type = self._analyze_block(function.body, create_scope=False)
            if function.return_type is not None and body_type is not None:
                self._require_assignable_type(function.return_type, body_type, "函数体末尾表达式类型与返回类型不匹配")
            if function.return_type is None and body_type is not None:
                self._error(f"函数 {function.name} 未声明返回类型，但函数体末尾存在表达式")
        finally:
            self._pop_scope()
            self.current_return_type = None

    def _analyze_block(self, block: Block, create_scope: bool = True) -> Optional[TypeNode]:
        if create_scope:
            self._push_scope()
        try:
            for statement in block.statements:
                self._analyze_statement(statement)
            if block.result is not None:
                return self._type_of_expr(block.result)
            return None
        finally:
            if create_scope:
                self._pop_scope()

    def _analyze_statement(self, statement) -> None:
        if isinstance(statement, LetStmt):
            initializer_type = self._type_of_expr(statement.initializer) if statement.initializer is not None else None
            if statement.type_name is not None and initializer_type is not None:
                self._require_assignable_type(statement.type_name, initializer_type, f"变量 {statement.name} 初始化类型不匹配")
            inferred_type = statement.type_name if statement.type_name is not None else initializer_type
            self._define_variable(statement.name, inferred_type, statement.is_mut)
            return

        if isinstance(statement, AssignStmt):
            target_info = self._lvalue_info(statement.target)
            if not target_info.writable:
                self._error("不能给不可变左值赋值")
            value_type = self._type_of_expr(statement.value)
            if target_info.type_name is not None:
                self._require_assignable_type(target_info.type_name, value_type, "赋值语句左右类型不匹配")
            elif isinstance(statement.target, IdentifierExpr):
                symbol = self._lookup_variable(statement.target.name)
                symbol.type_name = value_type
            return

        if isinstance(statement, ReturnStmt):
            value_type = self._type_of_expr(statement.value) if statement.value is not None else None
            if self.current_return_type is None:
                if value_type is not None:
                    self._error("当前函数未声明返回类型，不能返回表达式")
            else:
                if value_type is None:
                    self._error("当前函数声明了返回类型，return 语句缺少返回表达式")
                self._require_assignable_type(self.current_return_type, value_type, "return 表达式类型与函数返回类型不匹配")
            return

        if isinstance(statement, IfStmt):
            self._require_i32(self._type_of_expr(statement.condition), "if 条件表达式")
            self._analyze_block(statement.then_block)
            for else_if in statement.else_if_blocks:
                self._analyze_else_if(else_if)
            if statement.else_block is not None:
                self._analyze_block(statement.else_block)
            return

        if isinstance(statement, WhileStmt):
            self._require_i32(self._type_of_expr(statement.condition), "while 条件表达式")
            self.loop_stack.append(LoopContext(allow_break_value=False, break_types=[]))
            try:
                self._analyze_block(statement.body)
            finally:
                self.loop_stack.pop()
            return

        if isinstance(statement, LoopStmt):
            self.loop_stack.append(LoopContext(allow_break_value=False, break_types=[]))
            try:
                self._analyze_block(statement.body)
            finally:
                self.loop_stack.pop()
            return

        if isinstance(statement, ForStmt):
            iterable_type = self._type_of_expr(statement.iterable)
            if isinstance(iterable_type, RangeType):
                element_type: Optional[TypeNode] = iterable_type.element_type
            elif isinstance(iterable_type, ArrayType):
                element_type = iterable_type.element_type
            elif iterable_type is None:
                element_type = statement.type_name
            else:
                self._error("for 循环 in 后的表达式不是可迭代结构")

            if statement.type_name is not None and element_type is not None:
                self._require_assignable_type(statement.type_name, element_type, "for 循环变量类型与可迭代元素类型不匹配")
            loop_var_type = statement.type_name if statement.type_name is not None else element_type

            self.loop_stack.append(LoopContext(allow_break_value=False, break_types=[]))
            self._push_scope()
            try:
                self._define_variable(statement.name, loop_var_type, statement.is_mut)
                self._analyze_block(statement.body, create_scope=False)
            finally:
                self._pop_scope()
                self.loop_stack.pop()
            return

        if isinstance(statement, BreakStmt):
            if not self.loop_stack:
                self._error("break 只能出现在循环内部")
            value_type = self._type_of_expr(statement.value) if statement.value is not None else None
            context = self.loop_stack[-1]
            if value_type is not None and not context.allow_break_value:
                self._error("只有 loop 表达式中的 break 可以携带表达式")
            context.break_types.append(value_type)
            return

        if isinstance(statement, ContinueStmt):
            if not self.loop_stack:
                self._error("continue 只能出现在循环内部")
            return

        if isinstance(statement, ExprStmt):
            self._type_of_expr(statement.expr)
            return

    def _analyze_else_if(self, else_if: ElseIf) -> None:
        self._require_i32(self._type_of_expr(else_if.condition), "else if 条件表达式")
        self._analyze_block(else_if.block)

    def _type_of_expr(self, expr: Optional[Expr]) -> Optional[TypeNode]:
        if expr is None:
            return None

        if isinstance(expr, NumberExpr):
            return I32Type()

        if isinstance(expr, IdentifierExpr):
            return self._lookup_variable(expr.name).type_name

        if isinstance(expr, BinaryExpr):
            left_type = self._type_of_expr(expr.left)
            right_type = self._type_of_expr(expr.right)
            self._require_i32(left_type, "二元表达式左侧")
            self._require_i32(right_type, "二元表达式右侧")
            return I32Type()

        if isinstance(expr, CallExpr):
            function = self.functions.get(expr.callee)
            if function is None:
                self._error(f"调用未定义函数: {expr.callee}")
            if len(expr.arguments) != len(function.params):
                self._error(f"函数 {expr.callee} 实参数量不匹配")
            for index, (argument, param_type) in enumerate(zip(expr.arguments, function.params), start=1):
                arg_type = self._type_of_expr(argument)
                self._require_assignable_type(param_type, arg_type, f"函数 {expr.callee} 第 {index} 个实参类型不匹配")
            return function.return_type

        if isinstance(expr, BorrowExpr):
            info = self._lvalue_info(expr.value)
            if expr.is_mut and not info.writable:
                self._error("不能对不可变左值进行可变借用")
            return RefType(is_mut=expr.is_mut, inner=info.type_name if info.type_name is not None else I32Type())

        if isinstance(expr, DerefExpr):
            value_type = self._type_of_expr(expr.value)
            if isinstance(value_type, RefType):
                return value_type.inner
            if value_type is None:
                return None
            self._error("解引用目标不是引用类型")

        if isinstance(expr, ArrayExpr):
            element_types = [self._type_of_expr(element) for element in expr.elements]
            element_type = self._unify_types(element_types, "数组元素类型不一致") if element_types else I32Type()
            return ArrayType(element_type=element_type if element_type is not None else I32Type(), size=len(expr.elements))

        if isinstance(expr, TupleExpr):
            return TupleType(elements=[self._type_of_expr(element) or I32Type() for element in expr.elements])

        if isinstance(expr, IndexExpr):
            collection_type = self._type_of_expr(expr.collection)
            self._require_i32(self._type_of_expr(expr.index), "数组下标")
            if isinstance(collection_type, ArrayType):
                return collection_type.element_type
            if collection_type is None:
                return None
            self._error("下标访问目标不是数组类型")

        if isinstance(expr, FieldExpr):
            target_type = self._type_of_expr(expr.target)
            if isinstance(target_type, TupleType):
                if expr.field < 0 or expr.field >= len(target_type.elements):
                    self._error(f"元组字段 .{expr.field} 越界")
                return target_type.elements[expr.field]
            if target_type is None:
                return None
            self._error("字段访问目标不是元组类型")

        if isinstance(expr, RangeExpr):
            self._require_i32(self._type_of_expr(expr.start), "范围表达式起点")
            self._require_i32(self._type_of_expr(expr.end), "范围表达式终点")
            return RangeType(element_type=I32Type())

        if isinstance(expr, BlockExpr):
            return self._analyze_block(expr.block)

        if isinstance(expr, IfExpr):
            self._require_i32(self._type_of_expr(expr.condition), "if 表达式条件")
            branch_types = [self._analyze_block(expr.then_block)]
            for else_if in expr.else_if_blocks:
                self._require_i32(self._type_of_expr(else_if.condition), "else if 表达式条件")
                branch_types.append(self._analyze_block(else_if.block))
            branch_types.append(self._analyze_block(expr.else_block))
            return self._unify_types(branch_types, "if 表达式各分支类型不一致")

        if isinstance(expr, LoopExpr):
            context = LoopContext(allow_break_value=True, break_types=[])
            self.loop_stack.append(context)
            try:
                self._analyze_block(expr.body)
            finally:
                self.loop_stack.pop()
            return self._unify_types(context.break_types, "loop 表达式 break 类型不一致")

        self._error(f"暂不支持的表达式类型: {type(expr).__name__}")

    def _lvalue_info(self, expr: Expr) -> LValueInfo:
        if isinstance(expr, IdentifierExpr):
            symbol = self._lookup_variable(expr.name)
            return LValueInfo(type_name=symbol.type_name, writable=symbol.is_mut)

        if isinstance(expr, DerefExpr):
            value_type = self._type_of_expr(expr.value)
            if isinstance(value_type, RefType):
                return LValueInfo(type_name=value_type.inner, writable=value_type.is_mut)
            if value_type is None:
                return LValueInfo(type_name=None, writable=True)
            self._error("解引用左值目标不是引用类型")

        if isinstance(expr, IndexExpr):
            collection_info = self._lvalue_info(expr.collection)
            self._require_i32(self._type_of_expr(expr.index), "数组下标")
            if isinstance(collection_info.type_name, ArrayType):
                return LValueInfo(type_name=collection_info.type_name.element_type, writable=collection_info.writable)
            if collection_info.type_name is None:
                return LValueInfo(type_name=None, writable=collection_info.writable)
            self._error("下标赋值目标不是数组类型")

        if isinstance(expr, FieldExpr):
            target_info = self._lvalue_info(expr.target)
            if isinstance(target_info.type_name, TupleType):
                if expr.field < 0 or expr.field >= len(target_info.type_name.elements):
                    self._error(f"元组字段 .{expr.field} 越界")
                return LValueInfo(type_name=target_info.type_name.elements[expr.field], writable=target_info.writable)
            if target_info.type_name is None:
                return LValueInfo(type_name=None, writable=target_info.writable)
            self._error("字段赋值目标不是元组类型")

        self._error("表达式不是可赋值左值")

    def _push_scope(self) -> None:
        self.scopes.append({})

    def _pop_scope(self) -> None:
        self.scopes.pop()

    def _define_variable(self, name: str, type_name: Optional[TypeNode], is_mut: bool) -> None:
        scope = self.scopes[-1]
        if name in scope:
            self._error(f"变量重复定义: {name}")
        scope[name] = VariableSymbol(name=name, type_name=type_name, is_mut=is_mut)

    def _lookup_variable(self, name: str) -> VariableSymbol:
        for scope in reversed(self.scopes):
            if name in scope:
                return scope[name]
        self._error(f"使用未定义变量: {name}")

    def _require_i32(self, type_name, context: str) -> None:
        if type_name is None:
            return
        if not isinstance(type_name, I32Type):
            self._error(f"{context} 应为 i32 类型")

    def _require_assignable_type(self, expected, actual, message: str) -> None:
        if expected is None or actual is None:
            return
        if not self._same_type(expected, actual):
            self._error(f"{message}: 期望 {self._type_name(expected)}，实际 {self._type_name(actual)}")

    def _unify_types(self, types: list[Optional[TypeNode]], message: str) -> Optional[TypeNode]:
        known_types = [type_name for type_name in types if type_name is not None]
        if not known_types:
            return None
        first = known_types[0]
        for type_name in known_types[1:]:
            if not self._same_type(first, type_name):
                self._error(message)
        return first

    def _same_type(self, left, right) -> bool:
        if isinstance(left, RangeType) or isinstance(right, RangeType):
            return isinstance(left, RangeType) and isinstance(right, RangeType) and self._same_type(left.element_type, right.element_type)
        if type(left) is not type(right):
            return False
        if isinstance(left, I32Type):
            return True
        if isinstance(left, RefType):
            return left.is_mut == right.is_mut and self._same_type(left.inner, right.inner)
        if isinstance(left, ArrayType):
            return left.size == right.size and self._same_type(left.element_type, right.element_type)
        if isinstance(left, TupleType):
            return len(left.elements) == len(right.elements) and all(
                self._same_type(a, b) for a, b in zip(left.elements, right.elements)
            )
        return False

    def _type_name(self, type_name) -> str:
        if type_name is None:
            return "unknown"
        if isinstance(type_name, I32Type):
            return "i32"
        if isinstance(type_name, RefType):
            prefix = "&mut " if type_name.is_mut else "&"
            return prefix + self._type_name(type_name.inner)
        if isinstance(type_name, ArrayType):
            return f"[{self._type_name(type_name.element_type)};{type_name.size}]"
        if isinstance(type_name, TupleType):
            if len(type_name.elements) == 1:
                return f"({self._type_name(type_name.elements[0])},)"
            return "(" + ",".join(self._type_name(element) for element in type_name.elements) + ")"
        if isinstance(type_name, RangeType):
            return "range"
        return type(type_name).__name__

    def _error(self, message: str):
        raise SemanticError(message)
