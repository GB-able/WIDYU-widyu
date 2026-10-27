import 'package:flutter_test/flutter_test.dart';
import 'package:medication_alarm/medication_alarm.dart';

void main() {
  MedicationOccurrence at(DateTime time) => MedicationOccurrence(
      scheduleId: 1, localDate: '2026-10-12', scheduledAt: time);

  test('canVerify는 예정 시각 앞뒤 30분만 허용한다', () {
    final o = at(DateTime(2026, 10, 12, 9));
    expect(o.canVerify(DateTime(2026, 10, 12, 8, 30)), isTrue);
    expect(o.canVerify(DateTime(2026, 10, 12, 9, 30)), isTrue);
    expect(o.canVerify(DateTime(2026, 10, 12, 8, 29)), isFalse);
    expect(o.canVerify(DateTime(2026, 10, 12, 9, 31)), isFalse);
  });

  test('canVerify 구간은 같은 날짜를 넘지 않는다', () {
    final early = at(DateTime(2026, 10, 12, 0, 10));
    expect(early.canVerify(DateTime(2026, 10, 11, 23, 50)), isFalse);
    expect(early.canVerify(DateTime(2026, 10, 12)), isTrue);
    final late = at(DateTime(2026, 10, 12, 23, 50));
    expect(late.canVerify(DateTime(2026, 10, 12, 23, 59)), isTrue);
    expect(late.canVerify(DateTime(2026, 10, 12, 23, 59, 1)), isFalse);
  });

  test('scheduledAt이 없으면 항상 허용한다', () {
    final o = MedicationOccurrence.fromJson(
        {'scheduleId': 1, 'localDate': '2026-10-12'});
    expect(o.canVerify(DateTime(2000)), isTrue);
    expect(o.id, '1:2026-10-12');
  });

  test('필수 필드가 없으면 FormatException', () {
    expect(() => MedicationOccurrence.fromJson({'scheduleId': 1}),
        throwsFormatException);
  });
}
