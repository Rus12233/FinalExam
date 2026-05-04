# 환경 설정 (Setup)

## 필수 요건

| 항목 | 버전 |
|------|------|
| Flutter | 3.x 이상 |
| Dart | 3.4.0 이상 |
| Android Studio / Xcode | 최신 안정 버전 |

## 설치 순서

### 1. Flutter SDK 설치
[Flutter 공식 문서](https://docs.flutter.dev/get-started/install)를 참고해 설치합니다.

```bash
flutter doctor   # 설치 환경 점검
```

### 2. 프로젝트 클론 및 패키지 설치

```bash
git clone https://github.com/Rus12233/app.git
cd app
flutter pub get
```

### 3. 실행

```bash
# Android 에뮬레이터 또는 연결된 기기
flutter run

# 특정 기기 지정
flutter run -d <device_id>

# 웹 브라우저
flutter run -d chrome
```

## 자주 묻는 문제

**Q. `flutter doctor`에서 오류가 나요**
- Android SDK 라이선스: `flutter doctor --android-licenses` 실행

**Q. 패키지 설치 오류**
```bash
flutter clean
flutter pub get
```
