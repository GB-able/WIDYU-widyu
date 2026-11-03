extension DateTimeExtension on DateTime {
  String get weekdayLabel {
    final weekdays = ['월', '화', '수', '목', '금', '토', '일'];
    return weekdays[weekday - 1];
  }

  String get onlyMonthDay {
    final month = this.month;
    final day = this.day;

    return "${month.toString().padLeft(2, '0')}. ${day.toString().padLeft(2, '0')} ($weekdayLabel)";
  }

  String get onlyDate {
    final year = this.year;
    final month = this.month;
    final day = this.day;

    return "$year-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}";
  }

  DateTime get onlyDateTime => DateTime(year, month, day);

  String get onlyTime {
    final hour = this.hour;
    final minute = this.minute;
    return "${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}";
  }

  int get endOfMonthDay {
    return DateTime(year, month + 1, 0).day;
  }

  bool isSameDay(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }

  bool isSameMonth(DateTime other) {
    return year == other.year && month == other.month;
  }

  String get shortTimeAgo {
    final now = DateTime.now();
    final diff = now.difference(this);

    if (diff.inMinutes < 1) return '방금전';
    if (diff.inHours < 1) return '${diff.inMinutes}분전';
    if (diff.inDays < 1) return '${diff.inHours}시간전';
    if (diff.inDays < 7) return '${diff.inDays}일전';
    if (year == now.year) return '$month월 $day일';
    return '$year년 $month월 $day일';
  }

  String get timeAgo {
    final diff = DateTime.now().difference(this);

    if (diff <= const Duration(minutes: 60)) {
      return '${diff.inMinutes}분 전';
    }
    if (diff <= const Duration(hours: 24)) {
      return '${diff.inHours}시간 전';
    }
    if (diff <= const Duration(days: 7)) {
      return '${diff.inDays}일 전';
    }
    return "$year.${month.toString().padLeft(2, '0')}.${day.toString().padLeft(2, '0')}";
  }
}
