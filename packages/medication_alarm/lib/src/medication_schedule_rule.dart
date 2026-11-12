/// 개별 복용 회차는 스케줄 revision과 무관하게 `<scheduleId>:<시간(YYYY-MM-DD)>`로 식별한다.
class MedicationScheduleRule {
  const MedicationScheduleRule({
    required this.scheduleId,
    required this.hour,
    required this.minute,
    required this.doseCount,
    this.enabled = true,
    this.effectiveFrom,
    this.effectiveTo,
  });

  final int scheduleId;
  final int hour;
  final int minute;
  final double doseCount;
  final bool enabled;

  final String? effectiveFrom;
  final String? effectiveTo;

  bool activeOn(String localDate) =>
      (effectiveFrom == null || effectiveFrom!.compareTo(localDate) <= 0) &&
      (effectiveTo == null || effectiveTo!.compareTo(localDate) >= 0);

  factory MedicationScheduleRule.fromJson(Map<String, dynamic> json) {
    final time = (json['alarmTime'] as String).split(':');
    if (time.length != 2 && time.length != 3) {
      throw const FormatException('Invalid medication schedule');
    }
    final id = json['scheduleId'] as int;
    final hour = int.parse(time[0]);
    final minute = int.parse(time[1]);
    final dose = (json['doseCount'] as num).toDouble();
    if (id <= 0 ||
        hour < 0 ||
        hour > 23 ||
        minute < 0 ||
        minute > 59 ||
        !dose.isFinite ||
        dose <= 0) {
      throw const FormatException('Invalid medication schedule');
    }
    return MedicationScheduleRule(
      scheduleId: id,
      hour: hour,
      minute: minute,
      doseCount: dose,
      enabled: json['enabled'] as bool? ?? true,
      effectiveFrom: _date(json['effectiveFrom']),
      effectiveTo: _date(json['effectiveTo']),
    );
  }

  static final _datePattern = RegExp(r'^\d{4}-\d{2}-\d{2}$');

  static String? _date(Object? value) {
    if (value == null) return null;
    if (value is! String || !_datePattern.hasMatch(value)) {
      throw const FormatException('Invalid medication schedule');
    }
    return value;
  }

  Map<String, dynamic> toJson() => {
        'scheduleId': scheduleId,
        'alarmTime':
            '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}',
        'doseCount': doseCount,
        'enabled': enabled,
        'effectiveFrom': effectiveFrom,
        'effectiveTo': effectiveTo,
      };
}
