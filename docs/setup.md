# 환경 설정 (Setup)

> 목표: 이 문서만 따라 하면 **5분 안에 앱이 실행**됩니다.

## 필수 요건

| 항목 | 버전 | 확인 명령 |
|------|------|----------|
| Flutter | 3.x 이상 | `flutter --version` |
| Dart | 3.4.0 이상 | `dart --version` |
| Git | 최신 | `git --version` |

---

## Windows 설치

### 1. Flutter SDK 설치

```powershell
# winget으로 설치 (권장)
winget install Google.Flutter

# 또는 공식 문서에서 zip 다운로드
# https://docs.flutter.dev/get-started/install/windows
```

설치 후 환경 변수 확인:
```powershell
flutter doctor
```

`flutter doctor` 출력에서 다음 항목에 체크가 있어야 합니다:
- [x] Flutter
- [x] Chrome (웹 실행용)
- [x] VS Code 또는 Android Studio

### 2. Android Studio 설치 (Android 기기 사용 시)

```
https://developer.android.com/studio 에서 다운로드 후 설치
```

Android SDK 라이선스 동의:
```powershell
flutter doctor --android-licenses
```

---

## macOS 설치

```bash
# Homebrew로 설치
brew install --cask flutter

flutter doctor
```

---

## 프로젝트 클론 & 실행

```bash
# 1. 클론
git clone https://github.com/Rus12233/app.git
cd app

# 2. 패키지 설치
flutter pub get

# 3. 실행 (가장 빠른 방법: Chrome)
flutter run -d chrome
```

---

## 실행 옵션

```bash
flutter run -d chrome    # 웹 브라우저 (추천 - 기기 불필요)
flutter run              # 연결된 Android/iOS 기기
flutter run -d windows  # Windows 앱으로 실행
```

연결된 기기 목록 확인:
```bash
flutter devices
```

---

## 자주 발생하는 오류

**Q. `flutter doctor`에 오류가 표시됩니다**
```powershell
# Android 라이선스 오류
flutter doctor --android-licenses

# SDK 경로 오류 → Android Studio 재설치 후 SDK Manager에서 SDK 설치
```

**Q. `flutter pub get` 실패**
```bash
flutter clean
flutter pub get
```

**Q. Chrome에서 흰 화면만 나옵니다**
```bash
# Hot restart
r  # 앱 실행 중 터미널에서 r 입력

# 완전 재실행
flutter run -d chrome --web-renderer html
```
