# GSD Master Validation Script
# Runs all validators and reports overall status

$TotalErrors = 0

Write-Host ""
Write-Host "╔═══════════════════════════════════════════════════════╗" -ForegroundColor Magenta
Write-Host "║         GSD ► RUNNING ALL VALIDATORS                  ║" -ForegroundColor Magenta
Write-Host "╚═══════════════════════════════════════════════════════╝" -ForegroundColor Magenta
Write-Host ""

# Run workflow validator
Write-Host "▶ Running workflow validation..." -ForegroundColor Cyan
& "$PSScriptRoot\validate-workflows.ps1"
if ($LASTEXITCODE -ne 0) { $TotalErrors++ }
Write-Host ""

# Run skill validator
Write-Host "▶ Running skill validation..." -ForegroundColor Cyan
& "$PSScriptRoot\validate-skills.ps1"
if ($LASTEXITCODE -ne 0) { $TotalErrors++ }
Write-Host ""

# Run template validator
Write-Host "▶ Running template validation..." -ForegroundColor Cyan
& "$PSScriptRoot\validate-templates.ps1"
if ($LASTEXITCODE -ne 0) { $TotalErrors++ }
Write-Host ""

# Summary
Write-Host "╔═══════════════════════════════════════════════════════╗" -ForegroundColor Magenta
Write-Host "║                    SUMMARY                            ║" -ForegroundColor Magenta
Write-Host "╚═══════════════════════════════════════════════════════╝" -ForegroundColor Magenta
Write-Host ""

if ($TotalErrors -eq 0) {
    Write-Host "✅ All validators passed!" -ForegroundColor Green
    exit 0
} else {
    Write-Host "❌ $TotalErrors validator(s) failed" -ForegroundColor Red
    exit 1
}
