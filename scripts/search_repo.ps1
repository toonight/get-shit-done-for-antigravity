# search_repo.ps1 - Search codebase with best available tool
#
# Usage: .\scripts\search_repo.ps1 <pattern> [path] [options]
#
# Examples:
#   .\scripts\search_repo.ps1 "TODO"
#   .\scripts\search_repo.ps1 "function.*login" -Path "src/"
#   .\scripts\search_repo.ps1 "error" -FileType "ts"

param(
    [Parameter(Mandatory = $true, Position = 0)]
    [string]$Pattern,
    
    [Parameter(Position = 1)]
    [string]$Path = ".",
    
    [Parameter()]
    [string]$FileType,
    
    [Parameter()]
    [switch]$CaseSensitive
)

# Try ripgrep first (fastest)
$rgAvailable = Get-Command rg -ErrorAction SilentlyContinue

if ($rgAvailable) {
    Write-Host "# Using ripgrep" -ForegroundColor Gray
    
    $rgArgs = @($Pattern, $Path, "--color=always")
    
    if ($FileType) {
        $rgArgs += "--type"
        $rgArgs += $FileType
    }
    
    if ($CaseSensitive) {
        $rgArgs += "--case-sensitive"
    }
    
    & rg @rgArgs
    exit $LASTEXITCODE
}

# Fall back to Select-String
Write-Host "# Using Select-String (install ripgrep for better performance)" -ForegroundColor Gray

$searchParams = @{
    Pattern = $Pattern
    Path    = $Path
}

# Build file filter
if ($FileType) {
    $searchParams.Include = "*.$FileType"
}

if (-not $CaseSensitive) {
    $searchParams.CaseSensitive = $false
}

# Handle directory vs file
if (Test-Path $Path -PathType Container) {
    $searchParams.Path = Join-Path $Path "*"
    $searchParams.Recurse = $true
}

try {
    $results = Get-ChildItem -Path $Path -Recurse -File -ErrorAction SilentlyContinue |
    Where-Object { 
        if ($FileType) { 
            $_.Extension -eq ".$FileType" 
        }
        else { 
            $true 
        } 
    } |
    Select-String -Pattern $Pattern -CaseSensitive:$CaseSensitive
    
    if ($results) {
        $results | ForEach-Object {
            $relativePath = $_.Path
            $lineNum = $_.LineNumber
            $line = $_.Line
            Write-Host "${relativePath}:${lineNum}:${line}"
        }
    }
    else {
        Write-Host "No matches found for: $Pattern"
    }
}
catch {
    Write-Host "Search error: $_" -ForegroundColor Red
    exit 1
}
