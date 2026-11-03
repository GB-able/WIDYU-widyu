import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:widyu/core/ui/theme/colors.dart';
import 'package:widyu/core/ui/theme/typos.dart';
import 'package:widyu/core/ui/widgets/ui_event_listener.dart';
import 'package:widyu/core/ui/widgets/widu_icon.dart';
import 'package:widyu/core/utils/show_toast.dart';
import 'package:widyu/feature/notification_setting/notification_setting_ui_event.dart';
import 'package:widyu/feature/notification_setting/notification_setting_ui_model.dart';
import 'package:widyu/feature/notification_setting/notification_setting_view_model.dart';
import 'package:widyu/gen/assets.gen.dart';

part 'widget/notification_setting_app_bar.dart';
part 'widget/notification_setting_toggle.dart';
part 'widget/notification_setting_view.dart';

class NotificationSettingScreen extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(notificationSettingViewModelProvider.notifier);
    final uiState = ref.watch(notificationSettingViewModelProvider);

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
  }
}
