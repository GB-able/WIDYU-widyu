import 'dart:developer';

import 'package:widyu/core/data/datasources/location/location_local_data_source.dart';
import 'package:widyu/core/data/repositories/location_repository.dart';

class LocationRepositoryImpl implements LocationRepository {
  final LocationLocalDataSource _localDataSource;

  LocationRepositoryImpl(this._localDataSource);

  @override
  Future<void> uploadCurrentLocation() async {
    try {
      _localDataSource.getLocation().listen((userLocation) {
        log(userLocation.toString());
      });
    } catch (e) {
      log(e.toString());
    }
  }
}
