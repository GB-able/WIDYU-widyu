import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:widyu/core/model/goal/medication/medication.dart';
import 'package:widyu/core/model/home/senior_card.dart';
import 'package:widyu/feature/goal/_widget/medication_card.dart';

final now = DateTime(2026, 10, 30, 10, 43);

MedicationDoseStatus dose(String time, int count, {bool taken = false}) =>
    MedicationDoseStatus(
      scheduleId: int.parse(time.replaceAll(':', '')),
      doseTime: time,
      doseCount: count,
      taken: taken,
      proofImageUrl: taken ? 'https://example.com/$time.jpg' : null,
    );

Future<void> pumpCard(
  WidgetTester tester, {
  required int taken,
  required int total,
  required String next,
  int nextDoseCount = 1,
  String? proofImage,
  List<MedicationDoseStatus> doses = const [],
}) async {
  final medicine = Medication(
    medicineScheduleId: 1,
    takenCount: taken,
    totalCount: total,
    nextDoseCount: nextDoseCount,
    nextAlarmTime: next,
    proofImage: proofImage,
    scheduleStatuses: doses,
  );
  await withClock(Clock.fixed(now), () async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: MedicationCard(
          medicine: medicine,
          proofPhoto: null,
          verifyRemaining: medicine.verifyRemainingAt(now),
          onVerified: (_) {},
        ),
      ),
    ));
  });
}

final cameraOpen = find.text('인증가능 시간');
final waitingNext = find.text('다음 인증까지');
final missed = find.text('미복용');

void main() {
  group('scheduleStatuses 기준 (A 10:40 1정, B 10:45 2정, C 23:00 3정)', () {
    final a = dose('10:40', 1, taken: true);
    final b = dose('10:45', 2);
    final c = dose('23:00', 3);

    testWidgets('A 복용, B 창 열림 → B 카메라, B 시간·정 수', (tester) async {
      await pumpCard(tester,
          taken: 1,
          total: 3,
          next: '10:40',
          proofImage: 'https://example.com/a.jpg',
          doses: [a, b, c]);
      expect(cameraOpen, findsOneWidget);
      expect(find.text('2정 복용예정'), findsOneWidget);
      expect(find.text('오전 10:45'), findsOneWidget);
      expect(find.text('오전 10:40'), findsNothing);
    });

    testWidgets('A·B 복용, C 창 전 → B 복용완료 유지', (tester) async {
      await pumpCard(tester,
          taken: 2,
          total: 3,
          next: '10:40',
          doses: [a, dose('10:45', 2, taken: true), c]);
      expect(find.text('2정 복용완료'), findsOneWidget);
      expect(find.text('오전 10:45'), findsOneWidget);
      expect(waitingNext, findsNothing);
    });

    testWidgets('A 미복용 마감, B 창 전 → A 미복용 유지', (tester) async {
      await pumpCard(tester,
          taken: 0,
          total: 2,
          next: '09:00',
          doses: [dose('09:00', 1), dose('11:30', 2)]);
      expect(missed, findsOneWidget);
      expect(find.text('오전 9:00'), findsOneWidget);
    });

    testWidgets('아직 아무 창도 안 열림 → 첫 회차 다음 인증까지', (tester) async {
      await pumpCard(tester,
          taken: 0, total: 2, next: '11:20', doses: [dose('11:20', 2), c]);
      expect(waitingNext, findsOneWidget);
      expect(find.text('2정 복용예정'), findsOneWidget);
      expect(find.text('오전 11:20'), findsOneWidget);
    });

    testWidgets('모든 회차 창 지남, 마지막 회차 복용 → 복용완료 유지', (tester) async {
      await pumpCard(tester, taken: 2, total: 2, next: '09:30', doses: [
        dose('09:00', 1, taken: true),
        dose('09:30', 2, taken: true)
      ]);
      expect(find.text('2정 복용완료'), findsOneWidget);
      expect(find.text('오전 9:30'), findsOneWidget);
    });

    testWidgets('A 미복용 마감, B 창 열림 → B 카메라', (tester) async {
      await pumpCard(tester,
          taken: 0, total: 3, next: '10:40', doses: [dose('09:00', 1), b, c]);
      expect(cameraOpen, findsOneWidget);
      expect(find.text('오전 10:45'), findsOneWidget);
    });

    testWidgets('할 회차 없음, 마지막 회차 복용 → 복용완료 (앞선 미복용 무시)', (tester) async {
      await pumpCard(tester,
          taken: 2,
          total: 3,
          next: '09:00',
          doses: [dose('09:00', 1), a, dose('10:41', 2, taken: true)]);
      expect(find.text('2정 복용완료'), findsOneWidget);
      expect(find.text('오전 10:41'), findsOneWidget);
      expect(missed, findsNothing);
    });

    testWidgets('할 회차 없음, 마지막 회차 미복용 → 미복용', (tester) async {
      await pumpCard(tester,
          taken: 1,
          total: 3,
          next: '09:00',
          doses: [dose('09:00', 1, taken: true), dose('10:10', 1)]);
      expect(missed, findsOneWidget);
      expect(find.text('오전 10:10'), findsOneWidget);
    });

    test('인증 요청 ID는 고른 회차의 scheduleId, 없으면 medicineScheduleId', () {
      final medicine = Medication(
        medicineScheduleId: 1,
        takenCount: 1,
        totalCount: 3,
        nextDoseCount: 1,
        nextAlarmTime: '10:40',
        proofImage: null,
        scheduleStatuses: [a, b, c],
      );
      expect(medicine.scheduleIdAt(now), 1045);
      expect(
          medicine.copyWith(scheduleStatuses: const []).scheduleIdAt(now), 1);
    });

    testWidgets('순서 섞여 와도 시간순으로 고름', (tester) async {
      await pumpCard(tester,
          taken: 1, total: 3, next: '10:40', doses: [c, b, a]);
      expect(find.text('오전 10:45'), findsOneWidget);
    });
  });

  group('scheduleStatuses 없으면 nextAlarmTime 폴백', () {
    testWidgets('창 열림 → 카메라', (tester) async {
      await pumpCard(tester, taken: 0, total: 3, next: '10:45');
      expect(cameraOpen, findsOneWidget);
    });

    testWidgets('창 전 → 다음 인증까지', (tester) async {
      await pumpCard(tester, taken: 2, total: 3, next: '23:00');
      expect(waitingNext, findsOneWidget);
    });

    testWidgets('전부 복용 → 복용완료', (tester) async {
      await pumpCard(tester, taken: 3, total: 3, next: '10:40');
      expect(find.text('1정 복용완료'), findsOneWidget);
    });

    testWidgets('마감 지남 → 미복용', (tester) async {
      await pumpCard(tester, taken: 2, total: 3, next: '09:00');
      expect(missed, findsOneWidget);
    });
  });
}
