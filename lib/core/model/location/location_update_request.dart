// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'location_update_request.freezed.dart';
part 'location_update_request.g.dart';

/// `reason` 에 허용된 값. 그 밖의 값은 서버가 요청 전체를 거부한다.
class LocationReason {
  const LocationReason._();

  /// 이동 중(약 5초 주기).
  static const move = 'move';

  /// 정지 중(60초 주기).
  static const keepalive = 'keepalive';

  /// 사고·이상 상황. 아직 쓰는 곳이 없다.
  static const incident = 'incident';
}

/// STOMP `/app/location/update` 로 보내는 위치 원본(v2).
///
/// 키는 snake_case 이고 `memberId` 만 기존처럼 camelCase 다.
/// 회차 필드(`run_id`·`study_id`·`participation_id`)는 서버가 `ts_ms` 시점에
/// 배정된 회차를 붙여 주므로 앱에서 보내지 않는다(직접 보내면 원본이 누락된다).
@freezed
abstract class LocationUpdateRequest with _$LocationUpdateRequest {
  const factory LocationUpdateRequest({
    @Default(2) int v,
    required int memberId,
    @JsonKey(name: 'device_id') required String deviceId,
    @JsonKey(name: 'session_id') required String sessionId,
    required int seq,

    /// 위치를 **잰** 시각(epoch ms). 보낸 시각이 아니다.
    @JsonKey(name: 'ts_ms') required int tsMs,
    required String reason,
    required double lat,
    required double lon,

    /// 모의 위치가 아니어도 `false` 를 실어 보낸다(서버 권장).
    @JsonKey(name: 'is_mock') required bool isMock,
    @JsonKey(name: 'accuracy_m') double? accuracyM,
    @JsonKey(name: 'speed_mps') double? speedMps,
    @JsonKey(name: 'speed_accuracy_mps') double? speedAccuracyMps,
    @JsonKey(name: 'heading_deg') double? headingDeg,
    @JsonKey(name: 'altitude_m') double? altitudeM,
  }) = _LocationUpdateRequest;

  factory LocationUpdateRequest.fromJson(Map<String, dynamic> json) =>
      _$LocationUpdateRequestFromJson(json);
}
