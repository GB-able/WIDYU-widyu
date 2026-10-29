import 'dart:io';
import 'dart:ui';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:widyu/core/data/repository/goal/walk_repository_impl.dart';
import 'package:widyu/core/data/source/goal/walk_local_data_source_impl.dart';
import 'package:widyu/core/data/source/goal/walk_remote_data_source_impl.dart';
import 'package:widyu/core/log/log.dart';
import 'package:widyu/core/network/api_client.dart';
import 'package:widyu/core/network/token_manager.dart';
import 'package:workmanager/workmanager.dart';

const _walkBackgroundTaskName = 'widyu.steps.sync';
const _channel = MethodChannel('com.widucorp.widu/step_background');
const _uniqueTaskName = 'widyu.steps.periodic';
Future<void>? _initialization;

@pragma('vm:entry-point')
void onWalkStart() {
  Workmanager().executeTask((task, inputData) async {
    if (task != _walkBackgroundTaskName) return true;
    try {
      await syncWalkBackground();
      return true;
    } catch (error, stack) {
      WiduLog.bg.w('걸음수 백그라운드 동기화 실패', error: error, stackTrace: stack);
      return false;
    }
  });
}

@pragma('vm:entry-point')
Future<void> onIosWalkBackground() async {
  WidgetsFlutterBinding.ensureInitialized();
  const channel = MethodChannel('com.widucorp.widu/step_background_worker');
  var succeeded = false;
  try {
    await channel.invokeMethod<void>('ready');
    await syncWalkBackground();
    succeeded = true;
  } catch (error, stack) {
    WiduLog.bg.w('HealthKit 백그라운드 동기화 실패', error: error, stackTrace: stack);
  } finally {
    await channel.invokeMethod<void>('complete', succeeded);
  }
}

Future<void> syncWalkBackground() async {
  try {
    final tokenManager = TokenManager();
    final memberId = await tokenManager.memberId;
    if (!await tokenManager.hasToken() || memberId == null) {
      await stopWalkBackgroundService();
      return;
    }
    await dotenv.load();
    final repository = WalkRepositoryImpl(
      localDataSource: WalkLocalDataSourceImpl(),
      remoteDataSource: WalkRemoteDataSourceImpl(apiClient: ApiClient()),
    );
    final result = await repository.sync(memberId: memberId, background: true);
    if (result.unauthorized) {
      WiduLog.bg.w('인증 만료로 걸음수 백그라운드 동기화 중단');
      await stopWalkBackgroundService();
      return;
    }
    WiduLog.bg.i('걸음수 백그라운드 동기화 완료 uploaded=${result.uploaded}');
  } catch (error, stack) {
    WiduLog.bg.w('걸음수 백그라운드 동기화 보류', error: error, stackTrace: stack);
  }
}

Future<void> initializeWalkService() {
  return _initialization ??=
      _initializeWalkService().catchError((Object error) {
    _initialization = null;
    throw error;
  });
}

Future<void> _initializeWalkService() async {
  if (Platform.isAndroid) {
    await Workmanager().initialize(onWalkStart);
  } else if (Platform.isIOS) {
    _channel.setMethodCallHandler((call) async {
      if (call.method != 'sync') throw MissingPluginException();
      await syncWalkBackground();
    });
    final callback = PluginUtilities.getCallbackHandle(
      onIosWalkBackground,
    );
    if (callback == null) {
      throw StateError('걸음수 백그라운드 진입점을 등록할 수 없습니다.');
    }
    await _channel.invokeMethod<void>('initialize', callback.toRawHandle());
  }
}

Future<void> startWalkBackgroundService() async {
  await initializeWalkService();
  if (Platform.isAndroid) {
    await Workmanager().registerPeriodicTask(
      _uniqueTaskName,
      _walkBackgroundTaskName,
      frequency: const Duration(minutes: 15),
      existingWorkPolicy: ExistingPeriodicWorkPolicy.keep,
      constraints: Constraints(networkType: NetworkType.connected),
      backoffPolicy: BackoffPolicy.exponential,
      backoffPolicyDelay: const Duration(minutes: 5),
    );
  } else if (Platform.isIOS) {
    await _channel.invokeMethod<void>('enable');
  }
}

Future<void> stopWalkBackgroundService() async {
  if (Platform.isAndroid) {
    await Workmanager().cancelByUniqueName(_uniqueTaskName);
  } else if (Platform.isIOS) {
    await _channel.invokeMethod<void>('disable');
  }
}
