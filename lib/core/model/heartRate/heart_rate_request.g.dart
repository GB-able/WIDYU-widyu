// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'heart_rate_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_HeartRateRequest _$HeartRateRequestFromJson(Map<String, dynamic> json) =>
    _HeartRateRequest(
      heartRates: (json['heartRates'] as List<dynamic>)
          .map((e) => HeartRate.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$HeartRateRequestToJson(_HeartRateRequest instance) =>
    <String, dynamic>{
      'heartRates': instance.heartRates,
    };
