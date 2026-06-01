
---
marp: true
theme: default
paginate: true
backgroundColor: #F5EDD3
color: #3d2b1f
style: |
  section {
    font-family: 'Noto Sans KR', sans-serif;
    font-size: 28px;
  }
  h1 { color: #2d6a4f; }
  h2 { color: #40916c; border-bottom: 2px solid #40916c; }
  code { background: #e9f5e1; }
  strong { color: #2d6a4f; }
---

# 🌱 나의 숲
## 중간 발표

**일기를 쓸 때마다 식물이 자라는 감성 다이어리 앱**

Rus12233 | Flutter | 12주차

---

## 문제 정의

> "일기 앱은 많은데, 왜 꾸준히 못 쓸까?"

- 기록해도 **변하는 것이 없다**
- 동기 부여 메커니즘 부재
- 텍스트만 쌓이는 단조로운 경험

**→ 시각적 보상으로 기록 습관을 만든다**

---

## 접근 방법

### 핵심 아이디어
```
일기 1편 작성 = 화분에 물 한 번 주기
```

| 총 일기 수 | 식물 단계 |
|-----------|----------|
| 0개 | 🌰 씨앗 |
| 1~4개 | 🌱 새싹 |
| 5~9개 | 🌿 어린나무 |
| 10~19개 | 🌳 나무 |
| 20개+ | 🌲 숲 |

---

## 기술 스택

```
Flutter 3.x
    ├── Provider (상태 관리)
    ├── Hive (로컬 저장소)
    └── flutter_animate (파티클 효과)
```

**선택 이유**
- Flutter: 단일 코드베이스 → iOS/Android/Web 동시 지원
- Hive: 빌드러너 없는 빠른 로컬 NoSQL
- Provider: 이 규모에 딱 맞는 단순한 상태 관리

---

## 아키텍처

```
WriteScreen
    ↓ addEntry()
DiaryProvider (ChangeNotifier)
    ↓ Hive Box 저장
PlantState 재계산
    ↓ notifyListeners()
HomeScreen 리빌드 → PlantWidget 진화 🌱
```

**단방향 데이터 흐름** → 디버깅 쉬움

---

## 진행 상황

### ✅ 완료 (Must Have 100%)
- 일기 작성 / 저장 / 삭제
- 식물 5단계 진화
- 물방울 파티클 애니메이션 (1.5초)
- 일기 목록 화면 (날짜 역순)
- 성장도 프로그레스 바

### 🔄 진행 중
- 테스트 커버리지 개선
- 발표 자료 정리

---

## 데모 시나리오

> **지금 바로 시연 가능**

1. 앱 실행 → 🌰 씨앗 화면
2. 일기 작성 → 저장
3. 💧 물방울 파티클 재생
4. 🌱 새싹으로 단계 상승 확인
5. 기록 목록 화면에서 저장된 일기 확인

```bash
# 발표 환경 실행 명령
flutter run -d chrome
```

---

## 기술적 도전 & 해결

### 도전: 빌드러너 없이 Hive TypeAdapter 작성
```dart
// diary_entry.g.dart 수동 구현
class DiaryEntryAdapter extends TypeAdapter<DiaryEntry> {
  @override
  final int typeId = 0;
  // ...
}
```
**결과**: 빌드 단계 단순화, Web 호환성 개선

---

## 다음 단계 (13~15주차)

| 주차 | 목표 |
|------|------|
| 13주차 | 테스트 보완, 피드백 반영 |
| 14주차 | APK/Web 빌드 검증 |
| 15주차 | **최종 발표** |

### Could Have (여유 시)
- 📸 사진 첨부 기능 (`image_picker` 패키지)

---

## Q&A 대비

| 질문 | 답변 |
|------|------|
| 환경 설정은? | `docs/setup.md` — 5분 안에 실행 |
| 왜 Flutter? | ADR-001 — 단일 코드베이스, 60fps |
| 왜 Hive? | ADR-002 — 빌드러너 불필요, 빠름 |
| 테스트는? | `flutter test` — PlantState 경계값 |

---

# 감사합니다 🌲

> "꾸준히 기록하면 숲이 됩니다"

**GitHub**: github.com/Rus12233/app
**실행**: `flutter run -d chrome`
