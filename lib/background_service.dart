import 'dart:async';
import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:widyu/core/data/repository/auth/auth_repository_impl.dart';
import 'package:widyu/core/data/repository/heartRate/heart_rate_repository.dart';
import 'package:widyu/core/data/repository/heartRate/heart_rate_repository_impl.dart';
import 'package:widyu/core/data/repository/location/location_repository.dart';
import 'package:widyu/core/data/repository/location/location_repository_impl.dart';
import 'package:widyu/core/data/source/auth/auth_local_data_source_impl.dart';
import 'package:widyu/core/data/source/auth/auth_remote_data_source_impl.dart';
import 'package:widyu/core/data/source/heartRate/heart_rate_local_data_source_impl.dart';
import 'package:widyu/core/data/source/heartRate/heart_rate_remote_data_source_impl.dart';
import 'package:widyu/core/data/source/location/location_local_data_source_impl.dart';
import 'package:widyu/core/data/source/location/location_remote_data_source_impl.dart';
import 'package:widyu/core/model/api/api_result.dart';
import 'package:widyu/core/network/api_client.dart';
import 'package:widyu/core/network/socket_client.dart';
import 'package:widyu/core/utils/location_service_manager.dart';

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

Future<
    ({
      SocketClient socketClient,
      HeartRateRepository heartRateRepository,
      LocationRepository locationRepository,
    })> createDependencies() async {
  final apiClient = ApiClient();
  final socketClient = SocketClient();
  final authRepository = AuthRepositoryImpl(
    remoteDatasource: AuthRemoteDataSourceImpl(apiClient: apiClient),
    localDataSource: AuthLocalDataSourceImpl(),
  );

  final result = await authRepository.fetchSocketToken();
  if (result is Success) {
    final socketToken = (result as Success<String>).data;
    await socketClient.connect(socketToken);
  }

  return (
    socketClient: socketClient,
    heartRateRepository: HeartRateRepositoryImpl(
      localDataSource: HeartRateLocalDataSourceImpl(),
      remoteDataSource: HeartRateRemoteDataSourceImpl(
        socketClient: socketClient,
        apiClient: apiClient,
      ),
    ),
    locationRepository: LocationRepositoryImpl(
      localDataSource: LocationLocalDataSourceImpl(),
      remoteDataSource:
          LocationRemoteDataSourceImpl(socketClient: socketClient),
    )
  );
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();
  await dotenv.load(fileName: ".env");

  late final StreamSubscription locationServiceState;
  LocationServiceManager.startMonitoring();

  final (
    socketClient: socketClient,
    heartRateRepository: heartRateRepository,
    locationRepository: locationRepository,
  ) = await createDependencies();

  heartRateRepository.observeHeartRate();

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
