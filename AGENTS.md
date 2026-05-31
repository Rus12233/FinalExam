# AGENTS.md — 에이전트 운영 헌법

> 이 파일은 Claude Code 및 모든 AI 에이전트가 매 턴 자동으로 참조합니다.
> `AUTHORING.Rus12233.v0.1.0.md`의 선호를 반영해 작성되었습니다.

## 프로젝트 정체성

**나의 숲 (My Forest)**
일기/메모를 쓸 때마다 화분에 물이 주어지고 식물이 자라는 감성 다이어리 Flutter 앱.
사용자의 꾸준한 기록 습관을 식물 성장으로 시각화합니다.

## 소통 원칙

- **한국어 우선**: 모든 설명, 주석, 문서는 한국어로 작성
- **질문 먼저**: 구현 전 모호한 부분은 선택형 질문으로 확인
- **단계별 진행**: 한 번에 많은 변경 대신, 단계별로 확인하며 진행

## 핵심 원칙

1. **단순성 우선** — 기능 추가보다 기존 기능의 완성도를 높인다
2. **감성 유지** — 모든 UI 변경은 따뜻하고 자연적인 톤을 유지
3. **데이터 안전** — 사용자 일기 데이터는 의도치 않게 삭제되지 않도록
4. **테스트 필수** — `PlantState`, `DiaryProvider` 변경 시 테스트 함께 수정

## 기술 스택

| 영역 | 선택 | 이유 |
|------|------|------|
| 프레임워크 | Flutter 3.x | 단일 코드베이스, 60fps 애니메이션 |
| 상태 관리 | Provider (ChangeNotifier) | 낮은 학습 곡선, 규모 적합 |
| 로컬 저장소 | Hive | 빠른 NoSQL, 빌드러너 불필요 |
| 애니메이션 | flutter_animate | 선언형 파티클/성장 효과 |

## 코드 작업 시 준수 사항

- `lib/models/plant_state.dart` 변경 시 → `docs/architecture.md` + `SPECS.md` 동시 수정
- `diary_entry.g.dart` — 빌드러너 사용 안 함, 수동 TypeAdapter 직접 편집
- Provider는 `DiaryProvider` 하나로 유지, 불필요한 분리 금지
- Hive Box 이름 `'diary'` 변경 금지
- 파일 삭제·구조 변경 전 사용자에게 확인

## 서브에이전트 역할

| 에이전트 | 책임 |
|----------|------|
| `feasibility-researcher` | 기술 선택 타당성 조사 |
| `implementation-planner` | 구현 계획 수립 |
| `code-reviewer` | 코드 품질/보안 검토 |
| `test-writer` | 테스트 코드 작성 |

정의 파일: `.github/agents/*.agent.md`

## 슬래시 명령

| 명령 | 역할 |
|------|------|
| `/spec` | 기능 명세 작성 |
| `/plan` | 구현 계획 수립 |
| `/implement` | 기능 구현 |
| `/retro` | 회고 작성 |

정의 파일: `.github/prompts/*.prompt.md`

## 문서 맵

| 파일 | 역할 |
|------|------|
| `SPECS.md` | 도메인 규칙 (식물 단계, 데이터 제약) |
| `docs/setup.md` | 환경 설정 (5분 안에 실행) |
| `docs/deploy.md` | 빌드/배포 전 단계 |
| `docs/testing.md` | 테스트 실행 및 작성 규약 |
| `docs/architecture.md` | 구조 상세 |
| `.planning/decisions/ADR-*.md` | 기술 선택 근거 |
