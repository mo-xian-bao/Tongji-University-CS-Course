#pragma once

#include <memory>
#include <optional>
#include <string>
#include <vector>

namespace analyzer {

struct Expr {
    virtual ~Expr() = default;
};

struct NumberExpr : Expr {
    int value = 0;
};

struct IdentifierExpr : Expr {
    std::string name;
};

struct BinaryExpr : Expr {
    std::unique_ptr<Expr> left;
    std::string op;
    std::unique_ptr<Expr> right;
};

struct Statement {
    virtual ~Statement() = default;
};

struct EmptyStmt : Statement {};

struct LetStmt : Statement {
    bool isMut = false;
    std::string name;
    std::optional<std::string> typeName;
};

struct AssignStmt : Statement {
    std::string targetName;
    std::unique_ptr<Expr> value;
};

struct ReturnStmt : Statement {
    std::unique_ptr<Expr> value;
};

struct Block;

struct IfStmt : Statement {
    std::unique_ptr<Expr> condition;
    std::unique_ptr<Block> thenBlock;
    std::unique_ptr<Block> elseBlock;
};

struct WhileStmt : Statement {
    std::unique_ptr<Expr> condition;
    std::unique_ptr<Block> body;
};

struct ExprStmt : Statement {
    std::unique_ptr<Expr> expr;
};

struct Block {
    std::vector<std::unique_ptr<Statement>> statements;
};

struct Param {
    bool isMut = false;
    std::string name;
    std::string typeName;
};

struct FunctionDecl {
    std::string name;
    std::vector<Param> params;
    std::optional<std::string> returnType;
    Block body;
};

struct Program {
    std::vector<FunctionDecl> declarations;
};

std::string ProgramToJson(const Program& program);

}  // namespace analyzer
