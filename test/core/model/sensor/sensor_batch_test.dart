import 'package:flutter_test/flutter_test.dart';
import 'package:widyu/core/model/sensor/sensor_batch.dart';

/// 워치 `ImuBatch.toMap()`(android/wear .../data/model/ImuBatch.kt) 형태 그대로.
/// 평시 배치: acc 있음, gyro·trigger null.
Map<String, dynamic> _steadyBatch() => {
      'v': 2,
      'stream': 'imu_watch',
      'source': 'watch',
      'batch_id': 'batch-1',
      'device_id': 'device-1',
      'session_id': 'session-1',
      'seq': 1,
      'study_id': null,
      'participation_id': null,
      'run_id': null,
      'clock': {
        'boot_id': 'boot-1',
        'clock_mapping_id': 'mapping-1',
        'anchor_elapsed_ns': '123456789012345',
        'anchor_epoch_ms': 1758000000000,
        'uncertainty_ms': 1.5,
      },
      'boot_id': 'boot-1',
      'clock_mapping_id': 'mapping-1',
      'acc': {
        'fs_hz_requested': 50,
        'n': 3,
        't0_elapsed_ns': '123456789012345',
        'dt_ns': [20000000, 20000000],
        'mg': [
          [1, 2, 1000],
          [3, 4, 1001],
          [5, 6, 1002],
        ],
      },
      'gyro': null,
      'trigger': null,
      'gyro_backfill': false,
      'backfill_for': null,
      'gyro_mode': 'continuous',
      'collection_mode': 'product',
      'missing_reason': 'omitted_by_mode',
      'on_body': true,
      'watch_battery_pct': 84,
    };

/// 충격 배치: gyro·trigger 있음, backfill_for 채워짐.
Map<String, dynamic> _impactBatch() => {
      'v': 2,
      'stream': 'imu_watch',
      'source': 'watch',
      'batch_id': 'batch-2',
      'device_id': 'device-1',
      'session_id': 'session-1',
      'seq': 2,
      'study_id': 'study-1',
      'participation_id': 'participation-1',
      'run_id': 'run-1',
      'clock': {
        'boot_id': 'boot-1',
        'clock_mapping_id': 'mapping-1',
        'anchor_elapsed_ns': '123456789012345',
        'anchor_epoch_ms': 1758000000000,
        'uncertainty_ms': 0.5,
      },
      'boot_id': 'boot-1',
      'clock_mapping_id': 'mapping-1',
      'acc': {
        'fs_hz_requested': 50,
        'n': 2,
        't0_elapsed_ns': '123456789032345',
        'dt_ns': [20000000],
        'mg': [
          [10, 20, 900],
          [11, 21, 901],
        ],
      },
      'gyro': {
        'fs_hz_requested': 50,
        'n': 2,
        't0_elapsed_ns': '123456789032345',
        'dt_ns': [20000000],
        'mrads': [
          [100, 200, 300],
          [101, 201, 301],
        ],
      },
      'trigger': {
        'kind': 'impact',
        'smv_g': 2.4,
        'event_elapsed_ns': '123456789042345',
        'ts_ms': 1758000000100,
      },
      'gyro_backfill': true,
      'backfill_for': 'batch-1',
      'gyro_mode': 'trigger',
      'collection_mode': 'product',
      'missing_reason': null,
      'on_body': null,
      'watch_battery_pct': null,
    };

/// 폰 네이티브 HeartRateListenerService 가 넘기는 폐기 레코드.
Map<String, dynamic> _droppedRecord() => {
      'stream': 'imu_dropped',
      'session_id': 'session-1',
      'from_seq': 10,
      'to_seq': 15,
      'reason': 'queue_full',
      'ts_ms': 1758000000200,
    };

void main() {
  // 워치 toMap() 에는 resend 키가 없다(재전송 때 폰이 붙인다).
  // 그 한 키만 빼면 왕복 결과가 원본과 같아야 한다.
  group('fromJson -> toJson 왕복', () {
    test('평시 배치는 원본 Map 과 같다', () {
      final json = _steadyBatch();
      expect(SensorBatch.fromJson(json).toJson(), {...json, 'resend': null});
    });

    test('충격 배치는 원본 Map 과 같다', () {
      final json = _impactBatch();
      expect(SensorBatch.fromJson(json).toJson(), {...json, 'resend': null});
    });

    test('폐기 레코드는 원본 Map 과 같다', () {
      final json = _droppedRecord();
      expect(SensorDroppedRecord.fromJson(json).toJson(), json);
    });
  });

  test('나노초 값은 String 으로 유지된다', () {
    final batch = SensorBatch.fromJson(_impactBatch());

    expect(batch.clock.anchorElapsedNs, isA<String>());
    expect(batch.clock.anchorElapsedNs, '123456789012345');
    expect(batch.acc!.t0ElapsedNs, isA<String>());
    expect(batch.gyro!.t0ElapsedNs, isA<String>());
    expect(batch.trigger!.eventElapsedNs, isA<String>());
    expect(batch.trigger!.eventElapsedNs, '123456789042345');

    final roundTripped = batch.toJson();
    expect((roundTripped['clock'] as Map)['anchor_elapsed_ns'], isA<String>());
    expect((roundTripped['acc'] as Map)['t0_elapsed_ns'], isA<String>());
    expect(
        (roundTripped['trigger'] as Map)['event_elapsed_ns'], isA<String>());
  });

  test('null 필드도 키가 남는다', () {
    final json = SensorBatch.fromJson(_steadyBatch()).toJson();

    for (final key in [
      'study_id',
      'participation_id',
      'run_id',
      'gyro',
      'trigger',
      'backfill_for',
      'resend',
    ]) {
      expect(json.containsKey(key), isTrue, reason: '$key 키가 사라졌다');
      expect(json[key], isNull);
    }
    // resend 는 워치 toMap() 에 없는 필드라 기본 null 이다.
    expect(json['resend'], isNull);
  });

  group('SensorMessage.fromJson 분기', () {
    test('imu_watch 는 batch 로 간다', () {
      final message = SensorMessage.fromJson(_steadyBatch());

      expect(message, isA<SensorMessageBatch>());
      expect((message as SensorMessageBatch).batch.batchId, 'batch-1');
    });

    test('imu_dropped 는 dropped 로 간다', () {
      final message = SensorMessage.fromJson(_droppedRecord());

      expect(message, isA<SensorMessageDropped>());
      final record = (message as SensorMessageDropped).record;
      expect(record.fromSeq, 10);
      expect(record.toSeq, 15);
      expect(record.reason, 'queue_full');
    });
  });
}
