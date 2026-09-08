import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:widyu/core/model/permission/permission_type.dart';
import 'package:widyu/core/ui/theme/colors.dart';
import 'package:widyu/core/ui/theme/typos.dart';
import 'package:widyu/core/ui/widgets/ui_event_listener.dart';
import 'package:widyu/core/ui/widgets/widyu_icon.dart';
import 'package:widyu/core/ui/widgets/widyu_text_button.dart';
import 'package:widyu/core/ui/widgets/permission_recovery_dialog.dart';
import 'package:widyu/core/model/permission/permission_recovery_prompt.dart';
import 'package:widyu/core/utils/show_toast.dart';
import 'package:widyu/feature/permission/permission_ui_event.dart';
import 'package:widyu/feature/permission/permission_ui_model.dart';
import 'package:widyu/feature/permission/permission_ui_state.dart';
import 'package:widyu/feature/permission/permission_view_model.dart';

part 'widget/permission_header.dart';
part 'widget/permission_list.dart';
part 'widget/permission_section.dart';
part 'widget/permission_item.dart';

class PermissionScreen extends StatelessWidget {
  final String nextPath;

  const PermissionScreen({super.key, required this.nextPath});

  void _handleEvent(BuildContext context, PermissionUiEvent event) {
    switch (event) {
      case NavigateToNext():
        context.pushReplacement(nextPath);
      case PermissionsDenied(:final types):
        showToast(
            '${types.map((e) => e.title).join(', ')} 권한이 없어 일부 기능이 제한될 수 있어요.');
      case PermissionSettingsLaunchFailure(:final types):
        showToast('${types.map((e) => e.title).join(', ')} 설정 화면을 열지 못했어요.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => PermissionViewModel(),
      builder: (context, _) {
        final uiState = context
            .select<PermissionViewModel, PermissionUiState>((vm) => vm.uiState);
        final viewModel = context.read<PermissionViewModel>();

        return UiEventListener(
          stream: viewModel.uiEvent,
          onEvent: (event) => _handleEvent(context, event),
          child: Scaffold(
            backgroundColor: MyColor.white,
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _PermissionHeader(),
                    const SizedBox(height: 16),
                    Expanded(
                      child: SingleChildScrollView(
                        child: _PermissionList(
                          requiredPermissions: uiState.requiredPermissions,
                          optionalPermissions: uiState.optionalPermissions,
                        ),
                      ),
                    ),
                    WidyuTextButton(
                      onTap: () => viewModel.requestPermissions(
                        showPrompt: (type, mode) => _showPrompt(context, type, mode),
                      ),
                      text: '확인',
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
  Future<PermissionRecoveryAction> _showPrompt(
    BuildContext context,
    PermissionType type,
    PermissionRecoveryMode mode,
  ) => PermissionRecoveryDialog.show(
    context,
    permissionName: type.title,
    description: type.description,
    mode: mode,
  );
