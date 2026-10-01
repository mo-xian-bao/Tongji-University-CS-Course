from src.ast_nodes import (
    AssignStmt,
    ArrayExpr,
    ArrayType,
    BinaryExpr,
    Block,
    BlockExpr,
    BreakStmt,
    BorrowExpr,
    CallExpr,
    ContinueStmt,
    DerefExpr,
    EmptyStmt,
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
    Param,
    Program,
    RangeExpr,
    RefType,
    ReturnStmt,
    TupleExpr,
    TupleType,
    TypeNode,
    WhileStmt,
)
from src.errors import ParserError
from src.lexer import Lexer
from src.tokens import Token, TokenKind
from typing import Callable, Optional


class Parser:
    """递归下降语法分析器。"""

    def __init__(self, tokens: list[Token] | Lexer, source: Optional[str] = None):
        self.token_source = tokens if isinstance(tokens, Lexer) else None
        self.tokens = [] if self.token_source is not None else tokens
        self.pos = 0
        self.source_lines = source.splitlines() if source is not None else []

    def parse_program(
        self,
        on_function: Optional[Callable[[FunctionDecl], None]] = None,
    ) -> Program:
        declarations: list[FunctionDecl] = []

        while not self._check(TokenKind.EOF) and not self._check(TokenKind.HASH):
            function = self._parse_function_decl()
            declarations.append(function)
            if on_function is not None:
                on_function(function)

        # 允许可选结束符 #
        if self._match(TokenKind.HASH):
            pass

        self._expect(TokenKind.EOF, "程序末尾应为 EOF")
        return Program(declarations)

    def _parse_function_decl(self) -> FunctionDecl:
        self._expect(TokenKind.FN, "函数声明应以 fn 开始")
        name = self._expect(TokenKind.IDENT, "fn 后应为函数名").lexeme

        self._expect(TokenKind.LPAREN, "函数名后缺少 '('")
        params = self._parse_param_list()
        self._expect(TokenKind.RPAREN, "形参列表后缺少 ')'")

        return_type: str | None = None
        if self._match(TokenKind.ARROW):
            return_type = self._parse_type()

        body = self._parse_block()
        return FunctionDecl(name=name, params=params, return_type=return_type, body=body)

    def _parse_param_list(self) -> list[Param]:
        params: list[Param] = []

        if self._check(TokenKind.RPAREN):
            return params

        params.append(self._parse_param())
        while self._match(TokenKind.COMMA):
            params.append(self._parse_param())

        return params

    def _parse_param(self) -> Param:
        is_mut = self._match(TokenKind.MUT)
        name = self._expect(TokenKind.IDENT, "形参缺少标识符").lexeme
        self._expect(TokenKind.COLON, "形参标识符后缺少 ':'")
        type_name = self._parse_type()
        return Param(is_mut=is_mut, name=name, type_name=type_name)

    def _parse_type(self) -> TypeNode:
        if self._match(TokenKind.I32):
            return I32Type()

        if self._match(TokenKind.AMP):
            is_mut = self._match(TokenKind.MUT)
            inner = self._parse_type()
            return RefType(is_mut=is_mut, inner=inner)

        if self._match(TokenKind.LBRACKET):
            element_type = self._parse_type()
            self._expect(TokenKind.SEMICOLON, "数组类型缺少 ';'")
            size_token = self._expect(TokenKind.NUMBER, "数组类型长度应为数字")
            size = int(size_token.lexeme)
            if size <= 0:
                self._error(size_token, "数组类型长度必须为正整数")
            self._expect(TokenKind.RBRACKET, "数组类型缺少 ']'")
            return ArrayType(element_type=element_type, size=size)

        if self._match(TokenKind.LPAREN):
            elements: list[TypeNode] = []
            if self._match(TokenKind.RPAREN):
                return TupleType(elements=elements)

            elements.append(self._parse_type())
            self._expect(TokenKind.COMMA, "元组类型至少应包含一个 ','")
            if not self._check(TokenKind.RPAREN):
                elements.append(self._parse_type())
                while self._match(TokenKind.COMMA):
                    if self._check(TokenKind.RPAREN):
                        break
                    elements.append(self._parse_type())

            self._expect(TokenKind.RPAREN, "元组类型缺少 ')'")
            return TupleType(elements=elements)

        self._error(self._current(), "类型应为 i32、引用类型、数组类型或元组类型")

    def _parse_block(self) -> Block:
        self._expect(TokenKind.LBRACE, "语句块缺少 '{'")
        return self._parse_block_body()

    def _parse_block_body(self) -> Block:
        statements = []
        result = None

        while not self._check(TokenKind.RBRACE):
            if self._check(TokenKind.EOF):
                self._error(self._current(), "语句块未闭合，缺少 '}'")
            if self._can_start_expression(self._current().kind):
                saved_pos = self.pos
                try:
                    expr = self._parse_expression()
                except ParserError:
                    self.pos = saved_pos
                else:
                    if self._check(TokenKind.RBRACE):
                        result = expr
                        break
                    self.pos = saved_pos
            statements.append(self._parse_statement())

        self._expect(TokenKind.RBRACE, "语句块缺少 '}'")
        return Block(statements=statements, result=result)

    def _can_start_expression(self, kind: TokenKind) -> bool:
        return kind in {
            TokenKind.NUMBER,
            TokenKind.IDENT,
            TokenKind.AMP,
            TokenKind.STAR,
            TokenKind.LBRACKET,
            TokenKind.LPAREN,
            TokenKind.LBRACE,
            TokenKind.IF,
            TokenKind.LOOP,
        }

    def _parse_statement(self):
        if self._match(TokenKind.SEMICOLON):
            return EmptyStmt()

        if self._match(TokenKind.LET):
            return self._parse_let_stmt()

        if self._match(TokenKind.RETURN):
            return self._parse_return_stmt()

        if self._match(TokenKind.IF):
            return self._parse_if_stmt()

        if self._match(TokenKind.WHILE):
            return self._parse_while_stmt()

        if self._match(TokenKind.FOR):
            return self._parse_for_stmt()

        if self._match(TokenKind.LOOP):
            return self._parse_loop_stmt()

        if self._match(TokenKind.BREAK):
            return self._parse_break_stmt()

        if self._match(TokenKind.CONTINUE):
            return self._parse_continue_stmt()

        return self._parse_expr_or_assign_stmt()

    def _parse_let_stmt(self) -> LetStmt:
        is_mut, name, type_name = self._parse_variable_decl_parts("let 后缺少变量名")

        initializer = None
        if self._match(TokenKind.EQ):
            initializer = self._parse_expression()

        self._expect(TokenKind.SEMICOLON, "变量声明语句末尾缺少 ';'")
        return LetStmt(is_mut=is_mut, name=name, type_name=type_name, initializer=initializer)

    def _parse_variable_decl_parts(self, missing_name_message: str) -> tuple[bool, str, Optional[TypeNode]]:
        is_mut = self._match(TokenKind.MUT)
        name = self._expect(TokenKind.IDENT, missing_name_message).lexeme

        type_name = None
        if self._match(TokenKind.COLON):
            type_name = self._parse_type()

        return is_mut, name, type_name

    def _parse_assign_stmt(self) -> AssignStmt:
        target_name = self._expect(TokenKind.IDENT, "赋值语句缺少左值").lexeme
        self._expect(TokenKind.EQ, "赋值语句左值后应为 '='")
        value = self._parse_expression()
        self._expect(TokenKind.SEMICOLON, "赋值语句末尾缺少 ';'")
        return AssignStmt(target=IdentifierExpr(name=target_name), value=value)

    def _parse_return_stmt(self) -> ReturnStmt:
        if self._match(TokenKind.SEMICOLON):
            return ReturnStmt(value=None)

        value = self._parse_expression()
        self._expect(TokenKind.SEMICOLON, "return 语句末尾缺少 ';'")
        return ReturnStmt(value=value)

    def _parse_if_stmt(self) -> IfStmt:
        condition = self._parse_expression()
        then_block = self._parse_block()

        else_if_blocks: list[ElseIf] = []
        else_block = None
        while self._match(TokenKind.ELSE):
            if self._match(TokenKind.IF):
                else_if_condition = self._parse_expression()
                else_if_block = self._parse_block()
                else_if_blocks.append(ElseIf(condition=else_if_condition, block=else_if_block))
                continue

            else_block = self._parse_block()
            break

        return IfStmt(
            condition=condition,
            then_block=then_block,
            else_if_blocks=else_if_blocks,
            else_block=else_block,
        )

    def _parse_while_stmt(self) -> WhileStmt:
        condition = self._parse_expression()
        body = self._parse_block()
        return WhileStmt(condition=condition, body=body)

    def _parse_for_stmt(self) -> ForStmt:
        is_mut, name, type_name = self._parse_variable_decl_parts("for 循环变量缺少变量名")
        self._expect(TokenKind.IN, "for 循环变量后缺少 in")
        iterable = self._parse_iterable()
        body = self._parse_block()
        return ForStmt(is_mut=is_mut, name=name, type_name=type_name, iterable=iterable, body=body)

    def _parse_iterable(self) -> Expr:
        start = self._parse_expression()
        if self._match(TokenKind.DOTDOT):
            end = self._parse_expression()
            return RangeExpr(start=start, end=end)

        return start

    def _parse_loop_stmt(self) -> LoopStmt:
        body = self._parse_block()
        return LoopStmt(body=body)

    def _parse_break_stmt(self) -> BreakStmt:
        value = None
        if not self._check(TokenKind.SEMICOLON):
            value = self._parse_expression()
        self._expect(TokenKind.SEMICOLON, "break 语句末尾缺少 ';'")
        return BreakStmt(value=value)

    def _parse_continue_stmt(self) -> ContinueStmt:
        self._expect(TokenKind.SEMICOLON, "continue 语句末尾缺少 ';'")
        return ContinueStmt()

    def _parse_expr_or_assign_stmt(self):
        expr = self._parse_expression()

        if self._match(TokenKind.EQ):
            if not self._is_assignable(expr):
                self._error(self._previous(), "赋值语句左侧不是可赋值左值")
            value = self._parse_expression()
            self._expect(TokenKind.SEMICOLON, "赋值语句末尾缺少 ';'")
            return AssignStmt(target=expr, value=value)

        self._expect(TokenKind.SEMICOLON, "表达式语句末尾缺少 ';'")
        return ExprStmt(expr=expr)

    def _is_assignable(self, expr: Expr) -> bool:
        return isinstance(expr, (IdentifierExpr, DerefExpr, IndexExpr, FieldExpr))

    def _parse_expr_stmt(self) -> ExprStmt:
        expr = self._parse_expression()
        self._expect(TokenKind.SEMICOLON, "表达式语句末尾缺少 ';'")
        return ExprStmt(expr=expr)

    def _parse_expression(self) -> Expr:
        return self._parse_comparison()

    def _parse_comparison(self) -> Expr:
        expr = self._parse_additive()

        while self._match(
            TokenKind.EQEQ,
            TokenKind.NE,
            TokenKind.GT,
            TokenKind.GTE,
            TokenKind.LT,
            TokenKind.LTE,
        ):
            op = self._previous().lexeme
            right = self._parse_additive()
            expr = BinaryExpr(left=expr, op=op, right=right)

        return expr

    def _parse_additive(self) -> Expr:
        expr = self._parse_term()

        while self._match(TokenKind.PLUS, TokenKind.MINUS):
            op = self._previous().lexeme
            right = self._parse_term()
            expr = BinaryExpr(left=expr, op=op, right=right)

        return expr

    def _parse_term(self) -> Expr:
        expr = self._parse_factor()

        while self._match(TokenKind.STAR, TokenKind.SLASH):
            op = self._previous().lexeme
            right = self._parse_factor()
            expr = BinaryExpr(left=expr, op=op, right=right)

        return expr

    def _parse_factor(self) -> Expr:
        return self._parse_postfix()

    def _parse_postfix(self) -> Expr:
        expr = self._parse_primary()

        while True:
            if self._match(TokenKind.LPAREN):
                if not isinstance(expr, IdentifierExpr):
                    self._error(self._previous(), "函数调用目前仅支持标识符作为被调用对象")
                arguments = self._parse_argument_list()
                self._expect(TokenKind.RPAREN, "函数调用实参列表后缺少 ')'")
                expr = CallExpr(callee=expr.name, arguments=arguments)
                continue

            if self._match(TokenKind.LBRACKET):
                index = self._parse_expression()
                self._expect(TokenKind.RBRACKET, "数组下标表达式缺少 ']'")
                expr = IndexExpr(collection=expr, index=index)
                continue

            if self._match(TokenKind.DOT):
                field = int(self._expect(TokenKind.NUMBER, "元组字段访问 '.' 后应为数字").lexeme)
                expr = FieldExpr(target=expr, field=field)
                continue

            break

        return expr

    def _parse_primary(self) -> Expr:
        if self._match(TokenKind.NUMBER):
            value = int(self._previous().lexeme)
            return NumberExpr(value=value)

        if self._match(TokenKind.IF):
            return self._parse_if_expr()

        if self._match(TokenKind.LOOP):
            body = self._parse_block()
            return LoopExpr(body=body)

        if self._match(TokenKind.LBRACE):
            block = self._parse_block_body()
            return BlockExpr(block=block)

        if self._match(TokenKind.IDENT):
            name = self._previous().lexeme
            return IdentifierExpr(name=name)

        if self._match(TokenKind.AMP):
            is_mut = self._match(TokenKind.MUT)
            value = self._parse_factor()
            return BorrowExpr(is_mut=is_mut, value=value)

        if self._match(TokenKind.STAR):
            value = self._parse_factor()
            return DerefExpr(value=value)

        if self._match(TokenKind.LBRACKET):
            elements = self._parse_expression_list(TokenKind.RBRACKET)
            self._expect(TokenKind.RBRACKET, "数组表达式缺少 ']'")
            return ArrayExpr(elements=elements)

        if self._match(TokenKind.LPAREN):
            if self._match(TokenKind.RPAREN):
                return TupleExpr(elements=[])

            expr = self._parse_expression()
            if self._match(TokenKind.COMMA):
                elements = [expr]
                if not self._check(TokenKind.RPAREN):
                    elements.append(self._parse_expression())
                    while self._match(TokenKind.COMMA):
                        if self._check(TokenKind.RPAREN):
                            break
                        elements.append(self._parse_expression())

                self._expect(TokenKind.RPAREN, "元组表达式缺少 ')'")
                return TupleExpr(elements=elements)

            self._expect(TokenKind.RPAREN, "括号表达式缺少 ')'")
            return expr

        self._error(self._current(), "表达式起始符号不合法")

    def _parse_if_expr(self) -> IfExpr:
        condition = self._parse_expression()
        then_block = self._parse_block()

        else_if_blocks: list[ElseIf] = []
        else_block = None
        while self._match(TokenKind.ELSE):
            if self._match(TokenKind.IF):
                else_if_condition = self._parse_expression()
                else_if_block = self._parse_block()
                else_if_blocks.append(ElseIf(condition=else_if_condition, block=else_if_block))
                continue

            else_block = self._parse_block()
            break

        if else_block is None:
            self._error(self._current(), "if 表达式必须包含 else 分支")

        return IfExpr(
            condition=condition,
            then_block=then_block,
            else_if_blocks=else_if_blocks,
            else_block=else_block,
        )

    def _parse_expression_list(self, end_kind: TokenKind) -> list[Expr]:
        elements: list[Expr] = []

        if self._check(end_kind):
            return elements

        elements.append(self._parse_expression())
        while self._match(TokenKind.COMMA):
            if self._check(end_kind):
                break
            elements.append(self._parse_expression())

        return elements

    def _parse_argument_list(self) -> list[Expr]:
        arguments: list[Expr] = []

        if self._check(TokenKind.RPAREN):
            return arguments

        arguments.append(self._parse_expression())
        while self._match(TokenKind.COMMA):
            arguments.append(self._parse_expression())

        return arguments

    def _match(self, *kinds: TokenKind) -> bool:
        for kind in kinds:
            if self._check(kind):
                self._advance()
                return True
        return False

    def _expect(self, kind: TokenKind, message: str) -> Token:
        if self._check(kind):
            return self._advance()
        self._error(self._current(), message)

    def _check(self, kind: TokenKind) -> bool:
        if self._is_at_end():
            return kind == TokenKind.EOF
        return self._current().kind == kind

    def _check_next(self, kind: TokenKind) -> bool:
        self._ensure_token(self.pos + 1)
        if self.pos + 1 >= len(self.tokens):
            return False
        return self.tokens[self.pos + 1].kind == kind

    def _advance(self) -> Token:
        if not self._is_at_end():
            self.pos += 1
        return self._previous()

    def _is_at_end(self) -> bool:
        return self._current().kind == TokenKind.EOF

    def _current(self) -> Token:
        self._ensure_token(self.pos)
        return self.tokens[self.pos]

    def _previous(self) -> Token:
        return self.tokens[self.pos - 1]

    def _ensure_token(self, index: int) -> None:
        """需要时才向词法分析器索取 Token，并保留缓冲以支持局部回溯。"""
        while self.token_source is not None and len(self.tokens) <= index:
            token = self.token_source.next_token()
            self.tokens.append(token)
            if token.kind == TokenKind.EOF:
                break

    def _error(self, token: Token, message: str):
        found = token.lexeme if token.lexeme else token.kind.name
        detail = f"{token.line}:{token.column} {message}，当前符号: {found!r}"
        if 1 <= token.line <= len(self.source_lines):
            source_line = self.source_lines[token.line - 1]
            caret_col = max(token.column, 1)
            detail += f"\n    {source_line}\n    {' ' * (caret_col - 1)}^"
        raise ParserError(detail)
