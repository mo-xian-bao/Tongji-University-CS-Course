class CompilerError(Exception):
    """Base class for compiler-related errors."""


class LexerError(CompilerError):
    """Lexer error."""


class ParserError(CompilerError):
    """Parser error."""


class SemanticError(CompilerError):
    """Semantic-analysis error."""


class CodegenError(CompilerError):
    """Intermediate-code generation error."""


class TargetCodeError(CompilerError):
    """Target assembly generation error."""
