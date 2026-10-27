import 'package:flutter_test/flutter_test.dart';
import 'package:medication_alarm/medication_alarm.dart';

void main() {
  test('alarmTime 초 단위 포함 형식 파싱', () {
    for (final time in ['17:12', '17:12:46']) {
      final rule = MedicationScheduleRule.fromJson(
          {'scheduleId': 16, 'alarmTime': time, 'doseCount': 1});
      expect((rule.hour, rule.minute), (17, 12));
    }
  });
}
