# ai-agents

Claude, Codex 등 AI 툴에서 공통으로 사용하는 에이전트 프로필 중앙 관리 저장소.

## 구조

```
ai-agents/
  profiles/                      # 에이전트 원본 파일 (여기만 수정)
    backend-developer.md
    frontend-developer.md
    code-reviewer.md
    database-architect.md

  codex/                         # Codex 어댑터 (SKILL.md는 profiles/ 심링크)
    backend-developer/
      SKILL.md -> ../../profiles/backend-developer.md
      agents/openai.yaml
    ...

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

## 동작 원리

실제 파일은 `profiles/` 에만 존재하고, 각 AI 툴 경로는 심링크/junction으로 연결됨.

```
profiles/backend-developer.md  ← 실제 파일

~/.claude/agents/backend-developer.md     → 심링크
~/.codex/skills/backend-developer/        → junction
  └── SKILL.md                            → 심링크
```

`profiles/` 파일 하나만 수정하면 모든 AI 툴에 즉시 반영됨.

## 새 PC 설치

```powershell
git clone <repo-url> $env:USERPROFILE\ai-agents
cd $env:USERPROFILE\ai-agents
./setup.ps1
```

> 심링크 생성에 Windows Developer Mode 또는 관리자 권한이 필요할 수 있음.

## 에이전트 추가 방법

1. `profiles/` 에 `{name}.md` 작성 (frontmatter: `name`, `description` 만)
2. `codex/{name}/agents/openai.yaml` 작성
3. `setup.ps1` 의 `$agents` 배열에 이름 추가
4. `./setup.ps1` 재실행

## frontmatter 규칙

`profiles/` 파일은 Claude/Codex 양쪽 호환을 위해 `name`, `description` 만 사용:

```markdown
---
name: agent-name
description: "에이전트 역할 설명"
---
```

Claude 전용 `tools`, `model` 필드는 넣지 않음 (Codex validator 호환성).
