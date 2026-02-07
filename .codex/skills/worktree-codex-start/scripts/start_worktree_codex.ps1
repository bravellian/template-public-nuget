[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$Slug,

    [int]$TicketId,

    [string]$RepoPath,

    [string]$WorktreesRoot,

    [string]$BaseBranch = "main",

    [string]$Prompt,

    [switch]$NoCodexLaunch
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Normalize-Slug {
    param([string]$Value)

    $normalized = $Value.Trim().ToLowerInvariant()
    $normalized = $normalized -replace "[^a-z0-9-]", "-"
    $normalized = $normalized -replace "-+", "-"
    $normalized = $normalized.Trim("-")

    if ([string]::IsNullOrWhiteSpace($normalized)) {
        throw "Slug must contain letters or numbers after normalization."
    }

    return $normalized
}

if ([string]::IsNullOrWhiteSpace($RepoPath)) {
    $RepoPath = (& git rev-parse --show-toplevel 2>$null).Trim()
    if ([string]::IsNullOrWhiteSpace($RepoPath)) {
        throw "Could not determine git repo root from current directory. Provide -RepoPath explicitly."
    }
}

if (-not (Test-Path $RepoPath)) {
    throw "RepoPath not found: $RepoPath"
}

if ([string]::IsNullOrWhiteSpace($WorktreesRoot)) {
    $WorktreesRoot = "$RepoPath.worktrees"
}

$slugValue = Normalize-Slug -Value $Slug
$branchName = if ($TicketId -gt 0) { "ticket-$TicketId-$slugValue" } else { "workitem-$slugValue" }
$worktreePath = Join-Path (Join-Path $WorktreesRoot "feature") $branchName

$branchExists = (& git -C $RepoPath branch --list $branchName).Trim().Length -gt 0
$worktreeExists = Test-Path (Join-Path $worktreePath ".git")

if (-not $worktreeExists) {
    New-Item -ItemType Directory -Force -Path (Split-Path -Parent $worktreePath) | Out-Null

    if ($branchExists) {
        & git -C $RepoPath worktree add $worktreePath $branchName
    }
    else {
        & git -C $RepoPath worktree add -b $branchName $worktreePath $BaseBranch
    }
}

$result = [pscustomobject]@{
    RepoPath      = $RepoPath
    BranchName    = $branchName
    WorktreePath  = $worktreePath
    WorktreeReady = $true
}

if (-not $NoCodexLaunch -and -not [string]::IsNullOrWhiteSpace($Prompt)) {
    $launcherPath = Join-Path $env:TEMP ("codex-launch-{0}.ps1" -f [guid]::NewGuid().ToString("N"))
    $launcher = @"
Set-Location '$worktreePath'
`$prompt = @'
$Prompt
'@
codex exec -- `$prompt
"@

    Set-Content -Path $launcherPath -Value $launcher -Encoding UTF8
    Start-Process pwsh -ArgumentList @('-NoExit', '-File', $launcherPath) | Out-Null

    $result | Add-Member -NotePropertyName CodexLaunched -NotePropertyValue $true
}
else {
    $result | Add-Member -NotePropertyName CodexLaunched -NotePropertyValue $false
}

$result
