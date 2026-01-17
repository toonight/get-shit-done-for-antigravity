# GSD Template Validation Script
# Validates all template files in .gsd/templates/

$ErrorCount = 0
$WarningCount = 0
$TemplatesChecked = 0

Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
Write-Host " GSD ► VALIDATING TEMPLATES" -ForegroundColor Cyan
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
Write-Host ""

$templates = Get-ChildItem ".gsd/templates/*.md"

foreach ($file in $templates) {
    $TemplatesChecked++
    $content = Get-Content $file.FullName -Raw
    $hasErrors = $false
    
    # Check for title (# heading)
    if ($content -notmatch "^# ") {
        Write-Host "❌ $($file.Name): Missing title (# heading)" -ForegroundColor Red
        $ErrorCount++
        $hasErrors = $true
    }
    
    # Check for Last updated marker
    if ($content -notmatch "Last updated") {
        Write-Host "⚠️  $($file.Name): Missing 'Last updated' marker" -ForegroundColor Yellow
        $WarningCount++
    }
    
    # Check minimum length (templates should have substance)
    if ($content.Length -lt 200) {
        Write-Host "⚠️  $($file.Name): Very short template (<200 chars)" -ForegroundColor Yellow
        $WarningCount++
    }
    
    if (-not $hasErrors) {
        Write-Host "✅ $($file.Name)" -ForegroundColor Green
    }
}

Write-Host ""
Write-Host "───────────────────────────────────────────────────────" -ForegroundColor Gray
Write-Host ""
Write-Host "Templates checked: $TemplatesChecked"
Write-Host "Errors: $ErrorCount" -ForegroundColor $(if ($ErrorCount -gt 0) { "Red" } else { "Green" })
Write-Host "Warnings: $WarningCount" -ForegroundColor $(if ($WarningCount -gt 0) { "Yellow" } else { "Green" })
Write-Host ""

if ($ErrorCount -eq 0) {
    Write-Host "✅ All templates valid!" -ForegroundColor Green
    exit 0
} else {
    Write-Host "❌ Validation failed" -ForegroundColor Red
    exit 1
}
