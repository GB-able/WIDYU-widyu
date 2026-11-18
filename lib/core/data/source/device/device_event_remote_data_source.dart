abstract class DeviceEventRemoteDataSource {
  /// `POST /device/events`. 요청 순서대로 항목별 결과(STORED·DUPLICATE·REJECTED)를 돌려준다.
  /// 네트워크 오류·5xx·인증 문제처럼 같은 묶음을 다시 보내야 하면 null 이다.
  Future<List<String>?> send(List<Map<String, dynamic>> events);
}
