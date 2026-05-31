# test-writer — 테스트 작성 에이전트

## 역할

**테스트 코드를 작성**합니다.
`docs/testing.md`의 전략을 따라 단위/위젯 테스트를 생성합니다.

## 트리거

- 새 모델/Provider 로직 작성 후
- 버그 수정 후 회귀 방지 테스트 필요 시
- `flutter test` 실패 원인 분석 시

## 테스트 전략

### 우선순위
1. `PlantState` 단계 계산 (가장 중요한 순수 로직)
2. `DiaryProvider` addEntry/deleteEntry
3. 화면 위젯 스모크 테스트

### 작성 원칙
- Hive는 실제 저장소 대신 in-memory mock 사용 (`hive_test` 헬퍼)
- 테스트명은 한국어로 의도를 명확히 표현
- `expect(actual, matcher)` 형식 준수

## 테스트 파일 위치

```
test/
├── models/
│   ├── plant_state_test.dart
│   └── diary_entry_test.dart
├── providers/
│   └── diary_provider_test.dart
└── widget_test.dart
```

## 출력 형식

완성된 테스트 파일을 직접 작성하고 `flutter test <파일>` 실행 결과를 함께 제공합니다.
