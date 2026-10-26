import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:widyu/app/routes/app_route.dart';
import 'package:widyu/core/data/provider/album_provider.dart';
import 'package:widyu/core/ui/theme/colors.dart';
import 'package:widyu/core/ui/theme/typos.dart';
import 'package:widyu/core/ui/widgets/bot_nav.dart';
import 'package:widyu/core/ui/widgets/custom_app_bar.dart';
import 'package:widyu/core/ui/widgets/icon_widget.dart';
import 'package:widyu/feature/album/calendar/calendar_tab_view.dart';
import 'package:widyu/feature/album/feed/feed_tab_view.dart';
import 'package:widyu/feature/album/photo/photo_tab_view.dart';

class AlbumScreen extends StatefulWidget {
  const AlbumScreen({super.key});

  @override
  State<AlbumScreen> createState() => _AlbumScreenState();
}

class _AlbumScreenState extends State<AlbumScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final albumProvider = context.read<AlbumProvider>();
      albumProvider.loadLikedAlbumIds();
      albumProvider.loadUnlockedAlbumIds();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        canBack: false,
        title: '앨범 위듀',
        actions: [
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () => context.push(AppRoute.notification.path),
            child: const IconWidget(
              icon: 'notification',
              width: 22,
              color: MyColor.grey600,
            ),
          ),
        ],
      ),
      body: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.only(
              bottom: BotNav.height + MediaQuery.of(context).padding.bottom),
          child: Column(
            children: [
              TabBar(
                controller: _tabController,
                indicator: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: MyColor.primary, width: 3),
                  ),
                ),
                indicatorSize: TabBarIndicatorSize.label,
                labelColor: MyColor.primary,
                unselectedLabelColor: MyColor.grey500,
                labelStyle: MyTypo.tab,
                unselectedLabelStyle: MyTypo.tab,
                tabs: const [
                  Tab(text: '피드'),
                  Tab(text: '앨범'),
                  Tab(text: '캘린더'),
                ],
                dividerColor: Colors.transparent,
                dividerHeight: 0,
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: const [
                    _KeepAlive(child: FeedTabView()),
                    _KeepAlive(child: PhotoTabView()),
                    _KeepAlive(child: CalendarTabView()),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(
          right: 4,
          bottom: BotNav.height + 18,
        ), // [NOTICE] 실제위치(34) - 기본 위치(16)
        child: Material(
          elevation: 6,
          borderRadius: BorderRadius.circular(30),
          color: MyColor.primary,
          child: InkWell(
            borderRadius: BorderRadius.circular(24),
            onTap: () => context.push(AppRoute.selectPhoto.path),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                spacing: 4,
                children: [
                  const IconWidget(icon: 'plus', width: 13),
                  Text(
                    '올리기',
                    style: MyTypo.button.copyWith(color: MyColor.white),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _KeepAlive extends StatefulWidget {
  const _KeepAlive({required this.child});

  final Widget child;

  @override
  State<_KeepAlive> createState() => _KeepAliveState();
}

class _KeepAliveState extends State<_KeepAlive>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }
}
