import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:widyu/app/routes/custom_router.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:widyu/core/ui/theme/theme.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await dotenv.load(fileName: ".env");

  runApp(const MyApp());
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
