import '../models/location/user_location.dart';

abstract class LocationRepository {
  Stream<UserLocation> getLocationStream();
}
