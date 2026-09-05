import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:widyu/core/utils/extensions/medicine_extension.dart';
import 'package:widyu/core/utils/extensions/string_extension.dart';

part 'medicine.freezed.dart';
part 'medicine.g.dart';

@freezed
abstract class Medicine with _$Medicine {
  const Medicine._();

  const factory Medicine({
    required int medicineScheduleId,
    required int takenCount,
    required int totalCount,
    required int nextDoseCount,
    required String nextAlarmTime,
    @JsonKey(name: 'proofImageUrl') required String? proofImage,
    bool? isReward, // [TODO] 변경 예정
  }) = _Medicine;

  factory Medicine.fromJson(Map<String, dynamic> json) =>
      _$MedicineFromJson(json);

  DateTime? alarmAt(DateTime today) => nextAlarmTime.toAlarmAt(today);

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
