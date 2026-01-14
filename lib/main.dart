import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';
import 'package:widyu/app/routes/custom_router.dart';
import 'package:widyu/core/data/datasources/auth_remote_data_source.dart';
import 'package:widyu/core/data/repositories/auth/auth_repository.dart';
import 'package:widyu/core/network/api_client.dart';
import 'package:widyu/core/network/token_manager.dart';
import 'package:widyu/core/ui/theme/theme.dart';

import 'core/data/repositories/auth/auth_repository_impl.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await dotenv.load(fileName: ".env");

  runApp(
    MultiProvider(
      providers: [
        Provider<TokenManager>(
          create: (_) => TokenManager(),
        ),
        Provider<ApiClient>(
          create: (_) => ApiClient(),
        ),
        ProxyProvider<ApiClient, AuthRemoteDataSource>(
          update: (_, apiClient, __) =>
              AuthRemoteDataSource(apiClient: apiClient),
        ),
        ProxyProvider2<AuthRemoteDataSource, TokenManager, AuthRepository>(
          update: (context, remote, token, previous) => AuthRepositoryImpl(
            remoteDatasource: remote,
            tokenManager: token,
          ),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: '위듀',
      theme: MyTheme.myTheme,
      routerConfig: CustomRouter.router,
    );
  }
}
