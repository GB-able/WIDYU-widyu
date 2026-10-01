import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_location.freezed.dart';
part 'user_location.g.dart';

@freezed
abstract class UserLocation with _$UserLocation {
  const factory UserLocation({
    required double latitude,
    required double longitude,
    int? measuredAt,
    double? accuracyM,
    double? speedMps,
    double? speedAccuracyMps,
    double? headingDeg,
    double? altitudeM,
    @Default(false) bool isMock,
  }) = _UserLocation;

  factory UserLocation.fromJson(Map<String, dynamic> json) =>
      _$UserLocationFromJson(json);
}
