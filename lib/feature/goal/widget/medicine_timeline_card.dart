import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:widyu/core/model/goal/monthly/daily_medicine_schedule.dart';
import 'package:widyu/core/ui/theme/colors.dart';
import 'package:widyu/core/ui/widget/widu_icon.dart';
import 'package:widyu/core/util/extension/string_extension.dart';
import 'package:widyu/feature/goal/main/goal_screen.dart';
import 'package:widyu/feature/goal/widget/goal_timeline.dart';
import 'package:widyu/gen/assets.gen.dart';

/// 하루치 약 복용 타임라인. 오늘이면 인증 시간 안의 회차에 약 인증하기 버튼을 띄운다.
class MedicineTimelineCard extends StatelessWidget {
  const MedicineTimelineCard({
    super.key,
    required this.date,
    required this.schedules,
    required this.onVerify,
  });

  final DateTime date;
  final List<DailyMedicineSchedule> schedules;
  final ValueChanged<DailyMedicineSchedule> onVerify;

  @override
  Widget build(BuildContext context) {
    final now = clock.now();
    final statuses = [
      for (final schedule in schedules)
        medicineTimelineStatus(
          schedule.alarmTime,
          taken: schedule.status == MedicineDoseState.done,
          missed: schedule.status == MedicineDoseState.missed,
          date: date,
          now: now,
        ),
    ];

    return GoalTimelineCard(
      type: GoalType.medicine,
      title: '약 복용',
      items: [
        for (final (index, schedule) in schedules.indexed)
          GoalTimelineItem(
            status: statuses[index],
            title: Row(
              spacing: 16,
              children: [
                Flexible(
                  child: Text(
                    schedule.alarmTime.twelveHourTime,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (schedule.totalCount case final count?)
                  Flexible(
                    child: Text(
                      '${_formatCount(count)}정',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: statuses[index] == TimelineStatus.active
                          ? null
                          : const TextStyle(color: MyColor.primary),
                    ),
                  ),
              ],
            ),
            action: GoalTimelineButton(
              label: '약 인증하기',
              icon: WiduIcon(
                icon: Assets.icons.ic24CameraAdd,
                width: 24,
                color: MyColor.grey900,
              ),
              onTap: () => onVerify(schedule),
            ),
          ),
      ],
    );
  }

  static String _formatCount(double count) => count == count.roundToDouble()
      ? count.toInt().toString()
      : count.toString();
}
