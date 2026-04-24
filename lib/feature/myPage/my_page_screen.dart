import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:widyu/core/data/repository/myPage/my_page_repository.dart';
import 'package:widyu/core/ui/theme/colors.dart';
import 'package:widyu/core/ui/theme/typos.dart';
import 'package:widyu/core/utils/show_toast.dart';
import 'package:widyu/feature/myPage/my_page_ui_state.dart';
import 'package:widyu/feature/myPage/my_page_view_model.dart';

part 'widget/my_page_header.dart';
part 'widget/header_content.dart';
part 'widget/profile_view.dart';
part 'widget/point_view.dart';
part 'widget/management_menu_view.dart';
part 'widget/management_menu_content.dart';

class MyPageScreen extends StatelessWidget {
  const MyPageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) =>
          MyPageViewModel(repository: context.read<MyPageRepository>()),
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
            const _MyPageHeader(),
            _ManagementMenuView(),
            Container(
              width: double.infinity,
              height: 10,
              decoration: const BoxDecoration(color: MyColor.grey50),
            ),
          ],
        ),
      ),
    );
  }
}
