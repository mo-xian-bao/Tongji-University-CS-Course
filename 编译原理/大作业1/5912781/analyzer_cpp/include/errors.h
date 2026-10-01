#pragma once

#include <stdexcept>
#include <string>

namespace analyzer {

class CompilerError : public std::runtime_error {
public:
    explicit CompilerError(const std::string& message)
        : std::runtime_error(message) {}
};

class LexerError : public CompilerError {
public:
    explicit LexerError(const std::string& message)
        : CompilerError(message) {}
};

class ParserError : public CompilerError {
public:
    explicit ParserError(const std::string& message)
        : CompilerError(message) {}
};

}  // namespace analyzer
