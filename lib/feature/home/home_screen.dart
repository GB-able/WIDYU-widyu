import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:app_settings/app_settings.dart';
import 'package:flutter/foundation.dart' show listEquals;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:watch_connectivity/watch_connectivity.dart';
import 'package:widyu/app/routes/app_route.dart';
import 'package:widyu/core/data/repository/heartRate/heart_rate_repository.dart';
import 'package:widyu/core/data/repository/home/home_repository.dart';
import 'package:widyu/core/data/repository/myPage/my_page_repository.dart';
import 'package:widyu/core/data/repository/notification/notification_repository.dart';
import 'package:widyu/core/model/heartRate/heart_rate_status.dart';
import 'package:widyu/core/ui/theme/colors.dart';
import 'package:widyu/core/ui/theme/typos.dart';
import 'package:widyu/core/ui/widgets/text_btn.dart';
import 'package:widyu/core/ui/widgets/ui_event_listener.dart';
import 'package:widyu/core/ui/widgets/widyu_icon.dart';
import 'package:widyu/feature/home/home_ui_event.dart';
import 'package:widyu/feature/home/home_ui_state.dart';
import 'package:widyu/feature/home/home_view_model.dart';

part 'widget/home_app_bar.dart';
part 'widget/notification_view.dart';
part 'widget/home_greeting_view.dart';
part 'widget/watch_data_view.dart';
part 'widget/carousel_menu.dart';
part 'widget/carousel_card_shell.dart';
part 'widget/carousel_indicator.dart';
part 'widget/medication_card.dart';
part 'widget/health_schedule_card.dart';
part 'widget/walking_card.dart';
part 'widget/album_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _handleEvent(HomeUiEvent event) {}

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
          isPaired: watch.isPaired,
        );
      },
      builder: (context, child) {
        final viewModel = context.read<HomeViewModel>();
        final uiState =
            context.select<HomeViewModel, HomeUiState>((vm) => vm.uiState);

        return UiEventListener(
          stream: viewModel.uiEvent,
          onEvent: _handleEvent,
          child: Scaffold(
            extendBodyBehindAppBar: true,
            appBar: const _HomeAppBar(),
            body: Stack(
              children: [
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Image.asset(
                    'assets/images/img_home_background.png',
                    fit: BoxFit.fitWidth,
                  ),
                ),
                Positioned(
                  bottom: 90,
                  left: 0,
                  right: 0,
                  child: _CarouselMenu(
                    thumbanils: uiState.thumbnails,
                    todayTakenCount: uiState.todayTakenCount,
                    todayTotalCount: uiState.todayTotalCount,
                    nextDoseRemainingTime: uiState.nextDoseRemainingTime,
                    stepProgress: uiState.stepProgress,
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
                            const SizedBox(height: 28),
                            // const SizedBox(height: 12),
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
