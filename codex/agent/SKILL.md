---
name: agent
description: "사용자가 /agent, /agents, /에이전트, 슬래시 에이전트, 에이전트 목록, 스킬 목록, 명령어 목록, agent, agent menu를 요청할 때 사용한다. 기본은 에이전트/스킬 목록을 아주 간략한 리스트로만 보여주고, 사용자가 자세히 요청할 때만 세부 설명을 펼친다."
---

# Agent

이 스킬은 Codex에서 사용할 수 있는 에이전트와 작업 역할을 짧은 메뉴로 보여준다.

## 기본 원칙

기본 응답은 한 화면에 들어오도록 짧게 작성한다.

- 표를 남발하지 않는다.
- 각 항목은 이름과 1줄 설명만 쓴다.
- 호출 예시는 최대 2개만 쓴다.
- Spec Kit, GitHub, 문서 스킬은 기본 메뉴에서 요약만 보여준다.
- 사용자가 “자세히”, “전체”, “상세”, “Spec Kit 메뉴”, “GitHub 메뉴”처럼 요청할 때만 세부 명령을 펼친다.

## 기본 출력 형식

사용자가 `/agent`, `/agents`, `/에이전트`, `슬래시 에이전트`, `에이전트 메뉴 보여줘`, `agent`, `agent-menu`, `스킬 목록`처럼 요청하면 아래 형식으로 답한다.

```txt
에이전트 목록

- project-start-harness: 작업 시작 전 계획/범위/검증 정리
- backend-developer: API/서버/인증
- frontend-developer: UI/React/Next.js
- database-architect: DB/마이그레이션/인덱스
- code-reviewer: 코드 리뷰/보안/성능
- playwright: 브라우저 자동화 검증
- browser-use: 로컬 브라우저 확인
- github:github: 저장소/이슈/PR 확인
- github:gh-fix-ci: CI 실패 수정
- github:gh-address-comments: PR 리뷰 대응
- github:yeet: 커밋/푸시/PR 생성
- openai-docs: OpenAI 공식 문서 확인
- docs: pdf/doc/spreadsheets/presentations
- imagegen: 이미지 생성/편집

자세히: Spec Kit 메뉴 자세히 / GitHub 메뉴 자세히 / 개발 역할 자세히
```

## 상세 요청 처리

### Spec Kit 상세

사용자가 Spec Kit 관련 상세를 요청하면 다음을 보여준다.

```txt
Spec Kit
- $speckit-constitution: 프로젝트 원칙 정의
- $speckit-specify: 요구사항/사용자 스토리 작성
- $speckit-clarify: 모호한 요구사항 질문
- $speckit-plan: 기술 계획 작성
- $speckit-tasks: 작업 목록 생성
- $speckit-analyze: 산출물 간 갭 분석
- $speckit-checklist: 품질 체크리스트 생성
- $speckit-implement: 작업 목록 기반 구현

초기화:
specify init --here --ai codex --ai-skills
```

### 개발 역할 상세

사용자가 개발 역할 상세를 요청하면 다음을 보여준다.

```txt
개발 역할
- backend-developer: NestJS/Spring Boot, API, 서비스, DTO, 인증/인가, 외부 API 연동
- frontend-developer: Next.js/React/Tailwind, UI, 페이지, 상태관리, 접근성, 반응형
- database-architect: PostgreSQL/Supabase/Oracle/Redis, 스키마, RLS, 인덱스, 마이그레이션
- code-reviewer: 정확성, 보안, 성능, 유지보수성 중심 리뷰. 기본은 읽기 전용
```

### GitHub 상세

사용자가 GitHub 상세를 요청하면 다음을 보여준다.

```txt
GitHub
- github:github: 저장소, 이슈, PR 상황 파악
- github:gh-address-comments: PR 리뷰 코멘트 확인 및 대응
- github:gh-fix-ci: GitHub Actions 실패 로그 확인 및 수정
- github:yeet: 로컬 변경사항 커밋, 푸시, draft PR 생성
```

### 문서/자료 상세

사용자가 문서나 산출물 상세를 요청하면 다음을 보여준다.

```txt
문서/자료
- openai-docs: OpenAI API, 모델, 마이그레이션, 프롬프트 가이드
- doc / documents: DOCX 작성, 편집, 렌더링 검증
- pdf: PDF 읽기, 생성, 레이아웃 검증
- spreadsheets: Excel/CSV 분석, 작성, 수식, 차트
- presentations: PPTX 작성, 렌더링, 검증
- imagegen: 비트맵 이미지 생성/편집
```

## 병렬 에이전트 안내

기본 메뉴에는 병렬 에이전트 설명을 길게 넣지 않는다.

사용자가 병렬 작업을 물어보면 다음 정도로 답한다.

```txt
병렬 작업은 명시적으로 요청하면 가능하다.
예: 병렬 에이전트로 프론트/백엔드 나눠서 분석해줘
```

## 주의점

- Claude의 `/agent` UI와 완전히 같은 메뉴는 아니다.
- Codex에서는 스킬 이름을 직접 말하는 방식이 가장 안정적이다.
- 프로젝트별 Spec Kit 스킬은 해당 프로젝트에 초기화되어 있을 때만 사용 가능하다.
- 메뉴는 기억 보조가 목적이므로 기본 응답을 짧게 유지한다.