import 'package:flutter_test/flutter_test.dart';
import 'package:widyu/core/model/goal/goal_home_response.dart';
import 'package:widyu/core/model/goal/hospital/daily_health_schedule.dart';
import 'package:widyu/core/model/goal/medication/medication.dart';
import 'package:widyu/core/model/home/senior_card.dart';
import 'package:widyu/feature/goal/_widget/goal_timeline.dart';
import 'package:widyu/feature/goal/main/goal_schedule.dart';

final now = DateTime(2026, 11, 19, 16, 27);

MedicationDoseStatus dose(String time, {bool taken = false, int? id}) =>
    MedicationDoseStatus(
      scheduleId: id,
      doseTime: time,
      doseCount: 5,
      taken: taken,
    );

Medication medicine(List<MedicationDoseStatus> doses) => Medication(
      medicineScheduleId: 99,
      takenCount: 0,
      totalCount: doses.length,
      nextDoseCount: 1,
      nextAlarmTime: '',
      proofImage: null,
      scheduleStatuses: doses,
    );

DailyHealthSchedule visit(int hour, int minute, HealthScheduleState progress) =>
    DailyHealthSchedule(
      healthScheduleId: hour * 100 + minute,
      scheduleName: '병원',
      scheduledAt: DateTime(2026, 11, 19, hour, minute),
      placeAddress: '서울 성북구 고려대로 73',
      progressStatus: progress,
    );

List<TimelineStatus> statuses(List<GoalSchedule> schedules) =>
    schedules.map((s) => s.status).toList();

void main() {
  test('약 회차는 복용 여부와 인증 가능 시간(±30분)으로 상태를 정한다', () {
    final schedules = buildGoalSchedules(
      medicine: medicine([
        dose('08:30'), // 창 지남 → 미인증
        dose('11:30', taken: true), // 복용 → 완료
        dose('16:50'), // 16:20~17:20 창 안 → 인증 가능
        dose('16:58'), // 16:28부터 열림 → 예정
      ]),
      visits: const [],
      now: now,
    );

    expect(statuses(schedules), [
      TimelineStatus.missed,
      TimelineStatus.done,
      TimelineStatus.active,
      TimelineStatus.upcoming,
    ]);
  });

  test('회차 ID가 있으면 그 ID로, 없으면 다음 일정 ID로 인증한다', () {
    final schedules = buildGoalSchedules(
      medicine: medicine([dose('16:30', id: 7), dose('16:40')]),
      visits: const [],
      now: now,
    );

    expect(
      schedules.cast<DoseSchedule>().map((s) => s.scheduleId),
      [7, 99],
    );
  });

  test('병원은 방문 전 일정 중 가장 이른 것만 길 찾기 카드가 된다', () {
    final schedules = buildGoalSchedules(
      medicine: null,
      visits: [
        visit(22, 0, HealthScheduleState.upcoming),
        visit(9, 30, HealthScheduleState.completed),
        visit(8, 30, HealthScheduleState.incomplete),
        visit(16, 0, HealthScheduleState.upcoming), // +30분 안 → 길 찾기
        visit(15, 30, HealthScheduleState.upcoming), // +30분 지남 → 미인증
      ],
      now: now,
    );

    expect(schedules.map((s) => s.at.hour), [8, 9, 15, 16, 22]);
    expect(statuses(schedules), [
      TimelineStatus.missed,
      TimelineStatus.done,
      TimelineStatus.missed,
      TimelineStatus.active,
      TimelineStatus.upcoming,
    ]);
  });

  test('목표 홈 응답에서 회차 ID와 오늘 일정을 읽는다', () {
    final response = GoalHomeResponse.fromJson({
      'medicine': {
        'medicineScheduleId': 1,
        'takenCount': 0,
        'totalCount': 1,
        'nextDoseCount': 5.0,
        'nextAlarmTime': '18:30',
        'proofImageUrl': null,
        'scheduleStatuses': [
          {
            'medicineScheduleId': 42,
            'doseTime': '18:30',
            'doseCount': 5.0,
            'taken': false,
            'proofImageUrl': null,
          },
        ],
      },
      'steps': null,
      'hospital': null,
      'todaySchedules': [
        {
          'healthScheduleId': 12,
          'scheduleName': '약처방',
          'scheduledAt': '2026-11-19T15:30:00',
          'placeAddress': '서울 성북구 고려대로 73',
          'latitude': 37.5894,
          'longitude': 127.0327,
          'progressStatus': 'COMPLETED',
          'elapsed': true,
        },
      ],
    });

    expect(response.medicine!.scheduleStatuses.single.scheduleId, 42);
    final schedule = response.todaySchedules.single;
    expect(schedule.scheduledAt, DateTime(2026, 11, 19, 15, 30));
    expect(schedule.progressStatus, HealthScheduleState.completed);
  });
}
