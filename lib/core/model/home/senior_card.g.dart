// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'senior_card.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SeniorCard _$SeniorCardFromJson(Map<String, dynamic> json) => _SeniorCard(
      heartRate: json['heartRate'] == null
          ? null
          : SeniorHeartRate.fromJson(json['heartRate'] as Map<String, dynamic>),
      medicine: json['medicine'] == null
          ? null
          : MedicationSummary.fromJson(
              json['medicine'] as Map<String, dynamic>),
      albums: (json['albums'] as List<dynamic>?)
              ?.map((e) => Album.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      healthSchedule: json['healthSchedule'] == null
          ? null
          : HealthSchedule.fromJson(
              json['healthSchedule'] as Map<String, dynamic>),
      walk: json['walk'] == null
          ? null
          : StepProgress.fromJson(json['walk'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SeniorCardToJson(_SeniorCard instance) =>
    <String, dynamic>{
      'heartRate': instance.heartRate,
      'medicine': instance.medicine,
      'albums': instance.albums,
      'healthSchedule': instance.healthSchedule,
      'walk': instance.walk,
    };

_SeniorHeartRate _$SeniorHeartRateFromJson(Map<String, dynamic> json) =>
    _SeniorHeartRate(
      isWearing: json['isWearing'] as bool? ?? false,
      heartRateStatus: json['heartRateStatus'] as String?,
      bpm: (json['bpm'] as num?)?.toInt(),
    );

Map<String, dynamic> _$SeniorHeartRateToJson(_SeniorHeartRate instance) =>
    <String, dynamic>{
      'isWearing': instance.isWearing,
      'heartRateStatus': instance.heartRateStatus,
      'bpm': instance.bpm,
    };

_MedicationSummary _$MedicationSummaryFromJson(Map<String, dynamic> json) =>
    _MedicationSummary(
      medicineScheduleId: (json['medicineScheduleId'] as num?)?.toInt(),
      todayTakenCount: (json['todayTakenCount'] as num?)?.toInt(),
      todayTotalCount: (json['todayTotalCount'] as num?)?.toInt(),
      nextDoseCount: (json['nextDoseCount'] as num?)?.toInt(),
      nextAlarmTime: json['nextAlarmTime'] as String?,
      scheduleStatuses: (json['scheduleStatuses'] as List<dynamic>?)
              ?.map((e) =>
                  MedicationDoseStatus.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$MedicationSummaryToJson(_MedicationSummary instance) =>
    <String, dynamic>{
      'medicineScheduleId': instance.medicineScheduleId,
      'todayTakenCount': instance.todayTakenCount,
      'todayTotalCount': instance.todayTotalCount,
      'nextDoseCount': instance.nextDoseCount,
      'nextAlarmTime': instance.nextAlarmTime,
      'scheduleStatuses': instance.scheduleStatuses,
    };

_MedicationDoseStatus _$MedicationDoseStatusFromJson(
        Map<String, dynamic> json) =>
    _MedicationDoseStatus(
      scheduleId: (json['scheduleId'] as num?)?.toInt(),
      doseTime: json['doseTime'] as String?,
      taken: json['taken'] as bool? ?? false,
      doseCount: (json['doseCount'] as num?)?.toInt(),
      proofImageUrl: json['proofImageUrl'] as String?,
    );

Map<String, dynamic> _$MedicationDoseStatusToJson(
        _MedicationDoseStatus instance) =>
    <String, dynamic>{
      'scheduleId': instance.scheduleId,
      'doseTime': instance.doseTime,
      'taken': instance.taken,
      'doseCount': instance.doseCount,
      'proofImageUrl': instance.proofImageUrl,
    };

_Album _$AlbumFromJson(Map<String, dynamic> json) => _Album(
      albumId: (json['albumId'] as num?)?.toInt(),
      thumbnailUrl: json['thumbnailUrl'] as String?,
    );

Map<String, dynamic> _$AlbumToJson(_Album instance) => <String, dynamic>{
      'albumId': instance.albumId,
      'thumbnailUrl': instance.thumbnailUrl,
    };

_HealthSchedule _$HealthScheduleFromJson(Map<String, dynamic> json) =>
    _HealthSchedule(
      scheduleName: json['scheduleName'] as String?,
      dday: (json['dday'] as num?)?.toInt(),
      scheduledAt: json['scheduledAt'] == null
          ? null
          : DateTime.parse(json['scheduledAt'] as String),
      placeAddress: json['placeAddress'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$HealthScheduleToJson(_HealthSchedule instance) =>
    <String, dynamic>{
      'scheduleName': instance.scheduleName,
      'dday': instance.dday,
      'scheduledAt': instance.scheduledAt?.toIso8601String(),
      'placeAddress': instance.placeAddress,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
    };

_StepProgress _$StepProgressFromJson(Map<String, dynamic> json) =>
    _StepProgress(
      actual: (json['actual'] as num?)?.toInt(),
      goal: (json['goal'] as num?)?.toInt(),
    );

Map<String, dynamic> _$StepProgressToJson(_StepProgress instance) =>
    <String, dynamic>{
      'actual': instance.actual,
      'goal': instance.goal,
    };
