import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:widyu/app/route/app_route.dart';
import 'package:widyu/app/route/custom_page.dart';

Widget _page(String text, {bool canPop = true, Widget? body}) => PopScope(
      canPop: canPop,
      child: ColoredBox(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [Text(text), if (body != null) body],
        ),
      ),
    );

void main() {
  late GoRouter router;

  Future<void> pumpAndPush(
    WidgetTester tester, {
    bool canPop = true,
    Widget? body,
  }) async {
    router = GoRouter(initialLocation: AppRoute.home.path, routes: [
      CustomGoRoute.staticRoute(
        route: AppRoute.home,
        builder: (_, __) => _page('첫 화면'),
      ),
      CustomGoRoute.slideRoute(
        route: AppRoute.point,
        builder: (_, __) => _page('쌓인 화면', canPop: canPop, body: body),
      ),
    ]);
    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    unawaited(router.push(AppRoute.point.path));
    await tester.pumpAndSettle();
  }

  // 화면 가운데에서 오른쪽으로 끈다. 테스트 화면 너비는 800이다.
  Future<void> dragFromCenter(WidgetTester tester, double dx) async {
    final gesture = await tester.startGesture(const Offset(300, 300));
    for (var moved = 0.0; moved < dx; moved += 20) {
      await gesture.moveBy(const Offset(20, 0));
      await tester.pump(const Duration(milliseconds: 100));
    }
    await gesture.up();
    await tester.pumpAndSettle();
  }

  testWidgets('화면 가운데에서 절반 넘게 끌면 뒤로 간다', (tester) async {
    await pumpAndPush(tester);
    await dragFromCenter(tester, 460);
    expect(find.text('쌓인 화면'), findsNothing);
    expect(find.text('첫 화면'), findsOneWidget);
  });

  testWidgets('조금만 끌고 놓으면 제자리로 돌아온다', (tester) async {
    await pumpAndPush(tester);
    await dragFromCenter(tester, 120);
    expect(find.text('쌓인 화면'), findsOneWidget);
    expect(tester.getTopLeft(find.text('쌓인 화면')).dx, 0);
  });

  testWidgets('절반 넘게 끈 뒤 포인터가 취소되면 제자리로 돌아온다', (tester) async {
    await pumpAndPush(tester);
    final gesture = await tester.startGesture(const Offset(300, 300));
    for (var moved = 0; moved < 460; moved += 20) {
      await gesture.moveBy(const Offset(20, 0));
      await tester.pump(const Duration(milliseconds: 100));
    }
    await gesture.cancel();
    await tester.pumpAndSettle();
    expect(find.text('쌓인 화면'), findsOneWidget);
    expect(tester.getTopLeft(find.text('쌓인 화면')).dx, 0);
  });

  testWidgets('PopScope로 막힌 화면은 끌어도 뒤로 가지 않는다', (tester) async {
    await pumpAndPush(tester, canPop: false);
    await dragFromCenter(tester, 460);
    expect(find.text('쌓인 화면'), findsOneWidget);
    expect(tester.getTopLeft(find.text('쌓인 화면')).dx, 0);
  });

  testWidgets('안쪽 가로 스크롤 위에서 끌면 스크롤이 먼저 움직인다', (tester) async {
    final controller = PageController();
    addTearDown(controller.dispose);
    await pumpAndPush(
      tester,
      body: SizedBox(
        height: 400,
        child: PageView(
          controller: controller,
          children: const [Text('1쪽'), Text('2쪽')],
        ),
      ),
    );
    controller.jumpToPage(1);
    await tester.pump();
    await dragFromCenter(tester, 460);
    expect(find.text('쌓인 화면'), findsOneWidget);
    expect(controller.page, 0);
  });

  testWidgets('첫 화면에서는 끌어도 아무 일이 없다', (tester) async {
    await pumpAndPush(tester);
    router.pop();
    await tester.pumpAndSettle();
    await dragFromCenter(tester, 460);
    expect(find.text('첫 화면'), findsOneWidget);
    expect(tester.getTopLeft(find.text('첫 화면')).dx, 0);
  });
}
