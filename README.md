# 나의 숲 (My Forest)

> 일기를 쓸 때마다 화분에 물이 주어지고 식물이 자라는 감성 다이어리 Flutter 앱

## 스크린샷

| 홈 화면 | 달력 화면 | 프로필 화면 |
|:-:|:-:|:-:|
| 🌰→🌲 식물 성장 | 📅 기분별 달력 | 👤 통계·업적 |

## 구현된 화면

### 홈 (HomeScreen)
- 현재 식물 단계 시각화 (PlantWidget)
- 성장 진행바 + 다음 단계까지 힌트
- 월별 이달 기록 수 / 총 물방울 통계 카드
- 저장 시 💧 물방울 파티클 애니메이션
- 월 네비게이션 (이전/다음 달)

### 달력 (CalendarScreen)
- 월별 달력 그리드 (일요일 기준)
- 기분별 컬러 dot 표시 (행복·감사·평온·슬픔)
- 날짜 탭 → 하단 시트에서 일기 목록 조회
- 빠른 작성 시트 — 기분 선택 + 내용 입력 후 저장
- 소급 작성 지원 (과거 날짜에도 기록 가능)
- 이달 기분 분포 통계 (진행바)

### 프로필 (ProfileScreen)
- 닉네임 표시 + 수정 (최대 15자)
- 통계 3종: 총 기록 수 / 연속 기록(streak) / 총 물방울
- 식물 성장 여정 시각화 — 5단계 달성 현황
- 감정 분포 차트 (전체 기록 기준)
- 업적 시스템 6종

| 업적 | 조건 |
|------|------|
| 🌱 첫 기록 | 일기 1개 |
| 📝 꾸준함 | 일기 5개 |
| 🌿 성장 중 | 일기 10개 |
| 🌲 숲의 주인 | 일기 20개 |
| 🔥 3일 연속 | streak 3일 |
| ⭐ 일주일 | streak 7일 |

- 설정: 닉네임 변경, 전체 기록 삭제

## 핵심 기능

- **일기 작성** — 기분 선택(4종) + 본문 저장
- **식물 성장** — 일기 수에 따라 씨앗 → 새싹 → 어린나무 → 나무 → 숲으로 진화
- **물방울 파티클** — 일기 저장 시 물주기 애니메이션 재생
- **달력 조회** — 월별 기분 dot + 날짜별 빠른 작성
- **연속 기록** — 연속 기록일(streak) 자동 계산
- **업적 시스템** — 기록 수/연속일 달성 뱃지
- **감정 분포** — 전체 기록의 감정 통계 시각화

## 빠른 시작

```bash
# 1. 패키지 설치
flutter pub get

# 2. 앱 실행
flutter run           # 연결된 기기
flutter run -d chrome # 웹 브라우저
```

자세한 환경 설정은 [docs/setup.md](docs/setup.md)를 참고하세요.

## 식물 성장 기준

| 단계 | 총 일기 수 |
|------|-----------|
| 🌰 씨앗 | 0개 |
| 🌱 새싹 | 1~4개 |
| 🌿 어린나무 | 5~9개 |
| 🌳 나무 | 10~19개 |
| 🌲 숲 | 20개 이상 |

## 기술 스택

| 영역 | 기술 |
|------|------|
| 프레임워크 | Flutter 3.x / Dart 3.4+ |
| 상태 관리 | Provider (ChangeNotifier) |
| 로컬 저장소 | Hive (NoSQL) |
| 애니메이션 | flutter_animate |

## 아키텍처

```
lib/
├── main.dart
├── models/
│   ├── diary_entry.dart       # Hive 저장 모델
│   ├── diary_entry.g.dart     # TypeAdapter (수동 작성)
│   └── plant_state.dart       # 식물 단계 계산 순수 모델
├── providers/
│   └── diary_provider.dart    # 비즈니스 로직 (streak, mood, 업적)
├── screens/
│   ├── main_shell.dart        # BottomNavigationBar 컨테이너
│   ├── home_screen.dart       # 식물 성장 + 통계
│   ├── calendar_screen.dart   # 달력 + 빠른 작성
│   └── profile_screen.dart    # 닉네임 + 업적 + 감정 분포
└── widgets/
    ├── plant_widget.dart
    └── growth_progress_bar.dart
```

## 문서

- [환경 설정](docs/setup.md)
- [빌드 & 배포](docs/deploy.md)
- [테스트](docs/testing.md)
- [아키텍처](docs/architecture.md)

## 라이선스

MIT
