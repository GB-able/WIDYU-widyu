import 'package:flutter/material.dart';
import 'package:widyu/core/ui/widgets/widyu_icon.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:widyu/core/data/repository/myPage/my_page_repository.dart';
import 'package:widyu/core/model/myPage/contact/family_member.dart';
import 'package:widyu/core/model/myPage/contact/representative.dart';
import 'package:widyu/core/ui/theme/colors.dart';
import 'package:widyu/core/ui/theme/typos.dart';
import 'package:widyu/core/ui/widgets/ui_event_listener.dart';
import 'package:widyu/core/ui/widgets/widyu_divider.dart';
import 'package:widyu/core/utils/extensions/string_extension.dart';
import 'package:widyu/core/utils/show_toast.dart';
import 'package:widyu/feature/contact/contact_ui_event.dart';
import 'package:widyu/feature/contact/contact_ui_state.dart';
import 'package:widyu/feature/contact/contact_view_model.dart';

part 'widget/contact_app_bar.dart';
part 'widget/representative_contact_view.dart';
part 'widget/family_contact_view.dart';
part 'widget/family_contact_content.dart';

class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  void _handleEvent(ContactUiEvent event) {
    switch (event) {
      case FetchContactFailure():
        showToast('연락처 조회에 실패했습니다.');

      case UpdateRepresentativeContactFailure():
        showToast('대표 연락처 변경에 실패했습니다.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) =>
          ContactViewModel(repository: context.read<MyPageRepository>()),
      builder: (context, child) {
        final viewModel = context.read<ContactViewModel>();
        final uiState = context
            .select<ContactViewModel, ContactUiState>((vm) => vm.uiState);

        return UiEventListener(
          stream: viewModel.uiEvent,
          onEvent: _handleEvent,
          child: Scaffold(
            appBar: const _ContactAppBar(),
            body: uiState.isLoading
                ? const Center(child: CircularProgressIndicator())
                : Column(
                    children: [
                      const SizedBox(height: 16),
                      _RepresentativeContactView(
                        representative: uiState.representative,
                      ),
                      const SizedBox(height: 40),
                      const WidyuDivider(),
                      const SizedBox(height: 40),
                      _FamilyContactView(
                        familyMembers: uiState.familyMembers,
                        onRepresentativeSelected:
                            viewModel.updateRepresentativeContact,
                      ),
                    ],
                  ),
          ),
        );
      },
    );
  }
}
