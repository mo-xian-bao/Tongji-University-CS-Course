# Run script for this project.
Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"
[Console]::OutputEncoding = [System.Text.UTF8Encoding]::new($false)

$ProjectRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$BuildDir = Join-Path $ProjectRoot "build"

if (-not (Test-Path $BuildDir)) {
    & (Join-Path $ProjectRoot "build.ps1")
}

$Exe = Join-Path $BuildDir "analyzer_cpp.exe"

if (-not (Test-Path $Exe)) {
    throw "Executable file not found."
}

Set-Location $ProjectRoot
& $Exe
