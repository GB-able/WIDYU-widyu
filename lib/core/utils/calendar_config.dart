import 'package:clock/clock.dart';

abstract class CalendarConfig {
  static DateTime get today => clock.now();
  static final DateTime firstDay = DateTime(today.year - 5);
  static final DateTime lastDay = DateTime(today.year + 5, 12, 31);
}
