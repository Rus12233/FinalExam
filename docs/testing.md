# 테스트 (Testing)

## 테스트 실행

```bash
# 전체 테스트
flutter test

# 단일 파일 테스트
flutter test test/widget_test.dart

# 커버리지 측정
flutter test --coverage
```

## 테스트 구조

```
test/
├── models/
│   ├── plant_state_test.dart     # PlantState 단계 계산 로직
│   └── diary_entry_test.dart
├── providers/
│   └── diary_provider_test.dart  # 일기 추가/삭제, 식물 상태 반영
└── widget_test.dart              # HomeScreen 위젯 스모크 테스트
```

## 주요 테스트 시나리오

### PlantState 단계 테스트 (핵심 로직)
일기 개수에 따라 식물 단계가 올바르게 변하는지 검증합니다:
- 0개 → seed, 1~4개 → sprout, 5~9개 → sapling, 10~19개 → tree, 20개+ → forest

### DiaryProvider 테스트
- `addEntry()` 호출 시 `totalEntries` 증가 및 `showWaterEffect` 트리거 확인
- `deleteEntry()` 호출 시 항목 삭제 확인

## 기기 테스트

```bash
flutter devices           # 연결된 기기 목록
flutter run -d <id>       # 특정 기기에서 실행
```
