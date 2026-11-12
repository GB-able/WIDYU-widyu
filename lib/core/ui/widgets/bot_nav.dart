import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:widyu/app/routes/app_route.dart';
import 'package:widyu/core/ui/theme/colors.dart';
import 'package:widyu/core/ui/theme/typos.dart';
import 'package:widyu/core/ui/widgets/widu_icon.dart';
import 'package:widyu/gen/assets.gen.dart';

class BotNav extends StatelessWidget {
  static const height = 64.0;

  final StatefulNavigationShell navigationShell;

  const BotNav({super.key, required this.navigationShell});

  static final _routes = <({AppRoute route, String label, SvgGenImage icon})>[
    (route: AppRoute.home, label: '홈', icon: Assets.icons.ic24Home),
    (route: AppRoute.goal, label: '목표', icon: Assets.icons.ic24Health),
    (route: AppRoute.album, label: '앨범', icon: Assets.icons.ic24Album),
    (route: AppRoute.my, label: '내정보', icon: Assets.icons.ic24User),
  ];

  @override
  Widget build(BuildContext context) {
    // 그림자는 네 모서리가 같은 둥근 사각형이어야 Impeller가 블러 패스 없이 한 번에 그린다.
    // 위쪽만 둥근 모양이면 블러 패스로 그리므로 그림자만 바깥 상자로 뺐다.
    // 막대가 불투명하고 화면 아래·양옆에 붙어 있어서 그림자 아래 모서리 모양은 보이지 않는다.
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(8, 0),
          ),
        ],
      ),
      child: Container(
        height: height + MediaQuery.of(context).padding.bottom,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          color: MyColor.white,
        ),
        child: BottomNavigationBar(
          elevation: 0,
          currentIndex: navigationShell.currentIndex,
          onTap: (index) {
            navigationShell.goBranch(
              index,
              initialLocation: index ==
                  navigationShell
                      .currentIndex, // [NOTICE] 같은 탭을 다시 누르면 해당 탭의 첫 화면으로 이동
            );
          },
          backgroundColor: Colors.transparent,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: MyColor.grey700,
          unselectedItemColor: MyColor.grey400,
          selectedLabelStyle: MyTypo.helper.copyWith(color: MyColor.grey700),
          unselectedLabelStyle: MyTypo.helper.copyWith(color: MyColor.grey400),
          items: _routes
              .map((route) => BottomNavigationBarItem(
                    icon: WiduIcon(
                        icon: route.icon, width: 24, color: MyColor.grey400),
                    activeIcon: WiduIcon(
                        icon: route.icon, width: 24, color: MyColor.grey800),
                    label: route.label,
                  ))
              .toList(),
        ),
      ),
    );
  }
}
