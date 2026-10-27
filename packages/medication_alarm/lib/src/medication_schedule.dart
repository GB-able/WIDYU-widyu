import 'package:medication_alarm/src/medication_occurrence.dart';
import 'package:medication_alarm/src/medication_schedule_rule.dart';

class MedicationSchedule {
  const MedicationSchedule({
    required this.memberId,
    required this.revision,
    required this.timeZone,
    required this.schedules,
    required this.excludedOccurrenceIds,
  });
  final String memberId;
  final int revision;
  final String timeZone;
  final List<MedicationScheduleRule> schedules;

  /// 요청 기간 내 완료·취소된 복용 회차의 전체 스냅샷
  final Set<String> excludedOccurrenceIds;

  factory MedicationSchedule.fromJson(Map<String, dynamic> json) {
    if (json['complete'] == false ||
        json['memberId'] == null ||
        (json['revision'] as int) < 0 ||
        (json['timeZone'] as String).isEmpty) {
      throw const FormatException('Incomplete alarm snapshot');
    }
    final schedules = (json['schedules'] as List)
        .map((e) => MedicationScheduleRule.fromJson(
            Map<String, dynamic>.from(e as Map)))
        .toList();
    if (schedules.map((e) => e.scheduleId).toSet().length != schedules.length) {
      throw const FormatException('Duplicate schedule ID');
    }
    return MedicationSchedule(
      memberId: json['memberId'].toString(),
      revision: json['revision'] as int,
      timeZone: json['timeZone'] as String,
      schedules: schedules,
      excludedOccurrenceIds: ((json['excludedOccurrenceIds'] ??
              json['completed'] ??
              <Object?>[]) as List)
          .map((e) => e.toString())
          .toSet(),
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

  /// [timeZone] 필드가 아니라 기기의 현재 로컬 타임존 기준으로 동작
  List<Map<String, dynamic>> groups(DateTime now, {int days = 30}) {
    final byTime = <int, List<Map<String, dynamic>>>{};
    for (var day = 0; day < days; day++) {
      for (final schedule in schedules.where((e) => e.enabled)) {
        final at = DateTime(
            now.year, now.month, now.day + day, schedule.hour, schedule.minute);
        if (!at.isAfter(now)) continue;
        final date = localDate(at);
        final id = MedicationOccurrence(
                scheduleId: schedule.scheduleId, localDate: date)
            .id;
        if (excludedOccurrenceIds.contains(id)) continue;
        final occurrence = <String, dynamic>{
          'occurrenceId': id,
          'scheduleId': schedule.scheduleId,
          'localDate': date,
          'timeZone': timeZone,
          'scheduledAt': at.millisecondsSinceEpoch,
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
