# Build script for this project.
Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$ProjectRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$BuildDir = Join-Path $ProjectRoot "build"

if (-not (Test-Path $BuildDir)) {
    New-Item -ItemType Directory -Path $BuildDir | Out-Null
}

$Sources = @(
    (Join-Path $ProjectRoot "src/main.cpp"),
    (Join-Path $ProjectRoot "src/token.cpp"),
    (Join-Path $ProjectRoot "src/lexer.cpp"),
    (Join-Path $ProjectRoot "src/parser.cpp"),
    (Join-Path $ProjectRoot "src/ast.cpp")
)

$IncludeDir = Join-Path $ProjectRoot "include"
$OutputExe = Join-Path $BuildDir "analyzer_cpp.exe"

clang++ -std=c++17 -Wall -Wextra -D_ALLOW_COMPILER_AND_STL_VERSION_MISMATCH -I $IncludeDir $Sources -o $OutputExe
if ($LASTEXITCODE -ne 0) {
    throw "clang++ build failed."
}
