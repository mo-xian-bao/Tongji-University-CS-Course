#include "ast.h"

#include <sstream>
#include <stdexcept>
#include <string>

namespace analyzer {
namespace {

std::string Indent(int level) {
    return std::string(level * 2, ' ');
}

std::string Escape(const std::string& text) {
    std::string out;
    out.reserve(text.size());
    for (char c : text) {
        if (c == '"') {
            out += "\\\"";
        } else if (c == '\\') {
            out += "\\\\";
        } else {
            out += c;
        }
    }
    return out;
}

std::string ExprToJson(const Expr& expr, int indentLevel);
std::string StatementToJson(const Statement& stmt, int indentLevel);
std::string BlockToJson(const Block& block, int indentLevel);

std::string ExprToJson(const Expr& expr, int indentLevel) {
    std::ostringstream oss;

    if (const auto* node = dynamic_cast<const NumberExpr*>(&expr)) {
        oss << Indent(indentLevel) << "{\n";
        oss << Indent(indentLevel + 1) << "\"type\": \"NumberExpr\",\n";
        oss << Indent(indentLevel + 1) << "\"value\": " << node->value << "\n";
        oss << Indent(indentLevel) << "}";
        return oss.str();
    }

    if (const auto* node = dynamic_cast<const IdentifierExpr*>(&expr)) {
        oss << Indent(indentLevel) << "{\n";
        oss << Indent(indentLevel + 1) << "\"type\": \"IdentifierExpr\",\n";
        oss << Indent(indentLevel + 1) << "\"name\": \"" << Escape(node->name) << "\"\n";
        oss << Indent(indentLevel) << "}";
        return oss.str();
    }

    if (const auto* node = dynamic_cast<const BinaryExpr*>(&expr)) {
        oss << Indent(indentLevel) << "{\n";
        oss << Indent(indentLevel + 1) << "\"type\": \"BinaryExpr\",\n";
        oss << Indent(indentLevel + 1) << "\"op\": \"" << Escape(node->op) << "\",\n";
        oss << Indent(indentLevel + 1) << "\"left\":\n";
        oss << ExprToJson(*node->left, indentLevel + 2) << ",\n";
        oss << Indent(indentLevel + 1) << "\"right\":\n";
        oss << ExprToJson(*node->right, indentLevel + 2) << "\n";
        oss << Indent(indentLevel) << "}";
        return oss.str();
    }

    throw std::runtime_error("未知表达式节点");
}

std::string StatementToJson(const Statement& stmt, int indentLevel) {
    std::ostringstream oss;

    if (dynamic_cast<const EmptyStmt*>(&stmt) != nullptr) {
        oss << Indent(indentLevel) << "{\n";
        oss << Indent(indentLevel + 1) << "\"type\": \"EmptyStmt\"\n";
        oss << Indent(indentLevel) << "}";
        return oss.str();
    }

    if (const auto* node = dynamic_cast<const LetStmt*>(&stmt)) {
        oss << Indent(indentLevel) << "{\n";
        oss << Indent(indentLevel + 1) << "\"type\": \"LetStmt\",\n";
        oss << Indent(indentLevel + 1) << "\"is_mut\": " << (node->isMut ? "true" : "false") << ",\n";
        oss << Indent(indentLevel + 1) << "\"name\": \"" << Escape(node->name) << "\",\n";
        oss << Indent(indentLevel + 1) << "\"type_name\": ";
        if (node->typeName.has_value()) {
            oss << "\"" << Escape(node->typeName.value()) << "\"\n";
        } else {
            oss << "null\n";
        }
        oss << Indent(indentLevel) << "}";
        return oss.str();
    }

    if (const auto* node = dynamic_cast<const AssignStmt*>(&stmt)) {
        oss << Indent(indentLevel) << "{\n";
        oss << Indent(indentLevel + 1) << "\"type\": \"AssignStmt\",\n";
        oss << Indent(indentLevel + 1) << "\"target_name\": \"" << Escape(node->targetName) << "\",\n";
        oss << Indent(indentLevel + 1) << "\"value\":\n";
        oss << ExprToJson(*node->value, indentLevel + 2) << "\n";
        oss << Indent(indentLevel) << "}";
        return oss.str();
    }

    if (const auto* node = dynamic_cast<const ReturnStmt*>(&stmt)) {
        oss << Indent(indentLevel) << "{\n";
        oss << Indent(indentLevel + 1) << "\"type\": \"ReturnStmt\",\n";
        oss << Indent(indentLevel + 1) << "\"value\": ";
        if (node->value) {
            oss << "\n" << ExprToJson(*node->value, indentLevel + 2) << "\n";
            oss << Indent(indentLevel) << "}";
        } else {
            oss << "null\n";
            oss << Indent(indentLevel) << "}";
        }
        return oss.str();
    }

    if (const auto* node = dynamic_cast<const IfStmt*>(&stmt)) {
        oss << Indent(indentLevel) << "{\n";
        oss << Indent(indentLevel + 1) << "\"type\": \"IfStmt\",\n";
        oss << Indent(indentLevel + 1) << "\"condition\":\n";
        oss << ExprToJson(*node->condition, indentLevel + 2) << ",\n";
        oss << Indent(indentLevel + 1) << "\"then_block\":\n";
        oss << BlockToJson(*node->thenBlock, indentLevel + 2) << ",\n";
        oss << Indent(indentLevel + 1) << "\"else_block\": ";
        if (node->elseBlock) {
            oss << "\n" << BlockToJson(*node->elseBlock, indentLevel + 2) << "\n";
            oss << Indent(indentLevel) << "}";
        } else {
            oss << "null\n";
            oss << Indent(indentLevel) << "}";
        }
        return oss.str();
    }

    if (const auto* node = dynamic_cast<const WhileStmt*>(&stmt)) {
        oss << Indent(indentLevel) << "{\n";
        oss << Indent(indentLevel + 1) << "\"type\": \"WhileStmt\",\n";
        oss << Indent(indentLevel + 1) << "\"condition\":\n";
        oss << ExprToJson(*node->condition, indentLevel + 2) << ",\n";
        oss << Indent(indentLevel + 1) << "\"body\":\n";
        oss << BlockToJson(*node->body, indentLevel + 2) << "\n";
        oss << Indent(indentLevel) << "}";
        return oss.str();
    }

    if (const auto* node = dynamic_cast<const ExprStmt*>(&stmt)) {
        oss << Indent(indentLevel) << "{\n";
        oss << Indent(indentLevel + 1) << "\"type\": \"ExprStmt\",\n";
        oss << Indent(indentLevel + 1) << "\"expr\":\n";
        oss << ExprToJson(*node->expr, indentLevel + 2) << "\n";
        oss << Indent(indentLevel) << "}";
        return oss.str();
    }

    throw std::runtime_error("未知语句节点");
}

std::string BlockToJson(const Block& block, int indentLevel) {
    std::ostringstream oss;
    oss << Indent(indentLevel) << "{\n";
    oss << Indent(indentLevel + 1) << "\"type\": \"Block\",\n";
    oss << Indent(indentLevel + 1) << "\"statements\": [\n";

    for (std::size_t i = 0; i < block.statements.size(); ++i) {
        oss << StatementToJson(*block.statements[i], indentLevel + 2);
        if (i + 1 < block.statements.size()) {
            oss << ",";
        }
        oss << "\n";
    }

    oss << Indent(indentLevel + 1) << "]\n";
    oss << Indent(indentLevel) << "}";
    return oss.str();
}

}  // namespace

std::string ProgramToJson(const Program& program) {
    std::ostringstream oss;
    oss << "{\n";
    oss << "  \"type\": \"Program\",\n";
    oss << "  \"declarations\": [\n";

    for (std::size_t i = 0; i < program.declarations.size(); ++i) {
        const FunctionDecl& fn = program.declarations[i];
        oss << "    {\n";
        oss << "      \"type\": \"FunctionDecl\",\n";
        oss << "      \"name\": \"" << Escape(fn.name) << "\",\n";

        oss << "      \"params\": [\n";
        for (std::size_t j = 0; j < fn.params.size(); ++j) {
            const Param& p = fn.params[j];
            oss << "        {\n";
            oss << "          \"type\": \"Param\",\n";
            oss << "          \"is_mut\": " << (p.isMut ? "true" : "false") << ",\n";
            oss << "          \"name\": \"" << Escape(p.name) << "\",\n";
            oss << "          \"type_name\": \"" << Escape(p.typeName) << "\"\n";
            oss << "        }";
            if (j + 1 < fn.params.size()) {
                oss << ",";
            }
            oss << "\n";
        }
        oss << "      ],\n";

        oss << "      \"return_type\": ";
        if (fn.returnType.has_value()) {
            oss << "\"" << Escape(fn.returnType.value()) << "\",\n";
        } else {
            oss << "null,\n";
        }

        oss << "      \"body\":\n";
        oss << BlockToJson(fn.body, 4) << "\n";
        oss << "    }";
        if (i + 1 < program.declarations.size()) {
            oss << ",";
        }
        oss << "\n";
    }

    oss << "  ]\n";
    oss << "}\n";
    return oss.str();
}

}  // namespace analyzer
