import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:widyu/core/model/home/senior_card.dart';
import 'package:widyu/core/utils/extensions/medication_extension.dart';
import 'package:widyu/core/utils/extensions/string_extension.dart';

part 'medication.freezed.dart';
part 'medication.g.dart';

@freezed
abstract class Medication with _$Medication {
  const Medication._();

  const factory Medication({
    required int medicineScheduleId,
    required int takenCount,
    required int totalCount,
    required int nextDoseCount,
    required String nextAlarmTime,
    @JsonKey(name: 'proofImageUrl') required String? proofImage,
    @JsonKey(defaultValue: [])
    required List<MedicationDoseStatus> scheduleStatuses,
    bool? isReward, // [TODO] 변경 예정
  }) = _Medication;

  factory Medication.fromJson(Map<String, dynamic> json) =>
      _$MedicationFromJson(json);

  bool isDoneAt(DateTime now) =>
      currentDose(now)?.taken ?? takenCount >= totalCount;

  MedicationDoseStatus? currentDose(DateTime now) {
    final doses = scheduleStatuses
        .where((dose) => dose.doseTime?.toAlarmAt(now) != null)
        .toList()
      ..sort((a, b) =>
          a.doseTime!.toAlarmAt(now)!.compareTo(b.doseTime!.toAlarmAt(now)!));
    if (doses.isEmpty) return null;
    for (final dose in doses) {
      if (!dose.taken &&
          dose.doseTime!.toAlarmAt(now)!.isWithinVerifyWindow(now)) {
        return dose;
      }
    }
    final opened = doses.where(
        (dose) => !now.isBefore(dose.doseTime!.toAlarmAt(now)!.windowOpensAt));
    return opened.isNotEmpty ? opened.last : doses.first;
  }

  int scheduleIdAt(DateTime now) =>
      currentDose(now)?.scheduleId ?? medicineScheduleId;

  String alarmTimeAt(DateTime now) =>
      currentDose(now)?.doseTime ?? nextAlarmTime;

  int doseCountAt(DateTime now) => currentDose(now)?.doseCount ?? nextDoseCount;

  String? proofImageAt(DateTime now) =>
      currentDose(now)?.proofImageUrl ?? proofImage;

  DateTime? alarmAt(DateTime today) => alarmTimeAt(today).toAlarmAt(today);

  DateTime? verifyOpenAt(DateTime today) => alarmAt(today)?.windowOpensAt;

  DateTime? verifyDeadlineAt(DateTime today) => alarmAt(today)?.windowClosesAt;

  bool isVerifyOpenAt(DateTime now) {
    final alarm = alarmAt(now);
    return alarm != null && alarm.isWithinVerifyWindow(now);
  }

  Duration verifyRemainingAt(DateTime now) {
    final open = verifyOpenAt(now);
    final deadline = verifyDeadlineAt(now);
    if (open == null || deadline == null) return Duration.zero;

    final target = now.isBefore(open) ? open : deadline;
    final remaining = target.difference(now);
    return remaining.isNegative ? Duration.zero : remaining;
  }

  bool isVerifyExpiredAt(DateTime now) {
    final deadline = verifyDeadlineAt(now);
    return deadline != null && now.isAfter(deadline);
  }
}
