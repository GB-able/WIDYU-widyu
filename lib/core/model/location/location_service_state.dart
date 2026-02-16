import 'package:freezed_annotation/freezed_annotation.dart';

part 'location_service_state.freezed.dart';

@freezed
abstract class LocationServiceState with _$LocationServiceState {
  factory LocationServiceState({
    required bool serviceEnabled,
    required bool permissionGranted,
  }) = _LocationServiceState;

  LocationServiceState._();

  bool get isAvailable => serviceEnabled && permissionGranted;
}
