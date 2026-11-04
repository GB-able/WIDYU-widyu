import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:widyu/core/ui/widgets/ui_event_listener.dart';

void main() {
  testWidgets('숨은 동안 들어온 이벤트는 다시 보일 때 실행한다', (tester) async {
    final events = StreamController<int>.broadcast();
    final handled = <int>[];
    Widget build({required bool active}) => TickerMode(
          enabled: active,
          child: UiEventListener<int>(
            stream: events.stream,
            onEvent: handled.add,
            runWhileInactive: (event) => event == 0,
            child: const SizedBox(),
          ),
        );

    await tester.pumpWidget(build(active: false));
    events
      ..add(1)
      ..add(0);
    await tester.pump();
    expect(handled, [0]);

    await tester.pumpWidget(build(active: true));
    await tester.pump();
    expect(handled, [0, 1]);

    events.add(2);
    await tester.pump();
    expect(handled, [0, 1, 2]);
    await events.close();
  });
}
