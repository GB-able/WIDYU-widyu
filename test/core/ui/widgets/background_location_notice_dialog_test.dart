import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:widyu/core/ui/widgets/background_location_notice_dialog.dart';

void main() {
  Future<void> openDialog(
    WidgetTester tester,
    void Function(Future<bool>) onResult,
  ) async {
    await tester.pumpWidget(MaterialApp(
      home: Builder(
        builder: (context) => Scaffold(
          body: TextButton(
            onPressed: () =>
                onResult(BackgroundLocationNoticeDialog.show(context)),
            child: const Text('열기'),
          ),
        ),
      ),
    ));
    await tester.tap(find.text('열기'));
    await tester.pumpAndSettle();
  }

  testWidgets('설정 이동을 선택해야 설정 열기에 동의한다', (tester) async {
    late Future<bool> result;
    await openDialog(tester, (value) => result = value);
    expect(find.byType(AlertDialog), findsOneWidget);
    await tester.tap(find.text('설정으로 이동'));
    await tester.pumpAndSettle();
    expect(await result, isTrue);
    expect(find.byType(AlertDialog), findsNothing);
  });

  testWidgets('나중에 선택은 설정 이동 없이 안내를 닫는다', (tester) async {
    late Future<bool> result;
    await openDialog(tester, (value) => result = value);
    await tester.tap(find.text('나중에'));
    await tester.pumpAndSettle();
    expect(await result, isFalse);
    expect(find.byType(AlertDialog), findsNothing);
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
    expect(find.byType(AlertDialog), findsNothing);
  });
}
