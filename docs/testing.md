# 테스트 (Testing)

> 목표: 명령 한 줄로 전체 테스트를 실행하고 결과를 확인합니다.

## 테스트 실행

```bash
# 전체 테스트 (가장 중요)
flutter test

# 단일 파일 테스트
flutter test test/widget_test.dart

# 커버리지 측정
flutter test --coverage
# 결과: coverage/lcov.info 생성
```

---

## 테스트 구조

```
test/
├── models/
│   ├── plant_state_test.dart     # PlantState 단계 계산 로직 (핵심)
│   └── diary_entry_test.dart     # DiaryEntry 생성/직렬화
├── providers/
│   └── diary_provider_test.dart  # 일기 추가/삭제, 식물 상태 반영
└── widget_test.dart              # HomeScreen 위젯 스모크 테스트
```

---

## 테스트 작성 규약

### 파일 위치
- 모델 테스트 → `test/models/`
- Provider 테스트 → `test/providers/`
- 위젯 테스트 → `test/`

### 테스트명 규칙
```dart
// 형식: '조건 → 기대 결과'
test('일기 4개일 때 → 새싹 단계', () { ... });
test('일기 5개일 때 → 어린나무 단계', () { ... });
```

### Hive 초기화 (테스트 환경)
```dart
setUp(() async {
  final dir = await Directory.systemTemp.createTemp();
  Hive.init(dir.path);
  Hive.registerAdapter(DiaryEntryAdapter());
});

tearDown(() async {
  await Hive.deleteFromDisk();
});
```

---

## 주요 테스트 시나리오

### PlantState 경계값 테스트 (가장 중요)

| 입력 (totalEntries) | 기대 단계 |
|--------------------|----------|
| 0 | seed (씨앗) |
| 1 | sprout (새싹) |
| 4 | sprout (새싹) |
| 5 | sapling (어린나무) |
| 9 | sapling (어린나무) |
| 10 | tree (나무) |
| 19 | tree (나무) |
| 20 | forest (숲) |

### DiaryProvider 테스트
- `addEntry()` 호출 시 `totalEntries` 증가 확인
- `addEntry()` 후 `showWaterEffect == true` 확인
- `deleteEntry()` 호출 시 항목 삭제 확인

---

## 기기 테스트

```bash
flutter devices           # 연결된 기기 목록
flutter run -d <id>       # 특정 기기에서 실행
flutter run -d chrome     # Chrome에서 실행 (기기 불필요)
```
