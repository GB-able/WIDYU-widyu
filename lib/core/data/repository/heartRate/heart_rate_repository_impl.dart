import 'dart:async';
import 'dart:developer';

import 'package:rxdart/rxdart.dart';
import 'package:widyu/core/data/repository/heartRate/heart_rate_repository.dart';
import 'package:widyu/core/data/source/heartRate/heart_rate_local_data_source.dart';
import 'package:widyu/core/data/source/heartRate/heart_rate_remote_data_source.dart';
import 'package:widyu/core/model/api/api_result.dart';
import 'package:widyu/core/model/heartRate/heart_rate_request.dart';
import 'package:widyu/core/model/heartRate/heart_rate_response.dart';
import 'package:widyu/core/utils/extensions/api_result_extension.dart';

class HeartRateRepositoryImpl implements HeartRateRepository {
  final HeartRateLocalDataSource _localDataSource;
  final HeartRateRemoteDataSource _remoteDataSource;
  StreamSubscription? _heartRates;

  HeartRateRepositoryImpl(
      {required HeartRateLocalDataSource localDataSource,
      required HeartRateRemoteDataSource remoteDataSource})
      : _localDataSource = localDataSource,
        _remoteDataSource = remoteDataSource;

  @override
  void observeHeartRate() {
    _heartRates?.cancel();
    _heartRates = _localDataSource
        .getHeartRates()
        .bufferCount(15)
        .map((heartRates) => HeartRateRequest(heartRates: heartRates))
        .listen((request) async {
      _remoteDataSource.sendHeartRates(request);
      await _sendHeartRateStatus();
    }, onError: (e) => log("Stream Error: $e"));
  }

  @override
  void stopObserveHeartRate() {
    _heartRates?.cancel();
    _heartRates = null;
  }

  Future<void> _sendHeartRateStatus() async {
    final result = await _remoteDataSource.fetchHeartRateStatus().toApiResult();
    if (result is Success) {
      final data = (result as Success<HeartRateResponse>).data;
      await _localDataSource.sendHeartRateStatus(data.heartRateStatus);
    }
  }
}
