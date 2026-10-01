cmake_minimum_required(VERSION 3.16)
project(analyzer_cpp LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

add_executable(analyzer_cpp
    src/main.cpp
    src/token.cpp
    src/lexer.cpp
    src/parser.cpp
    src/ast.cpp
)

target_include_directories(analyzer_cpp PRIVATE include)
