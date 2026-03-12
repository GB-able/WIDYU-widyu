import 'package:widyu/core/model/location/user_location.dart';

abstract class LocationRemoteDataSource {
  void sendLocation(UserLocation location);
}
