import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:widyu/core/data/repository/heartRate/heart_rate_repository_impl.dart';
import 'package:widyu/core/data/repository/location/location_repository_impl.dart';
import 'package:widyu/core/data/source/heartRate/heart_rate_local_data_source_impl.dart';
import 'package:widyu/core/data/source/heartRate/heart_rate_remote_data_source_impl.dart';
import 'package:widyu/core/data/source/location/location_local_data_source_impl.dart';
import 'package:widyu/core/data/source/location/location_remote_data_source_impl.dart';
import 'package:widyu/core/network/api_client.dart';
import 'package:widyu/core/network/socket_client.dart';
import 'package:widyu/core/utils/location_service_manager.dart';

import 'core/network/token_manager.dart';

Future<void> initializeService() async {
  final service = FlutterBackgroundService();
  await service.configure(
    iosConfiguration: IosConfiguration(
      autoStart: false,
      onForeground: onStart,
      onBackground: onIosBackground,
    ),
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      autoStart: false,
      autoStartOnBoot: true,
      isForegroundMode: true,
      initialNotificationTitle: '알림',
      initialNotificationContent: '위듀에서 사용자의 위치를 추적중입니다.',
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

  late final StreamSubscription locationServiceState;
  LocationServiceManager.startMonitoring();

  final tokenManager = TokenManager();
  final socketClient = await SocketClient.create(tokenManager: tokenManager);
  final apiClient = ApiClient();

  final heartRateRepository = HeartRateRepositoryImpl(
      localDataSource: HeartRateLocalDataSourceImpl(),
      remoteDataSource: HeartRateRemoteDataSourceImpl(
        socketClient: socketClient,
        apiClient: apiClient,
      ));
  heartRateRepository.observeHeartRate();

  final locationRepository = LocationRepositoryImpl(
    localDataSource: LocationLocalDataSourceImpl(),
    remoteDataSource: LocationRemoteDataSourceImpl(socketClient: socketClient),
  );

  locationServiceState =
      LocationServiceManager.locationServiceState.listen((state) {
    if (state.isAvailable) {
      locationRepository.startLocationUpload();
    } else {
      locationRepository.stopLocationUpload();
    }
  });

  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });
    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });
  }

  service.on('stopService').listen((event) async {
    await locationServiceState.cancel();
    LocationServiceManager.stopMonitoring();
    heartRateRepository.stopObserveHeartRate();
    locationRepository.stopLocationUpload();
    socketClient.disconnect();
    service.stopSelf();
  });
}

Future<void> startBackgroundService() async {
  final service = FlutterBackgroundService();
  if (await service.isRunning()) return;
  await service.startService();
}

Future<void> stopBackgroundService() async {
  final service = FlutterBackgroundService();
  if (!await service.isRunning()) return;
  service.invoke('stopService');
}
