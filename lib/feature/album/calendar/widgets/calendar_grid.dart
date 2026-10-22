part of '../calendar_tab_view.dart';

class _CalendarGrid extends StatelessWidget {
  const _CalendarGrid({
    required this.viewModel,
    required this.format,
    required this.focusedDay,
    required this.selectedDay,
  });

  final CalendarTabViewModel viewModel;
  final CalendarFormat format;
  final DateTime focusedDay;
  final DateTime selectedDay;

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      locale: 'ko_KR',
      headerVisible: false,
      focusedDay: focusedDay,
      firstDay: CalendarConfig.firstDay,
      lastDay: CalendarConfig.lastDay,
      calendarFormat: format,
      formatAnimationDuration: Duration.zero,
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
      onPageChanged: viewModel.onPageChanged,
      calendarBuilders: CalendarBuilders<dynamic>(
        prioritizedBuilder: (context, date, _) => _CalendarDayCell(
          date: date,
          isSelected: date.isSameDay(selectedDay),
          hasEvents: viewModel.hasEvent(date),
          onTap: () => viewModel.selectDay(date),
        ),
      ),
    );
  }
}

class _CalendarDayCell extends StatelessWidget {
  const _CalendarDayCell({
    required this.date,
    required this.isSelected,
    required this.hasEvents,
    required this.onTap,
  });

  final DateTime date;
  final bool isSelected;
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
          color: isSelected ? MyColor.primary : Colors.transparent,
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
          child: Text(
            date.day.toString(),
            style: MyTypo.body1.copyWith(
              color: isSelected
                  ? MyColor.white
                  : hasEvents
                      ? MyColor.primary
                      : MyColor.grey700,
            ),
          ),
        ),
      ),
    );
  }
}
