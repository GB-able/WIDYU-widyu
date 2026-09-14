import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:widyu/core/ui/widgets/widyu_permission_dialog.dart';

void main() {
  Future<void> openDialog(
    WidgetTester tester,
    void Function(Future<bool>) onResult,
  ) async {
    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => Scaffold(
            body: TextButton(
              onPressed: () => onResult(WidyuPermissionDialog.show(
                context,
                description: '위치 권한을 항상 허용으로 설정해 주세요.',
              )),
              child: const Text('열기'),
            ),
          ),
        ),
      ],
    );
    addTearDown(router.dispose);
    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    await tester.tap(find.text('열기'));
    await tester.pumpAndSettle();
  }

  testWidgets('설정 이동을 선택해야 설정 열기에 동의한다', (tester) async {
    late Future<bool> result;
    await openDialog(tester, (value) => result = value);
    expect(find.byType(WidyuPermissionDialog), findsOneWidget);
    await tester.tap(find.text('설정으로 이동'));
    await tester.pumpAndSettle();
    expect(await result, isTrue);
    expect(find.byType(WidyuPermissionDialog), findsNothing);
    expect(find.text('열기'), findsOneWidget);
  });

  testWidgets('나중에 선택은 설정 이동 없이 안내를 닫는다', (tester) async {
    late Future<bool> result;
    await openDialog(tester, (value) => result = value);
    await tester.tap(find.text('나중에 하기'));
    await tester.pumpAndSettle();
    expect(await result, isFalse);
    expect(find.byType(WidyuPermissionDialog), findsNothing);
    expect(find.text('열기'), findsOneWidget);
  });

  testWidgets('바깥 터치와 뒤로가기도 설정 이동에 동의하지 않는다', (tester) async {
    late Future<bool> result;
    await openDialog(tester, (value) => result = value);
    await tester.tapAt(const Offset(10, 10));
    await tester.pumpAndSettle();
    expect(await result, isFalse);

    await tester.tap(find.text('열기'));
    await tester.pumpAndSettle();
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(await result, isFalse);
    expect(find.byType(WidyuPermissionDialog), findsNothing);
    expect(find.text('열기'), findsOneWidget);
  });
}
