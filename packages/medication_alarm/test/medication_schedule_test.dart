import 'package:flutter_test/flutter_test.dart';
import 'package:medication_alarm/medication_alarm.dart';

void main() {
  test('유효 기간 밖의 날짜는 알람을 만들지 않음', () {
    final schedule = MedicationSchedule.fromJson({
      'memberId': '1',
      'revision': 45,
      'timeZone': 'Asia/Seoul',
      'schedules': [
        {
          'scheduleId': 15,
          'alarmTime': '08:00',
          'doseCount': 1,
          'effectiveFrom': '2026-10-01',
          'effectiveTo': '2026-11-09'
        },
        {
          'scheduleId': 16,
          'alarmTime': '12:00',
          'doseCount': 2,
          'effectiveFrom': '2026-10-01',
          'effectiveTo': '2026-11-09'
        },
        {
          'scheduleId': 17,
          'alarmTime': '19:27',
          'doseCount': 2,
          'effectiveFrom': '2026-10-15',
          'effectiveTo': null
        },
        {
          'scheduleId': 21,
          'alarmTime': '20:00',
          'doseCount': 2,
          'effectiveFrom': '2026-11-10',
          'effectiveTo': null
        },
        {
          'scheduleId': 22,
          'alarmTime': '07:00',
          'doseCount': 1,
          'effectiveFrom': '2026-11-10',
          'effectiveTo': null
        },
      ],
      'completed': ['15:2026-11-09', '16:2026-11-09'],
    });

    final ids = schedule
        .groups(DateTime(2026, 11, 9, 6), days: 2)
        .expand((g) => g['occurrences'] as List)
        .map((o) => o['occurrenceId'])
        .toList();

    expect(ids, [
      '17:2026-11-09',
      '22:2026-11-10',
      '17:2026-11-10',
      '21:2026-11-10',
    ]);
  });

  test('유효 기간은 저장 후 다시 읽어도 유지됨', () {
    final rule = MedicationScheduleRule.fromJson({
      'scheduleId': 21,
      'alarmTime': '20:00',
      'doseCount': 2,
      'effectiveFrom': '2026-11-10',
    });
    final restored = MedicationScheduleRule.fromJson(rule.toJson());
    expect(
        (restored.effectiveFrom, restored.effectiveTo), ('2026-11-10', null));
  });

  test('잘못된 날짜 형식은 거부', () {
    expect(
        () => MedicationScheduleRule.fromJson({
              'scheduleId': 1,
              'alarmTime': '08:00',
              'doseCount': 1,
              'effectiveTo': '2026-11-9',
            }),
        throwsFormatException);
  });
}
