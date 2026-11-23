part of '../monthly_goal_screen.dart';

abstract class _CalendarMetrics {
  static const verticalPadding = 16.0;
  static const headerHeight = 30.0;
  static const daysOfWeekHeight = 43.0;
  static const cellHeight = 54.0;
  static const rowGap = 8.0;
  static const rowHeight = cellHeight + rowGap;

  /// 일요일 시작 기준 그 달의 주 수(4~6).
  static int weeksOf(DateTime month) {
    final leading = DateTime(month.year, month.month).weekday % 7;
    return ((leading + month.endOfMonthDay) / 7).ceil();
  }

  // 마지막 줄 아래 간격은 아래 여백이 대신한다.
  static double monthGridHeight(DateTime month) =>
      daysOfWeekHeight + rowHeight * weeksOf(month) - rowGap;

  static const weekGridHeight = daysOfWeekHeight + cellHeight;

  /// table_calendar는 마지막 줄 아래 간격까지 그린다.
  static const sixWeekGridHeight = daysOfWeekHeight + rowHeight * 6;
}

class _MonthlyCalendar extends StatelessWidget {
  const _MonthlyCalendar({
    required this.today,
    required this.focusedMonth,
    required this.selectedDay,
    required this.healthDays,
    required this.firstMonth,
    required this.lastMonth,
    required this.shrink,
    required this.onMonthChanged,
    required this.onSelectDay,
  });

  final DateTime today;
  final DateTime focusedMonth;
  final DateTime selectedDay;
  final Set<DateTime> healthDays;
  final DateTime firstMonth;
  final DateTime lastMonth;

  /// 0이면 한 달, 1이면 선택한 날의 한 주.
  final double shrink;
  final ValueChanged<DateTime> onMonthChanged;
  final ValueChanged<DateTime> onSelectDay;

  @override
  Widget build(BuildContext context) {
    final monthHeight = _CalendarMetrics.monthGridHeight(focusedMonth);
    final gridHeight =
        monthHeight - (monthHeight - _CalendarMetrics.weekGridHeight) * shrink;
    final canGoBack = focusedMonth.isAfter(firstMonth);
    final canGoForward = focusedMonth.isBefore(lastMonth);

    // 접힌 주에는 이웃 달의 날짜도 보이므로 달과 상관없이 날짜로 찾는다.
    bool hasHealth(DateTime day) => healthDays.contains(day.onlyDateTime);

    Widget grid(CalendarFormat format, DateTime focusedDay) => _CalendarGrid(
          format: format,
          focusedDay: focusedDay,
          today: today,
          selectedDay: selectedDay,
          firstDay: firstMonth,
          lastDay: DateTime(lastMonth.year, lastMonth.month + 1, 0),
          hasHealth: hasHealth,
          onPageChanged: onMonthChanged,
          onSelectDay: onSelectDay,
        );

    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: _CalendarMetrics.verticalPadding,
      ),
      child: Column(
        children: [
          SizedBox(
            height: _CalendarMetrics.headerHeight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _MonthArrow(
                  icon: Assets.icons.ic22ChevronLeft,
                  visible: canGoBack,
                  onTap: () => onMonthChanged(
                    DateTime(focusedMonth.year, focusedMonth.month - 1),
                  ),
                ),
                Text(
                  '${focusedMonth.year}년 ${focusedMonth.month}월',
                  style: MyTypo.title2.copyWith(color: MyColor.grey800),
                ),
                _MonthArrow(
                  icon: Assets.icons.ic22ChevronRight,
                  visible: canGoForward,
                  onTap: () => onMonthChanged(
                    DateTime(focusedMonth.year, focusedMonth.month + 1),
                  ),
                ),
              ],
            ),
          ),
          ClipRect(
            child: SizedBox(
              height: gridHeight,
              child: OverflowBox(
                alignment: Alignment.topCenter,
                // 모든 달을 6주로 그려, 줄 수가 다른 달로 넘기는 동안에도 줄 높이를 유지한다.
                // 높이가 제한되면 table_calendar가 그 높이를 페이지의 줄 수로 나누기 때문이다.
                maxHeight: _CalendarMetrics.sixWeekGridHeight,
                child: Stack(
                  children: [
                    IgnorePointer(
                      ignoring: shrink > 0,
                      child: Opacity(
                        opacity: 1 - shrink,
                        child: grid(CalendarFormat.month, focusedMonth),
                      ),
                    ),
                    if (shrink > 0)
                      IgnorePointer(
                        ignoring: shrink < 1,
                        child: Opacity(
                          opacity: shrink,
                          child: grid(CalendarFormat.week, selectedDay),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CalendarGrid extends StatefulWidget {
  const _CalendarGrid({
    required this.format,
    required this.focusedDay,
    required this.today,
    required this.selectedDay,
    required this.firstDay,
    required this.lastDay,
    required this.hasHealth,
    required this.onPageChanged,
    required this.onSelectDay,
  });

  final CalendarFormat format;
  final DateTime focusedDay;
  final DateTime today;
  final DateTime selectedDay;
  final DateTime firstDay;
  final DateTime lastDay;
  final bool Function(DateTime day) hasHealth;
  final ValueChanged<DateTime> onPageChanged;
  final ValueChanged<DateTime> onSelectDay;

  @override
  State<_CalendarGrid> createState() => _CalendarGridState();
}

class _CalendarGridState extends State<_CalendarGrid> {
  /// 달력 페이지의 스크롤 위치. 선택 원을 페이지와 함께 옮기는 데 쓴다.
  PageController? _pages;

  void _onCalendarCreated(PageController pages) {
    // table_calendar가 빌드 중에 넘겨주므로 다음 프레임에 반영한다.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) setState(() => _pages = pages);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isMonth = widget.format == CalendarFormat.month;
    final weekdayStyle = MyTypo.body2.copyWith(color: MyColor.grey500);
    final selected = widget.selectedDay;
    final pages = _pages;

    return Stack(
      children: [
        // 선택 원은 날짜 칸 아래에 따로 두고, 고른 칸으로 미끄러지듯 옮긴다.
        Positioned.fill(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final dot = _SelectionDot(
                // 다른 달·주의 날을 고르면 새로 만들어 움직이지 않고 그 자리에 놓는다.
                key: ValueKey(
                  isMonth
                      ? DateTime(selected.year, selected.month)
                      : selected.onlyDateTime
                          .subtract(Duration(days: selected.weekday % 7)),
                ),
                offset: _offsetOf(constraints.maxWidth, isMonth),
              );
              // 접힌 주 달력은 넘기지 않으므로 페이지를 따라갈 필요가 없다.
              if (!isMonth || pages == null) return dot;
              // 선택한 날이 있는 달 페이지에 붙여, 달을 넘기면 페이지와 함께 밀려 나간다.
              // table_calendar는 빌드 중에 페이지를 옮기므로 다시 빌드하지 않고 그리는 위치만 바꾼다.
              final selectedPage = (selected.year - widget.firstDay.year) * 12 +
                  selected.month -
                  widget.firstDay.month;
              return Flow(
                delegate: _FollowPageDelegate(pages, selectedPage),
                children: [dot],
              );
            },
          ),
        ),
        TableCalendar<void>(
          locale: 'ko_KR',
          headerVisible: false,
          focusedDay: widget.focusedDay,
          firstDay: widget.firstDay,
          lastDay: widget.lastDay,
          calendarFormat: widget.format,
          formatAnimationDuration: Duration.zero,
          // 접힌 주 달력은 선택한 날을 따라가므로 넘기지 않는다. 달은 화살표로 바꾼다.
          availableGestures: isMonth
              ? AvailableGestures.horizontalSwipe
              : AvailableGestures.none,
          sixWeekMonthsEnforced: isMonth,
          rowHeight: isMonth
              ? _CalendarMetrics.rowHeight
              : _CalendarMetrics.cellHeight,
          daysOfWeekHeight: _CalendarMetrics.daysOfWeekHeight,
          daysOfWeekStyle: DaysOfWeekStyle(
            weekdayStyle: weekdayStyle,
            weekendStyle: weekdayStyle,
          ),
          calendarStyle: const CalendarStyle(
            outsideDaysVisible: false,
            markersMaxCount: 0,
          ),
          onPageChanged: widget.onPageChanged,
          onCalendarCreated: _onCalendarCreated,
          calendarBuilders: CalendarBuilders<void>(
            prioritizedBuilder: (context, date, _) {
              // table_calendar는 날짜를 UTC로 넘기므로 날짜만 떼어 비교한다.
              final day = date.onlyDateTime;
              final isEnabled = !day.isBefore(widget.firstDay) &&
                  !day.isAfter(widget.lastDay);
              return _CalendarDayCell(
                date: date,
                isToday: date.isSameDay(widget.today),
                isSelected: date.isSameDay(widget.selectedDay),
                hasHealth: widget.hasHealth(date),
                onTap: isEnabled ? () => widget.onSelectDay(date) : null,
              );
            },
          ),
        ),
      ],
    );
  }

  /// 일요일 시작 달력에서 선택한 날 칸의 왼쪽 위 좌표. 원은 칸 위쪽 가운데에 그린다.
  Offset _offsetOf(double width, bool isMonth) {
    final selected = widget.selectedDay;
    final index = isMonth
        ? DateTime(selected.year, selected.month).weekday % 7 + selected.day - 1
        : selected.weekday % 7;
    final cellWidth = width / 7;
    return Offset(
      cellWidth * (index % 7) + (cellWidth - _SelectionDot.size) / 2,
      _CalendarMetrics.daysOfWeekHeight +
          _CalendarMetrics.rowHeight * (index ~/ 7),
    );
  }
}

/// 선택 원을 [selectedPage] 페이지가 밀린 만큼 옆으로 옮겨 그린다.
class _FollowPageDelegate extends FlowDelegate {
  _FollowPageDelegate(this.pages, this.selectedPage) : super(repaint: pages);

  final PageController pages;
  final int selectedPage;

  @override
  void paintChildren(FlowPaintingContext context) {
    final page = pages.hasClients && pages.position.hasContentDimensions
        ? pages.page ?? selectedPage.toDouble()
        : selectedPage.toDouble();
    context.paintChild(
      0,
      transform: Matrix4.translationValues(
        (selectedPage - page) * context.size.width,
        0,
        0,
      ),
    );
  }

  @override
  bool shouldRepaint(_FollowPageDelegate oldDelegate) =>
      oldDelegate.pages != pages || oldDelegate.selectedPage != selectedPage;
}

class _SelectionDot extends StatelessWidget {
  const _SelectionDot({
    super.key,
    required this.offset,
  });

  static const size = 28.0;
  static const _duration = Duration(milliseconds: 200);
  static const _curve = Cubic(0.2, 0.8, 0.3, 1);

  final Offset offset;

  @override
  Widget build(BuildContext context) {
    final duration =
        MediaQuery.disableAnimationsOf(context) ? Duration.zero : _duration;
    return Stack(
      children: [
        AnimatedPositioned(
          duration: duration,
          curve: _curve,
          left: offset.dx,
          top: offset.dy,
          child: const DecoratedBox(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: MyColor.primary,
            ),
            child: SizedBox.square(dimension: size),
          ),
        ),
      ],
    );
  }
}

class _CalendarDayCell extends StatelessWidget {
  const _CalendarDayCell({
    required this.date,
    required this.isToday,
    required this.isSelected,
    required this.hasHealth,
    required this.onTap,
  });

  final DateTime date;
  final bool isToday;
  final bool isSelected;
  final bool hasHealth;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    // 선택한 날의 진한 주황 원은 [_SelectionDot]이 그린다. 오늘은 선택되지 않았을 때만 연한 주황으로 칠한다.

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Align(
        alignment: Alignment.topCenter,
        child: SizedBox(
          height: _CalendarMetrics.cellHeight,
          child: Column(
            spacing: 4,
            children: [
              Container(
                width: _SelectionDot.size,
                height: _SelectionDot.size,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isToday && !isSelected
                      ? MyColor.orange200
                      : Colors.transparent,
                ),
                child: AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 200),
                  style: MyTypo.body1.copyWith(
                    color: isSelected ? MyColor.white : MyColor.grey800,
                  ),
                  child: Text('${date.day}'),
                ),
              ),
              if (hasHealth)
                Container(
                  width: 22,
                  height: 22,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: MyColor.grey100,
                  ),
                  child: Assets.images.img24Health.image(width: 16, height: 16),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MonthArrow extends StatelessWidget {
  const _MonthArrow({
    required this.icon,
    required this.visible,
    required this.onTap,
  });

  final SvgGenImage icon;
  final bool visible;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    // 끝 달에서는 화살표를 숨기되 자리는 남겨 제목이 움직이지 않게 한다.
    return IgnorePointer(
      ignoring: !visible,
      child: Opacity(
        opacity: visible ? 1 : 0,
        child: GestureDetector(
          onTap: onTap,
          behavior: HitTestBehavior.opaque,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: WiduIcon(icon: icon, width: 22, color: MyColor.grey600),
          ),
        ),
      ),
    );
  }
}
