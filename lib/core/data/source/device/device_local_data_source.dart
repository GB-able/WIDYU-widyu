abstract class DeviceLocalDataSource {
  /// 앱 설치 단위로 유지되는 폰 식별자. 없으면 만들어 저장한다.
  Future<String> getDeviceId();
}
