import 'package:flutter_test/flutter_test.dart';
import 'package:widyu/core/model/heartRate/heart_rate_batch.dart';
import 'package:widyu/core/model/sensor/sensor_batch.dart';
import 'package:widyu/core/model/sensor/sensor_dropped_record.dart';
import 'package:widyu/core/model/sensor/sensor_message.dart';

/// 서버 스펙(배치 1건)의 키 집합 그대로. 워치 `ImuBatch.toMap()`
/// (android/wear .../data/model/ImuBatch.kt)이 만드는 형태가 정본이다.
/// 평시 배치: acc 있음, gyro·trigger null.
Map<String, dynamic> _steadyBatch() => {
      'v': 2,
      'stream': 'imu_watch',
      'source': 'watch',
      'batch_id': 'batch-1',
      'device_id': 'gw-abc',
      'session_id': 'session-1',
      'seq': 88213,
      'study_id': null,
      'participation_id': null,
      'run_id': null,
      'clock': {
        'boot_id': 'b7c1',
        'clock_mapping_id': 'cm-01',
        'anchor_elapsed_ns': '993847100000001',
        'anchor_epoch_ms': 1760000000000,
        'uncertainty_ms': 2.0,
      },
      'acc': {
        'fs_hz_requested': 50,
        'n': 3,
        't0_elapsed_ns': '993847112340001',
        'dt_ns': [19998417, 20003005],
        'mg': [
          [20, -980, 110],
          [22, -979, 108],
          [21, -981, 109],
        ],
      },
      'gyro': null,
      'trigger': null,
      'gyro_backfill': false,
      'backfill_for': null,
      'resend': null,
      'collection_mode': 'product',
      'gyro_mode': 'continuous',
      'on_body': true,
      'wear_state': null,
      'missing_reason': null,
      'watch_battery_pct': 63,
      'phone_received_at_ms': null,
    };

/// 충격 배치: gyro·trigger 있음, backfill_for 채워짐.
Map<String, dynamic> _impactBatch() => {
      'v': 2,
      'stream': 'imu_watch',
      'source': 'watch',
      'batch_id': 'batch-2',
      'device_id': 'gw-abc',
      'session_id': 'session-1',
      'seq': 88214,
      'study_id': 'study-1',
      'participation_id': 'participation-1',
      'run_id': 'run-1',
      'clock': {
        'boot_id': 'b7c1',
        'clock_mapping_id': 'cm-01',
        'anchor_elapsed_ns': '993847100000001',
        'anchor_epoch_ms': 1760000000000,
        'uncertainty_ms': 0.5,
      },
      'acc': {
        'fs_hz_requested': 50,
        'n': 2,
        't0_elapsed_ns': '993847132340001',
        'dt_ns': [20000000],
        'mg': [
          [10, 20, 900],
          [11, 21, 901],
        ],
      },
      'gyro': {
        'fs_hz_requested': 50,
        'n': 2,
        't0_elapsed_ns': '993847132340001',
        'dt_ns': [20000000],
        'mrads': [
          [100, 200, 300],
          [101, 201, 301],
        ],
      },
      'trigger': {
        'kind': 'impact',
        'smv_g': 2.4,
        'event_elapsed_ns': '993847142340001',
        'ts_ms': 1760000000100,
      },
      'gyro_backfill': true,
      'backfill_for': 'batch-1',
      'resend': null,
      'collection_mode': 'product',
      'gyro_mode': 'trigger',
      'on_body': null,
      'wear_state': null,
      'missing_reason': null,
      'watch_battery_pct': null,
      'phone_received_at_ms': 1760000000123,
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

/// 서버 심박 스펙 예시 그대로 + 폰이 채우는 phone_received_at_ms. 워치 `HeartRateBatch.toMap()` 이 정본이다.
Map<String, dynamic> _heartRateBatch() => {
      'v': 2,
      'stream': 'hr',
      'batch_id': '01j8zk3v9x2q4m7n8p1r5s6t7v',
      'device_id': 'gw-3f2a',
      'session_id': 's-01',
      'seq': 0,
      'study_id': null,
      'participation_id': null,
      'run_id': null,
      'clock': {
        'boot_id': 'boot-01',
        'clock_mapping_id': 'cm-01',
        'anchor_elapsed_ns': '1000000000',
        'anchor_epoch_ms': 1760000000000,
        'uncertainty_ms': 2.0,
      },
      'samples': [
        {'bpm': 82, 'ts_ms': 1760000000000, 'accuracy': 'UNKNOWN'},
        {'bpm': 83, 'ts_ms': 1760000001000, 'accuracy': 'HIGH'},
      ],
      'on_body': true,
      'watch_battery_pct': 63,
      'phone_received_at_ms': null,
      'resend': null,
    };

void main() {
  // 서버 스펙의 키 집합과 한 글자도 다르지 않아야 한다.
  group('fromJson -> toJson 왕복', () {
    test('평시 배치는 원본 Map 과 같다', () {
      final json = _steadyBatch();
      expect(SensorBatch.fromJson(json).toJson(), json);
    });

    test('충격 배치는 원본 Map 과 같다', () {
      final json = _impactBatch();
      expect(SensorBatch.fromJson(json).toJson(), json);
    });

    test('심박 배치는 원본 Map 과 같고 IMU 전용 필드·memberId 가 없다', () {
      final json = _heartRateBatch();
      final roundTrip = HeartRateBatch.fromJson(json).toJson();

      expect(roundTrip, json);
      for (final key in [
        'acc',
        'gyro',
        'collection_mode',
        'gyro_mode',
        'memberId'
      ]) {
        expect(roundTrip.containsKey(key), isFalse, reason: key);
      }
    });

    test('폐기 레코드는 원본 Map 과 같다', () {
      final json = _droppedRecord();
      expect(SensorDroppedRecord.fromJson(json).toJson(), json);
    });
  });

  test('나노초 값은 String 으로 유지된다', () {
    final batch = SensorBatch.fromJson(_impactBatch());

    expect(batch.clock.anchorElapsedNs, isA<String>());
    expect(batch.clock.anchorElapsedNs, '993847100000001');
    expect(batch.acc!.t0ElapsedNs, isA<String>());
    expect(batch.gyro!.t0ElapsedNs, isA<String>());
    expect(batch.trigger!.eventElapsedNs, isA<String>());
    expect(batch.trigger!.eventElapsedNs, '993847142340001');

    final roundTripped = batch.toJson();
    expect((roundTripped['clock'] as Map)['anchor_elapsed_ns'], isA<String>());
    expect((roundTripped['acc'] as Map)['t0_elapsed_ns'], isA<String>());
    expect((roundTripped['trigger'] as Map)['event_elapsed_ns'], isA<String>());
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
      'wear_state',
      'missing_reason',
      'phone_received_at_ms',
    ]) {
      expect(json.containsKey(key), isTrue, reason: '$key 키가 사라졌다');
      expect(json[key], isNull);
    }
  });

  test('최상위 boot_id·clock_mapping_id 는 clock 안에만 있다', () {
    final json = SensorBatch.fromJson(_steadyBatch()).toJson();

    expect(json.containsKey('boot_id'), isFalse);
    expect(json.containsKey('clock_mapping_id'), isFalse);
    expect((json['clock'] as Map)['boot_id'], 'b7c1');
    expect((json['clock'] as Map)['clock_mapping_id'], 'cm-01');
  });

  group('SensorMessage.fromJson 분기', () {
    test('imu_watch 는 batch 로 간다', () {
      final message = SensorMessage.fromJson(_steadyBatch());

      expect(message, isA<SensorMessageBatch>());
      expect((message as SensorMessageBatch).batch.batchId, 'batch-1');
    });

    test('hr 은 heartRate 로 간다', () {
      final message = SensorMessage.fromJson(_heartRateBatch());

      expect(message, isA<SensorMessageHeartRate>());
      final batch = (message as SensorMessageHeartRate).batch;
      expect(
          batch.samples.map((sample) => sample.accuracy), ['UNKNOWN', 'HIGH']);
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
