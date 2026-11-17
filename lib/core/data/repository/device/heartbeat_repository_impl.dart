import 'dart:async';

import 'package:clock/clock.dart';
import 'package:collection/collection.dart';
import 'package:widyu/core/data/repository/device/heartbeat_repository.dart';
import 'package:widyu/core/data/source/device/device_local_data_source.dart';
import 'package:widyu/core/data/source/device/device_status_local_data_source.dart';
import 'package:widyu/core/data/source/device/heartbeat_remote_data_source.dart';
import 'package:widyu/core/data/source/sensor/sensor_batch_local_data_source.dart';
import 'package:widyu/core/log/log.dart';
import 'package:widyu/core/model/sensor/sensor_batch.dart';
import 'package:widyu/core/model/sensor/sensor_config.dart';
import 'package:widyu/core/model/sensor/sensor_message.dart';
import 'package:widyu/core/utils/random_uuid.dart';

class HeartbeatRepositoryImpl implements HeartbeatRepository {
  HeartbeatRepositoryImpl({
    required Stream<SensorConfig> configs,
    required SensorBatchLocalDataSource sensorBatchLocalDataSource,
    required DeviceLocalDataSource deviceLocalDataSource,
    required DeviceStatusLocalDataSource deviceStatusLocalDataSource,
    required HeartbeatRemoteDataSource remoteDataSource,
    required bool Function() socketConnected,
    required int Function() queueDepth,
    Duration interval = const Duration(minutes: 5),
  })  : _configs = configs,
        _sensorBatchLocalDataSource = sensorBatchLocalDataSource,
        _deviceLocalDataSource = deviceLocalDataSource,
        _deviceStatusLocalDataSource = deviceStatusLocalDataSource,
        _remoteDataSource = remoteDataSource,
        _socketConnected = socketConnected,
        _queueDepth = queueDepth,
        _interval = interval;

  static const _researchMode = 'research';

  final Stream<SensorConfig> _configs;
  final SensorBatchLocalDataSource _sensorBatchLocalDataSource;
  final DeviceLocalDataSource _deviceLocalDataSource;
  final DeviceStatusLocalDataSource _deviceStatusLocalDataSource;
  final HeartbeatRemoteDataSource _remoteDataSource;
  final bool Function() _socketConnected;
  final int Function() _queueDepth;
  final Duration _interval;

  StreamSubscription<SensorConfig>? _configSubscription;
  StreamSubscription<SensorMessage>? _batches;
  Timer? _timer;
  bool _isResearch = false;
  String _sessionId = '';

  /// 워치 값은 워치가 따로 보내지 않으므로 받은 배치에서 채운다. 재전달된 옛 배치가 덮지 않도록 시각이 앞선 것만 반영한다.
  String? _watchDeviceId;
  int? _watchBatteryPct;
  bool? _watchOnBody;
  int? _watchSeenAtMs;
  int? _lastImuTsMs;
  int? _lastHrTsMs;

  @override
  void start() {
    if (_configSubscription != null) return;
    _sessionId = randomUuid();
    _batches = _sensorBatchLocalDataSource.getSensorBatches().listen(_onMessage);
    _configSubscription = _configs.listen((config) {
      final isResearch = _isResearch = config.collectionMode == _researchMode;
      if (isResearch && _timer == null) {
        unawaited(_beat());
        _timer = Timer.periodic(_interval, (_) => unawaited(_beat()));
      } else if (!isResearch) {
        _timer?.cancel();
        _timer = null;
      }
    });
  }

  void _onMessage(SensorMessage message) {
    switch (message) {
      case SensorMessageBatch(:final batch):
        final tsMs = imuLastSampleMs(batch);
        if (tsMs == null) return;
        _lastImuTsMs = _max(_lastImuTsMs, tsMs);
        _seeWatch(batch.deviceId, batch.watchBatteryPct, batch.onBody, tsMs);
      case SensorMessageHeartRate(:final batch):
        final tsMs = batch.samples.lastOrNull?.tsMs;
        if (tsMs == null) return;
        _lastHrTsMs = _max(_lastHrTsMs, tsMs);
        _seeWatch(batch.deviceId, batch.watchBatteryPct, batch.onBody, tsMs);
      case SensorMessageDropped() || SensorMessageDeviceEvent():
        break;
    }
  }

  void _seeWatch(String deviceId, int? batteryPct, bool? onBody, int tsMs) {
    final seenAt = _watchSeenAtMs;
    if (seenAt != null && tsMs < seenAt) return;
    _watchSeenAtMs = tsMs;
    _watchDeviceId = deviceId;
    _watchBatteryPct = batteryPct ?? _watchBatteryPct;
    _watchOnBody = onBody ?? _watchOnBody;
  }

  /// 상태 조회 중 하나라도 실패하면 이번 회차는 건너뛴다. 다음 주기에 다시 보낸다.
  Future<void> _beat() async {
    try {
      final heartbeat = await _buildHeartbeat();
      // 조회를 기다리는 사이 출시 모드로 바뀌었거나 서비스가 멈췄으면 보내지 않는다.
      if (heartbeat == null || !_isResearch || _configSubscription == null) {
        return;
      }
      await _remoteDataSource.send(heartbeat);
    } catch (error, stack) {
      WiduLog.data.w('하트비트 생성 실패', error: error, stackTrace: stack);
    }
  }

  Future<Map<String, dynamic>?> _buildHeartbeat() async {
    final phone = await _deviceStatusLocalDataSource.phoneStatus();
    // battery_pct 는 서버 필수다.
    if (phone['battery_pct'] == null) {
      WiduLog.data.w('폰 배터리를 읽지 못해 하트비트 생략');
      return null;
    }
    final watchConnected = await _deviceStatusLocalDataSource.watchConnected();
    return {
      'v': 1,
      'ts_ms': clock.now().millisecondsSinceEpoch,
      'device_id': await _deviceLocalDataSource.getDeviceId(),
      'session_id': _sessionId,
      'phone': {
        ...phone,
        'app_ver': await _deviceStatusLocalDataSource.appVersion(),
        'socket_connected': _socketConnected(),
        'location_permission':
            await _deviceStatusLocalDataSource.locationPermission(),
        'queue_depth': _queueDepth(),
      },
      // 연결되지 않았으면 connected 만 보낸다(서버 규약).
      'watch': watchConnected
          ? ({
              'connected': true,
              'device_id': _watchDeviceId,
              'battery_pct': _watchBatteryPct,
              'on_body': _watchOnBody,
              'last_hr_ts_ms': _lastHrTsMs,
              'last_imu_ts_ms': _lastImuTsMs,
            }..removeWhere((_, value) => value == null))
          : {'connected': false},
    };
  }

  static int _max(int? current, int next) =>
      current == null || next > current ? next : current;

  @override
  void stop() {
    _isResearch = false;
    _configSubscription?.cancel();
    _configSubscription = null;
    _batches?.cancel();
    _batches = null;
    _timer?.cancel();
    _timer = null;
  }
}

/// 배치 마지막 샘플의 워치 벽시계 시각. 시계 기준점으로 단조 시각을 환산한다.
int? imuLastSampleMs(SensorBatch batch) {
  final (t0, dtNs) = switch (batch) {
    SensorBatch(:final acc?) => (acc.t0ElapsedNs, acc.dtNs),
    SensorBatch(:final gyro?) => (gyro.t0ElapsedNs, gyro.dtNs),
    _ => (null, const <int>[]),
  };
  final t0Ns = t0 == null ? null : int.tryParse(t0);
  final anchorElapsedNs = int.tryParse(batch.clock.anchorElapsedNs);
  if (t0Ns == null || anchorElapsedNs == null) return null;
  return batch.clock.anchorEpochMs +
      (t0Ns + dtNs.sum - anchorElapsedNs) ~/ 1000000;
}
