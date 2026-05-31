---
applyTo: "lib/**/*.dart"
---

# Flutter/Dart 코드 작성 지침

## 이 프로젝트의 규칙

- 비즈니스 로직은 `lib/providers/diary_provider.dart`에만 작성한다
- Screen 위젯에서는 `context.read<DiaryProvider>()` 또는 `Consumer`만 사용
- `PlantState`는 순수 함수만 포함 — 저장소 접근 금지
- Hive Box 이름 `'diary'`는 변경하지 않는다

## Dart 스타일

- `const` 생성자 가능한 곳에 항상 사용
- `final` 변수 우선 (`var` 최소화)
- `async/await` 사용, `.then()` 체이닝 지양

## Flutter 패턴

- 상태 구독: `Consumer<DiaryProvider>` 또는 `context.watch<DiaryProvider>()`
- 단발성 액션: `context.read<DiaryProvider>().someMethod()`
- 화면 이동: `Navigator.push(context, MaterialPageRoute(...))`
