# ADR-003: 상태 관리로 Provider 선택

## 상태
채택됨

## 맥락
일기 추가 → 식물 성장 → UI 업데이트로 이어지는 단방향 상태 흐름이 필요합니다.

## 결정
`provider` 패키지(ChangeNotifier 기반)를 사용합니다.

## 이유
- Flutter 공식 권장 방식으로 학습 자료가 풍부함
- 이 앱의 상태는 `DiaryProvider` 하나로 충분히 단순함
- Riverpod, Bloc 대비 보일러플레이트가 적음
- 발표 Q&A에서 설명하기 쉬운 패턴

## 트레이드오프
- 앱이 커지면 Provider가 거대해질 수 있음 (현재 규모에서는 문제 없음)
- Riverpod처럼 컴파일 타임 안전성은 없음
