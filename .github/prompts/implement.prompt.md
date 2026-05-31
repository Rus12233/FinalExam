# /implement — 기능 구현

## 사용법

```
/implement [기능명 또는 plan 파일 경로]
```

## 프롬프트 템플릿

다음 순서로 구현을 진행하세요:

1. **사전 확인**
   - `AGENTS.md`의 코드 작업 준수 사항 확인
   - `SPECS.md`의 도메인 규칙 확인

2. **구현**
   - 계획된 순서대로 파일 수정
   - 각 파일 수정 후 `flutter analyze` 오류 없음 확인

3. **테스트**
   - `test-writer` 에이전트 호출하여 테스트 작성
   - `flutter test` 전체 통과 확인

4. **문서 동기화**
   - `SPECS.md` 또는 `docs/architecture.md` 업데이트 필요 여부 확인

5. **완료 보고**
   - 변경된 파일 목록
   - 테스트 통과 여부
   - `code-reviewer` 에이전트 호출 권고
