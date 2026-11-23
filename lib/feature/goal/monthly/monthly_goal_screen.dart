import 'dart:async';
import 'dart:math' as math;

import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:widyu/app/route/app_route.dart';
import 'package:widyu/core/di/providers.dart';
import 'package:widyu/core/model/goal/hospital/daily_health_schedule.dart';
import 'package:widyu/core/model/goal/monthly/daily_medicine_schedule.dart';
import 'package:widyu/core/ui/theme/colors.dart';
import 'package:widyu/core/ui/theme/typos.dart';
import 'package:widyu/core/ui/widget/bot_nav.dart';
import 'package:widyu/core/ui/widget/custom_app_bar.dart';
import 'package:widyu/core/ui/widget/medication_reward_dialog.dart';
import 'package:widyu/core/ui/widget/widu_icon.dart';
import 'package:widyu/core/ui/widget/widyu_text_button.dart';
import 'package:widyu/core/util/extension/date_extension.dart';
import 'package:widyu/core/util/medication_verification_launcher.dart';
import 'package:widyu/feature/goal/monthly/monthly_goal_ui_state.dart';
import 'package:widyu/feature/goal/monthly/monthly_goal_view_model.dart';
import 'package:widyu/feature/goal/widget/health_timeline_card.dart';
import 'package:widyu/feature/goal/widget/medicine_timeline_card.dart';
import 'package:widyu/feature/goal/widget/walk_donut_card.dart';
import 'package:widyu/gen/assets.gen.dart';

part 'widget/monthly_calendar.dart';
part 'widget/monthly_goal_day_view.dart';

class MonthlyGoalScreen extends ConsumerStatefulWidget {
  const MonthlyGoalScreen({super.key});

  @override
  ConsumerState<MonthlyGoalScreen> createState() => _MonthlyGoalScreenState();
}

class _MonthlyGoalScreenState extends ConsumerState<MonthlyGoalScreen>
    with SingleTickerProviderStateMixin {
  static const _snapDuration = Duration(milliseconds: 250);
  static const _flingVelocityThreshold = 200.0;

  /// 0이면 한 달, 1이면 한 주로 접힌 달력.
  late final AnimationController _shrink;

  @override
  void initState() {
    super.initState();
    _shrink = AnimationController(vsync: this, duration: _snapDuration);
  }

  @override
  void dispose() {
    _shrink.dispose();
    super.dispose();
  }

  double _range(DateTime month) =>
      _CalendarMetrics.monthGridHeight(month) - _CalendarMetrics.weekGridHeight;

  void _applyShrinkDelta(double delta) {
    // 레이아웃 도중 스크롤 알림으로 값을 바꾸면 같은 프레임에 다시 그려야 해서 건너뛴다.
    if (SchedulerBinding.instance.schedulerPhase ==
        SchedulerPhase.persistentCallbacks) {
      return;
    }
    if (_shrink.isAnimating) _shrink.stop();
    if (_shrink.value == 0 && delta > 0) {
      ref.read(monthlyGoalViewModelProvider.notifier).showSelectedMonth();
    }
    final range = _range(ref.read(monthlyGoalViewModelProvider).focusedMonth);
    _shrink.value = (_shrink.value + delta / range).clamp(0.0, 1.0);
  }

  void _snap({double velocity = 0}) {
    final double target;
    if (velocity.abs() < _flingVelocityThreshold) {
      target = _shrink.value < 0.5 ? 0 : 1;
    } else {
      target = velocity > 0 ? 1 : 0;
    }
    if ((target - _shrink.value).abs() < 0.001) return;
    _shrink.animateTo(target,
        duration: _snapDuration, curve: Curves.easeOutCubic);
  }

  /// 일정 목록 드래그를 달력이 먼저 받는다. 위로 밀면 달력을 다 접은 뒤에 목록이 스크롤되고,
  /// 아래로 당기면 목록이 맨 위일 때 달력을 편다. 달력이 받고 남은 만큼을 돌려준다.
  double _consumeScroll(double offset, ScrollMetrics position) {
    final range = _range(ref.read(monthlyGoalViewModelProvider).focusedMonth);
    final double taken;
    if (offset < 0) {
      taken = -math.min(-offset, (1 - _shrink.value) * range);
    } else if (offset > 0 && position.pixels <= position.minScrollExtent) {
      taken = math.min(offset, _shrink.value * range);
    } else {
      return offset;
    }
    if (taken != 0) _applyShrinkDelta(-taken);
    return offset - taken;
  }

  // 달력이 접히다 만 채로 손을 떼면 목록은 관성으로 움직이지 않고 달력만 맞춘다.
  bool get _isShrinkMidway => _shrink.value > 0 && _shrink.value < 1;

  bool _handleScroll(ScrollNotification notification) {
    if (notification.depth != 0) return false;
    if (notification case ScrollEndNotification(:final dragDetails)) {
      _snap(velocity: -(dragDetails?.primaryVelocity ?? 0));
    }
    return false;
  }

  void _changeMonth(DateTime month) {
    // 접힌 주 달력은 선택한 날의 주라서 다른 달로 넘기면 펼쳐서 보여 준다.
    if (_shrink.value > 0) {
      _shrink.animateTo(0, duration: _snapDuration, curve: Curves.easeInOut);
    }
    ref.read(monthlyGoalViewModelProvider.notifier).onPageChanged(month);
  }

  void _goToday() {
    ref.read(monthlyGoalViewModelProvider.notifier).goToday();
    _shrink.animateTo(0, duration: _snapDuration, curve: Curves.easeInOut);
  }

  Future<void> _verify(DateTime date, DailyMedicineSchedule schedule) async {
    final count = schedule.totalCount;
    final result = await openMedicationForSchedule(
      context,
      schedule.medicineScheduleId,
      date,
      doseCount: count != null && count == count.roundToDouble()
          ? count.toInt()
          : null,
    );
    if (result == null || !mounted) return;
    unawaited(showDialog<void>(
      context: context,
      builder: (context) => MedicationRewardDialog(
        earnedPoint: result.earnedPoints,
        currentPoint: result.currentPoints,
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(monthlyGoalViewModelProvider.notifier);
    final bottomInset = BotNav.height + MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: MyColor.white,
      appBar: CustomAppBar(
        title: '월간 목표',
        actions: [
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () => context.push(AppRoute.notification.path),
            child: WiduIcon(
              icon: Assets.icons.ic22Notification,
              width: 22,
              color: MyColor.grey600,
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onVerticalDragUpdate: (details) =>
                    _applyShrinkDelta(-details.delta.dy),
                onVerticalDragEnd: (details) =>
                    _snap(velocity: -(details.primaryVelocity ?? 0)),
                child: Consumer(
                  builder: (context, ref, _) {
                    final calendar = ref.watch(
                      monthlyGoalViewModelProvider.select(
                        (s) => (
                          s.today,
                          s.focusedMonth,
                          s.selectedDay,
                          s.healthDays,
                          s.firstMonth,
                          s.lastMonth,
                        ),
                      ),
                    );
                    return AnimatedBuilder(
                      animation: _shrink,
                      builder: (context, _) => _MonthlyCalendar(
                        today: calendar.$1,
                        focusedMonth: calendar.$2,
                        selectedDay: calendar.$3,
                        healthDays: calendar.$4,
                        firstMonth: calendar.$5,
                        lastMonth: calendar.$6,
                        shrink: _shrink.value,
                        onMonthChanged: _changeMonth,
                        onSelectDay: viewModel.selectDay,
                      ),
                    );
                  },
                ),
              ),
              Expanded(
                child: NotificationListener<ScrollNotification>(
                  onNotification: _handleScroll,
                  child: _MonthlyGoalDayView(
                    physics: _CalendarFirstScrollPhysics(
                      consume: _consumeScroll,
                      holdFling: () => _isShrinkMidway,
                    ),
                    bottomInset: bottomInset,
                    onRetry: viewModel.retry,
                    onVerify: _verify,
                    onFindRoute: viewModel.findRoute,
                  ),
                ),
              ),
            ],
          ),
          // 오늘이 아닌 날을 고르거나 다른 달을 보고 있으면 오늘로 돌아가는 버튼을 띄운다.
          Positioned(
            left: 0,
            right: 0,
            bottom: bottomInset + 16,
            child: Consumer(
              builder: (context, ref, child) {
                final visible = ref.watch(
                  monthlyGoalViewModelProvider.select(
                    (s) =>
                        !s.selectedDay.isSameDay(s.today) ||
                        !s.focusedMonth.isSameMonth(s.today),
                  ),
                );
                return IgnorePointer(
                  ignoring: !visible,
                  child: AnimatedOpacity(
                    opacity: visible ? 1 : 0,
                    duration: _snapDuration,
                    child: child,
                  ),
                );
              },
              child: Center(child: _BackToTodayButton(onTap: _goToday)),
            ),
          ),
        ],
      ),
    );
  }
}

class _BackToTodayButton extends StatelessWidget {
  const _BackToTodayButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: MyColor.grey900,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          '오늘로 돌아가기',
          style: MyTypo.subTitle2.copyWith(color: MyColor.white),
        ),
      ),
    );
  }
}

class _CalendarFirstScrollPhysics extends ScrollPhysics {
  const _CalendarFirstScrollPhysics({
    required this.consume,
    required this.holdFling,
    super.parent,
  });

  final double Function(double offset, ScrollMetrics position) consume;
  final bool Function() holdFling;

  @override
  _CalendarFirstScrollPhysics applyTo(ScrollPhysics? ancestor) =>
      _CalendarFirstScrollPhysics(
        consume: consume,
        holdFling: holdFling,
        parent: buildParent(ancestor),
      );

  @override
  double applyPhysicsToUserOffset(ScrollMetrics position, double offset) =>
      super.applyPhysicsToUserOffset(position, consume(offset, position));

  @override
  Simulation? createBallisticSimulation(
    ScrollMetrics position,
    double velocity,
  ) =>
      holdFling() ? null : super.createBallisticSimulation(position, velocity);
}
