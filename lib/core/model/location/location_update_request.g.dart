// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location_update_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LocationUpdateRequest _$LocationUpdateRequestFromJson(
        Map<String, dynamic> json) =>
    _LocationUpdateRequest(
      v: (json['v'] as num?)?.toInt() ?? 2,
      memberId: (json['memberId'] as num).toInt(),
      deviceId: json['device_id'] as String,
      sessionId: json['session_id'] as String,
      seq: (json['seq'] as num).toInt(),
      tsMs: (json['ts_ms'] as num).toInt(),
      reason: json['reason'] as String,
      lat: (json['lat'] as num).toDouble(),
      lon: (json['lon'] as num).toDouble(),
      isMock: json['is_mock'] as bool,
      accuracyM: (json['accuracy_m'] as num?)?.toDouble(),
      speedMps: (json['speed_mps'] as num?)?.toDouble(),
      speedAccuracyMps: (json['speed_accuracy_mps'] as num?)?.toDouble(),
      headingDeg: (json['heading_deg'] as num?)?.toDouble(),
      altitudeM: (json['altitude_m'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$LocationUpdateRequestToJson(
        _LocationUpdateRequest instance) =>
    <String, dynamic>{
      'v': instance.v,
      'memberId': instance.memberId,
      'device_id': instance.deviceId,
      'session_id': instance.sessionId,
      'seq': instance.seq,
      'ts_ms': instance.tsMs,
      'reason': instance.reason,
      'lat': instance.lat,
      'lon': instance.lon,
      'is_mock': instance.isMock,
      'accuracy_m': instance.accuracyM,
      'speed_mps': instance.speedMps,
      'speed_accuracy_mps': instance.speedAccuracyMps,
      'heading_deg': instance.headingDeg,
      'altitude_m': instance.altitudeM,
    };
