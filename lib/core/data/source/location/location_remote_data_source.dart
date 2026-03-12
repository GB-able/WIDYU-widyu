import 'package:widyu/core/model/location/user_location.dart';

abstract class LocationRemoteDataSource {
  Future<void> connect();

  void sendLocation(UserLocation location);

  void disconnect();
}
