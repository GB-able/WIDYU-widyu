import 'dart:async';

import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:widyu/app/route/app_route.dart';
import 'package:widyu/core/di/providers.dart';
import 'package:widyu/core/model/goal/hospital/daily_health_schedule.dart';
import 'package:widyu/core/model/goal/medication/medication.dart';
import 'package:widyu/core/model/goal/medication/medication_point_result.dart';
import 'package:widyu/core/ui/theme/colors.dart';
import 'package:widyu/core/ui/theme/typos.dart';
import 'package:widyu/core/ui/widget/medication_reward_dialog.dart';
import 'package:widyu/core/ui/widget/point_banner.dart';
import 'package:widyu/core/ui/widget/skeleton_box.dart';
import 'package:widyu/core/ui/widget/ui_event_listener.dart';
import 'package:widyu/core/ui/widget/wave_pulse_effect.dart';
import 'package:widyu/core/ui/widget/widu_icon.dart';
import 'package:widyu/core/ui/widget/widyu_text_button.dart';
import 'package:widyu/core/util/extension/int_extension.dart';
import 'package:widyu/core/util/medication_verification_launcher.dart';
import 'package:widyu/feature/goal/main/goal_schedule.dart';
import 'package:widyu/feature/goal/main/goal_ui_event.dart';
import 'package:widyu/feature/goal/main/goal_ui_state.dart';
import 'package:widyu/feature/goal/main/goal_view_model.dart';
import 'package:widyu/feature/goal/widget/goal_timeline.dart';
import 'package:widyu/feature/goal/widget/icon_tile.dart';
import 'package:widyu/gen/assets.gen.dart';

part 'widget/goal_app_bar.dart';
part 'widget/goal_content.dart';
part 'widget/goal_error_widget.dart';
part 'widget/goal_header.dart';
part 'widget/goal_skeleton.dart';
part 'widget/schedule_timeline.dart';

enum GoalType { medicine, walk, hospital }

class GoalScreen extends ConsumerWidget {
  const GoalScreen({super.key});

  void _handleEvent(BuildContext context, GoalUiEvent event) {
    switch (event) {
      case VerifyMedicationSuccess(:final earnedPoint, :final currentPoint):
        showDialog<void>(
          context: context,
          builder: (context) => MedicationRewardDialog(
            earnedPoint: earnedPoint,
            currentPoint: currentPoint,
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(goalViewModelProvider.notifier);
    final uiState = ref.watch(goalViewModelProvider);

    return UiEventListener(
      stream: viewModel.uiEvent,
      onEvent: (event) => _handleEvent(context, event),
      child: Scaffold(
        backgroundColor: MyColor.white,
        appBar: const _GoalAppBar(),
        body: Stack(
          children: [
            SingleChildScrollView(
              padding: EdgeInsets.only(
                bottom: 100 + MediaQuery.of(context).padding.bottom,
              ),
              child: Skeletonizer(
                enabled: uiState.isLoading,
                // 기기에서 동작 줄이기를 켜면 움직이지 않는 블록만 보여 준다.
                effect: MediaQuery.disableAnimationsOf(context)
                    ? const SolidColorEffect(color: MyColor.grey200)
                    : const WavePulseEffect(),
                containersColor: MyColor.grey50,
                // 시안처럼 글자 블록도 모서리를 6으로 둥글린다.
                textBoneBorderRadius:
                    TextBoneBorderRadius(BorderRadius.circular(6)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _GoalHeader(point: uiState.point),
                    _GoalContent(
                      state: uiState,
                      onRetry: viewModel.refresh,
                      onMedicationVerified: viewModel.onMedicationVerified,
                      findRoute: viewModel.findRoute,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
