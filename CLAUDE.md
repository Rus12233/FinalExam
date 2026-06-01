# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## 프로젝트 개요

**나의 숲** — 일기/메모를 쓸 때마다 화면 속 화분에 물이 주어지고 식물이 자라는 감성 다이어리 Flutter 앱.

## 주요 명령어

```bash
flutter pub get          # 패키지 설치
flutter run              # 앱 실행 (연결된 기기)
flutter run -d chrome    # 웹 브라우저 실행
flutter test             # 전체 테스트
flutter test test/path/to/file_test.dart  # 단일 테스트
flutter build apk --release   # Android APK 빌드
flutter build appbundle       # Play Store용 빌드
flutter build web --release --base-href "/app/"  # 웹 빌드
```

## 아키텍처

```
lib/
├── main.dart              # Hive 초기화, ChangeNotifierProvider 주입, AuthGate 라우팅
├── models/
│   ├── diary_entry.dart   # Hive 저장 모델 (@HiveType)
│   ├── diary_entry.g.dart # TypeAdapter (수동 작성, 빌드러너 불필요)
│   └── plant_state.dart   # 식물 단계 계산 순수 모델 (저장소 없음)
├── providers/
│   ├── auth_provider.dart   # 로그인·회원가입·게스트·로그아웃 + Hive 세션
│   └── diary_provider.dart  # 모든 비즈니스 로직 + ChangeNotifier
├── screens/               # 화면 단위 위젯
└── widgets/               # 재사용 가능한 UI 조각
```

### 핵심 데이터 흐름
`WriteScreen` → `DiaryProvider.addEntry()` → Hive 저장 → `PlantState` 재계산 → `Consumer` 리빌드 → `PlantWidget` 진화 + 물방울 파티클

### 식물 진화 기준 (`lib/models/plant_state.dart`)
씨앗(0) → 새싹(1~4) → 어린나무(5~9) → 나무(10~19) → 숲(20+)

## 문서

- `docs/setup.md` — 환경 설정
- `docs/deploy.md` — 빌드/배포
- `docs/testing.md` — 테스트
- `docs/architecture.md` — 구조 상세
- `.planning/decisions/ADR-*.md` — 기술 선택 근거
