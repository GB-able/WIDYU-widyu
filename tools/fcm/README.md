# FCM 테스트 발송

1. Firebase 콘솔 → 프로젝트 설정 → 서비스 계정 → 새 비공개 키 생성 → `tools/fcm/serviceAccount.json` 으로 저장 (gitignore 됨)
2. `cd tools/fcm && npm install`
3. 디버그 빌드 앱 로그에서 `FCM 토큰:` 줄을 복사
4. `node send.js payloads/album_post.json <토큰>`

payloads/ 의 JSON 은 Admin SDK `Message` 형식이다. 필요한 케이스는 파일을 복사해 고친다.
