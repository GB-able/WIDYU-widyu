import 'dart:async';

import 'package:widyu/core/data/repository/sensor/sensor_config_repository.dart';
import 'package:widyu/core/data/source/sensor/sensor_config_local_data_source.dart';
import 'package:widyu/core/data/source/sensor/sensor_config_remote_data_source.dart';
import 'package:widyu/core/model/sensor/sensor_config.dart';

class SensorConfigRepositoryImpl implements SensorConfigRepository {
  SensorConfigRepositoryImpl({
    required SensorConfigRemoteDataSource remoteDataSource,
    required SensorConfigLocalDataSource localDataSource,
  })  : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource;

  final SensorConfigRemoteDataSource _remoteDataSource;
  final SensorConfigLocalDataSource _localDataSource;

  /// 조회 실패 시 다음 재조회까지의 간격.
  static const _fallbackRefresh = SensorConfig();

  Timer? _timer;
  bool _active = false;

  @override
  void start() {
    if (_active) return;
    _active = true;
    unawaited(_refresh());
  }

  Future<void> _refresh() async {
    final config = await _remoteDataSource.fetch();
    if (!_active) return;
    // 조회가 실패하면 워치 설정은 그대로 두고 다음 주기에 다시 시도한다.
    if (config != null) await _localDataSource.sendToWatch(config);
    if (!_active) return;
    _timer?.cancel();
    _timer = Timer(
      Duration(seconds: (config ?? _fallbackRefresh).refreshSec),
      () => unawaited(_refresh()),
    );
  }

  @override
  void stop() {
    _active = false;
    _timer?.cancel();
    _timer = null;
  }
}
