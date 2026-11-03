part of '../calendar_tab_view.dart';

class _CalendarHeaderView extends StatelessWidget {
  const _CalendarHeaderView({
    required this.viewModel,
    required this.shrink,
    required this.onHandleTap,
  });

  final CalendarTabViewModel viewModel;
  final double shrink;
  final VoidCallback onHandleTap;

  @override
  Widget build(BuildContext context) {
    final remaining = shrink.clamp(0.0, _HeaderMetrics.shrinkRange);

    final double gridVisibleHeight;
    final double weekOpacity;
    if (remaining <= _HeaderMetrics.monthToWeekBudget) {
      gridVisibleHeight = _HeaderMetrics.gridMaxHeight - remaining;
      weekOpacity = remaining / _HeaderMetrics.monthToWeekBudget;
    } else {
      final afterCrossfade = remaining - _HeaderMetrics.monthToWeekBudget;
      weekOpacity = 1;
      if (afterCrossfade <= _HeaderMetrics.weekHideBudget) {
        gridVisibleHeight = _HeaderMetrics.gridMinHeight - afterCrossfade;
      } else {
        gridVisibleHeight = 0;
      }
    }
    final monthOpacity = 1 - weekOpacity;

    final focusedMonth = viewModel.focusedMonth;
    final selectedDay = viewModel.selectedDay;

    return Column(
      children: [
        const SizedBox(height: _HeaderMetrics.topPadding),
        SizedBox(
          height: _HeaderMetrics.headerHeight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _MonthArrow(
                icon: Assets.icons.ic22ChevronLeft,
                onTap: () => viewModel.onPageChanged(
                  DateTime(focusedMonth.year, focusedMonth.month - 1),
                ),
              ),
              Text(
                '${focusedMonth.year}년 ${focusedMonth.month}월',
                style: MyTypo.title3.copyWith(color: MyColor.grey800),
              ),
              _MonthArrow(
                icon: Assets.icons.ic22ChevronRight,
                onTap: () => viewModel.onPageChanged(
                  DateTime(focusedMonth.year, focusedMonth.month + 1),
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: MyColor.white,
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(20),
            ),
            boxShadow: [
              BoxShadow(
                color: MyColor.black.withValues(alpha: 0.1),
                offset: const Offset(0, 8),
                blurRadius: 10,
              ),
            ],
          ),
          child: Column(
            children: [
              ClipRect(
                child: SizedBox(
                  height: gridVisibleHeight,
                  child: OverflowBox(
                    alignment: Alignment.topCenter,
                    maxHeight: _HeaderMetrics.gridMaxHeight,
                    child: Stack(
                      alignment: Alignment.topCenter,
                      children: [
                        IgnorePointer(
                          ignoring: monthOpacity == 0,
                          child: Opacity(
                            opacity: monthOpacity,
                            child: _CalendarGrid(
                              viewModel: viewModel,
                              format: CalendarFormat.month,
                              focusedDay: focusedMonth,
                              selectedDay: selectedDay,
                            ),
                          ),
                        ),
                        IgnorePointer(
                          ignoring: weekOpacity == 0,
                          child: Opacity(
                            opacity: weekOpacity,
                            child: _CalendarGrid(
                              viewModel: viewModel,
                              format: CalendarFormat.week,
                              focusedDay: selectedDay,
                              selectedDay: selectedDay,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: onHandleTap,
                child: const Padding(
                  padding: EdgeInsets.fromLTRB(0, 21, 0, 8),
                  child: _CalendarHandle(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CalendarHandle extends StatelessWidget {
  const _CalendarHandle();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 3,
      decoration: BoxDecoration(
        color: MyColor.grey200,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}

class _MonthArrow extends StatelessWidget {
  const _MonthArrow({required this.icon, required this.onTap});

  final SvgGenImage icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: WiduIcon(icon: icon, width: 22, color: MyColor.grey600),
      ),
    );
  }
}
