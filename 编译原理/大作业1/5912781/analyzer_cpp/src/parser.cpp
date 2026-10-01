#include "parser.h"

#include <sstream>
#include <utility>

#include "errors.h"

namespace analyzer {

Parser::Parser(std::vector<Token> tokens) : tokens_(std::move(tokens)) {}

Program Parser::ParseProgram() {
    Program program;

    while (!Check(TokenKind::Eof) && !Check(TokenKind::Hash)) {
        program.declarations.push_back(ParseFunctionDecl());
    }

    if (Match({TokenKind::Hash})) {
        // 允许可选结束符
    }

    Expect(TokenKind::Eof, "程序末尾应为 EOF");
    return program;
}

FunctionDecl Parser::ParseFunctionDecl() {
    Expect(TokenKind::KwFn, "函数声明应以 fn 开始");
    const std::string name = Expect(TokenKind::Ident, "fn 后应为函数名").lexeme;

    Expect(TokenKind::LParen, "函数名后缺少 '('");
    std::vector<Param> params = ParseParamList();
    Expect(TokenKind::RParen, "形参列表后缺少 ')'");

    std::optional<std::string> returnType;
    if (Match({TokenKind::Arrow})) {
        returnType = ParseType();
    }

    Block body = ParseBlock();
    return FunctionDecl{name, std::move(params), std::move(returnType), std::move(body)};
}

std::vector<Param> Parser::ParseParamList() {
    std::vector<Param> params;

    if (Check(TokenKind::RParen)) {
        return params;
    }

    params.push_back(ParseParam());
    while (Match({TokenKind::Comma})) {
        params.push_back(ParseParam());
    }

    return params;
}

Param Parser::ParseParam() {
    const bool isMut = Match({TokenKind::KwMut});
    const std::string name = Expect(TokenKind::Ident, "形参缺少标识符").lexeme;
    Expect(TokenKind::Colon, "形参标识符后缺少 ':'");
    const std::string typeName = ParseType();
    return Param{isMut, name, typeName};
}

std::string Parser::ParseType() {
    return Expect(TokenKind::KwI32, "当前最小实现仅支持 i32 类型").lexeme;
}

Block Parser::ParseBlock() {
    Expect(TokenKind::LBrace, "语句块缺少 '{'");
    Block block;

    while (!Check(TokenKind::RBrace)) {
        if (Check(TokenKind::Eof)) {
            ErrorAtCurrent("语句块未闭合，缺少 '}'");
        }
        block.statements.push_back(ParseStatement());
    }

    Expect(TokenKind::RBrace, "语句块缺少 '}'");
    return block;
}

std::unique_ptr<Statement> Parser::ParseStatement() {
    if (Match({TokenKind::Semicolon})) {
        return std::make_unique<EmptyStmt>();
    }

    if (Match({TokenKind::KwLet})) {
        return ParseLetStmt();
    }

    if (Match({TokenKind::KwReturn})) {
        return ParseReturnStmt();
    }

    if (Match({TokenKind::KwIf})) {
        return ParseIfStmt();
    }

    if (Match({TokenKind::KwWhile})) {
        return ParseWhileStmt();
    }

    if (Check(TokenKind::Ident) && CheckNext(TokenKind::Eq)) {
        return ParseAssignStmt();
    }

    return ParseExprStmt();
}

std::unique_ptr<Statement> Parser::ParseLetStmt() {
    const bool isMut = Match({TokenKind::KwMut});
    const std::string name = Expect(TokenKind::Ident, "let 后缺少变量名").lexeme;

    std::optional<std::string> typeName;
    if (Match({TokenKind::Colon})) {
        typeName = ParseType();
    }

    Expect(TokenKind::Semicolon, "变量声明语句末尾缺少 ';'");

    auto stmt = std::make_unique<LetStmt>();
    stmt->isMut = isMut;
    stmt->name = name;
    stmt->typeName = std::move(typeName);
    return stmt;
}

std::unique_ptr<Statement> Parser::ParseAssignStmt() {
    const std::string targetName = Expect(TokenKind::Ident, "赋值语句缺少左值").lexeme;
    Expect(TokenKind::Eq, "赋值语句左值后应为 '='");
    std::unique_ptr<Expr> value = ParseExpression();
    Expect(TokenKind::Semicolon, "赋值语句末尾缺少 ';'");

    auto stmt = std::make_unique<AssignStmt>();
    stmt->targetName = targetName;
    stmt->value = std::move(value);
    return stmt;
}

std::unique_ptr<Statement> Parser::ParseReturnStmt() {
    auto stmt = std::make_unique<ReturnStmt>();

    if (Match({TokenKind::Semicolon})) {
        return stmt;
    }

    stmt->value = ParseExpression();
    Expect(TokenKind::Semicolon, "return 语句末尾缺少 ';'");
    return stmt;
}

std::unique_ptr<Statement> Parser::ParseIfStmt() {
    auto stmt = std::make_unique<IfStmt>();
    stmt->condition = ParseExpression();

    auto thenBlock = std::make_unique<Block>();
    *thenBlock = ParseBlock();
    stmt->thenBlock = std::move(thenBlock);

    if (Match({TokenKind::KwElse})) {
        auto elseBlock = std::make_unique<Block>();
        *elseBlock = ParseBlock();
        stmt->elseBlock = std::move(elseBlock);
    }

    return stmt;
}

std::unique_ptr<Statement> Parser::ParseWhileStmt() {
    auto stmt = std::make_unique<WhileStmt>();
    stmt->condition = ParseExpression();

    auto body = std::make_unique<Block>();
    *body = ParseBlock();
    stmt->body = std::move(body);
    return stmt;
}

std::unique_ptr<Statement> Parser::ParseExprStmt() {
    auto stmt = std::make_unique<ExprStmt>();
    stmt->expr = ParseExpression();
    Expect(TokenKind::Semicolon, "表达式语句末尾缺少 ';'");
    return stmt;
}

std::unique_ptr<Expr> Parser::ParseExpression() {
    return ParseComparison();
}

std::unique_ptr<Expr> Parser::ParseComparison() {
    std::unique_ptr<Expr> expr = ParseAdditive();

    while (Match({TokenKind::EqEq, TokenKind::Ne, TokenKind::Gt, TokenKind::Gte, TokenKind::Lt, TokenKind::Lte})) {
        const std::string op = Previous().lexeme;
        std::unique_ptr<Expr> right = ParseAdditive();

        auto node = std::make_unique<BinaryExpr>();
        node->left = std::move(expr);
        node->op = op;
        node->right = std::move(right);
        expr = std::move(node);
    }

    return expr;
}

std::unique_ptr<Expr> Parser::ParseAdditive() {
    std::unique_ptr<Expr> expr = ParseTerm();

    while (Match({TokenKind::Plus, TokenKind::Minus})) {
        const std::string op = Previous().lexeme;
        std::unique_ptr<Expr> right = ParseTerm();

        auto node = std::make_unique<BinaryExpr>();
        node->left = std::move(expr);
        node->op = op;
        node->right = std::move(right);
        expr = std::move(node);
    }

    return expr;
}

std::unique_ptr<Expr> Parser::ParseTerm() {
    std::unique_ptr<Expr> expr = ParseFactor();

    while (Match({TokenKind::Star, TokenKind::Slash})) {
        const std::string op = Previous().lexeme;
        std::unique_ptr<Expr> right = ParseFactor();

        auto node = std::make_unique<BinaryExpr>();
        node->left = std::move(expr);
        node->op = op;
        node->right = std::move(right);
        expr = std::move(node);
    }

    return expr;
}

std::unique_ptr<Expr> Parser::ParseFactor() {
    if (Match({TokenKind::Number})) {
        auto node = std::make_unique<NumberExpr>();
        node->value = std::stoi(Previous().lexeme);
        return node;
    }

    if (Match({TokenKind::Ident})) {
        auto node = std::make_unique<IdentifierExpr>();
        node->name = Previous().lexeme;
        return node;
    }

    if (Match({TokenKind::LParen})) {
        std::unique_ptr<Expr> expr = ParseExpression();
        Expect(TokenKind::RParen, "括号表达式缺少 ')'");
        return expr;
    }

    ErrorAtCurrent("表达式起始符号不合法");
}

bool Parser::Match(std::initializer_list<TokenKind> kinds) {
    for (TokenKind kind : kinds) {
        if (Check(kind)) {
            Advance();
            return true;
        }
    }
    return false;
}

const Token& Parser::Expect(TokenKind kind, const std::string& message) {
    if (Check(kind)) {
        return Advance();
    }
    ErrorAtCurrent(message);
}

bool Parser::Check(TokenKind kind) const {
    if (IsAtEnd()) {
        return kind == TokenKind::Eof;
    }
    return Current().kind == kind;
}

bool Parser::CheckNext(TokenKind kind) const {
    if (pos_ + 1 >= tokens_.size()) {
        return false;
    }
    return tokens_[pos_ + 1].kind == kind;
}

const Token& Parser::Advance() {
    if (!IsAtEnd()) {
        ++pos_;
    }
    return Previous();
}

bool Parser::IsAtEnd() const {
    return Current().kind == TokenKind::Eof;
}

const Token& Parser::Current() const {
    return tokens_[pos_];
}

const Token& Parser::Previous() const {
    return tokens_[pos_ - 1];
}

[[noreturn]] void Parser::ErrorAtCurrent(const std::string& message) const {
    const Token& token = Current();
    const std::string found = token.lexeme.empty() ? TokenKindToString(token.kind) : token.lexeme;

    std::ostringstream oss;
    oss << token.line << ":" << token.column << " " << message << "，当前符号: '" << found << "'";
    throw ParserError(oss.str());
}

}  // namespace analyzer
