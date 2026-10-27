import 'package:freezed_annotation/freezed_annotation.dart';

part 'walk_sync_response.freezed.dart';
part 'walk_sync_response.g.dart';

@freezed
abstract class WalkSyncResponse with _$WalkSyncResponse {
  const factory WalkSyncResponse({
    required bool achieved,
  }) = _WalkSyncResponse;

  factory WalkSyncResponse.fromJson(Map<String, dynamic> json) =>
      _$WalkSyncResponseFromJson(json);
}
