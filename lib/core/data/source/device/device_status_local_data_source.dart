abstract class DeviceStatusLocalDataSource {
  /// 하트비트 `phone{}` 중 `battery_pct`·`charging`·`os`·`background_restricted`. 읽지 못한 키는 빠진다.
  Future<Map<String, dynamic>> phoneStatus();

  Future<String> appVersion();

  /// `always`·`while_in_use`·`denied`·`denied_forever`·`unknown`.
  Future<String> locationPermission();

  Future<bool> watchConnected();
}
