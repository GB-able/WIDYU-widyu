// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medication.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Medication _$MedicationFromJson(Map<String, dynamic> json) => _Medication(
      medicineScheduleId: (json['medicineScheduleId'] as num).toInt(),
      takenCount: (json['takenCount'] as num).toInt(),
      totalCount: (json['totalCount'] as num).toInt(),
      nextDoseCount: (json['nextDoseCount'] as num).toInt(),
      nextAlarmTime: json['nextAlarmTime'] as String,
      proofImage: json['proofImageUrl'] as String?,
      isReward: json['isReward'] as bool?,
    );

Map<String, dynamic> _$MedicationToJson(_Medication instance) =>
    <String, dynamic>{
      'medicineScheduleId': instance.medicineScheduleId,
      'takenCount': instance.takenCount,
      'totalCount': instance.totalCount,
      'nextDoseCount': instance.nextDoseCount,
      'nextAlarmTime': instance.nextAlarmTime,
      'proofImageUrl': instance.proofImage,
      'isReward': instance.isReward,
    };
