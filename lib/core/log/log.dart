import 'dart:async';

import 'package:flutter/foundation.dart';

/// release에서 zone 안의 모든 print(debugPrint·서드파티 print 포함)를 버린다(작업지시서 L1).
/// isolate마다 따로 적용해야 하므로 main과 background 서비스의 runZonedGuarded에 함께 넘긴다.
/// runZonedGuarded의 onError는 바깥 zone에서 실행되어 이 차단이 적용되지 않는다.
final quietPrintInRelease = ZoneSpecification(
  print: (self, parent, zone, line) {
    if (!kReleaseMode) parent.print(zone, line);
  },
);
