#include "lexer.h"

#include <cctype>
#include <sstream>
#include <unordered_map>

#include "errors.h"

namespace analyzer {

Lexer::Lexer(std::string source) : source_(std::move(source)) {}

std::vector<Token> Lexer::Tokenize() {
    std::vector<Token> tokens;

    while (!IsAtEnd()) {
        SkipWhitespaceAndComments();
        if (IsAtEnd()) {
            break;
        }

        const int startLine = line_;
        const int startColumn = column_;
        const char current = CurrentChar();

        if (std::isalpha(static_cast<unsigned char>(current)) || current == '_') {
            const std::string lexeme = ReadIdentifier();
            const auto keywordIt = kKeywords.find(lexeme);
            const TokenKind kind = (keywordIt == kKeywords.end()) ? TokenKind::Ident : keywordIt->second;
            tokens.push_back(Token{kind, lexeme, startLine, startColumn});
            continue;
        }

        if (std::isdigit(static_cast<unsigned char>(current))) {
            const std::string lexeme = ReadNumber();
            tokens.push_back(Token{TokenKind::Number, lexeme, startLine, startColumn});
            continue;
        }

        const std::string twoChars{current, PeekChar()};
        if (twoChars == "->") {
            Advance();
            Advance();
            tokens.push_back(Token{TokenKind::Arrow, "->", startLine, startColumn});
            continue;
        }
        if (twoChars == "==") {
            Advance();
            Advance();
            tokens.push_back(Token{TokenKind::EqEq, "==", startLine, startColumn});
            continue;
        }
        if (twoChars == "!=") {
            Advance();
            Advance();
            tokens.push_back(Token{TokenKind::Ne, "!=", startLine, startColumn});
            continue;
        }
        if (twoChars == ">=") {
            Advance();
            Advance();
            tokens.push_back(Token{TokenKind::Gte, ">=", startLine, startColumn});
            continue;
        }
        if (twoChars == "<=") {
            Advance();
            Advance();
            tokens.push_back(Token{TokenKind::Lte, "<=", startLine, startColumn});
            continue;
        }

        static const std::unordered_map<char, TokenKind> singleMap = {
            {'+', TokenKind::Plus},
            {'-', TokenKind::Minus},
            {'*', TokenKind::Star},
            {'/', TokenKind::Slash},
            {'=', TokenKind::Eq},
            {'>', TokenKind::Gt},
            {'<', TokenKind::Lt},
            {'&', TokenKind::Amp},
            {'(', TokenKind::LParen},
            {')', TokenKind::RParen},
            {'{', TokenKind::LBrace},
            {'}', TokenKind::RBrace},
            {'[', TokenKind::LBracket},
            {']', TokenKind::RBracket},
            {';', TokenKind::Semicolon},
            {':', TokenKind::Colon},
            {',', TokenKind::Comma},
            {'#', TokenKind::Hash},
        };

        const auto it = singleMap.find(current);
        if (it != singleMap.end()) {
            Advance();
            tokens.push_back(Token{it->second, std::string(1, current), startLine, startColumn});
            continue;
        }

        std::ostringstream oss;
        oss << startLine << ":" << startColumn << " 发现非法字符: '" << current << "'";
        throw LexerError(oss.str());
    }

    tokens.push_back(Token{TokenKind::Eof, "", line_, column_});
    return tokens;
}

void Lexer::SkipWhitespaceAndComments() {
    while (!IsAtEnd()) {
        const char c = CurrentChar();

        if (c == ' ' || c == '\t' || c == '\r' || c == '\n') {
            Advance();
            continue;
        }

        if (c == '/' && PeekChar() == '/') {
            Advance();
            Advance();
            while (!IsAtEnd() && CurrentChar() != '\n') {
                Advance();
            }
            continue;
        }

        if (c == '/' && PeekChar() == '*') {
            const int commentLine = line_;
            const int commentColumn = column_;
            Advance();
            Advance();

            bool closed = false;
            while (!IsAtEnd()) {
                if (CurrentChar() == '*' && PeekChar() == '/') {
                    Advance();
                    Advance();
                    closed = true;
                    break;
                }
                Advance();
            }

            if (!closed) {
                std::ostringstream oss;
                oss << commentLine << ":" << commentColumn << " 块注释未闭合";
                throw LexerError(oss.str());
            }

            continue;
        }

        break;
    }
}

std::string Lexer::ReadIdentifier() {
    std::string text;
    while (!IsAtEnd()) {
        const char c = CurrentChar();
        if (std::isalnum(static_cast<unsigned char>(c)) || c == '_') {
            text.push_back(Advance());
        } else {
            break;
        }
    }
    return text;
}

std::string Lexer::ReadNumber() {
    std::string text;
    while (!IsAtEnd() && std::isdigit(static_cast<unsigned char>(CurrentChar()))) {
        text.push_back(Advance());
    }
    return text;
}

bool Lexer::IsAtEnd() const {
    return index_ >= source_.size();
}

char Lexer::CurrentChar() const {
    return source_[index_];
}

char Lexer::PeekChar() const {
    if (index_ + 1 >= source_.size()) {
        return '\0';
    }
    return source_[index_ + 1];
}

char Lexer::Advance() {
    const char c = source_[index_];
    ++index_;

    if (c == '\n') {
        ++line_;
        column_ = 1;
    } else {
        ++column_;
    }

    return c;
}

}  // namespace analyzer
