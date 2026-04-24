# ai-agents setup.ps1
# 새 PC에서 clone 후 실행: ./setup.ps1
# 요구사항: Windows Developer Mode 또는 관리자 권한 (SymbolicLink 생성용)

param(
    [switch]$DryRun
)

$ErrorActionPreference = "Stop"

$base = if ($PSScriptRoot) { $PSScriptRoot } else { Split-Path -Parent $MyInvocation.MyCommand.Path }
$profilesDir = Join-Path $base "profiles"
$codexDir = Join-Path $base "codex"

if (-not (Test-Path -LiteralPath $profilesDir)) {
    throw "profiles 폴더를 찾을 수 없습니다: $profilesDir"
}

$agents = Get-ChildItem -LiteralPath $profilesDir -Filter "*.md" |
    Sort-Object BaseName |
    ForEach-Object { $_.BaseName }

if ($agents.Count -eq 0) {
    throw "profiles/*.md 에이전트 파일이 없습니다."
}

function Ensure-Directory {
    param([Parameter(Mandatory)][string]$Path)

    if ($DryRun) {
        Write-Host "  [DryRun] ensure directory: $Path"
        return
    }

    if (-not (Test-Path -LiteralPath $Path)) {
        New-Item -ItemType Directory -Force -Path $Path | Out-Null
    }
}

function Backup-Or-RemoveExisting {
    param([Parameter(Mandatory)][string]$Path)

    if (-not (Test-Path -LiteralPath $Path)) {
        return
    }

    $item = Get-Item -LiteralPath $Path -Force
    $isReparsePoint = (($item.Attributes -band [System.IO.FileAttributes]::ReparsePoint) -ne 0)
    $isManagedLink = $isReparsePoint -or $item.LinkType

    if ($isManagedLink) {
        Write-Host "  [Replace] 기존 링크 제거: $Path"
        if (-not $DryRun) {
            Remove-Item -LiteralPath $Path -Force
        }
        return
    }

    $timestamp = Get-Date -Format "yyyyMMddHHmmss"
    $backupPath = "$Path.backup.$timestamp"
    Write-Host "  [Backup] 기존 파일/폴더 백업: $Path -> $backupPath"
    if (-not $DryRun) {
        Move-Item -LiteralPath $Path -Destination $backupPath
    }
}

function New-SafeSymbolicLink {
    param(
        [Parameter(Mandatory)][string]$Path,
        [Parameter(Mandatory)][string]$Target
    )

    Ensure-Directory -Path (Split-Path -Parent $Path)
    Backup-Or-RemoveExisting -Path $Path

    Write-Host "  [Link] $Path -> $Target"
    if (-not $DryRun) {
        New-Item -ItemType SymbolicLink -Path $Path -Target $Target | Out-Null
    }
}

function New-SafeJunction {
    param(
        [Parameter(Mandatory)][string]$Path,
        [Parameter(Mandatory)][string]$Target
    )

    Ensure-Directory -Path (Split-Path -Parent $Path)
    Backup-Or-RemoveExisting -Path $Path

    Write-Host "  [Junction] $Path -> $Target"
    if (-not $DryRun) {
        New-Item -ItemType Junction -Path $Path -Target $Target | Out-Null
    }
}

Write-Host "ai-agents 링크 설정 시작..."
Write-Host "base: $base"
if ($DryRun) { Write-Host "mode: DryRun" }
Write-Host ""

foreach ($agent in $agents) {
    $profilePath = Join-Path $profilesDir "$agent.md"
    $codexSkillDir = Join-Path $codexDir $agent
    $codexSkillPath = Join-Path $codexSkillDir "SKILL.md"
    $codexMetaPath = Join-Path $codexSkillDir "agents\openai.yaml"

    if (-not (Test-Path -LiteralPath $profilePath)) {
        throw "profile 파일을 찾을 수 없습니다: $profilePath"
    }

    if (-not (Test-Path -LiteralPath $codexMetaPath)) {
        Write-Warning "Codex 메타데이터가 없습니다: $codexMetaPath"
    }

    Write-Host "[$agent]"

    New-SafeSymbolicLink `
        -Path (Join-Path $env:USERPROFILE ".claude\agents\$agent.md") `
        -Target $profilePath

    Ensure-Directory -Path $codexSkillDir
    New-SafeSymbolicLink `
        -Path $codexSkillPath `
        -Target $profilePath

    New-SafeJunction `
        -Path (Join-Path $env:USERPROFILE ".codex\skills\$agent") `
        -Target $codexSkillDir

    New-SafeJunction `
        -Path (Join-Path $env:USERPROFILE ".gemini\skills\$agent") `
        -Target $codexSkillDir

    Write-Host ""
}

Write-Host "완료. 연결된 에이전트: $($agents.Count)개 x 3개 툴 (Claude / Codex / Gemini)"
Write-Host "기존 일반 파일/폴더는 .backup.YYYYMMDDHHMMSS 이름으로 보존됩니다."