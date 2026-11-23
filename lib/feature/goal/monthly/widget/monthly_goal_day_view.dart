part of '../monthly_goal_screen.dart';

class _MonthlyGoalDayView extends ConsumerWidget {
  const _MonthlyGoalDayView({
    required this.physics,
    required this.bottomInset,
    required this.onRetry,
    required this.onVerify,
    required this.onFindRoute,
  });

  static const _swapDuration = Duration(milliseconds: 250);

  final ScrollPhysics physics;
  final double bottomInset;
  final VoidCallback onRetry;
  final void Function(DateTime date, DailyMedicineSchedule schedule) onVerify;
  final ValueChanged<DailyHealthSchedule> onFindRoute;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final (day, isLoading, hasError) = ref.watch(
      monthlyGoalViewModelProvider.select(
        (s) => (s.day, s.isDayLoading, s.hasDayError),
      ),
    );

    final Widget content;
    final Key key;
    if (hasError) {
      key = const ValueKey('error');
      content = _DayError(onRetry: onRetry);
    } else if (day == null) {
      key = const ValueKey('loading');
      content = isLoading
          ? const Padding(
              padding: EdgeInsets.symmetric(vertical: 48),
              child: Center(child: CircularProgressIndicator()),
            )
          : const SizedBox.shrink();
    } else {
      // 새 날짜를 다 불러온 뒤에 바꿔 끼워야 빈 화면이 밀려 들어오지 않는다.
      key = ValueKey(day.date);
      content = _TodayTicker(
        enabled: day.date.isSameDay(clock.now()),
        builder: (_) => _DayCards(
          day: day,
          onVerify: onVerify,
          onFindRoute: onFindRoute,
        ),
      );
    }

    return DecoratedBox(
      decoration: const BoxDecoration(
        color: MyColor.grey100,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        child: SingleChildScrollView(
          physics: physics.applyTo(
            const AlwaysScrollableScrollPhysics(
              parent: ClampingScrollPhysics(),
            ),
          ),
          padding: EdgeInsets.fromLTRB(16, 24, 16, bottomInset + 24),
          child: AnimatedSwitcher(
            duration: _swapDuration,
            switchInCurve: Curves.easeOutCubic,
            switchOutCurve: Curves.easeOutCubic,
            layoutBuilder: (current, previous) => Stack(
              alignment: Alignment.topCenter,
              children: [...previous, if (current != null) current],
            ),
            // 들어오는 날은 오른쪽에서, 나가는 날은 왼쪽으로 민다.
            transitionBuilder: (child, animation) => SlideTransition(
              position: Tween(
                begin: Offset(child.key == key ? 1 : -1, 0),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            ),
            child: KeyedSubtree(key: key, child: content),
          ),
        ),
      ),
    );
  }
}

/// 오늘이면 인증 시간이 열리고 닫히는 걸 반영하려고 30초마다 다시 그린다(목표 메인과 같은 주기).
/// 화면 밖 탭이면(TickerMode 꺼짐) 그리지 않는다.
class _TodayTicker extends StatefulWidget {
  const _TodayTicker({required this.enabled, required this.builder});

  final bool enabled;
  final WidgetBuilder builder;

  @override
  State<_TodayTicker> createState() => _TodayTickerState();
}

class _TodayTickerState extends State<_TodayTicker> {
  late final Timer _timer;
  bool _visible = true;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 30), (_) {
      if (widget.enabled && _visible) setState(() {});
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _visible = TickerMode.of(context);
    return widget.builder(context);
  }
}

class _DayCards extends StatelessWidget {
  const _DayCards({
    required this.day,
    required this.onVerify,
    required this.onFindRoute,
  });

  final MonthlyGoalDay day;
  final void Function(DateTime date, DailyMedicineSchedule schedule) onVerify;
  final ValueChanged<DailyHealthSchedule> onFindRoute;

  @override
  Widget build(BuildContext context) {
    final date = day.date;
    final isToday = date.isSameDay(clock.now());
    final walkGoal = day.walk?.goal ?? 0;
    final isEmpty =
        day.medicines.isEmpty && day.healthSchedules.isEmpty && walkGoal <= 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 16,
      children: [
        Text(
          '${date.month}월 ${date.day}일',
          style: MyTypo.title1.copyWith(color: MyColor.grey800),
        ),
        if (day.medicines.isNotEmpty)
          MedicineTimelineCard(
            date: date,
            schedules: day.medicines,
            onVerify: (schedule) => onVerify(date, schedule),
          ),
        if (day.healthSchedules.isNotEmpty)
          HealthTimelineCard(
            date: date,
            schedules: day.healthSchedules,
            onFindRoute: onFindRoute,
          ),
        if (walkGoal > 0)
          isToday
              // 오늘 걸음은 서버보다 기기 값이 최신이다.
              ? Consumer(
                  builder: (context, ref, _) => WalkDonutCard(
                    actual: ref.watch(todayStepsProvider),
                    goal: walkGoal,
                  ),
                )
              : WalkDonutCard(actual: day.walk?.actual ?? 0, goal: walkGoal),
        if (isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 48),
            child: Text(
              '이 날은 목표가 없어요.',
              textAlign: TextAlign.center,
              style: MyTypo.body1.copyWith(color: MyColor.grey500),
            ),
          ),
      ],
    );
  }
}

class _DayError extends StatelessWidget {
  const _DayError({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Column(
        spacing: 12,
        children: [
          Text(
            '목표를 불러오지 못했어요.',
            style: MyTypo.body1.copyWith(color: MyColor.grey600),
          ),
          SizedBox(
            width: 160,
            child: WidyuTextButton(text: '다시 시도', onTap: onRetry),
          ),
        ],
      ),
    );
  }
}
