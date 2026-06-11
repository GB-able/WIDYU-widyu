import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';
import 'package:widyu/app/routes/custom_router.dart';
import 'package:widyu/background_service.dart';
import 'package:widyu/core/data/repository/auth/auth_repository.dart';
import 'package:widyu/core/data/repository/auth/auth_repository_impl.dart';
import 'package:widyu/core/data/repository/myPage/my_page_repository.dart';
import 'package:widyu/core/data/repository/myPage/my_page_repository_impl.dart';
import 'package:widyu/core/data/repository/notification/notification_repository.dart';
import 'package:widyu/core/data/repository/notification/notification_repository_impl.dart';
import 'package:widyu/core/data/source/auth_remote_data_source.dart';
import 'package:widyu/core/data/source/myPage/my_page_remote_data_source.dart';
import 'package:widyu/core/data/source/myPage/my_page_remote_data_source_impl.dart';
import 'package:widyu/core/data/source/notification/notification_remote_data_source.dart';
import 'package:widyu/core/data/source/notification/notification_remote_data_source_impl.dart';
import 'package:widyu/core/network/api_client.dart';
import 'package:widyu/core/network/token_manager.dart';
import 'package:widyu/core/ui/theme/theme.dart';
import 'package:widyu/core/utils/app_service_controller.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await dotenv.load(fileName: ".env");
  await initializeService();

  runApp(
    MultiProvider(
      providers: [
        Provider<TokenManager>(
          create: (_) => TokenManager(),
        ),
        Provider<AppServiceController>(
          create: (context) => AppServiceController(
            tokenManager: context.read<TokenManager>(),
          ),
        ),
        Provider<ApiClient>(
          create: (_) => ApiClient(),
        ),
        ProxyProvider<ApiClient, AuthRemoteDataSource>(
          update: (_, apiClient, __) =>
              AuthRemoteDataSource(apiClient: apiClient),
        ),
        ProxyProvider<ApiClient, MyPageRemoteDataSource>(
            update: (_, apiClient, __) =>
                MyPageRemoteDataSourceImpl(apiClient: apiClient)),
        ProxyProvider<ApiClient, NotificationRemoteDataSource>(
            update: (_, apiClient, __) =>
                NotificationRemoteDataSourceImpl(apiClient: apiClient)),
        ProxyProvider2<AuthRemoteDataSource, TokenManager, AuthRepository>(
          update: (context, remote, token, previous) => AuthRepositoryImpl(
            remoteDatasource: remote,
            tokenManager: token,
          ),
        ),
        ProxyProvider<MyPageRemoteDataSource, MyPageRepository>(
            update: (_, remote, __) =>
                MyPageRepositoryImpl(remoteDataSource: remote)),
        ProxyProvider<NotificationRemoteDataSource, NotificationRepository>(
            update: (_, remote, __) =>
                NotificationRepositoryImpl(remoteDataSource: remote)),
      ],
      child: const App(),
    ),
  );
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _MyAppState();
}

class _MyAppState extends State<App> {
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
