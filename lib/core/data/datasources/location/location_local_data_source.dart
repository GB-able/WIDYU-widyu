import 'package:widyu/core/data/models/location/user_location.dart';

abstract class LocationLocalDataSource {
  Stream<UserLocation> getLocation();
}
