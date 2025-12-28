import 'package:flutter/material.dart';
import 'package:widyu/app/routes/custom_router.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:widyu/core/theme/theme.dart';

void main() async {
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
