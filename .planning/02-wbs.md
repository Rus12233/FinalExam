# WBS — 나의 숲

> 작성: AI Agent 자동 생성 / 본인 검토 완료 (2026-05-31)

## 1. 사용자 영역

### 1.1 일기 작성 흐름
- 1.1.1 텍스트 입력 UI (WriteScreen) (1d) ✅
- 1.1.2 감정(Mood) 선택 UI — happy / neutral / sad / grateful (1d) ✅
- 1.1.3 저장 액션 → DiaryProvider.addEntry() 호출 (0.5d) ✅
- 1.1.4 저장 성공 스낵바 + 화면 복귀 (0.5d) ✅

### 1.2 일기 조회 흐름
- 1.2.1 목록 화면 (DiaryListScreen) — 날짜 역순 ListView (1d) ✅
- 1.2.2 날짜 + 감정 이모지 표시 카드 (0.5d) ✅
- 1.2.3 스와이프(Dismissible) 삭제 (0.5d) ✅

### 1.3 홈 화면
- 1.3.1 화분 + 식물 중앙 배치 (HomeScreen) (1d) ✅
- 1.3.2 통계 카드 (전체 기록 수 / 오늘 물방울 수) (0.5d) ✅
- 1.3.3 일기 쓰기 / 기록 보기 버튼 내비게이션 (0.5d) ✅

---

## 2. 핵심 기능 영역

### 2.1 식물 성장 시스템
- 2.1.1 단계 계산 순수 모델 (PlantState.stage) (1d) ✅
- 2.1.2 성장도 퍼센트 계산 (PlantState.growthPercent) (0.5d) ✅
- 2.1.3 이모지 + 단계명 시각화 (PlantWidget) (1d) ✅
- 2.1.4 다음 단계 힌트 텍스트 (GrowthProgressBar) (0.5d) ✅

### 2.2 물방울 파티클 애니메이션
- 2.2.1 파티클 생성 및 물리 계산 (_Particle, _ParticlePainter) (1d) ✅
- 2.2.2 부유 애니메이션 (AnimationController + Tween) (0.5d) ✅
- 2.2.3 1.5초 자동 종료 타이머 (DiaryProvider) (0.5d) ✅

### 2.3 감정(Mood) 트래킹
- 2.3.1 DiaryEntry.mood 필드 (0.5d) ✅
- 2.3.2 감정 선택 버튼 UI (WriteScreen) (1d) ✅
- 2.3.3 목록에서 감정 이모지 표시 (0.5d) ✅

---

## 3. 데이터

### 3.1 데이터 모델
- 3.1.1 DiaryEntry 모델 — id, content, createdAt, mood (0.5d) ✅
- 3.1.2 Hive TypeAdapter 수동 작성 (diary_entry.g.dart) (1d) ✅
- 3.1.3 PlantState 순수 모델 — totalEntries, waterDrops, lastWatered (0.5d) ✅

### 3.2 로컬 저장소
- 3.2.1 Hive.initFlutter() + Box<DiaryEntry> 초기화 (0.5d) ✅
- 3.2.2 addEntry / deleteEntry CRUD (0.5d) ✅

### 3.3 오프라인 지원
- 3.3.1 전체 기능 인터넷 없이 동작 (0d — 설계 의도) ✅

---

## 4. 운영

### 4.1 빌드 / 배포
- 4.1.1 Android APK 빌드 (0.5d) ✅ (docs/deploy.md)
- 4.1.2 Web 빌드 + GitHub Pages 배포 (0.5d) ✅ (docs/deploy.md)
- 4.1.3 iOS 빌드 (0.5d) ✅ (docs/deploy.md)

### 4.2 테스트
- 4.2.1 PlantState 경계값 단위 테스트 (1d) ✅ (test/widget_test.dart)
- 4.2.2 DiaryEntry 모델 단위 테스트 (0.5d) ✅ (test/models/diary_entry_test.dart)
- 4.2.3 PlantState 전용 테스트 파일 분리 (0.5d) ✅ (test/models/plant_state_test.dart)

---

## 5. 문서 / 발표

### 5.1 기술 문서
- 5.1.1 README.md — 프로젝트 설명 + 빠른 시작 (0.5d) ✅
- 5.1.2 docs/setup.md — zero → run (5분 기준) (0.5d) ✅
- 5.1.3 docs/deploy.md — 빌드/배포 전 단계 (0.5d) ✅
- 5.1.4 docs/testing.md — 테스트 실행 + 작성 규약 (0.5d) ✅
- 5.1.5 docs/architecture.md — 구조 + Mermaid 다이어그램 (0.5d) ✅

### 5.2 AI 에이전트 문서
- 5.2.1 AGENTS.md — 에이전트 운영 헌법 (0.5d) ✅
- 5.2.2 SPECS.md — 도메인 규칙 (0.5d) ✅
- 5.2.3 AUTHORING.Rus12233.v0.1.0.md — 개인 부트스트랩 (0.5d) ✅

### 5.3 발표 자료
- 5.3.1 docs/presentation/interim.md — 중간 발표 Marp (1d) ✅
- 5.3.2 docs/presentation/final.md — 최종 발표 Marp + 백업 슬라이드 (1d) ✅

---

## 합계

| 구분 | 항목 | 공수 |
|------|------|------|
| Must (1~2번 영역) | 일기 작성/조회, 식물 성장, 파티클, 감정 | ~10d |
| Must (3번 데이터) | 모델, 저장소 | ~3d |
| Should (4번 운영) | 빌드, 테스트 | ~3d |
| Could (5번 문서) | 기술 문서, 발표 자료 | ~5d |
| **총 작업일** | 버퍼 20% 포함 | **~25d** |
