import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:widyu/core/data/repository/myPage/my_page_repository.dart';
import 'package:widyu/core/ui/theme/colors.dart';
import 'package:widyu/core/ui/theme/typos.dart';
import 'package:widyu/core/ui/widgets/ui_event_listener.dart';
import 'package:widyu/core/ui/widgets/widyu_icon.dart';
import 'package:widyu/core/ui/widgets/widyu_text_button.dart';
import 'package:widyu/core/utils/show_toast.dart';
import 'package:widyu/feature/management/management_ui_event.dart';
import 'package:widyu/feature/management/management_ui_state.dart';
import 'package:widyu/feature/management/management_view_model.dart';

part 'widget/close_button.dart';
part 'widget/famliy_code_view.dart';
part 'widget/invite_button.dart';
part 'widget/management_app_bar.dart';
part 'widget/share_item.dart';

class ManagementScreen extends StatelessWidget {
  const ManagementScreen({super.key});

  void _handleEvent(ManagementUiEvent event) {
    switch (event) {
      case FetchFamilyCodeFailure():
        showToast('가족 멤버 조회에 실패했습니다.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) =>
          ManagementViewModel(repository: context.read<MyPageRepository>()),
      builder: (context, child) {
        final uiEvent = context.read<ManagementViewModel>().uiEvent;
        final uiState = context
            .select<ManagementViewModel, ManagementUiState>((vm) => vm.uiState);

        return UiEventListener(
          stream: uiEvent,
          onEvent: _handleEvent,
          child: Scaffold(
            appBar: const _ManagementAppBar(),
            body: uiState.isLoading
                ? const Center(child: CircularProgressIndicator())
                : SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          _FamilyCodeView(familyCode: uiState.familyCode),
                          const Spacer(),
                          _InviteButton(familyCode: uiState.familyCode),
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
