[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$WorktreePath,

    [string]$VerifyCommand,

    [string]$CommitMessage,

    [string]$BaseBranch = "main",

    [string]$PrTitle,

    [string]$PrBody,

    [string]$Repo,

    [string[]]$Paths,

    [switch]$IncludeAll,

    [switch]$SkipVerify,

    [switch]$SkipPush,

    [switch]$SkipPr
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Ensure-GhTokenFromGitCredential {
    if (-not [string]::IsNullOrWhiteSpace($env:GH_TOKEN)) {
        return
    }

    try {
        $credentialOutput = ("protocol=https`nhost=github.com`n`n" | git credential fill)
        $passwordLine = $credentialOutput | Where-Object { $_ -like "password=*" } | Select-Object -First 1
        if ($null -ne $passwordLine) {
            $env:GH_TOKEN = $passwordLine.Substring(9)
        }
    }
    catch {
        # Ignore; caller can still use pre-configured gh auth.
    }
}

if (-not (Test-Path $WorktreePath)) {
    throw "WorktreePath not found: $WorktreePath"
}

Set-Location $WorktreePath

if (-not $SkipVerify -and -not [string]::IsNullOrWhiteSpace($VerifyCommand)) {
    Write-Host "Running verification: $VerifyCommand"
    pwsh -NoProfile -Command $VerifyCommand
    if ($LASTEXITCODE -ne 0) {
        throw "Verification command failed with exit code $LASTEXITCODE"
    }
}

if (-not [string]::IsNullOrWhiteSpace($CommitMessage)) {
    if ($Paths -and $Paths.Count -gt 0) {
        & git add -- $Paths
    }
    elseif ($IncludeAll) {
        & git add -A
    }
    else {
        & git add -u
    }

    $hasStaged = (& git diff --cached --name-only).Trim().Length -gt 0
    if ($hasStaged) {
        & git commit -m $CommitMessage
    }
}

$branchName = (& git rev-parse --abbrev-ref HEAD).Trim()

if (-not $SkipPush) {
    & git push -u origin $branchName
}

$prUrl = $null
if (-not $SkipPr) {
    Ensure-GhTokenFromGitCredential

    $gh = Get-Command gh -ErrorAction SilentlyContinue
    if ($null -eq $gh -and (Test-Path "C:\Program Files\GitHub CLI\gh.exe")) {
        $ghPath = "C:\Program Files\GitHub CLI\gh.exe"
    }
    elseif ($null -ne $gh) {
        $ghPath = $gh.Source
    }
    else {
        throw "GitHub CLI (gh) is not available. Install gh or run with -SkipPr."
    }

    $repoArgs = @()
    if (-not [string]::IsNullOrWhiteSpace($Repo)) {
        $repoArgs = @("--repo", $Repo)
    }

    $existingPr = & $ghPath pr view --head $branchName --json url @repoArgs 2>$null
    if ($LASTEXITCODE -eq 0 -and -not [string]::IsNullOrWhiteSpace($existingPr)) {
        try {
            $prUrl = ((ConvertFrom-Json $existingPr).url)
        }
        catch {
            $prUrl = $null
        }
    }

    if ([string]::IsNullOrWhiteSpace($prUrl)) {
        $title = if ([string]::IsNullOrWhiteSpace($PrTitle)) { "$branchName" } else { $PrTitle }
        $body = if ([string]::IsNullOrWhiteSpace($PrBody)) { "Automated PR from worktree finish script." } else { $PrBody }
        $prUrl = (& $ghPath pr create --base $BaseBranch --head $branchName --title $title --body $body @repoArgs).Trim()
    }
}

[pscustomobject]@{
    WorktreePath = $WorktreePath
    BranchName   = $branchName
    PrUrl        = $prUrl
}
