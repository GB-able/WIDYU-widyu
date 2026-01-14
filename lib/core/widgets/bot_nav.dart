import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:widyu/app/routes/app_route.dart';
import 'package:widyu/core/ui/theme/colors.dart';
import 'package:widyu/core/ui/theme/typos.dart';
import 'package:widyu/core/widgets/icon_widget.dart';

class BotNav extends StatefulWidget {
  const BotNav({super.key});

  @override
  State<BotNav> createState() => _BotNavState();
}

class _BotNavState extends State<BotNav> {
  final List<({AppRoute route, String label, String icon})> _routes = [
    (route: AppRoute.home, label: "홈", icon: "home"),
    (route: AppRoute.goal, label: "목표", icon: "health"),
    (route: AppRoute.album, label: "앨범", icon: "album"),
    (route: AppRoute.my, label: "내정보", icon: "user"),
  ];
  int _currentIndex = 0;

  void setIdx(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64 + MediaQuery.of(context).padding.bottom,
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
        currentIndex: _currentIndex,
        onTap: (index) {
          setIdx(index);
          context.go(_routes[index].route.path);
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
