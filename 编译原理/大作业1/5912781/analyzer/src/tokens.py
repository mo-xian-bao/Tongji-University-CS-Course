from dataclasses import dataclass
from enum import Enum, auto


class TokenKind(Enum):
    # 标识符与字面量
    IDENT = auto()
    NUMBER = auto()

    # 关键字
    I32 = auto()
    LET = auto()
    IF = auto()
    ELSE = auto()
    WHILE = auto()
    RETURN = auto()
    MUT = auto()
    FN = auto()

    # 运算符
    PLUS = auto()      # +
    MINUS = auto()     # -
    STAR = auto()      # *
    SLASH = auto()     # /
    EQ = auto()        # =
    EQEQ = auto()      # ==
    NE = auto()        # !=
    GT = auto()        # >
    GTE = auto()       # >=
    LT = auto()        # <
    LTE = auto()       # <=
    AMP = auto()       # &

    # 界符与分隔符
    LPAREN = auto()    # (
    RPAREN = auto()    # )
    LBRACE = auto()    # {
    RBRACE = auto()    # }
    LBRACKET = auto()  # [
    RBRACKET = auto()  # ]
    SEMICOLON = auto() # ;
    COLON = auto()     # :
    COMMA = auto()     # ,
    ARROW = auto()     # ->
    HASH = auto()      # #

    EOF = auto()


KEYWORDS = {
    "i32": TokenKind.I32,
    "let": TokenKind.LET,
    "if": TokenKind.IF,
    "else": TokenKind.ELSE,
    "while": TokenKind.WHILE,
    "return": TokenKind.RETURN,
    "mut": TokenKind.MUT,
    "fn": TokenKind.FN,
}


@dataclass(frozen=True)
class Token:
    kind: TokenKind
    lexeme: str
    line: int
    column: int

    def __str__(self) -> str:
        return f"{self.line}:{self.column} {self.kind.name} {self.lexeme!r}"
