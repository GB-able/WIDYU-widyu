import 'package:flutter/material.dart';
import 'package:widyu/core/ui/widgets/widyu_icon.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:widyu/core/data/repository/myPage/my_page_repository.dart';
import 'package:widyu/core/ui/theme/colors.dart';
import 'package:widyu/core/ui/theme/typos.dart';
import 'package:widyu/core/ui/widgets/ui_event_listener.dart';
import 'package:widyu/core/utils/show_toast.dart';
import 'package:widyu/feature/point/point_ui_event.dart';
import 'package:widyu/feature/point/point_ui_model.dart';
import 'package:widyu/feature/point/point_ui_state.dart';
import 'package:widyu/feature/point/point_view_model.dart';

part 'widget/point_app_bar.dart';
part 'widget/total_point_view.dart';
part 'widget/point_history_view.dart';

class PointScreen extends StatelessWidget {
  const PointScreen({super.key});

  void _handleEvent(PointUiEvent event) {
    switch (event) {
      case FetchPointFailure():
        showToast('포인트 내역을 불러오는데 실패했습니다.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => PointViewModel(
        repository: context.read<MyPageRepository>(),
      ),
      builder: (context, child) {
        final uiEvent = context.read<PointViewModel>().uiEvent;
        final uiState =
            context.select<PointViewModel, PointUiState>((vm) => vm.uiState);

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
                        _TotalPointView(amount: uiState.currentPoints),
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
      },
    );
  }
}
