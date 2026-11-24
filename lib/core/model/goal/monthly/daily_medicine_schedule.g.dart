// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_medicine_schedule.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DailyMedicineSchedule _$DailyMedicineScheduleFromJson(
        Map<String, dynamic> json) =>
    _DailyMedicineSchedule(
      medicineScheduleId: (json['medicineScheduleId'] as num).toInt(),
      totalCount: (json['totalCount'] as num?)?.toDouble(),
      alarmTime: json['alarmTime'] as String,
      status: $enumDecode(_$MedicineDoseStateEnumMap, json['status']),
      proofImageUrl: json['proofImageUrl'] as String?,
    );

Map<String, dynamic> _$DailyMedicineScheduleToJson(
        _DailyMedicineSchedule instance) =>
    <String, dynamic>{
      'medicineScheduleId': instance.medicineScheduleId,
      'totalCount': instance.totalCount,
      'alarmTime': instance.alarmTime,
      'status': _$MedicineDoseStateEnumMap[instance.status]!,
      'proofImageUrl': instance.proofImageUrl,
    };

const _$MedicineDoseStateEnumMap = {
  MedicineDoseState.done: 'DONE',
  MedicineDoseState.upcoming: 'UPCOMING',
  MedicineDoseState.missed: 'MISSED',
};
