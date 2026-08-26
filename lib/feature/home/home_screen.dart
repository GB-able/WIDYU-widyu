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
        AppSettings.openAppSettings();
      case OpenCameraFailure():
        showToast('카메라를 실행할 수 없어요. 잠시 후 다시 시도해 주세요.');
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
                Positioned(
                  bottom: 90,
                  left: 0,
                  right: 0,
                  child: _CarouselMenu(
                    isLoading: uiState.isSeniorCardLoading,
                    hasGoal: uiState.hasGoal,
                    thumbanils: uiState.thumbnails,
                    medicationStatus: uiState.medicationStatus,
                    hasStepGoal: uiState.hasStepGoal,
                    stepProgress: uiState.stepProgress,
                    onCameraTap: viewModel.takeMedicationPhoto,
                    onRouteTap: viewModel.openHealthScheduleRoute,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).padding.top + kToolbarHeight,
                  ),
                  child: Column(
                    spacing: 24,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
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
                    ],
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
