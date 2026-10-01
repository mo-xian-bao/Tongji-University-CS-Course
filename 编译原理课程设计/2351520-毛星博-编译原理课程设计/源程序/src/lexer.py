from src.errors import LexerError
from src.tokens import KEYWORDS, Token, TokenKind


class Lexer:
    """按需扫描类 Rust 源码。

    ``next_token`` 是语法分析器调用的子程序；``tokenize`` 仅作为教学、
    调试和向后兼容接口保留。
    """

    def __init__(self, source: str):
        self.source = source
        self.index = 0
        self.line = 1
        self.column = 1
        self.emitted_tokens: list[Token] = []
        self._finished = False

    def tokenize(self) -> list[Token]:
        while not self._finished:
            self.next_token()
        return list(self.emitted_tokens)

    @property
    def is_finished(self) -> bool:
        return self._finished

    def next_token(self) -> Token:
        """扫描并返回一个 Token；到达末尾后重复返回同一个 EOF。"""
        if self._finished:
            return self.emitted_tokens[-1]

        self._skip_whitespace_and_comments()
        if self._is_at_end():
            self._finished = True
            return self._emit(TokenKind.EOF, "", self.line, self.column)

        start_line = self.line
        start_col = self.column
        current = self._current_char()

        if current.isalpha() or current == "_":
            lexeme = self._read_identifier()
            return self._emit(KEYWORDS.get(lexeme, TokenKind.IDENT), lexeme, start_line, start_col)

        if current.isdigit():
            lexeme = self._read_number()
            return self._emit(TokenKind.NUMBER, lexeme, start_line, start_col)

        two_char_map = {
            "->": TokenKind.ARROW,
            "==": TokenKind.EQEQ,
            "!=": TokenKind.NE,
            ">=": TokenKind.GTE,
            "<=": TokenKind.LTE,
            "..": TokenKind.DOTDOT,
        }
        two_char = current + self._peek_char()
        if two_char in two_char_map:
            self._advance()
            self._advance()
            return self._emit(two_char_map[two_char], two_char, start_line, start_col)

        single_map = {
            "+": TokenKind.PLUS,
            "-": TokenKind.MINUS,
            "*": TokenKind.STAR,
            "/": TokenKind.SLASH,
            "=": TokenKind.EQ,
            ">": TokenKind.GT,
            "<": TokenKind.LT,
            "&": TokenKind.AMP,
            "(": TokenKind.LPAREN,
            ")": TokenKind.RPAREN,
            "{": TokenKind.LBRACE,
            "}": TokenKind.RBRACE,
            "[": TokenKind.LBRACKET,
            "]": TokenKind.RBRACKET,
            ";": TokenKind.SEMICOLON,
            ":": TokenKind.COLON,
            ",": TokenKind.COMMA,
            ".": TokenKind.DOT,
            "#": TokenKind.HASH,
        }
        kind = single_map.get(current)
        if kind is not None:
            self._advance()
            return self._emit(kind, current, start_line, start_col)

        raise LexerError(f"{start_line}:{start_col} 发现非法字符: {current!r}")

    def _emit(self, kind: TokenKind, lexeme: str, line: int, column: int) -> Token:
        token = Token(kind, lexeme, line, column)
        self.emitted_tokens.append(token)
        return token

    def _skip_whitespace_and_comments(self) -> None:
        while not self._is_at_end():
            c = self._current_char()

            if c in " \t\r\n":
                self._advance()
                continue

            # 行注释: // ...
            if c == "/" and self._peek_char() == "/":
                self._advance()
                self._advance()
                while not self._is_at_end() and self._current_char() != "\n":
                    self._advance()
                continue

            # 块注释: /* ... */
            if c == "/" and self._peek_char() == "*":
                comment_line = self.line
                comment_col = self.column
                self._advance()
                self._advance()

                while not self._is_at_end():
                    if self._current_char() == "*" and self._peek_char() == "/":
                        self._advance()
                        self._advance()
                        break
                    self._advance()
                else:
                    raise LexerError(f"{comment_line}:{comment_col} 块注释未闭合")

                continue

            break

    def _read_identifier(self) -> str:
        chars: list[str] = []
        while not self._is_at_end():
            c = self._current_char()
            if c.isalnum() or c == "_":
                chars.append(self._advance())
            else:
                break
        return "".join(chars)

    def _read_number(self) -> str:
        chars: list[str] = []
        while not self._is_at_end() and self._current_char().isdigit():
            chars.append(self._advance())
        return "".join(chars)

    def _is_at_end(self) -> bool:
        return self.index >= len(self.source)

    def _current_char(self) -> str:
        return self.source[self.index]

    def _peek_char(self) -> str:
        if self.index + 1 >= len(self.source):
            return ""
        return self.source[self.index + 1]

    def _advance(self) -> str:
        c = self.source[self.index]
        self.index += 1

        if c == "\n":
            self.line += 1
            self.column = 1
        else:
            self.column += 1

        return c
