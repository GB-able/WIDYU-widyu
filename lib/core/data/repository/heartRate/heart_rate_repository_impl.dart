import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:widyu/core/data/repository/heartRate/heart_rate_repository.dart';
import 'package:widyu/core/data/source/heartRate/heart_rate_local_data_source.dart';
import 'package:widyu/core/data/source/heartRate/heart_rate_remote_data_source.dart';
import 'package:widyu/core/log/log.dart';
import 'package:widyu/core/model/api/api_result.dart';
import 'package:widyu/core/model/heartRate/heart_rate.dart';
import 'package:widyu/core/model/heartRate/heart_rate_response.dart';
import 'package:widyu/core/utils/extensions/api_result_extension.dart';

class HeartRateRepositoryImpl implements HeartRateRepository {
  final HeartRateLocalDataSource _localDataSource;
  final HeartRateRemoteDataSource _remoteDataSource;
  StreamSubscription<HeartRate>? _heartRates;

  static const _statusRefreshInterval = Duration(seconds: 15);

  HeartRateRepositoryImpl({
    required HeartRateLocalDataSource localDataSource,
    required HeartRateRemoteDataSource remoteDataSource,
  })  : _localDataSource = localDataSource,
        _remoteDataSource = remoteDataSource;

  /// 심박 원본은 워치가 만든 v2 배치로 센서 배치 경로가 올린다. 새 경로는 판정을 방송하지 않으므로
  /// 심박이 들어오는 동안 판정 상태를 조회해 워치 화면에 전달한다.
  @override
  void observeHeartRate() {
    _heartRates?.cancel();
    _heartRates = _localDataSource
        .getHeartRates()
        .throttleTime(_statusRefreshInterval)
        .listen(
          (_) => _sendHeartRateStatus(),
          onError: (Object e, StackTrace stack) =>
              WiduLog.data.w('심박 스트림 오류', error: e, stackTrace: stack),
        );
  }

  @override
  void stopObserveHeartRate() {
    _heartRates?.cancel();
    _heartRates = null;
  }

  @override
  Future<ApiResult<HeartRateResponse>> fetchHeartRate() async =>
      _remoteDataSource.fetchHeartRateStatus().toApiResult();

  Future<void> _sendHeartRateStatus() async {
    final result = await _remoteDataSource.fetchHeartRateStatus().toApiResult();
    if (result is Success) {
      final data = (result as Success<HeartRateResponse>).data;
      await _localDataSource.sendHeartRateStatus(data.heartRateStatus);
    }
  }

  @override
  Stream<bool> observeConnection() => _localDataSource.observeConnection();
}
