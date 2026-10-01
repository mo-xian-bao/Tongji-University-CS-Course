from src.errors import LexerError
from src.tokens import KEYWORDS, Token, TokenKind


class Lexer:
    """将源代码切分为 Token 序列。"""

    def __init__(self, source: str):
        self.source = source
        self.index = 0
        self.line = 1
        self.column = 1

    def tokenize(self) -> list[Token]:
        tokens: list[Token] = []

        while not self._is_at_end():
            self._skip_whitespace_and_comments()
            if self._is_at_end():
                break

            start_line = self.line
            start_col = self.column
            current = self._current_char()

            if current.isalpha() or current == "_":
                lexeme = self._read_identifier()
                kind = KEYWORDS.get(lexeme, TokenKind.IDENT)
                tokens.append(Token(kind, lexeme, start_line, start_col))
                continue

            if current.isdigit():
                lexeme = self._read_number()
                tokens.append(Token(TokenKind.NUMBER, lexeme, start_line, start_col))
                continue

            # 先匹配双字符运算符
            two_char = current + self._peek_char()
            if two_char == "->":
                self._advance()
                self._advance()
                tokens.append(Token(TokenKind.ARROW, "->", start_line, start_col))
                continue
            if two_char == "==":
                self._advance()
                self._advance()
                tokens.append(Token(TokenKind.EQEQ, "==", start_line, start_col))
                continue
            if two_char == "!=":
                self._advance()
                self._advance()
                tokens.append(Token(TokenKind.NE, "!=", start_line, start_col))
                continue
            if two_char == ">=":
                self._advance()
                self._advance()
                tokens.append(Token(TokenKind.GTE, ">=", start_line, start_col))
                continue
            if two_char == "<=":
                self._advance()
                self._advance()
                tokens.append(Token(TokenKind.LTE, "<=", start_line, start_col))
                continue

            # 单字符符号
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
                "#": TokenKind.HASH,
            }

            kind = single_map.get(current)
            if kind is not None:
                self._advance()
                tokens.append(Token(kind, current, start_line, start_col))
                continue

            raise LexerError(f"{start_line}:{start_col} 发现非法字符: {current!r}")

        tokens.append(Token(TokenKind.EOF, "", self.line, self.column))
        return tokens

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
