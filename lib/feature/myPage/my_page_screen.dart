import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:widyu/app/routes/app_route.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:widyu/core/data/repository/myPage/my_page_repository.dart';
import 'package:widyu/core/ui/theme/colors.dart';
import 'package:widyu/core/ui/theme/typos.dart';
import 'package:widyu/core/ui/widgets/ui_event_listener.dart';
import 'package:widyu/core/ui/widgets/widyu_divider.dart';
import 'package:widyu/core/utils/show_toast.dart';
import 'package:widyu/feature/myPage/my_page_ui_event.dart';
import 'package:widyu/feature/myPage/my_page_ui_state.dart';
import 'package:widyu/feature/myPage/my_page_view_model.dart';

part 'widget/my_page_header.dart';
part 'widget/header_content.dart';
part 'widget/profile_view.dart';
part 'widget/point_view.dart';
part 'widget/management_menu_view.dart';
part 'widget/management_menu_content.dart';
part 'widget/setting_menu_view.dart';
part 'widget/text_menu.dart';
part 'widget/information_menu_view.dart';

class MyPageScreen extends StatelessWidget {
  const MyPageScreen({super.key});

  void _handleEvent(MyPageUiEvent event) {
    switch (event) {
      case FetchUserFailure():
        showToast('사용자 정보를 불러오지 못했어요.\n잠시 후 다시 시도해주세요.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) =>
          MyPageViewModel(repository: context.read<MyPageRepository>()),
      builder: (context, child) {
        final uiEvent = context.read<MyPageViewModel>().uiEvent;
        final uiState =
            context.select<MyPageViewModel, MyPageUiState>((vm) => vm.uiState);

        return UiEventListener(
          stream: uiEvent,
          onEvent: _handleEvent,
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: MyColor.orange400,
              systemOverlayStyle: const SystemUiOverlayStyle(
                statusBarColor: Colors.transparent,
                statusBarBrightness: Brightness.light,
              ),
              title: Text(
                "내 정보",
                style: MyTypo.title4.copyWith(color: MyColor.grey800),
              ),
              centerTitle: true,
            ),
            body: Column(
              children: [
                _MyPageHeader(
                  profileImage: uiState.profileImage,
                  name: uiState.name,
                  points: uiState.points,
                  isLoading: uiState.isLoading,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewPadding.bottom + 64,
                    ),
                    scrollDirection: Axis.vertical,
                    child: const Column(
                      children: [
                        _ManagementMenuView(),
                        WidyuDivider(),
                        _SettingMenuView(),
                        _InformationMenuView(),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
