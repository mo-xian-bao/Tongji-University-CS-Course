param(
    [string]$InputPath = "111",
    [string]$OutputPath = "program.coe",
    [int]$Depth = 2048
)

$ErrorActionPreference = 'Stop'

if (-not (Test-Path $InputPath)) {
    throw "Input file not found: $InputPath"
}

$rawLines = Get-Content $InputPath
$validWords = New-Object System.Collections.Generic.List[string]

for ($i = 0; $i -lt $rawLines.Count; $i++) {
    $line = $rawLines[$i].Trim()
    if ($line -eq "") {
        continue
    }

    if ($line -notmatch '^[0-9A-Fa-f]{8}$') {
        throw "Invalid machine code at line $($i + 1): '$line'"
    }

    $validWords.Add($line.ToLower())
}

if ($validWords.Count -eq 0) {
    throw "No valid 32-bit hex words found in $InputPath"
}

$instructionCount = $validWords.Count

if ($validWords.Count -gt $Depth) {
    throw "Instruction count ($($validWords.Count)) exceeds depth ($Depth)"
}

while ($validWords.Count -lt $Depth) {
    $validWords.Add("00000000")
}

$body = [string]::Join(",`r`n", $validWords)
$coe = "memory_initialization_radix=16;`r`nmemory_initialization_vector=`r`n$body;`r`n"

Set-Content -Path $OutputPath -Value $coe -Encoding ascii

Write-Host "COE generated: $OutputPath"
Write-Host "Instructions (before padding): $instructionCount"
Write-Host "Depth (after padding): $Depth"