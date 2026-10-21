class MedicationOccurrence {
  const MedicationOccurrence({
    required this.scheduleId,
    required this.localDate,
    this.scheduledAt,
  });

  final int scheduleId;
  final String localDate;
  final DateTime? scheduledAt;

  String get id => '$scheduleId:$localDate';

  factory MedicationOccurrence.fromJson(Map<String, dynamic> json) {
    final scheduleId = json['scheduleId'];
    final localDate = json['localDate'];
    final scheduledAt = json['scheduledAt'];
    if (scheduleId is! int ||
        localDate is! String ||
        (scheduledAt != null && scheduledAt is! num)) {
      throw const FormatException('Invalid medication occurrence');
    }
    return MedicationOccurrence(
      scheduleId: scheduleId,
      localDate: localDate,
      scheduledAt: scheduledAt == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch((scheduledAt as num).toInt()),
    );
  }

  bool canVerify(DateTime now) {
    final at = scheduledAt;
    if (at == null) return true;
    final opens = at.subtract(const Duration(minutes: 30));
    final closes = at.add(const Duration(minutes: 30));
    final dayStart = DateTime(at.year, at.month, at.day);
    final dayEnd = DateTime(at.year, at.month, at.day, 23, 59);
    final from = opens.isBefore(dayStart) ? dayStart : opens;
    final to = closes.isAfter(dayEnd) ? dayEnd : closes;
    return !now.isBefore(from) && !now.isAfter(to);
  }
}
