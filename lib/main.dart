import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:widyu/app/routes/custom_router.dart';
import 'package:widyu/background_service.dart';
import 'package:widyu/core/data/repository/auth/auth_repository.dart';
import 'package:widyu/core/data/repository/auth/auth_repository_impl.dart';
import 'package:widyu/core/data/repository/heartRate/heart_rate_repository.dart';
import 'package:widyu/core/data/repository/heartRate/heart_rate_repository_impl.dart';
import 'package:widyu/core/data/repository/home/home_repository.dart';
import 'package:widyu/core/data/repository/home/home_repository_impl.dart';
import 'package:widyu/core/data/repository/myPage/my_page_repository.dart';
import 'package:widyu/core/data/repository/myPage/my_page_repository_impl.dart';
import 'package:widyu/core/data/repository/notification/notification_repository.dart';
import 'package:widyu/core/data/repository/notification/notification_repository_impl.dart';
import 'package:widyu/core/data/source/auth/auth_local_data_source.dart';
import 'package:widyu/core/data/source/auth/auth_local_data_source_impl.dart';
import 'package:widyu/core/data/source/auth/auth_remote_data_source.dart';
import 'package:widyu/core/data/source/auth/auth_remote_data_source_impl.dart';
import 'package:widyu/core/data/source/heartRate/heart_rate_local_data_source.dart';
import 'package:widyu/core/data/source/heartRate/heart_rate_local_data_source_impl.dart';
import 'package:widyu/core/data/source/heartRate/heart_rate_remote_data_source.dart';
import 'package:widyu/core/data/source/heartRate/heart_rate_remote_data_source_impl.dart';
import 'package:widyu/core/data/source/home/home_remote_data_source.dart';
import 'package:widyu/core/data/source/home/home_remote_data_source_impl.dart';
import 'package:widyu/core/data/source/myPage/my_page_remote_data_source.dart';
import 'package:widyu/core/data/source/myPage/my_page_remote_data_source_impl.dart';
import 'package:widyu/core/data/source/notification/notification_remote_data_source.dart';
import 'package:widyu/core/data/source/notification/notification_remote_data_source_impl.dart';
import 'package:widyu/core/network/api_client.dart';
import 'package:widyu/core/network/socket_client.dart';
import 'package:widyu/core/network/token_manager.dart';
import 'package:widyu/core/ui/theme/theme.dart';
import 'package:widyu/core/utils/app_service_controller.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await dotenv.load(fileName: ".env");
  await initializeService();
  await initializeDateFormatting('ko_KR');

  runApp(
    MultiProvider(
      providers: [
        Provider<TokenManager>(create: (_) => TokenManager()),
        Provider<AppServiceController>(create: (_) => AppServiceController()),
        Provider<ApiClient>(create: (_) => ApiClient()),
        Provider<SocketClient>(create: (_) => SocketClient()),
        ProxyProvider<ApiClient, AuthRemoteDataSource>(
          update: (_, apiClient, __) =>
              AuthRemoteDataSourceImpl(apiClient: apiClient),
        ),
        Provider<AuthLocalDataSource>(create: (_) => AuthLocalDataSourceImpl()),
        ProxyProvider<ApiClient, HomeRemoteDataSource>(
          update: (_, apiClient, __) =>
              HomeRemoteDataSourceImpl(apiClient: apiClient),
        ),
        ProxyProvider<ApiClient, MyPageRemoteDataSource>(
          update: (_, apiClient, __) =>
              MyPageRemoteDataSourceImpl(apiClient: apiClient),
        ),
        ProxyProvider<ApiClient, NotificationRemoteDataSource>(
          update: (_, apiClient, __) =>
              NotificationRemoteDataSourceImpl(apiClient: apiClient),
        ),
        Provider<HeartRateLocalDataSource>(
          create: (_) => HeartRateLocalDataSourceImpl(),
        ),
        ProxyProvider2<SocketClient, ApiClient, HeartRateRemoteDataSource>(
          update: (_, socketClient, apiClient, __) =>
              HeartRateRemoteDataSourceImpl(
            socketClient: socketClient,
            apiClient: apiClient,
          ),
        ),
        ProxyProvider2<AuthRemoteDataSource, AuthLocalDataSource,
            AuthRepository>(
          update: (_, remote, local, __) => AuthRepositoryImpl(
            remoteDatasource: remote,
            localDataSource: local,
          ),
        ),
        ProxyProvider<HomeRemoteDataSource, HomeRepository>(
          update: (_, remote, __) =>
              HomeRepositoryImpl(remoteDataSource: remote),
        ),
        ProxyProvider<MyPageRemoteDataSource, MyPageRepository>(
          update: (_, remote, __) =>
              MyPageRepositoryImpl(remoteDataSource: remote),
        ),
        ProxyProvider<NotificationRemoteDataSource, NotificationRepository>(
          update: (_, remote, __) =>
              NotificationRepositoryImpl(remoteDataSource: remote),
        ),
        ProxyProvider2<HeartRateLocalDataSource, HeartRateRemoteDataSource,
            HeartRateRepository>(
          update: (_, local, remote, __) => HeartRateRepositoryImpl(
            localDataSource: local,
            remoteDataSource: remote,
          ),
        ),
      ],
      child: const App(),
    ),
  );
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late final AppServiceController _serviceController;

  @override
  void initState() {
    super.initState();
    _serviceController = context.read<AppServiceController>();
    _serviceController.start();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: '위듀',
      theme: MyTheme.myTheme,
      routerConfig: CustomRouter.router,
    );
  }
}
