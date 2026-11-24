import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:widyu/core/model/home/senior_card.dart';

part 'medication.freezed.dart';
part 'medication.g.dart';

@freezed
abstract class Medication with _$Medication {
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
}
