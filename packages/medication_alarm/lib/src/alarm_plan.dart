/// Wire contract: schedule IDs identify daily rules. A dose is identified by
/// `<scheduleId>:<local YYYY-MM-DD>`, independently of schedule revisions.
class MedicationSchedule {
  const MedicationSchedule({
    required this.scheduleId,
    required this.hour,
    required this.minute,
    required this.doseCount,
    this.enabled = true,
  });

  final int scheduleId;
  final int hour;
  final int minute;
  final double doseCount;
  final bool enabled;

  factory MedicationSchedule.fromJson(Map<String, dynamic> json) {
    final time = (json['alarmTime'] as String).split(':');
    final id = json['scheduleId'] as int;
    final hour = int.parse(time[0]);
    final minute = int.parse(time[1]);
    final dose = (json['doseCount'] as num).toDouble();
    if (time.length != 2 ||
        id <= 0 ||
        hour < 0 ||
        hour > 23 ||
        minute < 0 ||
        minute > 59 ||
        !dose.isFinite ||
        dose <= 0) {
      throw const FormatException('Invalid medication schedule');
    }
    return MedicationSchedule(
      scheduleId: id,
      hour: hour,
      minute: minute,
      doseCount: dose,
      enabled: json['enabled'] as bool,
    );
  }

  Map<String, dynamic> toJson() => {
        'scheduleId': scheduleId,
        'alarmTime':
            '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}',
        'doseCount': doseCount,
        'enabled': enabled,
      };
}

class MedicationAlarmPlan {
  const MedicationAlarmPlan({
    required this.memberId,
    required this.revision,
    required this.timeZone,
    required this.schedules,
    required this.excludedOccurrenceIds,
  });
  final String memberId;
  final int revision;
  final String timeZone;
  final List<MedicationSchedule> schedules;

  /// Complete snapshot of completed/cancelled doses in the requested period.
  final Set<String> excludedOccurrenceIds;

  factory MedicationAlarmPlan.fromJson(Map<String, dynamic> json) {
    if (json['complete'] != true ||
        (json['revision'] as int) < 0 ||
        (json['timeZone'] as String).isEmpty) {
      throw const FormatException('Incomplete alarm snapshot');
    }
    final schedules = (json['schedules'] as List)
        .map((e) =>
            MedicationSchedule.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
    if (schedules.map((e) => e.scheduleId).toSet().length != schedules.length) {
      throw const FormatException('Duplicate schedule ID');
    }
    return MedicationAlarmPlan(
      memberId: json['memberId'].toString(),
      revision: json['revision'] as int,
      timeZone: json['timeZone'] as String,
      schedules: schedules,
      excludedOccurrenceIds:
          (json['excludedOccurrenceIds'] as List).cast<String>().toSet(),
    );
  }

  Map<String, dynamic> toJson() => {
        'complete': true,
        'memberId': memberId,
        'revision': revision,
        'timeZone': timeZone,
        'schedules': schedules.map((e) => e.toJson()).toList(),
        'excludedOccurrenceIds': excludedOccurrenceIds.toList()..sort(),
      };

  /// Use calendar dates, never 24-hour increments (DST changes day length).
  /// This method runs in the device's current local timezone.
  List<Map<String, dynamic>> groups(DateTime now, {int days = 30}) {
    final byTime = <int, List<Map<String, dynamic>>>{};
    for (var day = 0; day < days; day++) {
      for (final schedule in schedules.where((e) => e.enabled)) {
        final at = DateTime(
            now.year, now.month, now.day + day, schedule.hour, schedule.minute);
        if (!at.isAfter(now)) continue;
        final date = localDate(at);
        final id = '${schedule.scheduleId}:$date';
        if (excludedOccurrenceIds.contains(id)) continue;
        final midnight = DateTime(at.year, at.month, at.day);
        final end = DateTime(at.year, at.month, at.day, 23, 59);
        final opens = at.subtract(const Duration(minutes: 30));
        final closes = at.add(const Duration(minutes: 30));
        final occurrence = <String, dynamic>{
          'occurrenceId': id,
          'scheduleId': schedule.scheduleId,
          'localDate': date,
          'timeZone': timeZone,
          'scheduledAt': at.millisecondsSinceEpoch,
          'opensAt': (opens.isBefore(midnight) ? midnight : opens)
              .millisecondsSinceEpoch,
          'closesAt':
              (closes.isAfter(end) ? end : closes).millisecondsSinceEpoch,
          'doseCount': schedule.doseCount,
        };
        byTime.putIfAbsent(at.millisecondsSinceEpoch, () => []).add(occurrence);
      }
    }
    return (byTime.entries.toList()..sort((a, b) => a.key.compareTo(b.key)))
        .map((entry) {
      entry.value.sort(
          (a, b) => (a['scheduleId'] as int).compareTo(b['scheduleId'] as int));
      return <String, dynamic>{
        'groupId': '$memberId:${entry.key}',
        'memberId': memberId,
        'scheduledAt': entry.key,
        'timeZone': timeZone,
        'occurrences': entry.value,
      };
    }).toList();
  }

  static String localDate(DateTime at) =>
      '${at.year.toString().padLeft(4, '0')}-${at.month.toString().padLeft(2, '0')}-${at.day.toString().padLeft(2, '0')}';
}
