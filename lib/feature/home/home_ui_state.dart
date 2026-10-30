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
    int? heartRate,
    required HeartRateStatus heartRateStatus,
    DateTime? measuredAt,
    required List<String> thumbnails,
    required MedicationStatus medicationStatus,
    required int stepGoal,
    required int steps,
    required String? healthSchedulePlace,
    required double? healthScheduleLatitude,
    required double? healthScheduleLongitude,
  }) = _HomeUiState;

  /// 목표 유무
  bool get hasGoal =>
      medicationStatus != const MedicationStatus.unknown() ||
      hasStepGoal ||
      hasHealthSchedule;

  /// 걷기 목표 설정 여부
  bool get hasStepGoal => stepGoal > 0;

  /// 건강 일정 등록 여부
  bool get hasHealthSchedule => healthSchedulePlace?.isNotEmpty ?? false;

  /// 목표 대비 진행률(%)
  double get stepProgress => hasStepGoal ? (steps / stepGoal) * 100 : 0.0;

  /// 최상단에 나타날 알림
  NotificationUiModel? get notification =>
      notifications.isEmpty ? null : notifications.first;

  factory HomeUiState.init() => const HomeUiState(
        isUserLoading: false,
        isHeartRateLoading: false,
        isNotificationLoading: false,
        isSeniorCardLoading: false,
        notifications: [],
        name: '',
        isWearing: false,
        heartRateStatus: HeartRateStatus.unknown,
        thumbnails: [],
        medicationStatus: MedicationStatus.unknown(),
        stepGoal: 0,
        steps: 0,
        healthSchedulePlace: null,
        healthScheduleLatitude: null,
        healthScheduleLongitude: null,
      );
}
