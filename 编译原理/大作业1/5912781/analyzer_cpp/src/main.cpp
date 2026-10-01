#include <fstream>
#include <iomanip>
#include <iostream>
#include <sstream>
#include <string>

#include "ast.h"
#include "errors.h"
#include "lexer.h"
#include "parser.h"
#include "token.h"

namespace {

struct RunConfig {
    std::string inputFile = "examples/ok_minimal.rs";
    bool showTokens = true;
    bool showAst = true;
};

bool RunFile(const RunConfig& config) {
    try {
        std::ifstream fin(config.inputFile);
        if (!fin.is_open()) {
            throw std::runtime_error("无法打开输入文件: " + config.inputFile);
        }

        std::ostringstream buffer;
        buffer << fin.rdbuf();
        const std::string source = buffer.str();

        analyzer::Lexer lexer(source);
        std::vector<analyzer::Token> tokens = lexer.Tokenize();

        if (config.showTokens) {
            std::cout << "=== 词法分析结果 ===\n";
            for (const auto& token : tokens) {
                if (token.kind == analyzer::TokenKind::Eof) {
                    continue;
                }
                std::cout << std::setw(3) << token.line << ":"
                          << std::left << std::setw(3) << token.column << "  "
                          << std::setw(10) << analyzer::TokenKindToString(token.kind) << "  "
                          << token.lexeme << "\n";
            }
            std::cout << "\n";
        }

        analyzer::Parser parser(tokens);
        analyzer::Program program = parser.ParseProgram();

        if (config.showAst) {
            std::cout << "=== 语法分析结果（AST）===\n";
            std::cout << analyzer::ProgramToJson(program) << "\n";
        }

        std::cout << "分析成功：词法与语法均通过。\n";
        return true;
    } catch (const analyzer::CompilerError& e) {
        std::cout << "分析失败：" << e.what() << "\n";
        return false;
    } catch (const std::exception& e) {
        std::cout << "分析失败：" << e.what() << "\n";
        return false;
    }
}

}  // namespace

int main(int argc, char* argv[]) {
    RunConfig config;

    // 默认无参数运行；如果给了文件路径，则优先使用该路径。
    if (argc >= 2) {
        config.inputFile = argv[1];
    }

    const bool ok = RunFile(config);
    return ok ? 0 : 1;
}
