import 'dart:async';
import 'dart:collection';
import 'dart:developer';

import 'package:widyu/core/data/repository/location/location_repository.dart';
import 'package:widyu/core/data/source/auth/auth_local_data_source.dart';
import 'package:widyu/core/data/source/device/device_local_data_source.dart';
import 'package:widyu/core/data/source/location/location_local_data_source.dart';
import 'package:widyu/core/data/source/location/location_remote_data_source.dart';
import 'package:widyu/core/model/location/location_config.dart';
import 'package:widyu/core/model/location/location_update_request.dart';
import 'package:widyu/core/model/location/user_location.dart';
import 'package:widyu/core/utils/random_uuid.dart';

class LocationRepositoryImpl implements LocationRepository {
  LocationRepositoryImpl({
    required LocationLocalDataSource localDataSource,
    required LocationRemoteDataSource remoteDataSource,
    required AuthLocalDataSource authLocalDataSource,
    required DeviceLocalDataSource deviceLocalDataSource,
    Duration keepaliveInterval = LocationConfig.keepaliveInterval,
    int queueMax = LocationConfig.queueMax,
  })  : _localDataSource = localDataSource,
        _remoteDataSource = remoteDataSource,
        _authLocalDataSource = authLocalDataSource,
        _deviceLocalDataSource = deviceLocalDataSource,
        _keepaliveInterval = keepaliveInterval,
        _queueMax = queueMax {
    assert(queueMax > 0, 'queueMax must be positive');
    assert(keepaliveInterval > Duration.zero,
        'keepaliveInterval must be positive');
  }

  final LocationLocalDataSource _localDataSource;
  final LocationRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _authLocalDataSource;
  final DeviceLocalDataSource _deviceLocalDataSource;
  final Duration _keepaliveInterval;
  final int _queueMax;

  /// 소켓이 끊겨 보내지 못한 요청. seq 는 그대로 두고 재전송한다(스펙 §3-1).
  final ListQueue<LocationUpdateRequest> _queue = ListQueue();

  StreamSubscription<UserLocation>? _locationSubscription;
  StreamSubscription<bool>? _connection;
  Timer? _keepaliveTimer;
  String? _deviceId;
  int? _memberId;
  String _sessionId = '';
  int _seq = 0;
  bool _active = false;

  @override
  Future<void> startLocationUpload() async {
    stopLocationUpload();

    _sessionId = randomUuid();
    _seq = 0;
    _memberId = null;
    _active = true;

    _deviceId ??= await _deviceLocalDataSource.getDeviceId();
    // await 사이에 중단됐다면 구독을 새로 열지 않는다.
    if (!_active) return;

    _locationSubscription = _localDataSource.getLocation().listen(
          (location) => _send(location, LocationReason.move),
          onError: (Object error, StackTrace stackTrace) =>
              log('Error in location stream: $error', stackTrace: stackTrace),
        );
    _connection = _remoteDataSource.connectionState.listen((connected) {
      if (connected) _resendQueued();
    });
    _restartKeepalive();
  }

  /// 정지 중에도 60초마다 한 번은 위치가 올라가도록 마지막 전송 기준으로 다시 잰다.
  void _restartKeepalive() {
    _keepaliveTimer?.cancel();
    if (!_active) return;
    _keepaliveTimer = Timer(_keepaliveInterval, _onKeepalive);
  }

  Future<void> _onKeepalive() async {
    if (!_active) return;
    final location = await _localDataSource.getCurrentLocation();
    if (!_active) return;
    if (location == null) {
      _restartKeepalive();
      return;
    }
    await _send(location, LocationReason.keepalive);
  }

  /// 정확도가 낮은 위치도 걸러내지 않고 그대로 보낸다(스펙 §3-3).
  Future<void> _send(UserLocation location, String reason) async {
    if (!_active) return;
    _restartKeepalive();

    final deviceId = _deviceId;
    _memberId ??= await _authLocalDataSource.getMemberId();
    final memberId = _memberId;
    if (deviceId == null || memberId == null) {
      log('Location upload skipped: memberId or deviceId is missing');
      return;
    }
    if (!_active) return;

    final request = LocationUpdateRequest(
      memberId: memberId,
      deviceId: deviceId,
      sessionId: _sessionId,
      seq: ++_seq,
      tsMs: location.measuredAt ?? DateTime.now().millisecondsSinceEpoch,
      reason: reason,
      lat: location.latitude,
      lon: location.longitude,
      isMock: location.isMock,
      accuracyM: location.accuracyM,
      speedMps: location.speedMps,
      speedAccuracyMps: location.speedAccuracyMps,
      headingDeg: location.headingDeg,
      altitudeM: location.altitudeM,
    );

    if (!_remoteDataSource.sendLocation(request)) _enqueue(request);
  }

  void _enqueue(LocationUpdateRequest request) {
    if (_queue.length == _queueMax) {
      final dropped = _queue.removeFirst();
      log('Location resend queue full; dropped oldest seq=${dropped.seq}');
    }
    _queue.addLast(request);
  }

  /// 순서대로 다시 보내고 성공한 것만 큐에서 뺀다. 한 건이라도 실패하면 멈춘다.
  void _resendQueued() {
    while (_active && _queue.isNotEmpty) {
      if (!_remoteDataSource.sendLocation(_queue.first)) return;
      _queue.removeFirst();
    }
  }

  @override
  Future<UserLocation?> getCurrentLocation() =>
      _localDataSource.getCurrentLocation();

  @override
  void stopLocationUpload() {
    _active = false;
    _keepaliveTimer?.cancel();
    _keepaliveTimer = null;
    _locationSubscription?.cancel();
    _locationSubscription = null;
    _connection?.cancel();
    _connection = null;
  }
}
