# 빌드 & 배포 (Deploy)

> 발표 Q&A에서 "배포는 어떻게 하나요?" 질문에 대한 답변 문서입니다.

## 빠른 참조

| 플랫폼 | 명령 | 결과물 위치 |
|--------|------|-----------|
| Android APK | `flutter build apk --release` | `build/app/outputs/flutter-apk/app-release.apk` |
| Android Bundle | `flutter build appbundle --release` | `build/app/outputs/bundle/release/app-release.aab` |
| Web | `flutter build web --release --base-href "/app/"` | `build/web/` |
| iOS | `flutter build ios --release` | Xcode에서 Archive 필요 |

---

## Android

### APK 빌드 (테스트/직접 설치용)

```bash
flutter build apk --release
```

결과물: `build/app/outputs/flutter-apk/app-release.apk`
- USB로 연결된 기기에 직접 설치 가능
- 발표 데모용으로 미리 빌드해 두면 좋습니다

### App Bundle 빌드 (Play Store 제출용)

```bash
flutter build appbundle --release
```

### 서명 설정 (Play Store 제출 시 필수)

`android/key.properties` 파일을 생성합니다 (git에 포함하지 않음):

```
storePassword=<비밀번호>
keyPassword=<비밀번호>
keyAlias=<키 별칭>
storeFile=<키스토어 파일 경로>
```

키스토어 생성 명령:
```bash
keytool -genkey -v -keystore ~/upload-keystore.jks \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias upload
```

---

## 웹 (발표용 권장)

### 빌드

```bash
flutter build web --release --base-href "/app/"
```

결과물: `build/web/` 폴더

### GitHub Pages 배포

```bash
# gh-pages 브랜치에 웹 빌드 배포
git subtree push --prefix build/web origin gh-pages
```

배포 후 접속: `https://Rus12233.github.io/app/`

> **발표 팁**: 기기 연결 없이 브라우저로 바로 시연 가능하므로
> 발표 전날 웹 빌드를 GitHub Pages에 올려두는 것을 권장합니다.

---

## iOS

```bash
flutter build ios --release
```

Xcode에서 `Runner.xcworkspace`를 열어:
1. Product → Archive
2. App Store Connect → Upload

---

## 버전 관리

`pubspec.yaml`의 `version` 필드:

```yaml
version: 1.0.0+1
#        ^^^^^  ^
#        semver 빌드번호 (스토어 제출마다 증가)
```

버전 업 후 빌드:
```bash
# pubspec.yaml version 수정 후
flutter build apk --release
```
