import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:widyu/core/model/heartRate/heart_rate_status.dart';

part 'home_ui_state.freezed.dart';

@freezed
abstract class HomeUiState with _$HomeUiState {
  const factory HomeUiState({
    required bool isUserLoading,
    required bool isHeartRateLoading,
    required bool isNotificationLoading,
    required String name,
    required bool isWearing,
    required int heartRate,
    required HeartRateStatus heartRateStatus,
    required DateTime measuredAt,
  }) = _HomeUiState;

  factory HomeUiState.init() => HomeUiState(
        isUserLoading: false,
        isHeartRateLoading: false,
        isNotificationLoading: false,
        name: '',
        isWearing: false,
        heartRate: 0,
        heartRateStatus: HeartRateStatus.unknown,
        measuredAt: DateTime.now(),
      );
}
