import 'dart:async';
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
import 'package:watch_connectivity/watch_connectivity.dart';
import 'package:widyu/app/routes/app_route.dart';
import 'package:widyu/core/data/repository/heartRate/heart_rate_repository.dart';
import 'package:widyu/core/data/repository/home/home_repository.dart';
import 'package:widyu/core/data/repository/location/location_repository.dart';
import 'package:widyu/core/data/repository/myPage/my_page_repository.dart';
import 'package:widyu/core/data/repository/notification/notification_repository.dart';
import 'package:widyu/core/model/heartRate/heart_rate_status.dart';
import 'package:widyu/core/model/home/medication_status.dart';
import 'package:widyu/core/ui/theme/colors.dart';
import 'package:widyu/core/ui/theme/typos.dart';
import 'package:widyu/core/ui/widgets/ui_event_listener.dart';
import 'package:widyu/core/ui/widgets/widyu_asset_image.dart';
import 'package:widyu/core/ui/widgets/widyu_icon.dart';
import 'package:widyu/core/ui/widgets/widyu_text_button.dart';
import 'package:widyu/core/ui/widgets/permission_recovery_dialog.dart';
import 'package:widyu/core/model/permission/permission_recovery_prompt.dart';
import 'package:widyu/core/model/permission/permission_type.dart';
import 'package:widyu/core/utils/app_service_controller.dart';
import 'package:widyu/core/utils/background_location_notice_controller.dart';
import 'package:widyu/core/utils/permission_manager.dart';
import 'package:widyu/core/ui/widgets/widyu_permission_dialog.dart';
import 'package:widyu/feature/permission/permission_ui_model.dart';
import 'package:widyu/core/utils/show_toast.dart';
import 'package:widyu/feature/home/home_ui_event.dart';
import 'package:widyu/feature/home/home_ui_state.dart';
import 'package:widyu/feature/home/home_view_model.dart';

part 'widget/home_app_bar.dart';
part 'widget/mesh_gradient_background.dart';
part 'widget/notification_view.dart';
part 'widget/home_greeting_view.dart';
part 'widget/watch_data_view.dart';
part 'widget/carousel_menu.dart';
part 'widget/carousel_card_shell.dart';
part 'widget/spring_bounce.dart';
part 'widget/carousel_indicator.dart';
part 'widget/medication_card.dart';
part 'widget/dose_countdown.dart';
part 'widget/health_schedule_card.dart';
part 'widget/walking_card.dart';
part 'widget/album_card.dart';
part 'widget/reward_dialog.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _showBackgroundLocationNotice(
    BuildContext context,
    BackgroundLocationNoticeController noticeController,
    AppServiceController serviceController,
  ) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!context.mounted || !_isCurrentRoute(context)) return;
      final shouldShow = await noticeController.claimNoticeIfNeeded();
      if (!context.mounted || !_isCurrentRoute(context) || !shouldShow) return;

      final openSettings = await WidyuPermissionDialog.show(
        context,
        description:
            '앱을 사용하지 않는 동안에 보호자에게 내 위치를\n공유하려면 설정>권한에서 위치 권한을\n 항상 허용으로 설정해 주세요.',
      );
      if (!openSettings || !context.mounted || !_isCurrentRoute(context)) {
        return;
      }

      final result = await noticeController.openSettingsAndRecheck();
      if (result == PermissionSettingsResult.granted ||
          result == PermissionSettingsResult.denied) {
        unawaited(serviceController.refresh());
      } else if (result == PermissionSettingsResult.launchFailed &&
          context.mounted &&
          _isCurrentRoute(context)) {
        showToast('설정 화면을 열지 못했어요.');
      }
    });
  }

  bool _isCurrentRoute(BuildContext context) =>
      ModalRoute.of(context)?.isCurrent ?? true;

  void _handleEvent(BuildContext context, HomeUiEvent event) {
    switch (event) {
      case TakeMedicationPhotoSuccess():
        // 추후 서버 연결 필요
        showDialog(
          context: context,
          builder: (_) => const _RewardDialog(point: 100, totalPoint: 600),
        );
      case RequestCameraPermissionFailure():
        showToast('카메라 권한이 필요해요.');
      case RequestCameraPermissionPermanentlyFailure():
        showToast('설정에서 카메라 권한을 허용해 주세요.');
      case CameraPermissionSettingsGranted():
        showToast('카메라 권한이 허용되었어요. 다시 촬영해 주세요.');
      case CameraPermissionSettingsDenied():
        showToast('카메라 권한이 아직 필요해요.');
      case CameraPermissionSettingsLaunchFailure():
        showToast('설정 화면을 열지 못했어요.');
      case OpenCameraFailure():
        showToast('카메라를 실행할 수 없어요. 잠시 후 다시 시도해 주세요.');
      case HealthSchedulePlaceUnavailable():
        showToast('일정 장소 정보가 없어요.');
      case OpenKakaoMapFailure():
        showToast('카카오맵을 실행할 수 없어요.');
      case LocationPermissionUnavailable():
        showToast('현재 위치 없이 길찾기를 열어요.');
      case LocationPermissionSettingsLaunchFailure():
        showToast('설정 화면을 열지 못해 현재 위치 없이 길찾기를 열어요.');
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
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) {
        final watch = WatchConnectivity();
        return HomeViewModel(
          homeRepository: context.read<HomeRepository>(),
          myPageRepository: context.read<MyPageRepository>(),
          notificationRepository: context.read<NotificationRepository>(),
          heartRateRepository: context.read<HeartRateRepository>(),
          locationRepository: context.read<LocationRepository>(),
          isPaired: watch.isPaired,
        );
      },
      builder: (context, child) {
        final viewModel = context.read<HomeViewModel>();
        final uiState =
            context.select<HomeViewModel, HomeUiState>((vm) => vm.uiState);
        final notification = uiState.notification;
        final noticeController =
            context.read<BackgroundLocationNoticeController>();
        final serviceController = context.read<AppServiceController>();
        _showBackgroundLocationNotice(
          context,
          noticeController,
          serviceController,
        );

        return UiEventListener(
          stream: viewModel.uiEvent,
          onEvent: (event) => _handleEvent(context, event),
          child: Scaffold(
            backgroundColor: MyColor.grey100,
            extendBodyBehindAppBar: true,
            appBar: const _HomeAppBar(),
            body: Stack(
              children: [
                const Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: WidyuAssetImage(
                    name: 'img_home_background.png',
                    fit: BoxFit.fitWidth,
                  ),
                ),
                LayoutBuilder(
                  builder: (context, constraints) => SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints:
                          BoxConstraints(minHeight: constraints.maxHeight),
                      child: Padding(
                        padding: EdgeInsets.only(
                          top: MediaQuery.of(context).padding.top +
                              kToolbarHeight,
                          bottom: 90,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (notification == null)
                                    const SizedBox(height: 28)
                                  else ...[
                                    _NotificationView(
                                      id: notification.notificationId,
                                      icon: notification.icon,
                                      description: notification.description,
                                      onTap: viewModel.markNotificationAsRead,
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
                                    onHeartRateClick: viewModel.fetchHeartRate,
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
                                stepProgress: uiState.stepProgress,
                                onCameraTap: () =>
                                    viewModel.takeMedicationPhoto(
                                  showPrompt: (type, mode) =>
                                      _showPrompt(context, type, mode),
                                ),
                                onRouteTap: () =>
                                    viewModel.openHealthScheduleRoute(
                                  showPrompt: (type, mode) =>
                                      _showPrompt(context, type, mode),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

Future<PermissionRecoveryAction> _showPrompt(
  BuildContext context,
  PermissionType type,
  PermissionRecoveryMode mode,
) =>
    PermissionRecoveryDialog.show(
      context,
      permissionName: type.title,
      description: type.description,
      mode: mode,
    );
