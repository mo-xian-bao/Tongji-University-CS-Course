#pragma once

#include <string>
#include <vector>

#include "token.h"

namespace analyzer {

class Lexer {
public:
    explicit Lexer(std::string source);

    std::vector<Token> Tokenize();

private:
    void SkipWhitespaceAndComments();
    std::string ReadIdentifier();
    std::string ReadNumber();

    bool IsAtEnd() const;
    char CurrentChar() const;
    char PeekChar() const;
    char Advance();

    std::string source_;
    std::size_t index_ = 0;
    int line_ = 1;
    int column_ = 1;
};

}  // namespace analyzer
