import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:widyu/core/data/repository/point/point_repository.dart';
import 'package:widyu/core/ui/widgets/widu_icon.dart';
import 'package:widyu/core/ui/widgets/widyu_text_button.dart';
import 'package:widyu/feature/album/_widgets/unlock_dialog.dart';

Future<void> pumpDialog(
  WidgetTester tester,
  Widget dialog, {
  ValueChanged<bool?>? onClosed,
}) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Builder(
        builder: (context) => Scaffold(
          body: TextButton(
            onPressed: () async {
              final result = await showDialog<bool>(
                context: context,
                builder: (_) => dialog,
              );
              onClosed?.call(result);
            },
            child: const Text('open'),
          ),
        ),
      ),
    ),
  );
  await tester.tap(find.text('open'));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('구매 다이얼로그는 가격과 잔여 포인트를 보여준다', (tester) async {
    var tapped = false;
    await pumpDialog(
      tester,
      UnlockDialog.purchase(
        price: 50,
        point: 150,
        onPurchase: () async => tapped = true,
      ),
    );

    expect(find.text('새로운 소식을 구매할까요?'), findsOneWidget);
    expect(find.text('50P'), findsOneWidget);
    expect(find.text('잔여 포인트'), findsOneWidget);
    expect(find.text('150P'), findsOneWidget);

    await tester.tap(find.text('구매하기'));
    await tester.pumpAndSettle();
    expect(tapped, isTrue);
    expect(find.byType(UnlockDialog), findsNothing);
  });

  testWidgets('포인트 부족 다이얼로그는 모으러 가기를 안내한다', (tester) async {
    var tapped = false;
    await pumpDialog(
      tester,
      UnlockDialog.notEnough(price: 50, point: 20, onTap: () => tapped = true),
    );

    expect(find.text('포인트가 부족해요'), findsOneWidget);
    expect(find.text('50P'), findsOneWidget);
    expect(find.text('20P'), findsOneWidget);
    expect(find.text('구매하기'), findsNothing);

    await tester.tap(find.text('포인트 모으러 가기'));
    await tester.pumpAndSettle();
    expect(tapped, isTrue);
    expect(find.byType(UnlockDialog), findsNothing);
  });

  group('showUnlockDialog', () {
    Future<void> open(
        WidgetTester tester, _FakePointRepository repository) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => Scaffold(
              body: TextButton(
                onPressed: () => showUnlockDialog(
                  context,
                  price: 50,
                  pointRepository: repository,
                  isUnlocking: false,
                  onPurchase: () async => true,
                  onGoToGoal: () {},
                ),
                child: const Text('open'),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
    }

    testWidgets('포인트를 아직 모르면 다시 조회한 뒤 다이얼로그를 연다', (tester) async {
      final repository = _FakePointRepository(onRefresh: 150);
      await open(tester, repository);
      expect(repository.refreshes, 1);
      expect(find.text('150P'), findsOneWidget);
    });

    testWidgets('다시 조회해도 포인트를 모르면 다이얼로그를 열지 않는다', (tester) async {
      final calls = <MethodCall>[];
      tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        const MethodChannel('PonnamKarthik/fluttertoast'),
        (call) async {
          calls.add(call);
          return true;
        },
      );
      final repository = _FakePointRepository(onRefresh: null);
      await open(tester, repository);
      expect(repository.refreshes, 1);
      expect(find.byType(UnlockDialog), findsNothing);
      expect(calls.single.method, 'showToast');
    });
  });

  testWidgets('구매 중에는 닫기와 중복 구매를 막고 성공 후 닫는다', (tester) async {
    final pending = Completer<bool>();
    var requests = 0;
    bool? result;
    await pumpDialog(
      tester,
      UnlockDialog.purchase(
        price: 50,
        point: 150,
        onPurchase: () {
          requests++;
          return pending.future;
        },
      ),
      onClosed: (value) => result = value,
    );

    await tester.tap(find.text('구매하기'));
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('구매하기'), findsNothing);
    await tester.tap(find.byType(WidyuTextButton));
    await tester.tap(find.byType(WiduIcon));
    await tester.tapAt(const Offset(5, 5));
    await tester.binding.handlePopRoute();
    await tester.pump();
    expect(find.byType(UnlockDialog), findsOneWidget);
    expect(requests, 1);
    expect(result, isNull);

    pending.complete(true);
    await tester.pumpAndSettle();
    expect(find.byType(UnlockDialog), findsNothing);
    expect(result, isTrue);
  });

  for (final throwsError in [false, true]) {
    testWidgets('구매 실패 후 안내를 표시하고 재시도할 수 있다 (예외: $throwsError)', (
      tester,
    ) async {
      var requests = 0;
      await pumpDialog(
        tester,
        UnlockDialog.purchase(
          price: 50,
          point: 150,
          onPurchase: () async {
            requests++;
            if (requests > 1) return true;
            if (throwsError) throw Exception('network');
            return false;
          },
        ),
      );
      await tester.tap(find.text('구매하기'));
      await tester.pumpAndSettle();
      expect(find.text('소식을 여는 데 실패했습니다. 다시 시도해주세요.'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(tester.widget<PopScope>(find.byType(PopScope)).canPop, isTrue);

      await tester.tap(find.text('구매하기'));
      await tester.pumpAndSettle();
      expect(requests, 2);
      expect(find.byType(UnlockDialog), findsNothing);
    });
  }

  testWidgets('구매 전에는 바깥 영역을 눌러 닫을 수 있다', (tester) async {
    await pumpDialog(
      tester,
      UnlockDialog.purchase(
        price: 50,
        point: 150,
        onPurchase: () async => true,
      ),
    );
    await tester.tapAt(const Offset(5, 5));
    await tester.pumpAndSettle();
    expect(find.byType(UnlockDialog), findsNothing);
  });

  testWidgets('구매 중 화면이 제거되면 늦은 결과로 화면을 조작하지 않는다', (tester) async {
    final pending = Completer<bool>();
    await pumpDialog(
      tester,
      UnlockDialog.purchase(
        price: 50,
        point: 150,
        onPurchase: () => pending.future,
      ),
    );
    await tester.tap(find.text('구매하기'));
    await tester.pump();
    await tester.pumpWidget(const SizedBox.shrink());
    pending.complete(true);
    await tester.pump();
    expect(tester.takeException(), isNull);
  });
}

class _FakePointRepository extends PointRepository {
  _FakePointRepository({required this.onRefresh});

  final int? onRefresh;
  int? _point;
  int refreshes = 0;

  @override
  Stream<PointStatus> get status => const Stream.empty();

  @override
  PointStatus get currentStatus => (point: _point, isLoading: false);

  @override
  Future<void> refresh() async {
    refreshes++;
    _point = onRefresh;
  }

  @override
  int get revision => refreshes;

  @override
  void sync(int? point, {required int revision}) {}

  @override
  void dispose() {}
}
