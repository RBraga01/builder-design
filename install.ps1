# builder-design install script (PowerShell)
# Sparse-clones skills/ and .claude/agents/ into the target directory

param(
    [string]$Destination = "."
)

$Repo = "https://github.com/RBraga01/builder-design.git"

function Write-Info  { param($msg) Write-Host "[builder-design] $msg" -ForegroundColor Green }
function Write-Warn  { param($msg) Write-Host "[builder-design] $msg" -ForegroundColor Yellow }
function Write-Fail  { param($msg) Write-Host "[builder-design] $msg" -ForegroundColor Red; exit 1 }

# Preflight checks
if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Fail "git is required but not installed."
}

if (-not (Test-Path $Destination)) {
    Write-Fail "Destination directory '$Destination' does not exist."
}

Write-Info "Installing builder-design into $Destination"

$Tmp = Join-Path $env:TEMP "builder-design-install-$(Get-Random)"
New-Item -ItemType Directory -Path $Tmp -Force | Out-Null

try {
    Write-Info "Cloning (sparse)..."
    $CloneDir = Join-Path $Tmp "builder-design"
    git clone --filter=blob:none --sparse --quiet $Repo $CloneDir
    Set-Location $CloneDir
    git sparse-checkout set skills .claude/agents

    Write-Info "Copying skills..."
    $DestSkills = Join-Path $Destination "skills"
    if (-not (Test-Path $DestSkills)) {
        Copy-Item -Recurse -Path (Join-Path $CloneDir "skills") -Destination $Destination
        $SkillCount = (Get-ChildItem -Recurse -Filter "SKILL.md" $DestSkills).Count
        Write-Info "  $SkillCount skills installed"
    } else {
        Write-Warn "  skills/ already exists — skipping"
    }

    Write-Info "Copying agents..."
    $DestAgents = Join-Path $Destination ".claude\agents"
    if (-not (Test-Path $DestAgents)) {
        $DestClaude = Join-Path $Destination ".claude"
        if (-not (Test-Path $DestClaude)) {
            New-Item -ItemType Directory -Path $DestClaude -Force | Out-Null
        }
        Copy-Item -Recurse -Path (Join-Path $CloneDir ".claude\agents") -Destination $DestClaude
        $AgentCount = (Get-ChildItem -Filter "*.md" $DestAgents).Count
        Write-Info "  $AgentCount agents installed"
    } else {
        Write-Warn "  .claude\agents\ already exists — skipping"
    }

    Write-Info "Done. builder-design v1.0.0 installed."
    Write-Host ""
    Write-Host "  Skills:  $DestSkills"
    Write-Host "  Agents:  $DestAgents"
    Write-Host ""
    Write-Host "  Start with: ai-states-required (before any component code)"
    Write-Host "  Then:        design-before-code (spec before implementation)"
} finally {
    Set-Location $Destination
    Remove-Item -Recurse -Force $Tmp -ErrorAction SilentlyContinue
}
