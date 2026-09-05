import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:widyu/app/routes/app_route.dart';
import 'package:widyu/core/data/provider/point_provider.dart';
import 'package:widyu/core/data/provider/step_provider.dart';
import 'package:widyu/core/data/repository/goal/goal_repository.dart';
import 'package:widyu/core/data/repository/location/location_repository.dart';
import 'package:widyu/core/model/goal/walk/walk.dart';
import 'package:widyu/core/model/goal/weekly_goal_status_response.dart';
import 'package:widyu/core/ui/theme/colors.dart';
import 'package:widyu/core/ui/theme/typos.dart';
import 'package:widyu/core/ui/widgets/icon_widget.dart';
import 'package:widyu/core/ui/widgets/medicine_reward_dialog.dart';
import 'package:widyu/core/ui/widgets/ui_event_listener.dart';
import 'package:widyu/core/ui/widgets/widyu_asset_image.dart';
import 'package:widyu/core/ui/widgets/widyu_text_button.dart';
import 'package:widyu/core/utils/extensions/date_extension.dart';
import 'package:widyu/core/utils/show_toast.dart';
import 'package:widyu/feature/goal/_widget/goal_empty_card.dart';
import 'package:widyu/feature/goal/_widget/hospital_card.dart';
import 'package:widyu/feature/goal/_widget/medicine_card.dart';
import 'package:widyu/feature/goal/_widget/walk_card.dart';
import 'package:widyu/feature/goal/main/goal_ui_event.dart';
import 'package:widyu/feature/goal/main/goal_ui_state.dart';
import 'package:widyu/feature/goal/main/goal_view_model.dart';

part 'widgets/goal_app_bar.dart';
part 'widgets/goal_content.dart';
part 'widgets/goal_error_widget.dart';
part 'widgets/goal_header.dart';
part 'widgets/goal_loading_widget.dart';
part 'widgets/weekly_card.dart';

enum GoalType { medicine, walk, hospital }

class GoalScreen extends StatefulWidget {
  const GoalScreen({super.key});

  @override
  State<GoalScreen> createState() => _GoalScreenState();
}

class _GoalScreenState extends State<GoalScreen> {
  static const _headerBottomGap = 24.0;
  static const _appBarFadeDistance = 52.0;

  final GlobalKey _headerKey = GlobalKey();
  final ValueNotifier<double> _appBarFade = ValueNotifier(0);

  @override
  void dispose() {
    _appBarFade.dispose();
    super.dispose();
  }

  bool _onScroll(ScrollNotification notification) {
    if (notification.depth != 0) return false;

    final headerBox =
        _headerKey.currentContext?.findRenderObject() as RenderBox?;
    if (headerBox == null) return false;

    final remaining =
        headerBox.size.height + _headerBottomGap - notification.metrics.pixels;
    _appBarFade.value = (1 - remaining / _appBarFadeDistance).clamp(0.0, 1.0);
    return false;
  }

  void _handleEvent(BuildContext context, GoalUiEvent event) {
    switch (event) {
      case FetchWeeklyStatusFailure():
        showToast('이번 주 달성 현황을 불러오지 못했어요.');
      case VerifyMedicineFailure(:final message):
        showToast(message);
      case VerifyMeidcineSuccess(:final earnedPoint, :final existingPoint):
        showDialog(
            context: context,
            builder: (context) => MedicineRewardDialog(
                earnedPoint: earnedPoint, existingPoint: existingPoint));
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => GoalViewModel(
        repository: context.read<GoalRepository>(),
        pointProvider: context.read<PointProvider>(),
        stepProvider: context.read<StepProvider>(),
        locationRepository: context.read<LocationRepository>(),
      ),
      builder: (context, child) {
        final viewModel = context.read<GoalViewModel>();
        final uiState =
            context.select<GoalViewModel, GoalUiState>((vm) => vm.uiState);

        return UiEventListener(
          stream: viewModel.uiEvent,
          onEvent: (event) => _handleEvent(context, event),
          child: Scaffold(
            backgroundColor: MyColor.orange300,
            appBar: _GoalAppBar(fade: _appBarFade),
            body: Stack(
              children: [
                NotificationListener<ScrollNotification>(
                  onNotification: _onScroll,
                  child: CustomScrollView(
                    physics: const ClampingScrollPhysics(),
                    slivers: [
                      SliverToBoxAdapter(
                        child: Padding(
                          padding:
                              const EdgeInsets.only(bottom: _headerBottomGap),
                          child: _GoalHeader(
                            key: _headerKey,
                            summary: uiState.weeklyStatuses,
                          ),
                        ),
                      ),
                      SliverLayoutBuilder(
                        builder: (context, sliverConstraints) {
                          final minHeight = math.max(
                            0.0,
                            sliverConstraints.viewportMainAxisExtent -
                                sliverConstraints.precedingScrollExtent,
                          );
                          return SliverToBoxAdapter(
                            child: ConstrainedBox(
                              constraints: BoxConstraints(minHeight: minHeight),
                              child: _GoalContent(
                                state: uiState.cards,
                                onRetry: viewModel.refresh,
                                onTakePhoto: viewModel.verifyMedication,
                                findRoute: viewModel.findRoute,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                if (uiState.isLoading) const _GoalLoadingWidget(),
              ],
            ),
          ),
        );
      },
    );
  }
}
