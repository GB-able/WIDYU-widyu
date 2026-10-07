import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:widyu/core/data/source/sensor/sensor_batch_remote_data_source.dart';
import 'package:widyu/core/model/sensor/sensor_batch.dart';
import 'package:widyu/core/model/sensor/sensor_result.dart';
import 'package:widyu/core/network/api_client.dart';
import 'package:widyu/core/network/socket_client.dart';

class SensorBatchRemoteDataSourceImpl implements SensorBatchRemoteDataSource {
  SensorBatchRemoteDataSourceImpl({
    required SocketClient socketClient,
    required ApiClient apiClient,
  })  : _socketClient = socketClient,
        _apiClient = apiClient;

  final SocketClient _socketClient;
  final ApiClient _apiClient;

  @override
  Stream<bool> get connectionState => _socketClient.connectionState;

  @override
  late final Stream<SensorResult> results = _socketClient.sensorResults
      .map(_parseResult)
      .where((result) => result != null)
      .cast<SensorResult>();

  static SensorResult? _parseResult(String raw) {
    try {
      return SensorResult.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (error) {
      log('Sensor result parse failed: $error');
      return null;
    }
  }

  @override
  bool sendBatch(SensorBatch batch) =>
      _socketClient.sendSensorBatch(batch.toJson());

  /// 서버가 이 경로로 폐기 레코드를 받는지는 미확인이다(스키마 확정 시 조정).
  @override
  bool sendDropped(SensorDroppedRecord record) =>
      _socketClient.sendSensorBatch(record.toJson());

  @override
  Future<ResendOutcome> resendBatch(SensorBatch batch) async {
    try {
      // ApiClient 가 /api 와 /v1 을 붙이므로 최종 경로는 /api/v1/sensor/batches 다.
      final response = await _apiClient.req(
        path: '/sensor/batches',
        method: HttpMethod.post,
        body: batch.toJson(),
      );
      final status = response.statusCode ?? 0;
      if (status >= 200 && status < 300) return ResendOutcome.stored;
      // 본문·검증 오류(400/409/422)만 거절로 본다. 401/403 등 인증 문제는 토큰 갱신 뒤 다시 보내야 한다.
      if (status == 400 || status == 409 || status == 422) {
        // 사유에 식별자가 섞일 수 있어 디버그에서만 찍는다.
        if (kDebugMode) {
          final data = response.data;
          log('Sensor batch rejected: ${data is Map ? data['code'] : null} '
              '${data is Map ? data['message'] : null}');
        }
        return ResendOutcome.rejected;
      }
      return ResendOutcome.retryLater;
    } catch (_) {
      return ResendOutcome.retryLater;
    }
  }
}
