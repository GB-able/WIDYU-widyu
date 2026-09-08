import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:widyu/core/model/location/location_service_state.dart';
import 'package:widyu/core/utils/app_service_controller.dart';
import 'package:widyu/feature/locationSetup/location_setup_screen.dart';

void main() {
  const permissionChannel = MethodChannel(
    'flutter.baseflow.com/permissions/methods',
  );

  late AppServiceController serviceController;

  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(permissionChannel, (call) async {
      switch (call.method) {
        case 'checkPermissionStatus':
          return PermissionStatus.denied.index;
        case 'checkServiceStatus':
          return 0;
        default:
          return null;
      }
    });
    serviceController = AppServiceController(
      hasToken: () async => true,
      refreshLocationState: () async => LocationServiceState(
        serviceEnabled: false,
        permissionGranted: false,
      ),
      locationStates: const Stream.empty(),
      startMonitoring: () async {},
      stopMonitoring: () async {},
      setAutoStart: (_) async {},
      startBackground: () async {},
      stopBackground: () async {},
    );
  });

  tearDown(() {
    serviceController.dispose();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(permissionChannel, null);
  });

  GoRouter createRouter() => GoRouter(
        initialLocation: '/setup',
        routes: [
          GoRoute(
            path: '/setup',
            builder: (_, __) => const LocationSetupScreen(),
          ),
          GoRoute(
            path: '/home',
            builder: (_, __) => const Text('home marker'),
          ),
        ],
      );

  testWidgets('작은 화면에서도 위치 설정 안내와 버튼이 overflow 없이 보인다', (tester) async {
    tester.view.physicalSize = const Size(320, 568);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ChangeNotifierProvider<AppServiceController>.value(
        value: serviceController,
        child: MaterialApp.router(routerConfig: createRouter()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('위치 공유를 설정해 주세요'), findsOneWidget);
    expect(find.textContaining('앱을 사용하지 않는 동안에도'), findsOneWidget);
    expect(find.text('나중에'), findsOneWidget);
    expect(find.text('위치 권한 설정하기'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('나중에를 누르면 home marker로 이동한다', (tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider<AppServiceController>.value(
        value: serviceController,
        child: MaterialApp.router(routerConfig: createRouter()),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('나중에'));
    await tester.pumpAndSettle();

    expect(find.text('home marker'), findsOneWidget);
  });
}
