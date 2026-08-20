# GSD Script Encoding Validation
# Parses every PowerShell script to catch encoding faults before users hit them.
#
# Windows PowerShell 5.1 reads .ps1 files as the system ANSI codepage unless a
# UTF-8 BOM is present. A script with non-ASCII characters and no BOM fails to
# parse entirely — the failure looks like a syntax error, not an encoding one.

$ErrorCount = 0
$ScriptsChecked = 0

Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
Write-Host " GSD ► VALIDATING SCRIPT ENCODING" -ForegroundColor Cyan
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
Write-Host ""

$scripts = Get-ChildItem $PSScriptRoot -Filter "*.ps1" -File | Sort-Object Name

foreach ($script in $scripts) {
    $ScriptsChecked++
    $hasErrors = $false

    # Does the file carry a UTF-8 BOM?
    $bytes = [System.IO.File]::ReadAllBytes($script.FullName)
    $hasBom = $bytes.Length -ge 3 -and $bytes[0] -eq 0xEF -and $bytes[1] -eq 0xBB -and $bytes[2] -eq 0xBF

    # Does it contain non-ASCII characters?
    $hasNonAscii = $false
    foreach ($byte in $bytes) {
        if ($byte -gt 127) { $hasNonAscii = $true; break }
    }

    if ($hasNonAscii -and -not $hasBom) {
        Write-Host "❌ $($script.Name): non-ASCII characters without a UTF-8 BOM" -ForegroundColor Red
        $ErrorCount++
        $hasErrors = $true
    }

    # Parse it the way PowerShell would, without executing anything
    $parseErrors = $null
    [System.Management.Automation.Language.Parser]::ParseFile(
        $script.FullName, [ref]$null, [ref]$parseErrors) | Out-Null

    if ($parseErrors -and $parseErrors.Count -gt 0) {
        $first = $parseErrors[0]
        Write-Host "❌ $($script.Name): parse error at line $($first.Extent.StartLineNumber) — $($first.Message)" -ForegroundColor Red
        $ErrorCount++
        $hasErrors = $true
    }

    if (-not $hasErrors) {
        Write-Host "✅ $($script.Name)" -ForegroundColor Green
    }
}

Write-Host ""
Write-Host "───────────────────────────────────────────────────────" -ForegroundColor Gray
Write-Host ""
Write-Host "Scripts checked: $ScriptsChecked"
Write-Host "Errors: $ErrorCount" -ForegroundColor $(if ($ErrorCount -gt 0) { "Red" } else { "Green" })
Write-Host ""

if ($ErrorCount -eq 0) {
    Write-Host "✅ All scripts parse cleanly!" -ForegroundColor Green
    exit 0
} else {
    Write-Host "❌ Validation failed" -ForegroundColor Red
    exit 1
}
