import 'package:widyu/core/model/goal/hospital/daily_health_schedule.dart';
import 'package:widyu/core/model/goal/medication/medication.dart';
import 'package:widyu/core/model/home/senior_card.dart';
import 'package:widyu/core/util/extension/string_extension.dart';
import 'package:widyu/feature/goal/widget/goal_timeline.dart';

sealed class GoalSchedule {
  const GoalSchedule({required this.at, required this.status});

  final DateTime at;
  final TimelineStatus status;
}

class DoseSchedule extends GoalSchedule {
  const DoseSchedule({
    required super.at,
    required super.status,
    required this.scheduleId,
    required this.doseCount,
  });

  final int scheduleId;
  final double doseCount;
}

class VisitSchedule extends GoalSchedule {
  const VisitSchedule({
    required super.at,
    required super.status,
    required this.visit,
  });

  final DailyHealthSchedule visit;
}

/// 오늘 약 회차와 건강 일정을 시각순으로 합친다. 상태 판정은 [medicineTimelineStatus]·[healthTimelineStatuses]를 따른다.
List<GoalSchedule> buildGoalSchedules({
  required Medication? medicine,
  required List<DailyHealthSchedule> visits,
  required DateTime now,
}) {
  final doses = <GoalSchedule>[
    for (final MedicationDoseStatus dose in medicine?.scheduleStatuses ?? [])
      if (dose.doseTime case final time?)
        if (time.toAlarmAt(now) case final at?)
          DoseSchedule(
            at: at,
            status: medicineTimelineStatus(
              time,
              taken: dose.taken,
              date: now,
              now: now,
            ),
            // 회차 ID가 없는 예전 응답이면 다음 일정 ID로 인증한다.
            scheduleId: dose.scheduleId ?? medicine!.medicineScheduleId,
            doseCount: dose.doseCount ?? medicine!.nextDoseCount,
          ),
  ];

  final sortedVisits = [...visits]
    ..sort((a, b) => a.scheduledAt.compareTo(b.scheduledAt));
  final visitStatuses =
      healthTimelineStatuses(sortedVisits, date: now, now: now);

  return [
    ...doses,
    for (final (index, visit) in sortedVisits.indexed)
      VisitSchedule(
        at: visit.scheduledAt,
        status: visitStatuses[index],
        visit: visit,
      ),
  ]..sort((a, b) => a.at.compareTo(b.at));
}
