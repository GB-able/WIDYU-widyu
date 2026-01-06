import 'package:flutter/material.dart';
import 'package:widyu/core/ui/theme/colors.dart';

class MyEffects {
  static BoxShadow shadow = BoxShadow(
    color: MyColor.grey900.withValues(alpha: 0.2),
    blurRadius: 12,
    offset: const Offset(1, 1),
  );
}
