from src.ast_nodes import (
    AssignStmt,
    BinaryExpr,
    Block,
    EmptyStmt,
    Expr,
    ExprStmt,
    FunctionDecl,
    IdentifierExpr,
    IfStmt,
    LetStmt,
    NumberExpr,
    Param,
    Program,
    ReturnStmt,
    WhileStmt,
)
from src.errors import ParserError
from src.tokens import Token, TokenKind


class Parser:
    """递归下降语法分析器。"""

    def __init__(self, tokens: list[Token]):
        self.tokens = tokens
        self.pos = 0

    def parse_program(self) -> Program:
        declarations: list[FunctionDecl] = []

        while not self._check(TokenKind.EOF) and not self._check(TokenKind.HASH):
            declarations.append(self._parse_function_decl())

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

    def _parse_type(self) -> str:
        token = self._expect(TokenKind.I32, "当前最小实现仅支持 i32 类型")
        return token.lexeme

    def _parse_block(self) -> Block:
        self._expect(TokenKind.LBRACE, "语句块缺少 '{'")
        statements = []

        while not self._check(TokenKind.RBRACE):
            if self._check(TokenKind.EOF):
                self._error(self._current(), "语句块未闭合，缺少 '}'")
            statements.append(self._parse_statement())

        self._expect(TokenKind.RBRACE, "语句块缺少 '}'")
        return Block(statements=statements)

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

        # 赋值语句优先判断: IDENT '=' 表达式 ';'
        if self._check(TokenKind.IDENT) and self._check_next(TokenKind.EQ):
            return self._parse_assign_stmt()

        return self._parse_expr_stmt()

    def _parse_let_stmt(self) -> LetStmt:
        is_mut = self._match(TokenKind.MUT)
        name = self._expect(TokenKind.IDENT, "let 后缺少变量名").lexeme

        type_name: str | None = None
        if self._match(TokenKind.COLON):
            type_name = self._parse_type()

        self._expect(TokenKind.SEMICOLON, "变量声明语句末尾缺少 ';'")
        return LetStmt(is_mut=is_mut, name=name, type_name=type_name)

    def _parse_assign_stmt(self) -> AssignStmt:
        target_name = self._expect(TokenKind.IDENT, "赋值语句缺少左值").lexeme
        self._expect(TokenKind.EQ, "赋值语句左值后应为 '='")
        value = self._parse_expression()
        self._expect(TokenKind.SEMICOLON, "赋值语句末尾缺少 ';'")
        return AssignStmt(target_name=target_name, value=value)

    def _parse_return_stmt(self) -> ReturnStmt:
        if self._match(TokenKind.SEMICOLON):
            return ReturnStmt(value=None)

        value = self._parse_expression()
        self._expect(TokenKind.SEMICOLON, "return 语句末尾缺少 ';'")
        return ReturnStmt(value=value)

    def _parse_if_stmt(self) -> IfStmt:
        condition = self._parse_expression()
        then_block = self._parse_block()

        else_block = None
        if self._match(TokenKind.ELSE):
            else_block = self._parse_block()

        return IfStmt(condition=condition, then_block=then_block, else_block=else_block)

    def _parse_while_stmt(self) -> WhileStmt:
        condition = self._parse_expression()
        body = self._parse_block()
        return WhileStmt(condition=condition, body=body)

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
        if self._match(TokenKind.NUMBER):
            value = int(self._previous().lexeme)
            return NumberExpr(value=value)

        if self._match(TokenKind.IDENT):
            return IdentifierExpr(name=self._previous().lexeme)

        if self._match(TokenKind.LPAREN):
            expr = self._parse_expression()
            self._expect(TokenKind.RPAREN, "括号表达式缺少 ')'")
            return expr

        self._error(self._current(), "表达式起始符号不合法")

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
        return self.tokens[self.pos]

    def _previous(self) -> Token:
        return self.tokens[self.pos - 1]

    def _error(self, token: Token, message: str):
        found = token.lexeme if token.lexeme else token.kind.name
        raise ParserError(f"{token.line}:{token.column} {message}，当前符号: {found!r}")
