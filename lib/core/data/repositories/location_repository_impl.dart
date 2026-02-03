import 'dart:async';
import 'dart:developer';

import 'package:widyu/core/data/datasources/location/location_local_data_source.dart';
import 'package:widyu/core/data/datasources/location/location_remote_data_source.dart';
import 'package:widyu/core/data/models/location/user_location.dart';
import 'package:widyu/core/data/repositories/location_repository.dart';

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
    await _remoteDataSource.connect();
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
  void stopLocationUpload() {
    _locationSubscription?.cancel();
    _remoteDataSource.disconnect();
  }
}
