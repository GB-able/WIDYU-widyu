import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:widyu/core/model/goal/hospital/daily_health_schedule.dart';
import 'package:widyu/core/ui/theme/colors.dart';
import 'package:widyu/core/ui/theme/typos.dart';
import 'package:widyu/core/util/extension/date_extension.dart';
import 'package:widyu/core/util/extension/medication_extension.dart';
import 'package:widyu/core/util/extension/string_extension.dart';
import 'package:widyu/feature/goal/main/goal_screen.dart';
import 'package:widyu/feature/goal/widget/icon_tile.dart';

/// 타임라인 한 줄의 상태. 점 모양과 오른쪽 문구가 정해진다.
enum TimelineStatus {
  /// 인증 완료. 보라 점.
  done,

  /// 인증 시간을 놓침. 회색 점.
  missed,

  /// 오늘 지금 인증할 일정. 주황 카드로 강조하고 버튼을 띄운다.
  active,

  /// 오늘 아직 시간이 안 된 일정. 속이 빈 주황 점.
  upcoming,

  /// 오늘이 아닌 날의 예정 일정. 회색 점.
  scheduled;

  String get label => switch (this) {
        done => '인증 완료',
        missed => '미인증',
        active || upcoming || scheduled => '인증 예정',
      };

  Color get labelColor => switch (this) {
        done => MyColor.secondary,
        missed => MyColor.grey400,
        active || upcoming || scheduled => MyColor.primary,
      };
}

/// 약 복용 한 회차의 상태. 서버 값이 '예정'이어도 오늘이면 [now] 기준 인증 시간(알람 ±30분)으로 다시 판단한다.
/// [missed]는 서버가 이미 놓침으로 정한 경우다(월간 일정). 목표 홈은 복용 여부만 준다.
TimelineStatus medicineTimelineStatus(
  String alarmTime, {
  required bool taken,
  bool missed = false,
  required DateTime date,
  required DateTime now,
}) {
  if (taken) return TimelineStatus.done;
  if (missed) return TimelineStatus.missed;
  final alarm = alarmTime.toAlarmAt(date);
  if (!date.isSameDay(now) || alarm == null) return TimelineStatus.scheduled;
  if (now.isAfter(alarm.windowClosesAt)) return TimelineStatus.missed;
  if (alarm.isWithinVerifyWindow(now)) return TimelineStatus.active;
  return TimelineStatus.upcoming;
}

/// 병원 방문 인증은 예정 시각 30분 뒤까지 받는다(서버 HealthSchedule.COMPLETION_GRACE_MINUTES).
const healthCompletionGrace = Duration(minutes: 30);

/// 건강 일정들의 상태. [schedules]는 시각순이어야 한다. 오늘 남은 일정 중 가장 이른 하나를 강조한다.
/// 오늘은 서버 값이 '예정'이어도 인증 마감이 지났으면 놓침으로 본다(응답 뒤 시간이 흐른 경우).
List<TimelineStatus> healthTimelineStatuses(
  List<DailyHealthSchedule> schedules, {
  required DateTime date,
  required DateTime now,
}) {
  final isToday = date.isSameDay(now);
  var hasActive = false;
  final statuses = <TimelineStatus>[];
  for (final schedule in schedules) {
    // 지난 일정이 강조되지 않게 놓침을 먼저 거른다.
    statuses.add(switch (schedule.progressStatus) {
      HealthScheduleState.completed => TimelineStatus.done,
      HealthScheduleState.incomplete => TimelineStatus.missed,
      HealthScheduleState.upcoming when !isToday => TimelineStatus.scheduled,
      HealthScheduleState.upcoming
          when now.isAfter(schedule.scheduledAt.add(healthCompletionGrace)) =>
        TimelineStatus.missed,
      HealthScheduleState.upcoming when hasActive => TimelineStatus.upcoming,
      HealthScheduleState.upcoming => TimelineStatus.active,
    });
    if (statuses.last == TimelineStatus.active) hasActive = true;
  }
  return statuses;
}

/// 약 복용·건강일정 카드의 공통 틀. 머리말 아래에 타임라인을 그린다.
class GoalTimelineCard extends StatelessWidget {
  const GoalTimelineCard({
    super.key,
    required this.type,
    required this.title,
    required this.items,
  });

  final GoalType type;
  final String title;
  final List<GoalTimelineItem> items;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: MyColor.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 16,
        children: [
          Row(
            spacing: 16,
            children: [
              IconTile(type: type),
              Text(title,
                  style: MyTypo.title3.copyWith(color: MyColor.grey800)),
            ],
          ),
          GoalTimeline(items: items),
        ],
      ),
    );
  }
}

/// 왼쪽 선·점과 함께 줄 목록만 그린다. 머리말이 필요하면 [GoalTimelineCard]를 쓴다.
class GoalTimeline extends StatelessWidget {
  const GoalTimeline({super.key, required this.items});

  final List<GoalTimelineItem> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final (index, item) in items.indexed)
          _TimelineEntry(
            isFirst: index == 0,
            isLast: index == items.length - 1,
            item: item,
          ),
      ],
    );
  }
}

/// 타임라인 한 줄. [action]은 [status]가 [TimelineStatus.active]일 때만 보인다.
class GoalTimelineItem {
  const GoalTimelineItem({
    required this.status,
    required this.title,
    this.subtitle,
    this.action,
    this.leading,
  });

  final TimelineStatus status;
  final Widget title;
  final String? subtitle;
  final Widget? action;

  /// 제목 왼쪽 아이콘. 없으면 아이콘 없이 그린다.
  final Widget? leading;
}

class _TimelineEntry extends StatelessWidget {
  const _TimelineEntry({
    required this.isFirst,
    required this.isLast,
    required this.item,
  });

  static const _gap = 6.0;

  final bool isFirst;
  final bool isLast;
  final GoalTimelineItem item;

  @override
  Widget build(BuildContext context) {
    // 스켈레톤일 때 선과 점도 블록으로 그린다.
    Widget line(bool visible) => Expanded(
          child: visible
              ? Skeleton.leaf(
                  child: Container(width: 1, color: MyColor.grey600),
                )
              : const SizedBox(width: 1),
        );

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 12,
        children: [
          SizedBox(
            width: 11,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Column(children: [line(!isFirst), line(!isLast)]),
                Skeleton.leaf(child: _TimelineDot(status: item.status)),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                top: isFirst ? 0 : _gap / 2,
                bottom: isLast ? 0 : _gap / 2,
              ),
              child: _TimelineTile(item: item),
            ),
          ),
        ],
      ),
    );
  }
}

class _TimelineDot extends StatelessWidget {
  const _TimelineDot({required this.status});

  final TimelineStatus status;

  @override
  Widget build(BuildContext context) {
    final hollow =
        status == TimelineStatus.active || status == TimelineStatus.upcoming;
    return Container(
      width: 11,
      height: 11,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: switch (status) {
          TimelineStatus.done => MyColor.secondary,
          _ when hollow => MyColor.white,
          _ => MyColor.grey500,
        },
        border: hollow ? Border.all(color: MyColor.primary) : null,
      ),
    );
  }
}

class _TimelineTile extends StatelessWidget {
  const _TimelineTile({required this.item});

  final GoalTimelineItem item;

  @override
  Widget build(BuildContext context) {
    final isActive = item.status == TimelineStatus.active;
    final subtitle = item.subtitle;
    final leading = item.leading;

    final texts = DefaultTextStyle.merge(
      style: MyTypo.subTitle5.copyWith(
        color: isActive ? MyColor.grey50 : MyColor.grey700,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 2,
        children: [
          item.title,
          if (subtitle != null)
            Text(
              subtitle,
              style: MyTypo.body2.copyWith(
                color: isActive ? MyColor.grey100 : MyColor.grey500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
        ],
      ),
    );

    // 두 줄이면 아이콘을 첫 줄에 맞춘다.
    final head = Row(
      crossAxisAlignment: subtitle != null && !isActive
          ? CrossAxisAlignment.start
          : CrossAxisAlignment.center,
      spacing: 6,
      children: [
        if (leading != null) leading,
        Expanded(child: texts),
      ],
    );

    return Container(
      padding: isActive
          ? const EdgeInsets.all(12)
          : const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: isActive ? MyColor.primary : MyColor.grey50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: isActive
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 12,
              children: [head, if (item.action case final action?) action],
            )
          : Row(
              spacing: 8,
              children: [
                Expanded(child: head),
                Text(
                  item.status.label,
                  style: MyTypo.subTitle5.copyWith(
                    color: item.status.labelColor,
                  ),
                ),
              ],
            ),
    );
  }
}

/// 강조된 줄 안의 흰 버튼(약 인증하기·길 찾기).
class GoalTimelineButton extends StatelessWidget {
  const GoalTimelineButton({
    super.key,
    required this.label,
    required this.onTap,
    this.icon,
  });

  final String label;
  final VoidCallback onTap;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: MyColor.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 4,
          children: [
            if (icon case final icon?) icon,
            Text(label,
                style: MyTypo.subTitle1.copyWith(color: MyColor.grey900)),
          ],
        ),
      ),
    );
  }
}
