import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:widyu/core/model/heartRate/heart_rate_status.dart';
import 'package:widyu/core/model/home/medication_status.dart';

part 'home_ui_state.freezed.dart';

@freezed
abstract class HomeUiState with _$HomeUiState {
  const HomeUiState._();

  const factory HomeUiState({
    required bool isUserLoading,
    required bool isHeartRateLoading,
    required bool isNotificationLoading,
    required bool isSeniorCardLoading,
    required String name,
    required bool isWearing,
    required int heartRate,
    required HeartRateStatus heartRateStatus,
    required DateTime measuredAt,
    required List<String> thumbnails,
    required MedicationStatus medicationStatus,
    required double stepProgress,
    required String? healthSchedulePlace,
    required double? healthScheduleLatitude,
    required double? healthScheduleLongitude,
  }) = _HomeUiState;

  /// 좌표가 있어야 카카오맵 길찾기를 열 수 있다.
  bool get canOpenHealthScheduleRoute =>
      healthScheduleLatitude != null && healthScheduleLongitude != null;

  factory HomeUiState.init() => HomeUiState(
        isUserLoading: false,
        isHeartRateLoading: false,
        isNotificationLoading: false,
        isSeniorCardLoading: false,
        name: '',
        isWearing: false,
        heartRate: 0,
        heartRateStatus: HeartRateStatus.unknown,
        measuredAt: DateTime.now(),
        thumbnails: [],
        medicationStatus: const MedicationStatus.unknown(),
        stepProgress: 0.0,
        healthSchedulePlace: null,
        healthScheduleLatitude: null,
        healthScheduleLongitude: null,
      );
}
