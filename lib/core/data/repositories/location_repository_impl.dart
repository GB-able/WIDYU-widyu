import 'package:widyu/core/data/datasources/location/location_local_data_source.dart';
import 'package:widyu/core/data/models/location/user_location.dart';
import 'package:widyu/core/data/repositories/location_repository.dart';

class LocationRepositoryImpl implements LocationRepository {
  final LocationLocalDataSource _localDataSource;

  LocationRepositoryImpl(this._localDataSource);

  @override
  Stream<UserLocation> getLocationStream() {
    return _localDataSource.getLocation();
  }
}
