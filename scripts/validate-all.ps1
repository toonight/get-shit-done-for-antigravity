# GSD Master Validation Script
# Runs all validators and reports overall status

$TotalErrors = 0

function Invoke-Validator {
    param(
        [string]$Label,
        [string]$Script
    )

    Write-Host "▶ Running $Label..." -ForegroundColor Cyan

    $path = Join-Path $PSScriptRoot $Script

    # A validator that cannot run is a failure, not a pass. Without this check a
    # missing or unparseable child script leaves $LASTEXITCODE untouched and the
    # suite reports success while nothing was actually validated.
    if (-not (Test-Path $path)) {
        Write-Host "❌ $Label could not run: $Script not found" -ForegroundColor Red
        Write-Host ""
        return $false
    }

    $global:LASTEXITCODE = 0
    try {
        & $path
    } catch {
        Write-Host "❌ $Label could not run: $($_.Exception.Message)" -ForegroundColor Red
        Write-Host ""
        return $false
    }

    Write-Host ""
    return ($LASTEXITCODE -eq 0)
}

Write-Host ""
Write-Host "╔═══════════════════════════════════════════════════════╗" -ForegroundColor Magenta
Write-Host "║         GSD ► RUNNING ALL VALIDATORS                  ║" -ForegroundColor Magenta
Write-Host "╚═══════════════════════════════════════════════════════╝" -ForegroundColor Magenta
Write-Host ""

if (-not (Invoke-Validator "workflow validation" "validate-workflows.ps1")) { $TotalErrors++ }
if (-not (Invoke-Validator "skill validation" "validate-skills.ps1")) { $TotalErrors++ }
if (-not (Invoke-Validator "subagent validation" "validate-agents.ps1")) { $TotalErrors++ }
if (-not (Invoke-Validator "template validation" "validate-templates.ps1")) { $TotalErrors++ }
if (-not (Invoke-Validator "script encoding validation" "validate-encoding.ps1")) { $TotalErrors++ }

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
