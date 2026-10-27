import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:widyu/core/ui/theme/colors.dart';

class MyTheme {
  static final myTheme = ThemeData(
    fontFamily: 'Pretendard',
    primaryColor: MyColor.primary,
    scaffoldBackgroundColor: MyColor.white,
    appBarTheme: const AppBarTheme(
      surfaceTintColor: Colors.transparent,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      toolbarHeight: 52,
      elevation: 0,
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: MyColor.secondary,
    ),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: MyColor.secondary,
      selectionHandleColor: MyColor.secondary,
      selectionColor: MyColor.secondary.withValues(alpha: 0.3),
    ),
  );
}
