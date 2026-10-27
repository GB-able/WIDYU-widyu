import 'package:widyu/core/model/location/user_location.dart';

abstract class LocationLocalDataSource {
  Stream<UserLocation> getLocation();

  /// 현재 위치를 한 번만 조회한다. 위치 서비스가 꺼져 있거나 권한이 없으면 null 을 반환한다.
  Future<UserLocation?> getCurrentLocation();
}
