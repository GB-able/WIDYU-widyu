// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prompt_displayed_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PromptDisplayedResult _$PromptDisplayedResultFromJson(
        Map<String, dynamic> json) =>
    _PromptDisplayedResult(
      incidentId: json['incidentId'] as String,
      state: json['state'] as String?,
      respondByMs: (json['respondByMs'] as num?)?.toInt(),
    );

Map<String, dynamic> _$PromptDisplayedResultToJson(
        _PromptDisplayedResult instance) =>
    <String, dynamic>{
      'incidentId': instance.incidentId,
      'state': instance.state,
      'respondByMs': instance.respondByMs,
    };
