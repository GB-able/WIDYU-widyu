import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:widyu/app/routes/custom_router.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:widyu/core/data/datasources/auth_remote_datasource.dart';
import 'package:widyu/core/data/repositories/auth_repository.dart';
import 'package:widyu/core/ui/theme/theme.dart';
import 'package:provider/provider.dart';
import 'package:widyu/core/network/api_client.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await dotenv.load(fileName: ".env");

  runApp(
    MultiProvider(
      providers: [
        Provider<ApiClient>(
          create: (_) => ApiClient(),
        ),
        ProxyProvider<ApiClient, AuthRemoteDatasource>(
          update: (_, apiClient, __) =>
              AuthRemoteDatasource(apiClient: apiClient),
        ),
        ProxyProvider2<ApiClient, AuthRemoteDatasource, AuthRepository>(
          update: (_, apiClient, remoteDatasource, __) => AuthRepository(
            apiClient: apiClient,
            remoteDatasource: remoteDatasource,
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
