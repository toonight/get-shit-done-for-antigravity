# GSD Subagent Validation Script
# Validates all subagent definitions in .agents/agents/

$ErrorCount = 0
$AgentsChecked = 0

Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
Write-Host " GSD ► VALIDATING SUBAGENTS" -ForegroundColor Cyan
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
Write-Host ""

if (-not (Test-Path ".agents/agents")) {
    Write-Host "❌ Missing .agents/agents/ directory" -ForegroundColor Red
    exit 1
}

$agents = Get-ChildItem ".agents/agents" -Filter "*.md" -File

foreach ($agent in $agents) {
    $AgentsChecked++
    $agentName = [System.IO.Path]::GetFileNameWithoutExtension($agent.Name)
    $hasErrors = $false

    $content = Get-Content $agent.FullName -Raw

    # Check for frontmatter
    if ($content -notmatch "^---") {
        Write-Host "❌ ${agentName}: Missing frontmatter" -ForegroundColor Red
        $ErrorCount++
        $hasErrors = $true
    }

    # Check required fields
    foreach ($field in @("name", "description", "subagent")) {
        if ($content -notmatch "(?m)^${field}:") {
            Write-Host "❌ ${agentName}: Missing $field in frontmatter" -ForegroundColor Red
            $ErrorCount++
            $hasErrors = $true
        }
    }

    # name must match filename (invoke_subagent targets the name field)
    if ($content -match "(?m)^name:\s*(.+?)\s*$") {
        $declaredName = $Matches[1]
        if ($declaredName -ne $agentName) {
            Write-Host "❌ ${agentName}: name '$declaredName' does not match filename" -ForegroundColor Red
            $ErrorCount++
            $hasErrors = $true
        }
    }

    # subagent must be true
    if ($content -notmatch "(?m)^subagent:\s*true") {
        Write-Host "❌ ${agentName}: subagent must be true" -ForegroundColor Red
        $ErrorCount++
        $hasErrors = $true
    }

    # Known Antigravity tool registry (antigravity.google/docs/hooks)
    # An unmapped or misspelled tool name makes the subagent hang, so this is an error.
    $knownTools = @(
        "view_file", "write_to_file", "replace_file_content", "multi_replace_file_content",
        "list_dir", "find_by_name", "grep_search", "search_web", "read_url_content",
        "run_command", "manage_task", "schedule", "list_permissions", "ask_permission",
        "invoke_subagent", "define_subagent", "send_message", "manage_subagents",
        "ask_question", "generate_image"
    )

    # tools: must be declared - the field defaults to an empty list, it does NOT inherit
    $declaredTools = @()
    if ($content -match "(?ms)^tools:[ \t]*\r?\n((?:[ \t]+-[ \t]*\S+[ \t]*\r?\n)+)") {
        $declaredTools = @([regex]::Matches($Matches[1], "(?m)^[ \t]*-[ \t]*(\S+)") |
            ForEach-Object { $_.Groups[1].Value })
    }

    if ($declaredTools.Count -eq 0) {
        Write-Host "❌ ${agentName}: No tools declared (tools: defaults to empty, it does not inherit)" -ForegroundColor Red
        $ErrorCount++
        $hasErrors = $true
    } else {
        foreach ($tool in $declaredTools) {
            if (($knownTools -notcontains $tool) -and ($tool -notlike "browser_*")) {
                Write-Host "❌ ${agentName}: Unknown tool '$tool' (typos make subagents hang)" -ForegroundColor Red
                $ErrorCount++
                $hasErrors = $true
            }
        }
    }

    # Referenced skills must exist
    $skillRefs = [regex]::Matches($content, "(?m)^\s+-\s*(skills/[a-z0-9-]+)")
    foreach ($ref in $skillRefs) {
        $skillPath = Join-Path ".agents" (Join-Path $ref.Groups[1].Value "SKILL.md")
        if (-not (Test-Path $skillPath)) {
            Write-Host "❌ ${agentName}: References missing skill '$($ref.Groups[1].Value)'" -ForegroundColor Red
            $ErrorCount++
            $hasErrors = $true
        }
    }

    # Return Contract keeps orchestrator context lean
    if ($content -notmatch "Return Contract") {
        Write-Host "⚠️  ${agentName}: Missing Return Contract section" -ForegroundColor Yellow
    }

    if (-not $hasErrors) {
        Write-Host "✅ $agentName" -ForegroundColor Green
    }
}

Write-Host ""
Write-Host "───────────────────────────────────────────────────────" -ForegroundColor Gray
Write-Host ""
Write-Host "Subagents checked: $AgentsChecked"
Write-Host "Errors: $ErrorCount" -ForegroundColor $(if ($ErrorCount -gt 0) { "Red" } else { "Green" })
Write-Host ""

if ($ErrorCount -eq 0) {
    Write-Host "✅ All subagents valid!" -ForegroundColor Green
    exit 0
} else {
    Write-Host "❌ Validation failed" -ForegroundColor Red
    exit 1
}
