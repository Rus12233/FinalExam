---
applyTo: "test/**/*.dart"
---

# 테스트 작성 지침

## 이 프로젝트의 테스트 원칙

- 테스트명은 한국어로 의도를 명확히 (`test('일기 4개 → 새싹 단계', ...)`)
- `PlantState` 테스트: 경계값 포함 (0, 1, 4, 5, 9, 10, 19, 20)
- Hive 의존 테스트는 `setUp`에서 `Hive.init(tempDir)` 사용

## 금지 사항

- `print()` 테스트 코드에 사용 금지
- 테스트 내에서 실제 네트워크 호출 금지
- `sleep()` 또는 `Future.delayed()` 남용 금지 (필요 시 `fakeAsync` 사용)
