// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sensor_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SensorConfig _$SensorConfigFromJson(Map<String, dynamic> json) =>
    _SensorConfig(
      collectionMode: json['collectionMode'] as String? ?? 'product',
      gyroMode: json['gyroMode'] as String? ?? 'continuous',
      accFsHz: (json['accFsHz'] as num?)?.toInt() ?? 50,
      batchSec: (json['batchSec'] as num?)?.toInt() ?? 1,
      impactThresholdG: (json['impactThresholdG'] as num?)?.toDouble() ?? 1.8,
      backfillBeforeSec: (json['backfillBeforeSec'] as num?)?.toInt() ?? 2,
      backfillAfterSec: (json['backfillAfterSec'] as num?)?.toInt() ?? 10,
      refreshSec: (json['refreshSec'] as num?)?.toInt() ?? 60,
    );

Map<String, dynamic> _$SensorConfigToJson(_SensorConfig instance) =>
    <String, dynamic>{
      'collectionMode': instance.collectionMode,
      'gyroMode': instance.gyroMode,
      'accFsHz': instance.accFsHz,
      'batchSec': instance.batchSec,
      'impactThresholdG': instance.impactThresholdG,
      'backfillBeforeSec': instance.backfillBeforeSec,
      'backfillAfterSec': instance.backfillAfterSec,
      'refreshSec': instance.refreshSec,
    };
