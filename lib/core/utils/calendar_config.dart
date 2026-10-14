abstract class CalendarConfig {
  static final DateTime today = DateTime.now();
  static final DateTime firstDay = DateTime(today.year - 5, 1, 1);
  static final DateTime lastDay = DateTime(today.year + 5, 12, 31);
}
