import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:app_settings/app_settings.dart';
import 'package:flutter/foundation.dart' show listEquals;
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart' show SpringSimulation;
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:widyu/app/routes/app_route.dart';
import 'package:widyu/core/data/provider/walk_provider.dart';
import 'package:widyu/core/data/repository/goal/medication_repository.dart';
import 'package:widyu/core/data/repository/heartRate/heart_rate_repository.dart';
import 'package:widyu/core/data/repository/home/home_repository.dart';
import 'package:widyu/core/data/repository/location/location_repository.dart';
import 'package:widyu/core/data/repository/myPage/my_page_repository.dart';
import 'package:widyu/core/data/repository/notification/notification_repository.dart';
import 'package:widyu/core/model/heartRate/heart_rate_status.dart';
import 'package:widyu/core/model/home/medication_status.dart';
import 'package:widyu/core/ui/theme/colors.dart';
import 'package:widyu/core/ui/theme/typos.dart';
import 'package:widyu/core/ui/widgets/bot_nav.dart';
import 'package:widyu/core/ui/widgets/custom_network_image.dart';
import 'package:widyu/core/ui/widgets/icon_widget.dart';
import 'package:widyu/core/ui/widgets/medication_reward_dialog.dart';
import 'package:widyu/core/ui/widgets/ui_event_listener.dart';
import 'package:widyu/core/ui/widgets/widyu_asset_image.dart';
import 'package:widyu/core/ui/widgets/widyu_icon.dart';
import 'package:widyu/core/ui/widgets/widyu_permission_dialog.dart';
import 'package:widyu/core/ui/widgets/widyu_text_button.dart';
import 'package:widyu/core/utils/background_location_notice_controller.dart';
import 'package:widyu/core/utils/medication_verification_launcher.dart';
import 'package:widyu/core/utils/show_toast.dart';
import 'package:widyu/feature/home/home_ui_event.dart';
import 'package:widyu/feature/home/home_ui_state.dart';
import 'package:widyu/feature/home/home_view_model.dart';
import 'package:widyu/feature/permission/permission_ui_model.dart';

part 'widget/album_card.dart';
part 'widget/carousel_card_shell.dart';
part 'widget/carousel_indicator.dart';
part 'widget/carousel_menu.dart';
part 'widget/dose_countdown.dart';
part 'widget/health_schedule_card.dart';
part 'widget/home_app_bar.dart';
part 'widget/home_greeting_view.dart';
part 'widget/medication_card.dart';
part 'widget/mesh_gradient_background.dart';
part 'widget/notification_view.dart';
part 'widget/spring_bounce.dart';
part 'widget/walking_card.dart';
part 'widget/watch_data_view.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static String get _backgroundLocationNoticeDescription => Platform.isIOS
      ? '앱을 사용하지 않는 동안에 보호자에게 내 위치를\n공유하려면 설정>위치에서 \'항상\'으로 설정해 주세요.'
      : '앱을 사용하지 않는 동안에 보호자에게 내 위치를\n공유하려면 설정>권한에서 위치 권한을\n 항상 허용으로 설정해 주세요.';

  Future<void> _showBackgroundLocationNotice(BuildContext context) async {
    if (!_isCurrentRoute(context)) return;
    final viewModel = context.read<HomeViewModel>();
    final openSettings = await WidyuPermissionDialog.show(
      context,
      description: _backgroundLocationNoticeDescription,
    );
    if (!openSettings || !context.mounted || !_isCurrentRoute(context)) return;
    await viewModel.openBackgroundLocationSettings();
  }

  Future<void> _openMedicationCamera(
      BuildContext context, int scheduleId, int? doseCount) async {
    final viewModel = context.read<HomeViewModel>();
    final result = await openMedicationForSchedule(
        context, scheduleId, DateTime.now(),
        doseCount: doseCount);
    if (result != null) viewModel.onMedicationVerified(result);
  }

  bool _isCurrentRoute(BuildContext context) =>
      ModalRoute.of(context)?.isCurrent ?? true;

  void _handleEvent(BuildContext context, HomeUiEvent event) {
    switch (event) {
      case LocationPermissionUnavailable():
        showToast('현재 위치 없이 길찾기를 열어요.');
      case LocationPermissionSettingsLaunchFailure():
        showToast('설정 화면을 열지 못해 현재 위치 없이 길찾기를 열어요.');
      case ShowBackgroundLocationNotice():
        unawaited(_showBackgroundLocationNotice(context));
      case BackgroundLocationSettingsLaunchFailure():
        showToast('설정 화면을 열지 못했어요.');
      case HealthSchedulePlaceUnavailable():
        showToast('일정 장소 정보가 없어요.');
      case OpenKakaoMapFailure():
        showToast('카카오맵을 실행할 수 없어요.');
      case MarkNotificationAsReadFailure():
        showToast('알림을 읽음 처리하지 못했어요.');
      case FetchHeartRateFailure():
        showToast('심박수를 불러오지 못했어요.');
      case FetchNotificationFailure():
        showToast('알림 목록을 불러오지 못했어요.');
      case FetchUserFailure():
        showToast('사용자 정보를 불러오지 못했어요.');
      case FetchSeniorCardFailure():
        showToast('카드를 불러오지 못했어요.');
      case NavigateToMedicationCamera(:final scheduleId, :final doseCount):
        unawaited(_openMedicationCamera(context, scheduleId, doseCount));
      case MedicationScheduleUnavailable():
        showToast('복용 일정 정보를 불러오지 못했어요.');
      case RequestCameraPermissionFailure():
        showToast('카메라 권한이 필요해요.');
      case CameraPermissionSettingsGranted():
        showToast('카메라 권한이 허용되었어요. 다시 촬영해 주세요.');
      case CameraPermissionSettingsDenied():
        showToast('카메라 권한이 아직 필요해요.');
      case CameraPermissionSettingsLaunchFailure():
        showToast('설정 화면을 열지 못했어요.');
      case ShowMedicationReward(:final result):
        showDialog(
          context: context,
          builder: (_) => MedicationRewardDialog(
            earnedPoint: result.earnedPoints,
            currentPoint: result.currentPoints,
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) {
        return HomeViewModel(
          homeRepository: context.read<HomeRepository>(),
          myPageRepository: context.read<MyPageRepository>(),
          notificationRepository: context.read<NotificationRepository>(),
          heartRateRepository: context.read<HeartRateRepository>(),
          locationRepository: context.read<LocationRepository>(),
          stepProvider: context.read<WalkProvider>(),
          medicationRepository: context.read<MedicationRepository>(),
          noticeController: context.read<BackgroundLocationNoticeController>(),
        );
      },
      builder: (context, child) {
        final viewModel = context.read<HomeViewModel>();
        final uiState = context.select<HomeViewModel, HomeUiState>(
          (vm) => vm.uiState,
        );
        final notification = uiState.notification;

        return UiEventListener(
          stream: viewModel.uiEvent,
          onEvent: (event) => _handleEvent(context, event),
          child: Scaffold(
            backgroundColor: MyColor.grey100,
            extendBodyBehindAppBar: true,
            appBar: const _HomeAppBar(),
            body: LayoutBuilder(
              builder: (context, constraints) {
                final backgroundHeight = constraints.maxHeight -
                    _CarouselMenu.sheetHeightOf(context) +
                    _CarouselMenu.sheetRadius;

                return Stack(
                  children: [
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      height: backgroundHeight,
                      child: const WidyuAssetImage(
                        name: 'img_375_home_background.png',
                        fit: BoxFit.cover,
                        alignment: Alignment.topCenter,
                      ),
                    ),
                    CustomScrollView(
                      slivers: [
                        SliverFillRemaining(
                          hasScrollBody: false,
                          child: Padding(
                            padding: EdgeInsets.only(
                              top: Scaffold.of(context).appBarMaxHeight!,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      if (notification == null)
                                        const SizedBox(height: 28)
                                      else ...[
                                        _NotificationView(
                                          id: notification.notificationId,
                                          icon: notification.icon,
                                          description: notification.description,
                                          onTap:
                                              viewModel.markNotificationAsRead,
                                        ),
                                        const SizedBox(height: 10),
                                      ],
                                      _HomeGreetingView(
                                        isLoading: uiState.isUserLoading,
                                        name: uiState.name,
                                      ),
                                      const SizedBox(height: 26),
                                      _WatchDataView(
                                        isLoading: uiState.isHeartRateLoading,
                                        isWearing: uiState.isWearing,
                                        heartRate: uiState.heartRate,
                                        status: uiState.heartRateStatus,
                                        measuredAt: uiState.measuredAt,
                                        onHeartRateClick:
                                            viewModel.fetchHeartRate,
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 24),
                                  child: _CarouselMenu(
                                    isLoading: uiState.isSeniorCardLoading,
                                    hasGoal: uiState.hasGoal,
                                    thumbanils: uiState.thumbnails,
                                    medicationStatus: uiState.medicationStatus,
                                    hasStepGoal: uiState.hasStepGoal,
                                    stepProgress: uiState.stepProgressOf(
                                      context.select<WalkProvider, int>(
                                          (p) => p.steps),
                                    ),
                                    hasHealthSchedule:
                                        uiState.hasHealthSchedule,
                                    onCameraTap: () =>
                                        viewModel.takeMedicationPhoto(
                                      showPrompt: (type, mode) =>
                                          showPermissionRecoveryPrompt(
                                              context, type, mode),
                                    ),
                                    onRouteTap: () =>
                                        viewModel.openHealthScheduleRoute(
                                      showPrompt: (type, mode) =>
                                          showPermissionRecoveryPrompt(
                                              context, type, mode),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }
}
