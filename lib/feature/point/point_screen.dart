import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:widyu/core/ui/theme/colors.dart';
import 'package:widyu/core/ui/theme/typos.dart';
import 'package:widyu/core/ui/widgets/ui_event_listener.dart';
import 'package:widyu/core/ui/widgets/widu_icon.dart';
import 'package:widyu/core/utils/show_toast.dart';
import 'package:widyu/feature/point/point_ui_event.dart';
import 'package:widyu/feature/point/point_ui_model.dart';
import 'package:widyu/feature/point/point_view_model.dart';
import 'package:widyu/gen/assets.gen.dart';

part 'widget/point_app_bar.dart';
part 'widget/point_history_view.dart';
part 'widget/total_point_view.dart';

class PointScreen extends ConsumerWidget {
  const PointScreen({super.key});

  void _handleEvent(PointUiEvent event) {
    switch (event) {
      case FetchPointFailure():
        showToast('포인트 내역을 불러오는데 실패했습니다.');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uiEvent = ref.watch(pointViewModelProvider.notifier).uiEvent;
    final uiState = ref.watch(pointViewModelProvider);

    return UiEventListener(
      stream: uiEvent,
      onEvent: _handleEvent,
      child: Scaffold(
        appBar: const _PointAppBar(),
        body: uiState.isLoading
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    _TotalPointView(point: uiState.point),
                    const SizedBox(height: 16),
                    Expanded(
                      child:
                          _PointHistoryView(histories: uiState.histories),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
