#include "token.h"

namespace analyzer {

std::string TokenKindToString(TokenKind kind) {
    switch (kind) {
        case TokenKind::Ident: return "IDENT";
        case TokenKind::Number: return "NUMBER";
        case TokenKind::KwI32: return "I32";
        case TokenKind::KwLet: return "LET";
        case TokenKind::KwIf: return "IF";
        case TokenKind::KwElse: return "ELSE";
        case TokenKind::KwWhile: return "WHILE";
        case TokenKind::KwReturn: return "RETURN";
        case TokenKind::KwMut: return "MUT";
        case TokenKind::KwFn: return "FN";
        case TokenKind::Plus: return "PLUS";
        case TokenKind::Minus: return "MINUS";
        case TokenKind::Star: return "STAR";
        case TokenKind::Slash: return "SLASH";
        case TokenKind::Eq: return "EQ";
        case TokenKind::EqEq: return "EQEQ";
        case TokenKind::Ne: return "NE";
        case TokenKind::Gt: return "GT";
        case TokenKind::Gte: return "GTE";
        case TokenKind::Lt: return "LT";
        case TokenKind::Lte: return "LTE";
        case TokenKind::Amp: return "AMP";
        case TokenKind::LParen: return "LPAREN";
        case TokenKind::RParen: return "RPAREN";
        case TokenKind::LBrace: return "LBRACE";
        case TokenKind::RBrace: return "RBRACE";
        case TokenKind::LBracket: return "LBRACKET";
        case TokenKind::RBracket: return "RBRACKET";
        case TokenKind::Semicolon: return "SEMICOLON";
        case TokenKind::Colon: return "COLON";
        case TokenKind::Comma: return "COMMA";
        case TokenKind::Arrow: return "ARROW";
        case TokenKind::Hash: return "HASH";
        case TokenKind::Eof: return "EOF";
    }
    return "UNKNOWN";
}

}  // namespace analyzer
