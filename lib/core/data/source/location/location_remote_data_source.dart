import 'package:widyu/core/model/location/location_update_request.dart';

abstract class LocationRemoteDataSource {
  /// STOMP 로 위치 원본을 보낸다. 소켓이 끊겨 보내지 못하면 false.
  bool sendLocation(LocationUpdateRequest request);

  Stream<bool> get connectionState;
}
