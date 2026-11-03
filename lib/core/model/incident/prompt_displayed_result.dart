import 'package:freezed_annotation/freezed_annotation.dart';

part 'prompt_displayed_result.freezed.dart';
part 'prompt_displayed_result.g.dart';

@freezed
abstract class PromptDisplayedResult with _$PromptDisplayedResult {
  const factory PromptDisplayedResult({
    required String incidentId,
    String? state,
    int? respondByMs,
  }) = _PromptDisplayedResult;

  factory PromptDisplayedResult.fromJson(Map<String, dynamic> json) =>
      _$PromptDisplayedResultFromJson(json);
}
