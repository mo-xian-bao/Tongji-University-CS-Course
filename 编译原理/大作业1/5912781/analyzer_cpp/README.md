# 类 Rust 词法分析 + 语法分析器（C++ 最基础要求版）

本项目是 C++ 版本，目标与 Python 版本一致：
1. 对类 Rust 程序做词法分析。
2. 对类 Rust 程序做语法分析。
3. 输出 Token 列表与 AST。

本实现只覆盖作业最低要求，不做扩展功能。

## 1. 支持范围

词法支持：
- 关键字：i32 let if else while return mut fn
- 标识符：字母或下划线开头，后接字母数字下划线
- 数字：十进制整数
- 运算符：+ - * / = == != > >= < <=
- 界符和分隔符：() {} [] ; : , -> #
- 注释：// 行注释，/* */ 块注释

语法支持（最低要求）：
- 0.1 变量属性：mut 或空
- 0.2 类型：i32
- 0.3 左值：标识符
- 1.1 1.2 1.3 1.4 1.5
- 2.0 2.1 2.2
- 3.1 3.2 3.3（并补充了乘除优先级，便于表达式完整工作）
- 4.1 if
- 5.0 5.1 while

## 2. 项目结构与阅读顺序

建议按以下顺序阅读：
1. include/token.h
2. include/ast.h
3. include/lexer.h 和 src/lexer.cpp
4. include/parser.h 和 src/parser.cpp
5. src/main.cpp
6. examples/

## 3. 构建与运行

方式一：PowerShell 脚本（推荐，最省事）
1. 运行 build.ps1 编译
2. 运行 run.ps1 执行

方式二：手动命令（clang++）
1. 创建 build 目录
2. 使用 clang++ 编译 src 下所有 cpp 文件，头文件目录为 include
3. 生成 build/analyzer_cpp.exe
4. 执行生成的可执行文件

说明：
- 默认输入文件写在 src/main.cpp 的 RunConfig.inputFile 中。
- 默认是 examples/ok_minimal.rs。
- 如果要换文件，直接改这个常量路径。
- 也可以在运行时传入一个可选文件路径参数，例如 analyzer_cpp.exe examples/err_lex.rs。

## 4. 示例文件

- examples/ok_minimal.rs：通过样例
- examples/err_lex.rs：词法错误样例
- examples/err_parse.rs：语法错误样例

## 5. 输出说明

程序输出包含两部分：
1. 词法分析结果（Token 的行、列、类型、词素）
2. 语法分析结果（JSON 风格 AST）

成功时打印：
- 分析成功：词法与语法均通过。

失败时打印：
- 分析失败：错误位置 + 错误原因

## 6. 代码风格说明

本项目遵循初学者友好原则：
- 不追求炫技写法
- 核心流程一眼能看懂
- 注释解释关键步骤的意图
- 文件职责单一，结构清晰
