extension StringExtension on String {
  String get formattedPhoneNumber {
    if (length != 11) return this;
    return '${substring(0, 3)}-${substring(3, 7)}-${substring(7)}';
  }

  String get twelveHourTime {
    try {
      final times = split(':');
      final hour = int.tryParse(times[0]);
      final minute = times[1];
      final isAfternoon = hour! >= 12;

      return "${isAfternoon ? '오후' : '오전'} ${hour % 12 == 0 ? 12 : hour % 12}:$minute";
    } catch (e) {
      return e.toString();
    }
  }

  DateTime? toAlarmAt(DateTime day) {
    if (isEmpty) return null;

    final parts = split(':');
    if (parts.length < 2) return null;

    final hour = int.tryParse(parts[0]);
    final minute = int.tryParse(parts[1]);
    if (hour == null || minute == null) return null;
    if (hour < 0 || hour > 23 || minute < 0 || minute > 59) return null;

    return DateTime(day.year, day.month, day.day, hour, minute);
  }
}
