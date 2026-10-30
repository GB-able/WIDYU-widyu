import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

/// 카테고리별 로거. 통신 원문·예외 원문이 섞일 수 있으므로 debug 빌드에서만 출력한다(작업지시서 L1).
/// 콘솔·logcat에서 `WidU`로 검색하면 앱 로그 전체를, `WidU_DATA`처럼 검색하면 해당 카테고리만 본다.
/// 메시지는 고정 문구로 쓰고 예외는 error·stackTrace로 넘긴다(docs/logging-strategy.md §9).
/// 본문처럼 만들기 비싼 메시지는 클로저로 넘기면 필터를 통과한 뒤에만 평가된다.
abstract final class WiduLog {
  /// ViewModel·화면·라우터
  static final ui = _logger('UI');

  /// Repository·DataSource·ApiResult·플랫폼 채널
  static final data = _logger('DATA');

  /// Dio 인터셉터(debug 전용)
  static final network = _logger('NETWORK');

  /// STOMP 소켓
  static final socket = _logger('SOCKET');

  /// background isolate
  static final bg = _logger('BG');

  /// 전역 에러 핸들러 전용
  static final global = _logger('GLOBAL');

  /// 개발 중 임시 디버깅용. 커밋 전에 지우거나 해당 레이어 로거로 옮긴다.
  static final debug = _logger('DEBUG');
}

Logger _logger(String category) => Logger(
      // profile·release는 끈다. 출력 여부를 assert가 아닌 kDebugMode로 명시하려고 ProductionFilter를 쓴다.
      filter: ProductionFilter(),
      level: kDebugMode ? Level.all : Level.off,
      printer: PrettyPrinter(methodCount: 0),
      output: _DebugPrintOutput('[WidU_$category]'),
    );

/// ConsoleOutput(print)은 줄이 몰리면 Android logcat이 버리므로 throttle하는 debugPrint로 낸다.
/// Dart 로그의 logcat 태그는 `flutter`로 고정이라, 검색용 태그를 모든 줄 앞에 붙인다.
class _DebugPrintOutput extends LogOutput {
  _DebugPrintOutput(this._tag);

  final String _tag;

  @override
  void output(OutputEvent event) {
    for (final line in event.lines) {
      debugPrint('$_tag $line');
    }
  }
}

/// release에서 zone 안의 모든 print(debugPrint·서드파티 print 포함)를 버린다(작업지시서 L1).
/// isolate마다 따로 적용해야 하므로 main과 background 서비스의 runZonedGuarded에 함께 넘긴다.
/// runZonedGuarded의 onError는 바깥 zone에서 실행되어 이 차단이 적용되지 않는다.
final quietPrintInRelease = ZoneSpecification(
  print: (self, parent, zone, line) {
    if (!kReleaseMode) parent.print(zone, line);
  },
);
