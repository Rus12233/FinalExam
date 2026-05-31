# ADR-0005: 배포 채널 선택

- 상태: Accepted
- 날짜: 2026-05-31
- 결정자: Rus12233

## 배경

완성된 앱을 사용자에게 배포할 채널을 결정해야 한다. Flutter는 Android, iOS, Web 모두 빌드 가능하므로 어느 플랫폼을 우선할지, 개발/시연 단계에서 어떤 방식으로 배포할지 결정이 필요하다.

## 고려한 대안

### 대안 A: Google Play Store (Android)
- 장점: Flutter Android 빌드 성숙, App Bundle 최적화 지원, 개발자 계정 비용 낮음($25 일회성)
- 단점: 심사 기간 1~3일, 스토어 등록 자료 준비 필요

### 대안 B: Apple App Store (iOS)
- 장점: iOS 사용자 접근 가능, 높은 사용자 신뢰도
- 단점: 개발자 계정 연 $99, macOS + Xcode 환경 필수, 심사 기간 길고 반려 가능성 있음

### 대안 C: 웹 배포 (Flutter Web)
- 장점: 설치 불필요, URL 공유로 즉시 시연 가능, GitHub Pages / Firebase Hosting 무료
- 단점: 모바일 네이티브 경험 부족, 일부 패키지 웹 미지원 가능성

## 결정

우선 대안 C 웹 배포(Flutter Web + GitHub Pages)로 시작하고, 이후 대안 A Android APK 배포를 병행한다.

## 이유

- 웹 배포는 별도 설치 없이 URL 하나로 발표·시연 가능 → 즉각적인 피드백 수집에 유리
- GitHub Pages는 무료이며 `flutter build web --release`로 바로 연동 가능
- Android APK는 직접 설치 파일 배포로 앱스토어 심사 없이 빠른 테스트 가능
- iOS는 개발자 계정 비용 및 macOS 환경 제약으로 현재 단계에서 보류

## 결과 (예상되는 영향)

긍정:
- 발표 시 URL 하나로 데모 가능
- 개발자 계정 비용 없이 배포 가능

부정 / 제약:
- 웹에서 Hive 저장소는 IndexedDB 기반으로 동작, 브라우저 데이터 초기화 시 유실
- iOS 사용자에게 배포 불가 (현재 단계)

## 후속 작업

- [x] `flutter build web --release --base-href "/app/"` 빌드 확인
- [ ] GitHub Pages 또는 Firebase Hosting 배포 설정
- [ ] Android APK 서명 키 생성 및 빌드
- [ ] 웹/앱 모두 스모크 테스트 수행
