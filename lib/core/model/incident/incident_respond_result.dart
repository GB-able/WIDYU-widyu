import 'package:freezed_annotation/freezed_annotation.dart';

part 'incident_respond_result.freezed.dart';
part 'incident_respond_result.g.dart';

@freezed
abstract class IncidentRespondResult with _$IncidentRespondResult {
  const factory IncidentRespondResult({
    required String incidentId,
    String? state,
  }) = _IncidentRespondResult;

  factory IncidentRespondResult.fromJson(Map<String, dynamic> json) =>
      _$IncidentRespondResultFromJson(json);
}
