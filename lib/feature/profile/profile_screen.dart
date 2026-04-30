import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:widyu/core/data/repository/myPage/my_page_repository.dart';
import 'package:widyu/core/ui/theme/colors.dart';
import 'package:widyu/core/ui/theme/typos.dart';
import 'package:widyu/core/ui/widgets/ui_event_listener.dart';
import 'package:widyu/core/utils/show_toast.dart';
import 'package:widyu/feature/profile/profile_ui_event.dart';
import 'package:widyu/feature/profile/profile_ui_state.dart';
import 'package:widyu/feature/profile/profile_view_model.dart';

part 'widget/profile_edit_view.dart';
part 'widget/profile_image_view.dart';
part 'widget/profile_name_view.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _handleEvent(ProfileUiEvent event) {
    switch (event) {
      case FetchProfileFailure():
        showToast('프로필 정보를 불러오는데 실패했습니다.');
      case UpdateNameFailure():
        showToast('이름 변경에 실패했습니다.');
      case UpdateProfileImageFailure():
        showToast('프로필 사진 변경에 실패했습니다.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ProfileViewModel(
        repository: context.read<MyPageRepository>(),
      ),
      builder: (context, child) {
        final uiState = context
            .select<ProfileViewModel, ProfileUiState>((vm) => vm.uiState);
        final uiEvent = context.read<ProfileViewModel>().uiEvent;

        return UiEventListener(
          stream: uiEvent,
          onEvent: _handleEvent,
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: MyColor.white,
              title: Text(
                '프로필 설정',
                style: MyTypo.title4.copyWith(color: MyColor.grey800),
              ),
              centerTitle: true,
              leading: IconButton(
                onPressed: () => context.pop(),
                icon: SvgPicture.asset(
                  'assets/icons/ic_22_arrow_left_bold.svg',
                  width: 22,
                  height: 22,
                ),
              ),
            ),
            body: uiState.isLoading
                ? const Center(child: CircularProgressIndicator())
                : const Padding(
                    padding: EdgeInsets.only(top: 24),
                    child: Column(
                      children: [
                        _ProfileEditView(),
                        SizedBox(
                          width: double.infinity,
                          height: 10,
                          child: DecoratedBox(
                            decoration: BoxDecoration(color: MyColor.grey50),
                          ),
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
