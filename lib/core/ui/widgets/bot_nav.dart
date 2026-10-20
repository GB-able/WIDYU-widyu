import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:widyu/app/routes/app_route.dart';
import 'package:widyu/core/ui/theme/colors.dart';
import 'package:widyu/core/ui/theme/typos.dart';
import 'package:widyu/core/ui/widgets/icon_widget.dart';

class BotNav extends StatelessWidget {
  static const height = 64.0;

  final StatefulNavigationShell navigationShell;

  const BotNav({super.key, required this.navigationShell});

  static const _routes = <({AppRoute route, String label, String icon})>[
    (route: AppRoute.home, label: "홈", icon: "home"),
    (route: AppRoute.goal, label: "목표", icon: "health"),
    (route: AppRoute.album, label: "앨범", icon: "album"),
    (route: AppRoute.my, label: "내정보", icon: "user"),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height + MediaQuery.of(context).padding.bottom,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        color: MyColor.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(8, 0),
          ),
        ],
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
                  icon: IconWidget(
                      icon: route.icon, width: 24, color: MyColor.grey400),
                  activeIcon: IconWidget(
                      icon: route.icon, width: 24, color: MyColor.grey800),
                  label: route.label,
                ))
            .toList(),
      ),
    );
  }
}
