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
import 'package:widyu/core/model/location/location_service_state.dart';
import 'package:widyu/core/network/api_client.dart';
import 'package:widyu/core/network/socket_client.dart';
import 'package:widyu/core/network/token_manager.dart';
import 'package:widyu/core/utils/location_service_manager.dart';

Future<void> initializeService({bool autoStartOnBoot = false}) async {
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
      autoStartOnBoot: autoStartOnBoot,
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

({
  SocketClient socketClient,
  HeartRateRepository heartRateRepository,
  LocationRepository locationRepository,
}) createDependencies() {
  final apiClient = ApiClient();
  final socketClient = SocketClient();

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

Future<void> connectSocket(SocketClient socketClient) async {
  final authRepository = AuthRepositoryImpl(
    remoteDatasource: AuthRemoteDataSourceImpl(apiClient: ApiClient()),
    localDataSource: AuthLocalDataSourceImpl(),
  );

  try {
    final result = await authRepository.fetchSocketToken();
    if (result is Success) {
      final socketToken = (result as Success<String>).data;
      socketClient.connect(socketToken);
    }
  } catch (e, stack) {
    debugPrint('[background_service] 소켓 연결 실패: $e\n$stack');
  }
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();
  await dotenv.load(fileName: ".env");

  final locationState = await LocationServiceManager.refresh();
  if (!await TokenManager().hasToken() || !locationState.isAvailable) {
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
    if (state.isAvailable) {
      locationRepository.startLocationUpload();
    } else {
      unawaited(shutdown());
    }
  });

  heartRateRepository.observeHeartRate();

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
  if (!(await LocationServiceManager.refresh()).isAvailable) return;

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
