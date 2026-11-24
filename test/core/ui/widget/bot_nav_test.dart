import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:widyu/core/ui/widget/bot_nav.dart';

/// 실제 라우터와 같은 모양(StatefulShellRoute + BotNav)만 최소로 흉내낸다.
GoRouter buildRouter() {
  StatefulShellBranch branch(String path, String label) => StatefulShellBranch(
        routes: [
          GoRoute(
            path: path,
            builder: (_, __) => Center(child: Text(label)),
          ),
        ],
      );

  return GoRouter(
    initialLocation: '/home',
    routes: [
      StatefulShellRoute.indexedStack(
        branches: [
          branch('/home', '홈화면'),
          branch('/goal', '목표화면'),
          branch('/album', '앨범화면'),
          branch('/my', '내정보화면'),
        ],
        builder: (context, state, navigationShell) => Stack(
          alignment: Alignment.bottomCenter,
          children: [
            navigationShell,
            BotNav(navigationShell: navigationShell),
          ],
        ),
      ),
    ],
  );
}

int selectedIndex(WidgetTester tester) => tester
    .widget<BottomNavigationBar>(find.byType(BottomNavigationBar))
    .currentIndex;

void main() {
  testWidgets('탭을 누르면 해당 화면과 강조가 함께 바뀐다', (tester) async {
    await tester.pumpWidget(MaterialApp.router(routerConfig: buildRouter()));
    await tester.pumpAndSettle();
    expect(selectedIndex(tester), 0);

    await tester.tap(find.text('앨범'));
    await tester.pumpAndSettle();

    expect(find.text('앨범화면'), findsOneWidget);
    expect(selectedIndex(tester), 2);
  });

  testWidgets('코드로 탭을 옮겨도 강조가 따라온다', (tester) async {
    final router = buildRouter();
    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    await tester.pumpAndSettle();

    // "포인트 모으러 가기" 처럼 화면 안에서 다른 탭으로 보내는 경우.
    router.go('/goal');
    await tester.pumpAndSettle();

    expect(find.text('목표화면'), findsOneWidget);
    expect(selectedIndex(tester), 1);
  });
}
