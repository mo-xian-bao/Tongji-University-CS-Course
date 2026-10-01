class CompilerError(Exception):
    """编译器相关错误的统一基类。"""


class LexerError(CompilerError):
    """词法分析错误。"""


class ParserError(CompilerError):
    """语法分析错误。"""
