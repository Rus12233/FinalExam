# ADR-002: 로컬 저장소로 Hive 선택

## 상태
채택됨

## 맥락
일기 데이터를 앱을 껐다 켜도 유지해야 합니다.
서버 없이 오프라인에서 동작해야 합니다.

## 결정
`hive` + `hive_flutter` 패키지를 사용합니다.

## 이유
- **빠른 읽기/쓰기**: 순수 Dart 기반 NoSQL, SQLite보다 단순 쿼리에서 빠름
- **타입 안전**: `TypeAdapter`로 `DiaryEntry` 객체를 직렬화, JSON 파싱 불필요
- `SharedPreferences`는 단순 키-값이라 일기 목록 저장에 부적합
- `sqflite`는 SQL 스키마 설계 오버헤드가 있음

## 트레이드오프
- 복잡한 쿼리(날짜 범위 검색 등) 지원이 SQLite보다 약함
- `TypeAdapter` 코드 작성 필요 (`diary_entry.g.dart`)
