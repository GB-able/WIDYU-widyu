import 'package:flutter_test/flutter_test.dart';
import 'package:widyu/core/model/home/medication_status.dart';
import 'package:widyu/core/model/home/senior_card.dart';

MedicationDoseStatus _dose(String time, {required bool taken}) =>
    MedicationDoseStatus(doseTime: time, taken: taken);

MedicationSummary _summary({
  int takenCount = 1,
  int totalCount = 3,
  String? nextAlarmTime = '15:00',
  List<MedicationDoseStatus>? scheduleStatuses,
}) =>
    MedicationSummary(
      medicineScheduleId: 1,
      todayTakenCount: takenCount,
      todayTotalCount: totalCount,
      nextDoseCount: 1,
      nextAlarmTime: nextAlarmTime,
      scheduleStatuses: scheduleStatuses ??
          [
            _dose('08:00', taken: true),
            _dose('15:00', taken: false),
            _dose('20:00', taken: false),
          ],
    );

DateTime _at(int hour, int minute) => DateTime(2026, 8, 14, hour, minute);

void main() {
  group('resolveMedicationStatus', () {
    test('14:29 → upcoming, opensAt == 14:30', () {
      final status = resolveMedicationStatus(
        medicine: _summary(),
        now: _at(14, 29),
      );

      expect(status, isA<MedicationUpcoming>());
      final upcoming = status as MedicationUpcoming;
      expect(upcoming.opensAt, _at(14, 30));
      expect(upcoming.doseAt, _at(15, 0));
      expect(upcoming.takenCount, 1);
      expect(upcoming.totalCount, 3);
    });

    test('14:30 → available (여는 경계 포함), closesAt == 15:30', () {
      final status = resolveMedicationStatus(
        medicine: _summary(),
        now: _at(14, 30),
      );

      expect(status, isA<MedicationAvailable>());
      final available = status as MedicationAvailable;
      expect(available.doseAt, _at(15, 0));
      expect(available.closesAt, _at(15, 30));
    });

    test('15:30 → available (닫는 경계 포함)', () {
      final status = resolveMedicationStatus(
        medicine: _summary(),
        now: _at(15, 30),
      );

      expect(status, isA<MedicationAvailable>());
      expect((status as MedicationAvailable).doseAt, _at(15, 0));
    });

    test('15:31 → 다음 회차 upcoming, opensAt == 19:30', () {
      final status = resolveMedicationStatus(
        medicine: _summary(),
        now: _at(15, 31),
      );

      expect(status, isA<MedicationUpcoming>());
      final upcoming = status as MedicationUpcoming;
      expect(upcoming.opensAt, _at(19, 30));
      expect(upcoming.doseAt, _at(20, 0));
    });

    test('20:31 → missed', () {
      final status = resolveMedicationStatus(
        medicine: _summary(),
        now: _at(20, 31),
      );

      expect(status, isA<MedicationMissed>());
      final missed = status as MedicationMissed;
      expect(missed.takenCount, 1);
      expect(missed.totalCount, 3);
    });

    test('taken == total → completed', () {
      final status = resolveMedicationStatus(
        medicine: _summary(
          takenCount: 3,
          totalCount: 3,
          scheduleStatuses: [
            _dose('08:00', taken: true),
            _dose('15:00', taken: true),
            _dose('20:00', taken: true),
          ],
        ),
        now: _at(21, 0),
      );

      expect(status, isA<MedicationCompleted>());
      expect((status as MedicationCompleted).totalCount, 3);
    });

    test('total == 0 → none', () {
      final status = resolveMedicationStatus(
        medicine: _summary(
          takenCount: 0,
          totalCount: 0,
          nextAlarmTime: null,
          scheduleStatuses: const [],
        ),
        now: _at(10, 0),
      );

      expect(status, isA<MedicationNone>());
    });

    test('medicine == null → unknown', () {
      final status = resolveMedicationStatus(
        medicine: null,
        now: _at(10, 0),
      );

      expect(status, isA<MedicationUnknown>());
    });

    test('창이 겹치면 가장 이른 회차(08:00)가 선택된다', () {
      final status = resolveMedicationStatus(
        medicine: _summary(
          takenCount: 0,
          totalCount: 2,
          scheduleStatuses: [
            _dose('08:00', taken: false),
            _dose('08:30', taken: false),
          ],
        ),
        now: _at(8, 15),
      );

      expect(status, isA<MedicationAvailable>());
      final available = status as MedicationAvailable;
      expect(available.doseAt, _at(8, 0));
      expect(available.closesAt, _at(8, 30));
    });

    test('scheduleStatuses 가 비면 nextAlarmTime 으로 폴백한다', () {
      final status = resolveMedicationStatus(
        medicine: _summary(
          takenCount: 0,
          totalCount: 1,
          nextAlarmTime: '15:00',
          scheduleStatuses: const [],
        ),
        now: _at(14, 45),
      );

      expect(status, isA<MedicationAvailable>());
      expect((status as MedicationAvailable).doseAt, _at(15, 0));
    });
  });
}
