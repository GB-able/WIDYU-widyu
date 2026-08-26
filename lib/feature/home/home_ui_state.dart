import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:widyu/core/model/heartRate/heart_rate_status.dart';
import 'package:widyu/core/model/home/medication_status.dart';
import 'package:widyu/feature/home/notification_ui_model.dart';

part 'home_ui_state.freezed.dart';

@freezed
abstract class HomeUiState with _$HomeUiState {
  const HomeUiState._();

  const factory HomeUiState({
    required bool isUserLoading,
    required bool isHeartRateLoading,
    required bool isNotificationLoading,
    required bool isSeniorCardLoading,
    required List<NotificationUiModel> notifications,
    required String name,
    required bool isWearing,
    required int heartRate,
    required HeartRateStatus heartRateStatus,
    required DateTime measuredAt,
    required List<String> thumbnails,
    required MedicationStatus medicationStatus,
    required int stepCount,
    required int stepGoal,
    required String? healthSchedulePlace,
    required double? healthScheduleLatitude,
    required double? healthScheduleLongitude,
  }) = _HomeUiState;

  /// 목표 유무
  bool get hasGoal =>
      medicationStatus != const MedicationStatus.unknown() ||
      hasStepGoal ||
      (healthSchedulePlace?.isNotEmpty ?? false);

  /// 걷기 목표 설정 여부
  bool get hasStepGoal => stepGoal > 0;

  /// 목표 대비 진행률(%)
  double get stepProgress => hasStepGoal ? (stepCount / stepGoal) * 100 : 0.0;

  /// 최상단에 나타날 알림
  NotificationUiModel? get notification =>
      notifications.isEmpty ? null : notifications.first;

  factory HomeUiState.init() => HomeUiState(
        isUserLoading: false,
        isHeartRateLoading: false,
        isNotificationLoading: false,
        isSeniorCardLoading: false,
        notifications: [],
        name: '',
        isWearing: false,
        heartRate: 0,
        heartRateStatus: HeartRateStatus.unknown,
        measuredAt: DateTime.now(),
        thumbnails: [],
        medicationStatus: const MedicationStatus.unknown(),
        stepCount: 0,
        stepGoal: 0,
        healthSchedulePlace: null,
        healthScheduleLatitude: null,
        healthScheduleLongitude: null,
      );
}
