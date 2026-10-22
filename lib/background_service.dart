import 'dart:async';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:widyu/core/data/repository/auth/auth_repository_impl.dart';
import 'package:widyu/core/data/repository/heartRate/heart_rate_repository.dart';
import 'package:widyu/core/data/repository/heartRate/heart_rate_repository_impl.dart';
import 'package:widyu/core/data/repository/location/location_repository.dart';
import 'package:widyu/core/data/repository/location/location_repository_impl.dart';
import 'package:widyu/core/data/repository/sensor/sensor_batch_repository.dart';
import 'package:widyu/core/data/repository/sensor/sensor_batch_repository_impl.dart';
import 'package:widyu/core/data/repository/sensor/sensor_config_repository.dart';
import 'package:widyu/core/data/repository/sensor/sensor_config_repository_impl.dart';
import 'package:widyu/core/data/source/auth/auth_local_data_source_impl.dart';
import 'package:widyu/core/data/source/auth/auth_remote_data_source_impl.dart';
import 'package:widyu/core/data/source/device/device_local_data_source_impl.dart';
import 'package:widyu/core/data/source/heartRate/heart_rate_local_data_source_impl.dart';
import 'package:widyu/core/data/source/heartRate/heart_rate_remote_data_source_impl.dart';
import 'package:widyu/core/data/source/location/location_local_data_source_impl.dart';
import 'package:widyu/core/data/source/location/location_remote_data_source_impl.dart';
import 'package:widyu/core/data/source/sensor/sensor_batch_local_data_source_impl.dart';
import 'package:widyu/core/data/source/sensor/sensor_batch_remote_data_source_impl.dart';
import 'package:widyu/core/data/source/sensor/sensor_config_local_data_source_impl.dart';
import 'package:widyu/core/data/source/sensor/sensor_config_remote_data_source_impl.dart';
import 'package:widyu/core/model/api/api_result.dart';
import 'package:widyu/core/model/location/location_service_state.dart';
import 'package:widyu/core/model/permission/permission_type.dart';
import 'package:widyu/core/network/api_client.dart';
import 'package:widyu/core/network/socket_client.dart';
import 'package:widyu/core/log/log.dart';
import 'package:widyu/core/network/token_manager.dart';
import 'package:widyu/core/utils/location_service_manager.dart';
import 'package:widyu/core/utils/permission_manager.dart';

Future<void> initializeService({bool autoStartOnBoot = false}) async {
  final service = FlutterBackgroundService();
  // Android 14+는 위치 권한 없이 location 타입으로 startForeground 하면 SecurityException 이 나고,
  // 플러그인이 이를 삼켜 서비스가 foreground 가 되지 못한 채 종료된다.
  final foregroundServiceTypes = [
    if (await PermissionManager.isGranted(PermissionType.location))
      AndroidForegroundType.location,
    AndroidForegroundType.connectedDevice,
  ];

  await service.configure(
    iosConfiguration: IosConfiguration(
      autoStart: false,
      onForeground: onStart,
      onBackground: onIosBackground,
    ),
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      autoStart: false,
      autoStartOnBoot: autoStartOnBoot,
      isForegroundMode: true,
      initialNotificationTitle: '알림',
      initialNotificationContent: '위듀에서 사용자의 위치와 심박수를 전송하고 있습니다.',
      foregroundServiceTypes: foregroundServiceTypes,
    ),
  );
}

@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  return true;
}

({
  SocketClient socketClient,
  HeartRateRepository heartRateRepository,
  LocationRepository locationRepository,
  SensorBatchRepository sensorBatchRepository,
  SensorConfigRepository sensorConfigRepository,
}) createDependencies() {
  final apiClient = ApiClient();
  final socketClient = SocketClient();

  return (
    socketClient: socketClient,
    heartRateRepository: HeartRateRepositoryImpl(
      localDataSource: HeartRateLocalDataSourceImpl(),
      remoteDataSource: HeartRateRemoteDataSourceImpl(apiClient: apiClient),
    ),
    locationRepository: LocationRepositoryImpl(
      localDataSource: LocationLocalDataSourceImpl(),
      remoteDataSource:
          LocationRemoteDataSourceImpl(socketClient: socketClient),
      authLocalDataSource: AuthLocalDataSourceImpl(),
      deviceLocalDataSource: DeviceLocalDataSourceImpl(),
    ),
    sensorBatchRepository: SensorBatchRepositoryImpl(
      localDataSource: SensorBatchLocalDataSourceImpl(),
      remoteDataSource: SensorBatchRemoteDataSourceImpl(
        socketClient: socketClient,
        apiClient: apiClient,
      ),
    ),
    sensorConfigRepository: SensorConfigRepositoryImpl(
      remoteDataSource: SensorConfigRemoteDataSourceImpl(apiClient: apiClient),
      localDataSource: SensorConfigLocalDataSourceImpl(),
    ),
  );
}

Future<void> connectSocket(SocketClient socketClient) async {
  final authRepository = AuthRepositoryImpl(
    remoteDatasource: AuthRemoteDataSourceImpl(apiClient: ApiClient()),
    localDataSource: AuthLocalDataSourceImpl(),
  );

  // WS 토큰은 30초·일회용이라 재연결마다 새로 받아야 한다. 소켓이 발급을 직접 호출한다.
  try {
    await socketClient.connect(tokenProvider: () async {
      try {
        final result = await authRepository.fetchSocketToken();
        return result is Success<String> ? result.data : null;
      } catch (e, stack) {
        debugPrint('[background_service] 소켓 토큰 발급 실패: $e\n$stack');
        return null;
      }
    });
  } catch (e, stack) {
    debugPrint('[background_service] 소켓 연결 실패: $e\n$stack');
  }
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) {
  // 서비스는 별도 isolate라 main의 zone이 적용되지 않으므로 여기서 다시 감싼다.
  runZonedGuarded(
    () => _onStart(service),
    (error, stack) {
      // onError는 바깥 zone에서 실행되어 print 차단이 적용되지 않으므로 직접 막는다.
      if (!kReleaseMode) {
        debugPrint('[background_service] 처리되지 않은 예외: $error\n$stack');
      }
    },
    zoneSpecification: quietPrintInRelease,
  );
}

Future<void> _onStart(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();
  await dotenv.load(fileName: ".env");

  if (!await TokenManager().hasToken()) {
    try {
      if (service is AndroidServiceInstance) {
        await service.setAutoStartOnBootMode(false);
      }
    } catch (error, stack) {
      debugPrint('[background_service] 초기 자동 시작 해제 실패: $error\n$stack');
    }
    try {
      await service.stopSelf();
    } catch (error, stack) {
      debugPrint('[background_service] 초기 종료 실패: $error\n$stack');
    }
    return;
  }

  final (
    socketClient: socketClient,
    heartRateRepository: heartRateRepository,
    locationRepository: locationRepository,
    sensorBatchRepository: sensorBatchRepository,
    sensorConfigRepository: sensorConfigRepository,
  ) = createDependencies();

  unawaited(connectSocket(socketClient));

  StreamSubscription<LocationServiceState>? locationServiceState;
  var isShuttingDown = false;
  Future<void> shutdown() async {
    if (isShuttingDown) return;
    isShuttingDown = true;
    try {
      if (service is AndroidServiceInstance) {
        await service.setAutoStartOnBootMode(false);
      }
    } catch (error, stack) {
      debugPrint('[background_service] 자동 시작 해제 실패: $error\n$stack');
    }
    try {
      await locationServiceState?.cancel();
      LocationServiceManager.stopMonitoring();
      heartRateRepository.stopObserveHeartRate();
      sensorBatchRepository.stopObserveSensorBatches();
      sensorConfigRepository.stop();
      locationRepository.stopLocationUpload();
      socketClient.disconnect();
      await service.stopSelf();
    } catch (error, stack) {
      debugPrint('[background_service] 종료 실패: $error\n$stack');
    }
  }

  LocationServiceManager.startMonitoring();
  locationServiceState =
      LocationServiceManager.locationServiceState.listen((state) {
    // 위치를 못 쓰더라도 심박수 전송은 계속해야 하므로 업로드만 끈다.
    if (state.isAvailable) {
      locationRepository.startLocationUpload();
    } else {
      locationRepository.stopLocationUpload();
    }
  });

  heartRateRepository.observeHeartRate();
  sensorBatchRepository.observeSensorBatches();
  sensorConfigRepository.start();

  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });
    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });
  }

  service.on('stopService').listen((event) async {
    await shutdown();
  });
}

Future<void> setAutoStartOnBoot(bool value) =>
    initializeService(autoStartOnBoot: value);

Future<void> _backgroundServiceQueue = Future.value();
bool _stopTimedOut = false;

Future<void> _enqueueBackgroundService(Future<void> Function() operation) {
  final next = _backgroundServiceQueue.then(
    (_) => operation(),
    onError: (_) => operation(),
  );
  _backgroundServiceQueue = next.catchError((error, stack) {
    debugPrint('[background_service] 서비스 제어 실패: $error\n$stack');
  });
  return next;
}

Future<void> startBackgroundService() =>
    _enqueueBackgroundService(_startBackgroundService);

Future<void> _startBackgroundService() async {
  if (!await TokenManager().hasToken()) return;

  final service = FlutterBackgroundService();
  if (await service.isRunning()) {
    if (_stopTimedOut) {
      throw StateError('이전 백그라운드 서비스 종료를 아직 확인하지 못했습니다.');
    }
    return;
  }
  _stopTimedOut = false;
  if (!await service.startService()) {
    throw StateError('백그라운드 서비스를 시작하지 못했습니다.');
  }
}

Future<void> stopBackgroundService() =>
    _enqueueBackgroundService(_stopBackgroundService);

Future<void> _stopBackgroundService() async {
  final service = FlutterBackgroundService();
  if (!await service.isRunning()) {
    _stopTimedOut = false;
    return;
  }
  service.invoke('stopService');
  // stopService는 isolate에 이벤트만 전달한다. 빠른 off→on에서 이전 종료가
  // 다음 시작을 가로막지 않도록 짧게 종료를 확인하되 무한히 기다리지는 않는다.
  for (var attempt = 0; attempt < 10; attempt++) {
    await Future<void>.delayed(const Duration(milliseconds: 100));
    if (!await service.isRunning()) {
      _stopTimedOut = false;
      return;
    }
  }
  _stopTimedOut = true;
  throw StateError('백그라운드 서비스 종료를 제한 시간 안에 확인하지 못했습니다.');
}
