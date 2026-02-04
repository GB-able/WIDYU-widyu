import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:widyu/core/data/datasources/location/location_local_data_source_impl.dart';
import 'package:widyu/core/data/datasources/location/location_remote_data_source_impl.dart';
import 'package:widyu/core/data/repositories/location_repository_impl.dart';

Future<void> initializeService() async {
  final service = FlutterBackgroundService();
  await service.configure(
    iosConfiguration: IosConfiguration(
      autoStart: false,
      onForeground: onStart,
      onBackground: onIosBackground,
    ),
    androidConfiguration: AndroidConfiguration(
      autoStart: false,
      autoStartOnBoot: true,
      isForegroundMode: true,
      onStart: onStart,
    ),
  );
}

@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  return true;
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  final locationRepository = LocationRepositoryImpl(
    localDataSource: LocationLocalDataSourceImpl(),
    remoteDataSource: LocationRemoteDataSourceImpl(),
  );

  locationRepository.startLocationUpload();

  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });
    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });
  }
  service.on('stopService').listen((event) {
    locationRepository.stopLocationUpload();
    service.stopSelf();
  });
}
