part of '../calendar_tab_view.dart';

class _CalendarGrid extends StatefulWidget {
  const _CalendarGrid({
    required this.format,
    required this.focusedDay,
    required this.selectedDay,
    required this.hasEvent,
    required this.onPageChanged,
    required this.onSelectDay,
  });

  final CalendarFormat format;
  final DateTime focusedDay;
  final DateTime selectedDay;
  final bool Function(DateTime day) hasEvent;
  final ValueChanged<DateTime> onPageChanged;
  final ValueChanged<DateTime> onSelectDay;

  @override
  State<_CalendarGrid> createState() => _CalendarGridState();
}

class _CalendarGridState extends State<_CalendarGrid>
    with SingleTickerProviderStateMixin {
  static const _circleSize = 44.0;
  static const _flightDuration = Duration(milliseconds: 200);
  static const _flightCurve = Cubic(0.2, 0.8, 0.3, 1);

  late final AnimationController _flight = AnimationController(
    vsync: this,
    duration: _flightDuration,
  )..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() => _flightFrom = null);
      }
    });
  DateTime? _flightFrom;

  @override
  void didUpdateWidget(_CalendarGrid oldWidget) {
    super.didUpdateWidget(oldWidget);
    final from = oldWidget.selectedDay;
    final to = widget.selectedDay;
    if (from.isSameDay(to)) return;
    final samePage =
        _pageStart(oldWidget.focusedDay) == _pageStart(widget.focusedDay);
    if (!samePage || !_isVisible(from) || !_isVisible(to)) {
      _flight.stop();
      _flightFrom = null;
      return;
    }
    _flightFrom = from;
    _flight.forward(from: 0);
  }

  @override
  void dispose() {
    _flight.dispose();
    super.dispose();
  }

  DateTime _utcDate(DateTime day) => DateTime.utc(day.year, day.month, day.day);

  DateTime _pageStart(DateTime focusedDay) {
    final base = widget.format == CalendarFormat.month
        ? DateTime.utc(focusedDay.year, focusedDay.month)
        : _utcDate(focusedDay);
    return base.subtract(Duration(days: base.weekday % 7));
  }

  int _indexOf(DateTime day) =>
      _utcDate(day).difference(_pageStart(widget.focusedDay)).inDays;

  bool _isVisible(DateTime day) {
    if (widget.format == CalendarFormat.month) {
      return day.isSameMonth(widget.focusedDay);
    }
    final index = _indexOf(day);
    return index >= 0 && index < 7;
  }

  Offset _centerOf(DateTime day, double width) {
    final index = _indexOf(day);
    return Offset(
      (index % 7 + 0.5) * width / 7,
      _HeaderMetrics.daysOfWeekHeight +
          (index ~/ 7 + 0.5) * _HeaderMetrics.rowHeight,
    );
  }

  @override
  Widget build(BuildContext context) {
    final flightFrom = _flightFrom;
    return LayoutBuilder(
      builder: (context, constraints) => Stack(
        children: [
          if (flightFrom != null)
            AnimatedBuilder(
              animation: _flight,
              builder: (context, child) {
                final center = Offset.lerp(
                  _centerOf(flightFrom, constraints.maxWidth),
                  _centerOf(widget.selectedDay, constraints.maxWidth),
                  _flightCurve.transform(_flight.value),
                )!;
                return Positioned(
                  left: center.dx - _circleSize / 2,
                  top: center.dy - _circleSize / 2,
                  child: child!,
                );
              },
              child: Container(
                width: _circleSize,
                height: _circleSize,
                decoration: const BoxDecoration(
                  color: MyColor.primary,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          TableCalendar(
            locale: 'ko_KR',
            headerVisible: false,
            focusedDay: widget.focusedDay,
            firstDay: CalendarConfig.firstDay,
            lastDay: CalendarConfig.lastDay,
            calendarFormat: widget.format,
            formatAnimationDuration: Duration.zero,
            availableGestures: AvailableGestures.horizontalSwipe,
            sixWeekMonthsEnforced: true,
            rowHeight: _HeaderMetrics.rowHeight,
            daysOfWeekHeight: _HeaderMetrics.daysOfWeekHeight,
            daysOfWeekStyle: DaysOfWeekStyle(
              weekdayStyle: MyTypo.body2.copyWith(color: MyColor.grey500),
              weekendStyle: MyTypo.body2.copyWith(color: MyColor.grey500),
            ),
            calendarStyle: const CalendarStyle(
              outsideDaysVisible: false,
              markersMaxCount: 0,
            ),
            onPageChanged: widget.onPageChanged,
            calendarBuilders: CalendarBuilders<dynamic>(
              prioritizedBuilder: (context, date, _) => _CalendarDayCell(
                date: date,
                isSelected: date.isSameDay(widget.selectedDay),
                showCircle: flightFrom == null,
                hasEvents: widget.hasEvent(date),
                onTap: () => widget.onSelectDay(date),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CalendarDayCell extends StatelessWidget {
  const _CalendarDayCell({
    required this.date,
    required this.isSelected,
    required this.showCircle,
    required this.hasEvents,
    required this.onTap,
  });

  final DateTime date;
  final bool isSelected;
  final bool showCircle;
  final bool hasEvents;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isToday = date.isSameDay(CalendarConfig.today);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color:
              isSelected && showCircle ? MyColor.primary : Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: Container(
          width: 28,
          height: 28,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color:
                !isSelected && isToday ? MyColor.orange100 : Colors.transparent,
            shape: BoxShape.circle,
          ),
          child: TweenAnimationBuilder<Color?>(
            tween: ColorTween(
              end: isSelected
                  ? MyColor.white
                  : hasEvents
                      ? MyColor.primary
                      : MyColor.grey700,
            ),
            duration: _CalendarGridState._flightDuration,
            builder: (context, color, _) => Text(
              date.day.toString(),
              style: MyTypo.body1.copyWith(color: color),
            ),
          ),
        ),
      ),
    );
  }
}
