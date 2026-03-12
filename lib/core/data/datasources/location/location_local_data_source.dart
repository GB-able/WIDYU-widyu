import 'package:widyu/core/model/location/user_location.dart';

abstract class LocationLocalDataSource {
  Stream<UserLocation> getLocation();
}
