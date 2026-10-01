#pragma once

#include <string>
#include <unordered_map>

namespace analyzer {

enum class TokenKind {
    // 标识符与字面量
    Ident,
    Number,

    // 关键字
    KwI32,
    KwLet,
    KwIf,
    KwElse,
    KwWhile,
    KwReturn,
    KwMut,
    KwFn,

    // 运算符
    Plus,
    Minus,
    Star,
    Slash,
    Eq,
    EqEq,
    Ne,
    Gt,
    Gte,
    Lt,
    Lte,
    Amp,

    // 界符与分隔符
    LParen,
    RParen,
    LBrace,
    RBrace,
    LBracket,
    RBracket,
    Semicolon,
    Colon,
    Comma,
    Arrow,
    Hash,

    Eof,
};

struct Token {
    TokenKind kind;
    std::string lexeme;
    int line;
    int column;
};

inline const std::unordered_map<std::string, TokenKind> kKeywords = {
    {"i32", TokenKind::KwI32},
    {"let", TokenKind::KwLet},
    {"if", TokenKind::KwIf},
    {"else", TokenKind::KwElse},
    {"while", TokenKind::KwWhile},
    {"return", TokenKind::KwReturn},
    {"mut", TokenKind::KwMut},
    {"fn", TokenKind::KwFn},
};

std::string TokenKindToString(TokenKind kind);

}  // namespace analyzer
