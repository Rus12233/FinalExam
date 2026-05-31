# ADR-0003: 상태 관리로 Provider 선택

- 상태: Accepted
- 날짜: 2026-05-31
- 결정자: Rus12233

## 배경

일기 추가 → 식물 성장 → UI 업데이트로 이어지는 단방향 상태 흐름을 관리해야 한다. 상태가 앱 전반에 공유되므로 `StatefulWidget`만으로는 prop-drilling 문제가 발생한다. 발표 Q&A에서 쉽게 설명할 수 있는 방식이어야 한다.

## 고려한 대안

### 대안 A: Provider (`provider` + ChangeNotifier)
- 장점: Flutter 공식 권장 패턴, 학습 자료 풍부, 보일러플레이트 최소, 발표 설명 용이
- 단점: 앱이 커지면 단일 Provider가 비대해질 수 있음, 컴파일 타임 안전성 없음

### 대안 B: Riverpod
- 장점: 컴파일 타임 안전성, Provider 간 의존성 관리 우수, 더 유연한 스코핑
- 단점: Provider 대비 학습 곡선 높음, 이 앱 규모에는 과도함

### 대안 C: BLoC (flutter_bloc)
- 장점: 이벤트/상태 분리로 대형 앱에 적합, 테스트 친화적
- 단점: 보일러플레이트가 많아 소규모 앱에 과도함, 개념 이해에 시간 필요

## 결정

대안 A Provider(ChangeNotifier 기반)를 선택한다.

## 이유

- 이 앱의 상태는 `DiaryProvider` 하나로 충분히 단순하게 표현 가능
- Flutter 공식 권장 방식으로 문서·예제가 풍부해 빠른 구현 가능
- Riverpod, BLoC 대비 보일러플레이트가 적어 개발 속도 유리
- `ChangeNotifier.notifyListeners()` → `Consumer` 리빌드 흐름이 직관적

## 결과 (예상되는 영향)

긍정:
- `DiaryProvider` 하나로 전체 앱 상태 관리 가능
- `Consumer<DiaryProvider>` 패턴으로 필요한 위젯만 리빌드

부정 / 제약:
- 앱 규모 확장 시 Provider 클래스가 비대해질 수 있음
- 컴파일 타임에 상태 타입 오류를 잡지 못할 수 있음

## 후속 작업

- [x] `provider` 패키지 추가
- [x] `DiaryProvider` 구현 (addEntry, plant state 계산)
- [x] `main.dart`에 `ChangeNotifierProvider` 주입
- [ ] Provider 단위 테스트 작성
