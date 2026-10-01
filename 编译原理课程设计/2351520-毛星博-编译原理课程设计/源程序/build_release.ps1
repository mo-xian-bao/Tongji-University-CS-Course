[CmdletBinding()]
param()

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$ProjectRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$Python = "D:\python3.11.9\python.exe"
$DistPath = Join-Path $ProjectRoot "dist"
$WorkPath = Join-Path $ProjectRoot "build\pyinstaller"
$SpecPath = Join-Path $WorkPath "spec"
$IconGenerator = Join-Path $ProjectRoot "tools\generate_icon.py"
$IconPath = Join-Path $ProjectRoot "assets\compiler.ico"
$VersionInfo = Join-Path $ProjectRoot "assets\version_info.txt"
$GuiEntry = Join-Path $ProjectRoot "gui.py"
$CliEntry = Join-Path $ProjectRoot "run.py"
$ExamplesRoot = Join-Path $ProjectRoot "examples"
$AssetsData = (Join-Path $ProjectRoot "assets") + ":assets"

function Assert-Path {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Path,
        [Parameter(Mandatory = $true)]
        [string]$Description
    )

    if (-not (Test-Path -LiteralPath $Path)) {
        throw "$Description not found: $Path"
    }
}

function Invoke-Python {
    param(
        [Parameter(Mandatory = $true)]
        [string[]]$Arguments
    )

    & $Python @Arguments
    if ($LASTEXITCODE -ne 0) {
        throw "Python command failed with exit code $LASTEXITCODE."
    }
}

function Get-PeSubsystem {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Path
    )

    $Bytes = [System.IO.File]::ReadAllBytes($Path)
    $PeOffset = [BitConverter]::ToInt32($Bytes, 0x3c)
    $OptionalHeader = $PeOffset + 24
    return [BitConverter]::ToUInt16($Bytes, $OptionalHeader + 0x44)
}

Assert-Path $Python "Python 3.11"
Assert-Path $IconGenerator "Icon generator"
Assert-Path $VersionInfo "Version resource"
Assert-Path $GuiEntry "GUI entry point"
Assert-Path $CliEntry "CLI entry point"
Assert-Path $ExamplesRoot "Examples directory"

Push-Location $ProjectRoot
try {
    Write-Host "Generating application icons..." -ForegroundColor Cyan
    Invoke-Python -Arguments @("-B", $IconGenerator)
    Assert-Path $IconPath "Generated application icon"

    if (Test-Path -LiteralPath $WorkPath) {
        Remove-Item -LiteralPath $WorkPath -Recurse -Force
    }
    New-Item -ItemType Directory -Path $DistPath, $SpecPath -Force | Out-Null

    Write-Host "Building windowed GUI executable..." -ForegroundColor Cyan
    $ExampleDataArguments = @()
    Get-ChildItem -LiteralPath $ExamplesRoot -Recurse -File -Filter "*.rs" |
        Sort-Object FullName |
        ForEach-Object {
            $RelativePath = $_.FullName.Substring($ExamplesRoot.Length + 1)
            $RelativeDirectory = [System.IO.Path]::GetDirectoryName($RelativePath)
            $Destination = "examples"
            if ($RelativeDirectory) {
                $Destination += "/" + $RelativeDirectory.Replace("\", "/")
            }
            $ExampleDataArguments += @("--add-data", ($_.FullName + ":" + $Destination))
        }

    $GuiArguments = @(
        "-m", "PyInstaller",
        "--noconfirm", "--clean", "--noupx", "--onefile", "--windowed",
        "--name", "rust_like_compiler",
        "--distpath", $DistPath,
        "--workpath", (Join-Path $WorkPath "gui"),
        "--specpath", $SpecPath,
        "--icon", $IconPath,
        "--version-file", $VersionInfo,
        "--add-data", $AssetsData
    )
    $GuiArguments += $ExampleDataArguments
    $GuiArguments += $GuiEntry
    Invoke-Python -Arguments $GuiArguments

    Write-Host "Building console CLI executable..." -ForegroundColor Cyan
    $CliArguments = @(
        "-m", "PyInstaller",
        "--noconfirm", "--clean", "--noupx", "--onefile", "--console",
        "--name", "rust_like_compiler_cli",
        "--distpath", $DistPath,
        "--workpath", (Join-Path $WorkPath "cli"),
        "--specpath", $SpecPath,
        "--icon", $IconPath,
        "--version-file", $VersionInfo,
        $CliEntry
    )
    Invoke-Python -Arguments $CliArguments

    $GuiExecutable = Join-Path $DistPath "rust_like_compiler.exe"
    $CliExecutable = Join-Path $DistPath "rust_like_compiler_cli.exe"
    Assert-Path $GuiExecutable "GUI executable"
    Assert-Path $CliExecutable "CLI executable"

    $GuiSubsystem = Get-PeSubsystem $GuiExecutable
    $CliSubsystem = Get-PeSubsystem $CliExecutable
    if ($GuiSubsystem -ne 2) {
        throw "GUI executable has PE subsystem $GuiSubsystem; expected 2 (Windows GUI)."
    }
    if ($CliSubsystem -ne 3) {
        throw "CLI executable has PE subsystem $CliSubsystem; expected 3 (Windows console)."
    }

    Write-Host "Release build completed." -ForegroundColor Green
    Get-FileHash -Algorithm SHA256 $GuiExecutable, $CliExecutable |
        Select-Object Path, Hash |
        Format-List
}
finally {
    Pop-Location
}
