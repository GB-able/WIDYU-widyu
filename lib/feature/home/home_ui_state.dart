import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:widyu/core/model/heartRate/heart_rate_status.dart';

part 'home_ui_state.freezed.dart';

@freezed
abstract class HomeUiState with _$HomeUiState {
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
    required int todayTakenCount,
    required int todayTotalCount,
    required Duration nextDoseRemainingTime,
    required double stepProgress,
  }) = _HomeUiState;

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
        todayTakenCount: 0,
        todayTotalCount: 0,
        nextDoseRemainingTime: Duration.zero,
        stepProgress: 0.0,
      );
}
