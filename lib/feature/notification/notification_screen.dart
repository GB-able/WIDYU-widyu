import 'package:flutter/material.dart';
import 'package:widyu/core/ui/widgets/widyu_icon.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:widyu/core/data/repository/notification/notification_repository.dart';
import 'package:widyu/core/ui/theme/colors.dart';
import 'package:widyu/core/ui/theme/typos.dart';
import 'package:widyu/core/ui/widgets/ui_event_listener.dart';
import 'package:widyu/core/utils/show_toast.dart';
import 'package:widyu/feature/notification/notification_ui_event.dart';
import 'package:widyu/feature/notification/notification_ui_model.dart';
import 'package:widyu/feature/notification/notification_ui_state.dart';
import 'package:widyu/feature/notification/notification_view_model.dart';

part 'widget/notification_app_bar.dart';
part 'widget/notification_setting_view.dart';
part 'widget/notification_toggle.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  void _handleEvent(NotificationUiEvent event) {
    switch (event) {
      case FetchNotificationFailure():
        showToast('알림 설정 조회에 실패했습니다.');
      case UpdateNotificationFailure():
        showToast('알림 설정 변경에 실패했습니다.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => NotificationViewModel(
        repository: context.read<NotificationRepository>(),
      ),
      builder: (context, _) {
        final uiState =
            context.select<NotificationViewModel, NotificationUiState>(
                (vm) => vm.uiState);
        final viewModel = context.read<NotificationViewModel>();

        return UiEventListener(
          stream: viewModel.uiEvent,
          onEvent: _handleEvent,
          child: Scaffold(
            appBar: const _NotificationAppBar(),
            body: uiState.isLoading
                ? const Center(child: CircularProgressIndicator())
                : Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        _NotificationSettingView(
                          notifications: uiState.notifications,
                          onToggle: viewModel.updateNotificationSetting,
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
