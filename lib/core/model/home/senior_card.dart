// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'senior_card.freezed.dart';
part 'senior_card.g.dart';

@freezed
abstract class SeniorCard with _$SeniorCard {
  const factory SeniorCard({
    required SeniorHeartRate? heartRate,
    required MedicationSummary? medicine,
    @JsonKey(defaultValue: []) required List<Album> albums,
    required HealthSchedule? healthSchedule,
    required StepProgress? walk,
  }) = _SeniorCard;

  factory SeniorCard.fromJson(Map<String, dynamic> json) =>
      _$SeniorCardFromJson(json);
}

@freezed
abstract class SeniorHeartRate with _$SeniorHeartRate {
  const factory SeniorHeartRate({
    @JsonKey(defaultValue: false) required bool isWearing,
    required String? heartRateStatus,
    required int? bpm,
  }) = _SeniorHeartRate;

  factory SeniorHeartRate.fromJson(Map<String, dynamic> json) =>
      _$SeniorHeartRateFromJson(json);
}

@freezed
abstract class MedicationSummary with _$MedicationSummary {
  const factory MedicationSummary({
    required int? medicineScheduleId,
    required int? todayTakenCount,
    required int? todayTotalCount,
    required int? nextDoseCount,
    required String? nextAlarmTime,
    @JsonKey(defaultValue: [])
    required List<MedicationDoseStatus> scheduleStatuses,
  }) = _MedicationSummary;

  factory MedicationSummary.fromJson(Map<String, dynamic> json) =>
      _$MedicationSummaryFromJson(json);
}

@freezed
abstract class MedicationDoseStatus with _$MedicationDoseStatus {
  const factory MedicationDoseStatus({
    required String? doseTime,
    @JsonKey(defaultValue: false) required bool taken,
  }) = _MedicationDoseStatus;

  factory MedicationDoseStatus.fromJson(Map<String, dynamic> json) =>
      _$MedicationDoseStatusFromJson(json);
}

@freezed
abstract class Album with _$Album {
  const factory Album({
    required int? albumId,
    required String? thumbnailUrl,
  }) = _Album;

  factory Album.fromJson(Map<String, dynamic> json) => _$AlbumFromJson(json);
}

@freezed
abstract class HealthSchedule with _$HealthSchedule {
  const factory HealthSchedule({
    required String? scheduleName,
    required int? dday,
    required DateTime? scheduledAt,
    required String? placeAddress,
    required double? latitude,
    required double? longitude,
  }) = _HealthSchedule;

  factory HealthSchedule.fromJson(Map<String, dynamic> json) =>
      _$HealthScheduleFromJson(json);
}

@freezed
abstract class StepProgress with _$StepProgress {
  const factory StepProgress({
    required int? actual,
    required int? goal,
  }) = _StepProgress;

  factory StepProgress.fromJson(Map<String, dynamic> json) =>
      _$StepProgressFromJson(json);
}
