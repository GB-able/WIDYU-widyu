import 'dart:async';

import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:widyu/app/routes/app_route.dart';
import 'package:widyu/core/di/providers.dart';
import 'package:widyu/core/model/goal/hospital/daily_health_schedule.dart';
import 'package:widyu/core/model/goal/medication/medication.dart';
import 'package:widyu/core/model/goal/medication/medication_point_result.dart';
import 'package:widyu/core/ui/theme/colors.dart';
import 'package:widyu/core/ui/theme/typos.dart';
import 'package:widyu/core/ui/widgets/custom_loading_widget.dart';
import 'package:widyu/core/ui/widgets/medication_reward_dialog.dart';
import 'package:widyu/core/ui/widgets/ui_event_listener.dart';
import 'package:widyu/core/ui/widgets/widu_icon.dart';
import 'package:widyu/core/ui/widgets/widyu_text_button.dart';
import 'package:widyu/core/utils/medication_verification_launcher.dart';
import 'package:widyu/feature/goal/_widget/goal_timeline.dart';
import 'package:widyu/feature/goal/_widget/icon_tile.dart';
import 'package:widyu/feature/goal/_widget/walk_donut_card.dart';
import 'package:widyu/feature/goal/main/goal_schedule.dart';
import 'package:widyu/feature/goal/main/goal_ui_event.dart';
import 'package:widyu/feature/goal/main/goal_ui_state.dart';
import 'package:widyu/feature/goal/main/goal_view_model.dart';
import 'package:widyu/gen/assets.gen.dart';

part 'widgets/goal_app_bar.dart';
part 'widgets/goal_content.dart';
part 'widgets/goal_error_widget.dart';
part 'widgets/goal_header.dart';
part 'widgets/schedule_timeline.dart';

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
            if (uiState.isLoading) const CustomLoadingWidget(),
          ],
        ),
      ),
    );
  }
}
