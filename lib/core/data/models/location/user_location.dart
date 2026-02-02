import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_location.freezed.dart';

@freezed
abstract class UserLocation with _$UserLocation {
  const factory UserLocation({
    required double latitude,
    required double longitude,
    required DateTime timestamp,
  }) = _UserLocation;

  factory UserLocation.toKST({
    required double latitude,
    required double longitude,
    required DateTime timestamp,
  }) =>
      UserLocation(
        latitude: latitude,
        longitude: longitude,
        timestamp: timestamp.add(const Duration(hours: 9)),
      );
}
