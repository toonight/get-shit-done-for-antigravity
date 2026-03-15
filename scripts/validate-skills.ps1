# GSD Skill Validation Script
# Validates all skill directories for required structure

$ErrorCount = 0
$WarningCount = 0
$SkillsChecked = 0

Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
Write-Host " GSD ► VALIDATING SKILLS" -ForegroundColor Cyan
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
Write-Host ""

$skills = Get-ChildItem ".agents/skills" -Directory

foreach ($skill in $skills) {
    $SkillsChecked++
    $skillFile = Join-Path $skill.FullName "SKILL.md"
    $hasErrors = $false
    
    # Check SKILL.md exists
    if (-not (Test-Path $skillFile)) {
        Write-Host "❌ $($skill.Name): Missing SKILL.md" -ForegroundColor Red
        $ErrorCount++
        continue
    }
    
    $content = Get-Content $skillFile -Raw
    
    # Check for frontmatter
    if ($content -notmatch "^---") {
        Write-Host "❌ $($skill.Name): Missing frontmatter" -ForegroundColor Red
        $ErrorCount++
        $hasErrors = $true
    }
    
    # Check for name field
    if ($content -notmatch "name:") {
        Write-Host "❌ $($skill.Name): Missing name in frontmatter" -ForegroundColor Red
        $ErrorCount++
        $hasErrors = $true
    }
    
    # Check for description field
    if ($content -notmatch "description:") {
        Write-Host "❌ $($skill.Name): Missing description in frontmatter" -ForegroundColor Red
        $ErrorCount++
        $hasErrors = $true
    }
    
    if (-not $hasErrors) {
        Write-Host "✅ $($skill.Name)" -ForegroundColor Green
    }
}

Write-Host ""
Write-Host "───────────────────────────────────────────────────────" -ForegroundColor Gray
Write-Host ""
Write-Host "Skills checked: $SkillsChecked"
Write-Host "Errors: $ErrorCount" -ForegroundColor $(if ($ErrorCount -gt 0) { "Red" } else { "Green" })
Write-Host ""

if ($ErrorCount -eq 0) {
    Write-Host "✅ All skills valid!" -ForegroundColor Green
    exit 0
} else {
    Write-Host "❌ Validation failed" -ForegroundColor Red
    exit 1
}
