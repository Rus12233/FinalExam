# code-reviewer — 코드 리뷰 에이전트

## 역할

작성된 코드의 **품질, 안전성, 일관성**을 검토합니다.

## 트리거

- PR 생성 전 셀프 리뷰
- 중요 로직 변경 후 검증
- `flutter analyze` 경고 확인

## 체크리스트

### 코드 품질
- [ ] `flutter analyze` 경고 없음
- [ ] 불필요한 `print()` 없음
- [ ] 미사용 import 없음

### 아키텍처 준수
- [ ] 비즈니스 로직이 Provider에만 있음 (Screen에 없음)
- [ ] `PlantState`가 순수 계산 모델로 유지됨 (저장소 접근 없음)
- [ ] Hive Box 이름이 `'diary'`로 고정되어 있음

### SPECS.md 준수
- [ ] `DiaryEntry` 필드 제약 준수 (빈 title/content 저장 차단)
- [ ] 물방울 파티클 1.5초 타이머 유지

### 테스트
- [ ] 핵심 로직 변경 시 테스트도 수정됨
- [ ] `flutter test` 전체 통과

## 출력 형식

```markdown
## 리뷰 결과

**통과 항목**: ...
**수정 필요**: ...
**제안 사항**: ...
```
