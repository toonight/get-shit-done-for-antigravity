# setup_search.ps1 - Optional search tool setup for GSD
#
# This script checks for and provides guidance on installing search tools.
# GSD works without these tools (falls back to Select-String), but they improve performance.

Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
Write-Host " GSD ► Search Tools Setup" -ForegroundColor Cyan
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
Write-Host ""

$rgInstalled = $false
$fdInstalled = $false

# Check for ripgrep
Write-Host "Checking search tools..." -ForegroundColor White
Write-Host ""

try {
    $rgVersion = & rg --version 2>$null
    if ($rgVersion) {
        Write-Host "✅ ripgrep (rg) is installed: $($rgVersion[0])" -ForegroundColor Green
        $rgInstalled = $true
    }
}
catch {
    Write-Host "❌ ripgrep (rg) is not installed" -ForegroundColor Yellow
}

# Check for fd
try {
    $fdVersion = & fd --version 2>$null
    if ($fdVersion) {
        Write-Host "✅ fd is installed: $fdVersion" -ForegroundColor Green
        $fdInstalled = $true
    }
}
catch {
    Write-Host "❌ fd is not installed" -ForegroundColor Yellow
}

Write-Host ""

if ($rgInstalled -and $fdInstalled) {
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Green
    Write-Host " ✅ All search tools are ready!" -ForegroundColor Green
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Green
    Write-Host ""
    Write-Host "You can use .\scripts\search_repo.ps1 for optimized searching."
}
else {
    Write-Host "⚠️  Some tools are missing (optional)" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "GSD will work fine with built-in Select-String, but ripgrep and fd"
    Write-Host "provide faster searching in large codebases."
    Write-Host ""
    Write-Host "───────────────────────────────────────────────────────" -ForegroundColor Gray
    Write-Host "📦 Installation Options" -ForegroundColor White
    Write-Host "───────────────────────────────────────────────────────" -ForegroundColor Gray
    Write-Host ""
    
    # Check for package managers
    $hasWinget = Get-Command winget -ErrorAction SilentlyContinue
    $hasChoco = Get-Command choco -ErrorAction SilentlyContinue
    $hasScoop = Get-Command scoop -ErrorAction SilentlyContinue
    
    if ($hasWinget) {
        Write-Host "Using winget:" -ForegroundColor Cyan
        Write-Host "  winget install BurntSushi.ripgrep.MSVC"
        Write-Host "  winget install sharkdp.fd"
        Write-Host ""
    }
    
    if ($hasChoco) {
        Write-Host "Using Chocolatey:" -ForegroundColor Cyan
        Write-Host "  choco install ripgrep fd"
        Write-Host ""
    }
    
    if ($hasScoop) {
        Write-Host "Using Scoop:" -ForegroundColor Cyan
        Write-Host "  scoop install ripgrep fd"
        Write-Host ""
    }
    
    if (-not ($hasWinget -or $hasChoco -or $hasScoop)) {
        Write-Host "Download binaries from:" -ForegroundColor Cyan
        Write-Host "  ripgrep: https://github.com/BurntSushi/ripgrep/releases"
        Write-Host "  fd: https://github.com/sharkdp/fd/releases"
        Write-Host ""
    }
    
    Write-Host "───────────────────────────────────────────────────────" -ForegroundColor Gray
    Write-Host ""
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
    Write-Host " GSD ► Using Select-String as fallback (works fine!)" -ForegroundColor Cyan
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
}
