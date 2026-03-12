// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'heart_rate_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_HeartRateResponse _$HeartRateResponseFromJson(Map<String, dynamic> json) =>
    _HeartRateResponse(
      memberId: (json['memberId'] as num).toInt(),
      heartRateStatus: json['heartRateStatus'] as String,
      heartRate: (json['heartRate'] as num).toInt(),
      measuredAt: DateTime.parse(json['measuredAt'] as String),
    );

Map<String, dynamic> _$HeartRateResponseToJson(_HeartRateResponse instance) =>
    <String, dynamic>{
      'memberId': instance.memberId,
      'heartRateStatus': instance.heartRateStatus,
      'heartRate': instance.heartRate,
      'measuredAt': instance.measuredAt.toIso8601String(),
    };
