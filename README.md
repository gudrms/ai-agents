# ai-agent-profiles

Claude Code, Codex, Gemini CLI에서 공통으로 사용하는 AI 에이전트 프로필 중앙 관리 저장소.

`profiles/` 하나만 수정하면 세 툴에 즉시 반영됩니다.

## 구조

```
ai-agents/
  profiles/                      # 에이전트 원본 파일 (여기만 수정)
    backend-developer.md
    frontend-developer.md
    code-reviewer.md
    database-architect.md
    project-start-harness.md

  codex/                         # Codex / Gemini 어댑터
    {name}/
      SKILL.md                   → ../../profiles/{name}.md (심링크)
      agents/openai.yaml         ← Codex 메타데이터 (5줄, 거의 안 바뀜)

    agent/                       # Codex 전용 /agent 메뉴 스킬
      SKILL.md
      agents/openai.yaml

  setup.ps1                      # 심링크/junction 자동 생성 스크립트
  README.md
```

## 에이전트 목록

| 이름 | 역할 |
|------|------|
| backend-developer | NestJS/Spring Boot API, 비즈니스 로직, 인증 |
| frontend-developer | Next.js/React/Tailwind UI 컴포넌트, 상태 관리 |
| code-reviewer | 코드 품질/보안/성능 리뷰 (읽기 전용) |
| database-architect | PostgreSQL/Supabase 스키마 설계, 쿼리 최적화 |
| project-start-harness | 새 프로젝트/기능 시작 전 목표, 범위, 검증 정리 |
| agent | /agent 입력 시 간략한 에이전트/스킬 목록 표시 |

## 동작 원리

역할 에이전트의 실제 파일은 `profiles/` 에만 존재하고, 각 AI 툴 경로는 심링크/junction으로 연결됩니다. `agent` 같은 Codex 전용 스킬은 `codex/` 아래에 원본을 둡니다.

```
profiles/backend-developer.md       ← 실제 파일 (여기만 수정)
         │
         ├── ~/.claude/agents/backend-developer.md     (심링크)
         │
         └── codex/backend-developer/SKILL.md          (심링크)
                    │
                    ├── ~/.codex/skills/backend-developer/   (junction)
                    └── ~/.gemini/skills/backend-developer/  (junction)
```

## 지원 툴

| 툴 | 연결 방식 | 경로 |
|----|-----------|------|
| Claude Code | 파일 심링크 | `~/.claude/agents/{name}.md` |
| Codex | 폴더 junction | `~/.codex/skills/{name}/` |
| Gemini CLI | 폴더 junction | `~/.gemini/skills/{name}/` |

## 새 PC 설치

```powershell
git clone <repo-url> $env:USERPROFILE\ai-agents
cd $env:USERPROFILE\ai-agents

# 먼저 변경될 링크만 확인
./setup.ps1 -DryRun

# 실제 링크 생성
./setup.ps1
```

> 심링크 생성에 Windows Developer Mode 또는 관리자 권한이 필요할 수 있습니다. 기존 경로가 일반 파일/폴더이면 삭제하지 않고 `.backup.YYYYMMDDHHMMSS` 이름으로 백업한 뒤 링크를 생성합니다. 기존 경로가 심링크/junction이면 링크만 교체합니다.


## 기존 설정 처리

`setup.ps1`은 중복을 없애기 위해 각 툴의 기존 경로를 중앙 저장소 링크로 교체합니다.

- 기존 경로가 심링크 또는 junction이면 링크만 제거하고 새 링크를 만듭니다.
- 기존 경로가 일반 파일 또는 일반 폴더이면 삭제하지 않고 `.backup.YYYYMMDDHHMMSS` 이름으로 이동합니다.
- 실제 원본은 `profiles/`에만 두고, Claude/Codex/Gemini 경로는 링크로 유지합니다.

실제 변경 전에 확인하려면 다음을 실행합니다.

```powershell
./setup.ps1 -DryRun
```

## 에이전트 추가 방법

1. `profiles/{name}.md` 작성 (frontmatter: `name`, `description` 만)
2. `codex/{name}/agents/openai.yaml` 작성
3. `./setup.ps1 -DryRun` 으로 연결 대상 확인
4. `./setup.ps1` 재실행

## frontmatter 규칙

`profiles/` 파일은 Claude / Codex / Gemini 호환을 위해 `name`, `description` 만 사용합니다.

```markdown
---
name: agent-name
description: "에이전트 역할 설명"
---
```

Claude 전용 `tools`, `model` 필드는 넣지 않습니다 (Codex / Gemini validator 호환성).
