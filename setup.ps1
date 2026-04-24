# ai-agents setup.ps1
# 새 PC에서 clone 후 실행: ./setup.ps1
# 요구사항: Windows Developer Mode 또는 관리자 권한 (심링크 생성용)

$base = "$env:USERPROFILE\ai-agents"
$agents = @("backend-developer", "frontend-developer", "code-reviewer", "database-architect")

Write-Host "ai-agents 심링크 설정 시작..."

foreach ($a in $agents) {
    # 1. Claude agent 심링크
    $claudePath = "$env:USERPROFILE\.claude\agents\$a.md"
    if (Test-Path $claudePath) { Remove-Item $claudePath -Force }
    New-Item -ItemType SymbolicLink -Path $claudePath -Target "$base\profiles\$a.md" | Out-Null
    Write-Host "  [Claude]  .claude/agents/$a.md"

    # 2. Codex SKILL.md 심링크 (codex 폴더 내부)
    $skillPath = "$base\codex\$a\SKILL.md"
    if (Test-Path $skillPath) { Remove-Item $skillPath -Force }
    New-Item -ItemType SymbolicLink -Path $skillPath -Target "$base\profiles\$a.md" | Out-Null
    Write-Host "  [Codex]   codex/$a/SKILL.md"

    # 3. Codex skills junction
    $codexPath = "$env:USERPROFILE\.codex\skills\$a"
    if (Test-Path $codexPath) { Remove-Item $codexPath -Recurse -Force }
    New-Item -ItemType Junction -Path $codexPath -Target "$base\codex\$a" | Out-Null
    Write-Host "  [Codex]   .codex/skills/$a/"
}

Write-Host ""
Write-Host "완료. 연결된 에이전트: $($agents.Count)개"
