# GSD Workflow Validation Script
# Validates all workflow files for required structure

$ErrorCount = 0
$WarningCount = 0
$WorkflowsChecked = 0

Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
Write-Host " GSD ► VALIDATING WORKFLOWS" -ForegroundColor Cyan
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
Write-Host ""

$workflows = Get-ChildItem ".agents/workflows/*.md"

foreach ($file in $workflows) {
    $WorkflowsChecked++
    $content = Get-Content $file.FullName -Raw
    $hasErrors = $false
    
    # Check for frontmatter
    if ($content -notmatch "^---") {
        Write-Host "❌ $($file.Name): Missing frontmatter" -ForegroundColor Red
        $ErrorCount++
        $hasErrors = $true
    }
    
    # Check for description
    if ($content -notmatch "description:") {
        Write-Host "❌ $($file.Name): Missing description in frontmatter" -ForegroundColor Red
        $ErrorCount++
        $hasErrors = $true
    }
    
    # Check for process tags (optional but recommended)
    if ($content -notmatch "<process>") {
        Write-Host "⚠️  $($file.Name): Missing <process> tag" -ForegroundColor Yellow
        $WarningCount++
    }
    
    if (-not $hasErrors) {
        Write-Host "✅ $($file.Name)" -ForegroundColor Green
    }
}

Write-Host ""
Write-Host "───────────────────────────────────────────────────────" -ForegroundColor Gray
Write-Host ""
Write-Host "Workflows checked: $WorkflowsChecked"
Write-Host "Errors: $ErrorCount" -ForegroundColor $(if ($ErrorCount -gt 0) { "Red" } else { "Green" })
Write-Host "Warnings: $WarningCount" -ForegroundColor $(if ($WarningCount -gt 0) { "Yellow" } else { "Green" })
Write-Host ""

if ($ErrorCount -eq 0) {
    Write-Host "✅ All workflows valid!" -ForegroundColor Green
    exit 0
} else {
    Write-Host "❌ Validation failed" -ForegroundColor Red
    exit 1
}
