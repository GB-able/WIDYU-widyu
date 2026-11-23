import 'dart:async';

import 'package:clock/clock.dart';
import 'package:widyu/core/data/repository/device/device_event_repository.dart';
import 'package:widyu/core/data/source/device/device_event_remote_data_source.dart';
import 'package:widyu/core/data/source/device/device_local_data_source.dart';
import 'package:widyu/core/data/source/device/device_status_local_data_source.dart';
import 'package:widyu/core/data/source/sensor/sensor_batch_local_data_source.dart';
import 'package:widyu/core/log/log.dart';
import 'package:widyu/core/model/location/location_service_state.dart';
import 'package:widyu/core/model/sensor/sensor_config.dart';
import 'package:widyu/core/model/sensor/sensor_message.dart';
import 'package:widyu/core/util/random_uuid.dart';

class DeviceEventRepositoryImpl implements DeviceEventRepository {
  DeviceEventRepositoryImpl({
    required SensorBatchLocalDataSource localDataSource,
    required DeviceEventRemoteDataSource remoteDataSource,
    required Stream<SensorConfig> configs,
    required DeviceLocalDataSource deviceLocalDataSource,
    required DeviceStatusLocalDataSource deviceStatusLocalDataSource,
    required Stream<LocationServiceState> Function() locationStates,
    Duration flushInterval = const Duration(minutes: 1),
  })  : _localDataSource = localDataSource,
        _remoteDataSource = remoteDataSource,
        _configs = configs,
        _deviceLocalDataSource = deviceLocalDataSource,
        _deviceStatusLocalDataSource = deviceStatusLocalDataSource,
        _locationStates = locationStates,
        _flushInterval = flushInterval;

  /// 서버가 한 번에 받는 최대 개수.
  static const maxBatch = 500;
  static const _researchMode = 'research';

  final SensorBatchLocalDataSource _localDataSource;
  final DeviceEventRemoteDataSource _remoteDataSource;
  final Stream<SensorConfig> _configs;
  final DeviceLocalDataSource _deviceLocalDataSource;
  final DeviceStatusLocalDataSource _deviceStatusLocalDataSource;
  final Stream<LocationServiceState> Function() _locationStates;
  final Duration _flushInterval;

  /// event_id 기준. 재전달로 같은 이벤트가 다시 와도 한 번만 보낸다. 삽입 순서를 쓴다.
  // ponytail: 폰 이벤트는 메모리에만 둔다. 다음 전송 주기 전에 서비스가 죽으면 그 사이 폰 이벤트를 잃는다. 문제가 되면 sqflite 에 보관한다.
  final Map<String, Map<String, dynamic>> _pending = {};
  StreamSubscription<SensorMessage>? _events;
  StreamSubscription<SensorConfig>? _configSubscription;
  StreamSubscription<String>? _network;
  StreamSubscription<LocationServiceState>? _location;
  Timer? _timer;
  bool _sending = false;

  /// 워치 이벤트는 워치가 연구 모드에서만 만든다. 여기서는 모드와 상관없이 남은 것을 모두 올린다.
  /// 폰 이벤트는 폰이 만들므로 연구 모드인 동안만 상태를 감시한다.
  @override
  void start() {
    if (_events != null) return;
    _events = _localDataSource.getSensorBatches().listen((message) {
      if (message is! SensorMessageDeviceEvent) return;
      final eventId = message.event['event_id'];
      if (eventId is! String) {
        WiduLog.data.w('event_id 없는 기기 이벤트');
        return;
      }
      _pending.putIfAbsent(eventId, () => message.event);
      if (_pending.length >= maxBatch) unawaited(_flush());
    });
    _configSubscription = _configs.listen((config) {
      if (config.collectionMode == _researchMode) {
        _watchPhone();
      } else {
        _unwatchPhone();
      }
    });
    _timer = Timer.periodic(_flushInterval, (_) => unawaited(_flush()));
  }

  /// 첫 값은 기준으로만 삼고 바뀐 것부터 남긴다.
  void _watchPhone() {
    if (_network != null) return;
    String? lastType;
    _network = _deviceStatusLocalDataSource.networkType().listen(
      (type) {
        final previous = lastType;
        lastType = type;
        if (previous != null && previous != type) {
          unawaited(_addPhoneEvent('NETWORK_CHANGED', {'type': type}));
        }
      },
      onError: (Object error, StackTrace stack) =>
          WiduLog.data.w('네트워크 상태 스트림 오류', error: error, stackTrace: stack),
    );
    bool? lastAvailable;
    _location = _locationStates().listen((state) {
      final previous = lastAvailable;
      lastAvailable = state.isAvailable;
      if (previous == null || previous == state.isAvailable) return;
      unawaited(state.isAvailable
          ? _addPhoneEvent('LOCATION_RESTARTED', {'reason': 'available'})
          : _addPhoneEvent('LOCATION_STOPPED', {
              'reason': state.serviceEnabled
                  ? 'permission_denied'
                  : 'service_disabled',
            }));
    });
  }

  void _unwatchPhone() {
    _network?.cancel();
    _network = null;
    _location?.cancel();
    _location = null;
  }

  Future<void> _addPhoneEvent(
      String kind, Map<String, dynamic> attributes) async {
    // 기기 ID 를 읽는 사이 시각이 밀리지 않게 먼저 잰다.
    final occurredAtMs = clock.now().millisecondsSinceEpoch;
    final deviceId = await _deviceLocalDataSource.getDeviceId();
    if (_events == null) return;
    final eventId = randomUuid();
    _pending[eventId] = {
      'event_id': eventId,
      'device_id': deviceId,
      'source': 'phone',
      'kind': kind,
      'occurred_at_ms': occurredAtMs,
      'attributes': attributes,
    };
    if (_pending.length >= maxBatch) unawaited(_flush());
  }

  /// 결과를 받은 항목은 결과가 무엇이든 대기열에서 뺀다. 거절은 다시 보내도 같다.
  Future<void> _flush() async {
    if (_sending || _pending.isEmpty) return;
    _sending = true;
    try {
      final batch = _pending.entries.take(maxBatch).toList();
      final results =
          await _remoteDataSource.send([for (final e in batch) e.value]);
      // 실패면 남겨 두었다가 다음 주기에 같은 묶음을 다시 보낸다. 저장된 항목은 DUPLICATE 로 온다.
      if (results == null) return;
      var rejected = 0;
      for (var i = 0; i < results.length && i < batch.length; i++) {
        final MapEntry(key: eventId, value: event) = batch[i];
        if (results[i] == 'REJECTED') rejected++;
        _pending.remove(eventId);
        // 폰 이벤트는 Data Layer 에 없으므로 지울 것도 없다.
        if (event['source'] == 'watch') _localDataSource.consumeEvent(eventId);
      }
      if (rejected > 0) WiduLog.data.w('기기 이벤트 거절 count=$rejected');
    } finally {
      _sending = false;
    }
  }

  @override
  void stop() {
    _timer?.cancel();
    _timer = null;
    _events?.cancel();
    _events = null;
    _configSubscription?.cancel();
    _configSubscription = null;
    _unwatchPhone();
    // 지우지 않은 워치 항목은 다음 구독 때 네이티브가 Data Layer 에서 다시 흘려준다.
    _pending.clear();
  }
}
