import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:widyu/app/routes/app_route.dart';
import 'package:widyu/core/model/album/album_post.dart';
import 'package:widyu/core/model/album/album_stat.dart';
import 'package:widyu/feature/album/_widgets/feed_widget.dart';

import 'album_fakes.dart';

void main() {
  Future<List<String>> unlockFrom(
    WidgetTester tester, {
    required bool isDetail,
  }) async {
    final pushed = <String>[];
    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (_, __) => Scaffold(
            body: SingleChildScrollView(
              child: FeedWidget(
                feed: AlbumPost.fromFeed(feed(1)),
                stat: const AlbumStat(
                  isLiked: false,
                  likeCount: 0,
                  commentCount: 0,
                ),
                isLocked: true,
                isDetail: isDetail,
                onToggleLike: () {},
                onDelete: () async => true,
                onRequestUnlock: () async => true,
              ),
            ),
          ),
        ),
        GoRoute(
          path: AppRoute.post.path,
          builder: (_, state) {
            pushed.add(state.uri.toString());
            return const SizedBox.shrink();
          },
        ),
      ],
    );
    addTearDown(router.dispose);

    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    await tester.tap(find.text('10P'));
    await tester.pumpAndSettle();
    return pushed;
  }

  testWidgets('피드에서 잠금 해제하면 게시물 화면을 연다', (tester) async {
    expect(await unlockFrom(tester, isDetail: false), [AppRoute.postOf(1)]);
  });

  testWidgets('게시물 화면에서 잠금 해제하면 같은 화면을 다시 열지 않는다', (tester) async {
    expect(await unlockFrom(tester, isDetail: true), isEmpty);
  });
}
