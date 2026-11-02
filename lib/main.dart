import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'
    show ConsumerState, ConsumerStatefulWidget, ProviderScope;
import 'package:flutter_riverpod/misc.dart' show ProviderListenable;
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart' show MultiProvider, Provider;
import 'package:widyu/app/routes/custom_router.dart';
import 'package:widyu/background_service.dart';
import 'package:widyu/core/data/repository/auth/auth_repository.dart';
import 'package:widyu/core/data/repository/goal/goal_repository.dart';
import 'package:widyu/core/data/repository/goal/medication_repository.dart';
import 'package:widyu/core/data/repository/heartRate/heart_rate_repository.dart';
import 'package:widyu/core/data/repository/home/home_repository.dart';
import 'package:widyu/core/data/repository/incident/incident_repository.dart';
import 'package:widyu/core/data/repository/location/location_repository.dart';
import 'package:widyu/core/data/repository/myPage/my_page_repository.dart';
import 'package:widyu/core/data/repository/notification/notification_repository.dart';
import 'package:widyu/core/di/providers.dart';
import 'package:widyu/core/log/log.dart';
import 'package:widyu/core/notification/local_notification_manager.dart';
import 'package:widyu/core/notification/medication_push_manager.dart';
import 'package:widyu/core/notification/safety_push_manager.dart';
import 'package:widyu/core/ui/theme/theme.dart';
import 'package:widyu/core/utils/app_service_controller.dart';
import 'package:widyu/core/utils/background_location_notice_controller.dart';
import 'package:widyu/firebase_options.dart';
import 'package:widyu/walk_background_service.dart';

void main() {
  runZonedGuarded(
    _bootstrap,
    (error, stack) {
      // onError는 바깥 zone에서 실행되어 print 차단이 적용되지 않지만, 로거는 release에서 꺼져 있다.
      WiduLog.global.e('zone', error: error, stackTrace: stack);
    },
    zoneSpecification: quietPrintInRelease,
  );
}

Future<void> _bootstrap() async {
  final WidgetsBinding widgetsBinding =
      WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // 초기화 단계 중 하나가 실패하더라도 나머지 단계와 runApp 은 반드시 수행한다.
  try {
    await dotenv.load();
  } catch (e, stack) {
    WiduLog.data.w('dotenv.load 실패', error: e, stackTrace: stack);
  }

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e, stack) {
    WiduLog.data.w('Firebase 초기화 실패', error: e, stackTrace: stack);
  }

  try {
    await initializeService();
  } catch (e, stack) {
    WiduLog.bg.w('백그라운드 서비스 초기화 실패', error: e, stackTrace: stack);
  }

  try {
    await initializeWalkService();
  } catch (e, stack) {
    WiduLog.bg.w('걸음수 백그라운드 초기화 실패', error: e, stackTrace: stack);
  }

  try {
    await initializeDateFormatting('ko_KR');
  } catch (e, stack) {
    WiduLog.ui.w('날짜 포맷 초기화 실패', error: e, stackTrace: stack);
  }

  try {
    await initializeMedicationPush();
    await LocalNotificationManager.initialize();
    SafetyPushManager.initialize();
  } catch (e, stack) {
    WiduLog.data.w('알림 초기화 실패', error: e, stackTrace: stack);
  }

  // 의존성은 Riverpod가 소유한다. 화면들이 아직 Provider로 읽으므로
  // MultiProvider는 같은 인스턴스를 넘겨주는 브리지로 둔다. (create: 처음 읽을 때 생성)
  runApp(
    ProviderScope(
      child: MultiProvider(
        providers: [
          Provider<AppServiceController>(
            create: (context) => _read(context, appServiceControllerProvider),
          ),
          Provider<BackgroundLocationNoticeController>(
            create: (context) =>
                _read(context, backgroundLocationNoticeControllerProvider),
          ),
          Provider<AuthRepository>(
            create: (context) => _read(context, authRepositoryProvider),
          ),
          Provider<GoalRepository>(
            create: (context) => _read(context, goalRepositoryProvider),
          ),
          Provider<MedicationRepository>(
            create: (context) => _read(context, medicationRepositoryProvider),
          ),
          Provider<HeartRateRepository>(
            create: (context) => _read(context, heartRateRepositoryProvider),
          ),
          Provider<HomeRepository>(
            create: (context) => _read(context, homeRepositoryProvider),
          ),
          Provider<LocationRepository>(
            create: (context) => _read(context, locationRepositoryProvider),
          ),
          Provider<MyPageRepository>(
            create: (context) => _read(context, myPageRepositoryProvider),
          ),
          Provider<NotificationRepository>(
            create: (context) => _read(context, notificationRepositoryProvider),
          ),
          Provider<IncidentRepository>(
            create: (context) => _read(context, incidentRepositoryProvider),
          ),
        ],
        child: const App(),
      ),
    ),
  );
}

T _read<T>(BuildContext context, ProviderListenable<T> provider) =>
    ProviderScope.containerOf(context, listen: false).read(provider);

class App extends ConsumerStatefulWidget {
  const App({super.key});

  @override
  ConsumerState<App> createState() => _AppState();
}

class _AppState extends ConsumerState<App> with WidgetsBindingObserver {
  late final AppServiceController _serviceController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _serviceController = ref.read(appServiceControllerProvider);
    unawaited(_serviceController.start());
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      unawaited(_serviceController.refresh());
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: '위듀',
      theme: MyTheme.myTheme,
      routerConfig: CustomRouter.router,
      locale: const Locale('ko', 'KR'),
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
    );
  }
}
