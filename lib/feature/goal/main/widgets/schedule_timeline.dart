part of '../goal_screen.dart';

/// 시간이 지나 예정 → 인증 가능 → 미인증으로 바뀌는 상태를 반영하려고
/// 타임라인만 주기적으로 다시 그린다. 화면 밖 탭이면(TickerMode 꺼짐) 그리지 않는다.
class _ScheduleTimeline extends StatefulWidget {
  const _ScheduleTimeline({
    required this.medicine,
    required this.visits,
    required this.onMedicationVerified,
    required this.findRoute,
  });

  final Medication? medicine;
  final List<DailyHealthSchedule> visits;
  final ValueChanged<MedicationPointResult> onMedicationVerified;
  final ValueChanged<DailyHealthSchedule> findRoute;

  @override
  State<_ScheduleTimeline> createState() => _ScheduleTimelineState();
}

class _ScheduleTimelineState extends State<_ScheduleTimeline> {
  late final Timer _timer;
  bool _visible = true;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 30), (_) {
      if (_visible) setState(() {});
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Future<void> _verify(DoseSchedule dose) async {
    final result = await openMedicationForSchedule(
      context,
      dose.scheduleId,
      clock.now(),
      doseCount: dose.doseCount,
    );
    if (result != null) widget.onMedicationVerified(result);
  }

  @override
  Widget build(BuildContext context) {
    _visible = TickerMode.of(context);
    final schedules = buildGoalSchedules(
      medicine: widget.medicine,
      visits: widget.visits,
      now: clock.now(),
    );

    if (schedules.isEmpty) {
      return Text(
        '오늘은 예정된 일정이 없어요.',
        style: MyTypo.body1.copyWith(color: MyColor.grey500),
      );
    }

    return GoalTimeline(
      items: [
        for (final schedule in schedules)
          switch (schedule) {
            DoseSchedule() => _doseItem(schedule),
            VisitSchedule() => _visitItem(schedule),
          },
      ],
    );
  }

  GoalTimelineItem _doseItem(DoseSchedule dose) {
    final isActive = dose.status == TimelineStatus.active;
    return GoalTimelineItem(
      status: dose.status,
      leading: IconTile(type: GoalType.medicine, size: isActive ? 40 : 24),
      title: Row(
        spacing: 12,
        children: [
          _TimeText(_timeLabel(dose.at)),
          Text(
            '${dose.doseCount}정',
            style: isActive ? null : const TextStyle(color: MyColor.primary),
          ),
        ],
      ),
      action: GoalTimelineButton(
        label: '약 인증하기',
        icon: WiduIcon(
          icon: Assets.icons.ic24CameraAdd,
          width: 24,
          color: MyColor.grey800,
        ),
        onTap: () => _verify(dose),
      ),
    );
  }

  GoalTimelineItem _visitItem(VisitSchedule schedule) {
    final visit = schedule.visit;
    final isActive = schedule.status == TimelineStatus.active;
    return GoalTimelineItem(
      status: schedule.status,
      leading: IconTile(type: GoalType.hospital, size: isActive ? 40 : 24),
      title: Row(
        spacing: 12,
        children: [
          _TimeText(_timeLabel(schedule.at)),
          Flexible(
            child: Text(
              visit.scheduleName,
              overflow: TextOverflow.ellipsis,
              style: isActive ? null : const TextStyle(color: MyColor.grey600),
            ),
          ),
        ],
      ),
      subtitle: visit.placeAddress,
      action: GoalTimelineButton(
        label: '길 찾기',
        onTap: () => widget.findRoute(visit),
      ),
    );
  }
}

String _timeLabel(DateTime at) {
  final hour = at.hour % 12 == 0 ? 12 : at.hour % 12;
  final minute = at.minute.toString().padLeft(2, '0');
  return '${at.hour < 12 ? '오전' : '오후'} $hour:$minute';
}

class _TimeText extends StatelessWidget {
  const _TimeText(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    // 시각 너비를 맞춰 옆 글자(정 수·일정 이름)가 줄마다 같은 자리에서 시작하게 한다.
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 72),
      child: Text(text),
    );
  }
}
