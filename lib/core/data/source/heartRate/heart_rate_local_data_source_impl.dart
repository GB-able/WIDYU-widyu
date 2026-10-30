import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:widyu/core/data/source/heartRate/heart_rate_local_data_source.dart';
import 'package:widyu/core/log/log.dart';
import 'package:widyu/core/model/heartRate/heart_rate.dart';

class HeartRateLocalDataSourceImpl implements HeartRateLocalDataSource {
  static const _eventChannel = EventChannel('com.widucorp.widu/heart_rate');
  static const _methodChannel =
      MethodChannel('com.widucorp.widu/heart_rate_status');

  late final Stream<HeartRate> _heartRateStream =
      _eventChannel.receiveBroadcastStream().map(
    (dynamic event) {
      final data = event as Map<dynamic, dynamic>;
      return HeartRate(
        heartRate: data['heartRate'] as int,
        measuredAt:
            DateTime.fromMillisecondsSinceEpoch(data['timestamp'] as int),
      );
    },
  );

  bool get _supported => defaultTargetPlatform == TargetPlatform.android;

  @override
  Stream<HeartRate> getHeartRates() =>
      _supported ? _heartRateStream : const Stream.empty();

  @override
  Future<void> sendHeartRateStatus(String heartRateStatus) async {
    if (!_supported) return;
    try {
      await _methodChannel.invokeMethod(
          'fetchHeartRateStatus', {'heartRateStatus': heartRateStatus});
    } on PlatformException catch (e) {
      WiduLog.data.w('워치로 심박 상태 전송 실패 code=${e.code}');
    }
  }

  /// 연결 여부는 심박수 샘플이 들어오는지로만 판단하므로,
  /// 샘플마다 이벤트를 흘려 구독자를 불필요하게 깨우지 않도록 [Stream.distinct] 로 접는다.
  /// [Stream.timeout] 은 원본 이벤트 기준으로 재설정되어야 하므로 반드시 그 뒤에 붙인다.
  @override
  Stream<bool> observeConnection() {
    if (!_supported) return Stream.value(false);
    return _heartRateStream
        .map((_) => true)
        .timeout(
          const Duration(seconds: 30),
          onTimeout: (sink) => sink.add(false),
        )
        .distinct();
  }
}
