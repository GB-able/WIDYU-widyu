import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:widyu/core/ui/widgets/widyu_dialog.dart';

import 'package:widyu/core/model/permission/permission_recovery_prompt.dart';
import 'package:widyu/core/ui/widgets/permission_recovery_dialog.dart';

Widget _routerApp(Widget home) {
  final router = GoRouter(routes: [
    GoRoute(path: '/', builder: (_, __) => home),
  ]);
  addTearDown(router.dispose);
  return MaterialApp.router(routerConfig: router);
}

void main() {
  Future<void> pumpHost(
    WidgetTester tester, {
    required PermissionRecoveryMode mode,
    required void Function(Future<PermissionRecoveryAction> result) onResult,
  }) async {
    await tester.pumpWidget(
      _routerApp(
        Builder(
          builder: (context) => Scaffold(
            body: Center(
              child: ElevatedButton(
                onPressed: () {
                  onResult(PermissionRecoveryDialog.show(
                    context,
                    permissionName: '알림',
                    description: '알림 권한이 필요합니다.',
                    mode: mode,
                  ));
                },
                child: const Text('열기'),
              ),
            ),
          ),
        ),
      ),
    );
  }

  testWidgets('rationale mode returns retry when 계속 is selected',
      (tester) async {
    late Future<PermissionRecoveryAction> result;
    await pumpHost(
      tester,
      mode: PermissionRecoveryMode.rationale,
      onResult: (value) => result = value,
    );

    await tester.tap(find.text('열기'));
    await tester.pumpAndSettle();
    expect(find.text('알림 권한이 필요해요'), findsOneWidget);
    expect(find.byType(WidyuDialog), findsOneWidget);

    await tester.tap(find.text('계속'));
    await tester.pumpAndSettle();
    expect(await result, PermissionRecoveryAction.retry);
    expect(find.byType(WidyuDialog), findsNothing);
  });

  testWidgets('settings mode returns openSettings when 설정으로 이동 is selected',
      (tester) async {
    late Future<PermissionRecoveryAction> result;
    await tester.pumpWidget(
      _routerApp(
        Builder(
          builder: (context) => Scaffold(
            body: ElevatedButton(
              onPressed: () {
                result = PermissionRecoveryDialog.show(
                  context,
                  permissionName: '위치',
                  description: '설정에서 위치 권한을 허용해주세요.',
                  mode: PermissionRecoveryMode.settings,
                );
              },
              child: const Text('열기'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('열기'));
    await tester.pumpAndSettle();
    expect(find.text('설정에서 위치 권한을 허용해주세요.\n\n이 권한은 앱 설정에서 허용할 수 있어요.'),
        findsOneWidget);
    await tester.tap(find.text('설정으로 이동'));
    await tester.pumpAndSettle();
    expect(await result, PermissionRecoveryAction.openSettings);
    expect(find.byType(WidyuDialog), findsNothing);
  });

  testWidgets('취소, 바깥 누르기, 뒤로가기는 모두 dialog를 닫는다', (tester) async {
    late Future<PermissionRecoveryAction> result;
    await pumpHost(
      tester,
      mode: PermissionRecoveryMode.rationale,
      onResult: (value) => result = value,
    );

    await tester.tap(find.text('열기'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('취소'));
    await tester.pumpAndSettle();
    expect(await result, PermissionRecoveryAction.cancel);
    expect(find.byType(WidyuDialog), findsNothing);

    await tester.tap(find.text('열기'));
    await tester.pumpAndSettle();
    await tester.tapAt(const Offset(10, 10));
    await tester.pumpAndSettle();
    expect(await result, PermissionRecoveryAction.cancel);
    expect(find.byType(WidyuDialog), findsNothing);

    await tester.tap(find.text('열기'));
    await tester.pumpAndSettle();
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(await result, PermissionRecoveryAction.cancel);
    expect(find.byType(WidyuDialog), findsNothing);
  });
}
