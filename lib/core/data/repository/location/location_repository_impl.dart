import 'dart:async';
import 'dart:developer';

import 'package:widyu/core/data/repository/location/location_repository.dart';
import 'package:widyu/core/data/source/location/location_local_data_source.dart';
import 'package:widyu/core/data/source/location/location_remote_data_source.dart';
import 'package:widyu/core/model/location/user_location.dart';

class LocationRepositoryImpl implements LocationRepository {
  final LocationLocalDataSource _localDataSource;
  final LocationRemoteDataSource _remoteDataSource;

  StreamSubscription<UserLocation>? _locationSubscription;

  LocationRepositoryImpl({
    required LocationLocalDataSource localDataSource,
    required LocationRemoteDataSource remoteDataSource,
  })  : _localDataSource = localDataSource,
        _remoteDataSource = remoteDataSource;

  @override
  Future<void> startLocationUpload() async {
    if (_locationSubscription != null) {
      await _locationSubscription?.cancel();
      _locationSubscription = null;
    }

    _locationSubscription = _localDataSource.getLocation().listen(
      (location) {
        _remoteDataSource.sendLocation(location);
      },
      onError: (error) {
        log('Error in location stream: $error');
      },
    );
  }

  @override
  Future<UserLocation?> getCurrentLocation() =>
      _localDataSource.getCurrentLocation();

  @override
  void stopLocationUpload() {
    _locationSubscription?.cancel();
    _locationSubscription = null;
  }
}
