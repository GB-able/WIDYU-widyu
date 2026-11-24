import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:widyu/core/model/goal/hospital/daily_health_schedule.dart';
import 'package:widyu/core/util/extension/date_extension.dart';
import 'package:widyu/core/util/extension/string_extension.dart';
import 'package:widyu/feature/goal/main/goal_screen.dart';
import 'package:widyu/feature/goal/widget/goal_timeline.dart';

/// 하루치 건강 일정 타임라인. 오늘 아직 인증할 수 있는 일정마다 길 찾기 버튼을 띄운다.
class HealthTimelineCard extends StatelessWidget {
  const HealthTimelineCard({
    super.key,
    required this.date,
    required this.schedules,
    required this.onFindRoute,
  });

  final DateTime date;
  final List<DailyHealthSchedule> schedules;
  final ValueChanged<DailyHealthSchedule> onFindRoute;

  @override
  Widget build(BuildContext context) {
    final statuses =
        healthTimelineStatuses(schedules, date: date, now: clock.now());

    return GoalTimelineCard(
      type: GoalType.hospital,
      title: '건강일정',
      items: [
        for (final (index, schedule) in schedules.indexed)
          GoalTimelineItem(
            status: statuses[index],
            title: Row(
              spacing: 8,
              children: [
                Flexible(
                  child: Text(
                    schedule.scheduledAt.onlyTime.twelveHourTime,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Flexible(
                  child: Text(
                    schedule.scheduleName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            subtitle: schedule.placeAddress,
            action: GoalTimelineButton(
              label: '길 찾기',
              onTap: () => onFindRoute(schedule),
            ),
          ),
      ],
    );
  }
}
