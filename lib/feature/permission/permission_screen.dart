import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:widyu/core/model/permission/permission_type.dart';
import 'package:widyu/core/ui/theme/colors.dart';
import 'package:widyu/core/ui/theme/typos.dart';
import 'package:widyu/core/ui/widgets/ui_event_listener.dart';
import 'package:widyu/core/ui/widgets/widu_icon.dart';
import 'package:widyu/core/ui/widgets/widyu_text_button.dart';
import 'package:widyu/core/utils/show_toast.dart';
import 'package:widyu/feature/permission/permission_ui_event.dart';
import 'package:widyu/feature/permission/permission_ui_model.dart';
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
        final isRequesting =
            context.select<PermissionViewModel, bool>((vm) => vm.isRequesting);
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
                          requiredPermissions: viewModel.requiredPermissions,
                          optionalPermissions: viewModel.optionalPermissions,
                        ),
                      ),
                    ),
                    WidyuTextButton(
                      onTap: () => viewModel.requestPermissions(
                        showPrompt: (type, mode) =>
                            showPermissionRecoveryPrompt(context, type, mode),
                      ),
                      text: '확인',
                      enable: !isRequesting,
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
