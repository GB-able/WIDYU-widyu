import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:widyu/core/data/repository/notification/notification_repository.dart';
import 'package:widyu/core/ui/theme/colors.dart';
import 'package:widyu/core/ui/theme/typos.dart';
import 'package:widyu/core/ui/widgets/ui_event_listener.dart';
import 'package:widyu/core/ui/widgets/widu_icon.dart';
import 'package:widyu/core/utils/show_toast.dart';
import 'package:widyu/feature/notification_setting/notification_setting_ui_event.dart';
import 'package:widyu/feature/notification_setting/notification_setting_ui_model.dart';
import 'package:widyu/feature/notification_setting/notification_setting_ui_state.dart';
import 'package:widyu/feature/notification_setting/notification_setting_view_model.dart';
import 'package:widyu/gen/assets.gen.dart';

part 'widget/notification_setting_app_bar.dart';
part 'widget/notification_setting_toggle.dart';
part 'widget/notification_setting_view.dart';

class NotificationSettingScreen extends StatelessWidget {
  const NotificationSettingScreen({super.key});

  void _handleEvent(NotificationSettingUiEvent event) {
    switch (event) {
      case FetchNotificationSettingFailure():
        showToast('알림 설정 조회에 실패했습니다.');
      case UpdateNotificationSettingFailure():
        showToast('알림 설정 변경에 실패했습니다.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => NotificationSettingViewModel(
        repository: context.read<NotificationRepository>(),
      ),
      builder: (context, _) {
        final uiState =
            context.select<NotificationSettingViewModel, NotificationSettingUiState>(
                (vm) => vm.uiState);
        final viewModel = context.read<NotificationSettingViewModel>();

        return UiEventListener(
          stream: viewModel.uiEvent,
          onEvent: _handleEvent,
          child: Scaffold(
            appBar: const _NotificationSettingAppBar(),
            body: uiState.isLoading
                ? const Center(child: CircularProgressIndicator())
                : Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        _NotificationSettingView(
                          notifications: uiState.notifications,
                          isUpdating: uiState.isUpdating,
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
