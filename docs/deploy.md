# 빌드 & 배포 (Deploy)

## Android

### APK 빌드 (테스트용)
```bash
flutter build apk --release
# 결과물: build/app/outputs/flutter-apk/app-release.apk
```

### App Bundle 빌드 (Play Store 제출용)
```bash
flutter build appbundle --release
# 결과물: build/app/outputs/bundle/release/app-release.aab
```

### 서명 설정
`android/key.properties` 파일 생성 (git에 포함하지 않음):
```
storePassword=<비밀번호>
keyPassword=<비밀번호>
keyAlias=<키 별칭>
storeFile=<키스토어 파일 경로>
```

## iOS

```bash
flutter build ios --release
```
Xcode에서 `Runner.xcworkspace`를 열어 Archive → App Store Connect 업로드.

## 웹 (GitHub Pages)

```bash
flutter build web --release --base-href "/app/"
```

빌드 결과물(`build/web/`)을 GitHub Pages 브랜치(`gh-pages`)에 푸시합니다.

```bash
git subtree push --prefix build/web origin gh-pages
```

## 버전 관리

`pubspec.yaml`의 `version` 필드를 `1.0.0+1` 형식으로 관리합니다.
- 앞 세 자리: 사용자에게 표시되는 버전 (semver)
- `+` 뒤 숫자: 빌드 번호 (스토어 제출 시 매번 증가)
