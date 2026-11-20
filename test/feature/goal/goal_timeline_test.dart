import 'package:flutter_test/flutter_test.dart';
import 'package:widyu/core/model/goal/hospital/daily_health_schedule.dart';
import 'package:widyu/feature/goal/_widget/goal_timeline.dart';

final today = DateTime(2026, 11, 19);
final now = DateTime(2026, 11, 19, 12);

DailyHealthSchedule health(int hour, HealthScheduleState status) =>
    DailyHealthSchedule(
      healthScheduleId: hour,
      scheduleName: '검진',
      scheduledAt: DateTime(2026, 11, 19, hour),
      progressStatus: status,
    );

enum _Dose { done, missed, upcoming }

void main() {
  group('medicineTimelineStatus', () {
    TimelineStatus of(String time, _Dose status, DateTime date) =>
        medicineTimelineStatus(
          time,
          taken: status == _Dose.done,
          missed: status == _Dose.missed,
          date: date,
          now: now,
        );

    test('서버 완료·놓침은 그대로 쓴다', () {
      expect(of('08:30:00', _Dose.done, today), TimelineStatus.done);
      expect(of('08:30:00', _Dose.missed, today), TimelineStatus.missed);
    });

    test('오늘 예정은 인증 시간(알람 ±30분) 기준으로 나눈다', () {
      expect(of('12:20:00', _Dose.upcoming, today), TimelineStatus.active);
      expect(of('11:40', _Dose.upcoming, today), TimelineStatus.active);
      expect(of('13:00:00', _Dose.upcoming, today), TimelineStatus.upcoming);
      // 다시 받기 전이라 서버는 아직 예정이지만 인증 마감이 지났다.
      expect(of('11:00:00', _Dose.upcoming, today), TimelineStatus.missed);
    });

    test('오늘이 아닌 날의 예정은 강조하지 않는다', () {
      expect(of('12:00:00', _Dose.upcoming, DateTime(2026, 11, 20)),
          TimelineStatus.scheduled);
    });
  });

  group('healthTimelineStatuses', () {
    test('오늘 남은 일정 중 가장 이른 하나만 강조한다', () {
      final statuses = healthTimelineStatuses(
        [
          health(9, HealthScheduleState.incomplete),
          health(10, HealthScheduleState.completed),
          health(15, HealthScheduleState.upcoming),
          health(16, HealthScheduleState.upcoming),
        ],
        date: today,
        now: now,
      );
      expect(statuses, [
        TimelineStatus.missed,
        TimelineStatus.done,
        TimelineStatus.active,
        TimelineStatus.upcoming,
      ]);
    });

    test('오늘 예정이어도 예정 시각 30분이 지나면 놓침으로 보고 강조하지 않는다', () {
      final statuses = healthTimelineStatuses(
        [
          health(11, HealthScheduleState.upcoming), // 11:30 마감 지남
          health(12, HealthScheduleState.upcoming),
        ],
        date: today,
        now: now,
      );
      expect(statuses, [TimelineStatus.missed, TimelineStatus.active]);
    });

    test('다른 날의 예정 일정은 모두 예정으로 둔다', () {
      final statuses = healthTimelineStatuses(
        [
          health(15, HealthScheduleState.upcoming),
          health(16, HealthScheduleState.upcoming),
        ],
        date: DateTime(2026, 11, 20),
        now: now,
      );
      expect(statuses, [TimelineStatus.scheduled, TimelineStatus.scheduled]);
    });
  });
}
