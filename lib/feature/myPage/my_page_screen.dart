import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:widyu/app/routes/app_route.dart';
import 'package:widyu/core/di/providers.dart';
import 'package:widyu/core/ui/theme/colors.dart';
import 'package:widyu/core/ui/theme/typos.dart';
import 'package:widyu/core/ui/widgets/ui_event_listener.dart';
import 'package:widyu/core/ui/widgets/widu_icon.dart';
import 'package:widyu/core/ui/widgets/widyu_divider.dart';
import 'package:widyu/core/utils/show_toast.dart';
import 'package:widyu/feature/myPage/my_page_ui_event.dart';
import 'package:widyu/feature/myPage/my_page_view_model.dart';
import 'package:widyu/gen/assets.gen.dart';

part 'widget/header_content.dart';
part 'widget/information_menu_view.dart';
part 'widget/management_menu_view.dart';
part 'widget/my_page_app_bar.dart';
part 'widget/my_page_header.dart';
part 'widget/point_view.dart';
part 'widget/profile_view.dart';
part 'widget/setting_menu_view.dart';
part 'widget/text_menu.dart';

class MyPageScreen extends ConsumerWidget {
  const MyPageScreen({super.key});

  void _handleEvent(BuildContext context, WidgetRef ref, MyPageUiEvent event) {
    switch (event) {
      case FetchUserFailure():
        showToast('사용자 정보를 불러오지 못했어요.\n잠시 후 다시 시도해주세요.');
      case LogoutSuccess():
        ref.read(appServiceControllerProvider).stop();
        context.go(AppRoute.onboarding.path);
      case LogoutFailure():
        showToast('로그아웃에 실패했어요.\n잠시 후 다시 시도해주세요.');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(myPageViewModelProvider.notifier);
    final uiState = ref.watch(myPageViewModelProvider);

    return UiEventListener(
      stream: viewModel.uiEvent,
      onEvent: (event) => _handleEvent(context, ref, event),
      // 세션이 이미 끝났으므로 다른 탭에 있어도 바로 온보딩으로 보낸다.
      runWhileInactive: (event) => event is LogoutSuccess,
      child: Scaffold(
        appBar: const _MyPageAppBar(),
        body: Column(
          children: [
            _MyPageHeader(
              profileImage: uiState.profileImage,
              name: uiState.name,
              isLoading: uiState.isLoading,
              point: uiState.point,
              isPointLoading: uiState.isPointLoading,
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewPadding.bottom + 64,
                ),
                child: Column(
                  children: [
                    const _ManagementMenuView(),
                    const WidyuDivider(),
                    const _SettingMenuView(),
                    _InformationMenuView(
                      appVersion: uiState.appVersion,
                      onLogout: viewModel.logout,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
