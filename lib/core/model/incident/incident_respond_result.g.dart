// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'incident_respond_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_IncidentRespondResult _$IncidentRespondResultFromJson(
        Map<String, dynamic> json) =>
    _IncidentRespondResult(
      incidentId: json['incidentId'] as String,
      state: json['state'] as String?,
    );

Map<String, dynamic> _$IncidentRespondResultToJson(
        _IncidentRespondResult instance) =>
    <String, dynamic>{
      'incidentId': instance.incidentId,
      'state': instance.state,
    };
