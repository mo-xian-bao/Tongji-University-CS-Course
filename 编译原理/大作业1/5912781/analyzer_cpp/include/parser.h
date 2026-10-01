#pragma once

#include <memory>
#include <vector>

#include "ast.h"
#include "token.h"

namespace analyzer {

class Parser {
public:
    explicit Parser(std::vector<Token> tokens);

    Program ParseProgram();

private:
    FunctionDecl ParseFunctionDecl();
    std::vector<Param> ParseParamList();
    Param ParseParam();
    std::string ParseType();
    Block ParseBlock();

    std::unique_ptr<Statement> ParseStatement();
    std::unique_ptr<Statement> ParseLetStmt();
    std::unique_ptr<Statement> ParseAssignStmt();
    std::unique_ptr<Statement> ParseReturnStmt();
    std::unique_ptr<Statement> ParseIfStmt();
    std::unique_ptr<Statement> ParseWhileStmt();
    std::unique_ptr<Statement> ParseExprStmt();

    std::unique_ptr<Expr> ParseExpression();
    std::unique_ptr<Expr> ParseComparison();
    std::unique_ptr<Expr> ParseAdditive();
    std::unique_ptr<Expr> ParseTerm();
    std::unique_ptr<Expr> ParseFactor();

    bool Match(std::initializer_list<TokenKind> kinds);
    const Token& Expect(TokenKind kind, const std::string& message);
    bool Check(TokenKind kind) const;
    bool CheckNext(TokenKind kind) const;

    const Token& Advance();
    bool IsAtEnd() const;
    const Token& Current() const;
    const Token& Previous() const;

    [[noreturn]] void ErrorAtCurrent(const std::string& message) const;

    std::vector<Token> tokens_;
    std::size_t pos_ = 0;
};

}  // namespace analyzer
