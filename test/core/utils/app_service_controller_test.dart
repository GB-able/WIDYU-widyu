import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:widyu/core/model/location/location_service_state.dart';
import 'package:widyu/core/utils/app_service_controller.dart';

LocationServiceState state({required bool gps, required bool alwaysAllowed}) =>
    LocationServiceState(
      serviceEnabled: gps,
      permissionGranted: alwaysAllowed,
    );

void main() {
  AppServiceController controller({
    required Future<bool> Function() hasToken,
    required Future<LocationServiceState> Function() refresh,
    required Stream<LocationServiceState> states,
    required List<String> calls,
    Future<void> Function(bool)? setAutoStart,
  }) =>
      AppServiceController(
        hasToken: hasToken,
        refreshLocationState: refresh,
        locationStates: states,
        startMonitoring: () async => calls.add('monitor:start'),
        stopMonitoring: () async => calls.add('monitor:stop'),
        setAutoStart:
            setAutoStart ?? (enabled) async => calls.add('auto:$enabled'),
        startBackground: () async => calls.add('background:start'),
        stopBackground: () async => calls.add('background:stop'),
      );

  test('토큰이 없으면 모니터와 서비스 시작을 하지 않는다', () async {
    final calls = <String>[];
    final states = StreamController<LocationServiceState>.broadcast();
    final sut = controller(
      hasToken: () async => false,
      refresh: () async => state(gps: true, alwaysAllowed: true),
      states: states.stream,
      calls: calls,
    );

    await sut.start();
    expect(calls, ['auto:false', 'background:stop']);
    await states.close();
    sut.dispose();
  });

  test('토큰 없는 start 뒤 로그인하면 다음 start가 모니터를 등록한다', () async {
    final calls = <String>[];
    final states = StreamController<LocationServiceState>.broadcast();
    var hasToken = false;
    final sut = controller(
      hasToken: () async => hasToken,
      refresh: () async => state(gps: true, alwaysAllowed: true),
      states: states.stream,
      calls: calls,
    );

    await sut.start();
    hasToken = true;
    await sut.start();

    expect(calls, [
      'auto:false',
      'background:stop',
      'monitor:start',
      'auto:true',
      'background:start',
    ]);
    await states.close();
    sut.dispose();
  });

  test('늦은 no-token 결과가 더 새 start 세션을 덮어쓰지 않는다', () async {
    final calls = <String>[];
    final states = StreamController<LocationServiceState>.broadcast();
    final firstToken = Completer<bool>();
    var tokenReads = 0;
    final sut = controller(
      hasToken: () {
        tokenReads++;
        return tokenReads == 1 ? firstToken.future : Future.value(true);
      },
      refresh: () async => state(gps: true, alwaysAllowed: true),
      states: states.stream,
      calls: calls,
    );

    final firstStart = sut.start();
    await Future<void>.delayed(Duration.zero);
    final stop = sut.stop();
    final secondStart = sut.start();
    firstToken.complete(false);
    await Future.wait([firstStart, stop, secondStart]);

    expect(calls, contains('monitor:start'));
    expect(calls.last, 'background:start');
    await states.close();
    sut.dispose();
  });

  test('토큰이 있으면 자동시작과 서비스를 켠다', () async {
    final calls = <String>[];
    final states = StreamController<LocationServiceState>.broadcast();
    final ready = state(gps: true, alwaysAllowed: true);
    final sut = controller(
      hasToken: () async => true,
      refresh: () async => ready,
      states: states.stream,
      calls: calls,
    );

    await sut.start();
    expect(sut.state, ready);
    expect(calls, ['monitor:start', 'auto:true', 'background:start']);
    await states.close();
    sut.dispose();
  });

  test('위치를 쓸 수 없어도 토큰이 있으면 서비스는 켠다', () async {
    for (final unavailable in [
      state(gps: false, alwaysAllowed: false),
      state(gps: false, alwaysAllowed: true),
      state(gps: true, alwaysAllowed: false),
    ]) {
      final calls = <String>[];
      final states = StreamController<LocationServiceState>.broadcast();
      final sut = controller(
        hasToken: () async => true,
        refresh: () async => unavailable,
        states: states.stream,
        calls: calls,
      );

      await sut.start();
      expect(sut.state, unavailable);
      expect(calls, ['monitor:start', 'auto:true', 'background:start']);
      await states.close();
      sut.dispose();
    }
  });

  test('토큰이 없으면 자동 시작 해제가 실패해도 서비스 중지는 시도한다', () async {
    final calls = <String>[];
    final states = StreamController<LocationServiceState>.broadcast();
    final sut = controller(
      hasToken: () async => false,
      refresh: () async => state(gps: true, alwaysAllowed: true),
      states: states.stream,
      calls: calls,
      setAutoStart: (_) async {
        calls.add('auto:false');
        throw StateError('auto boot failed');
      },
    );

    await sut.start();
    expect(calls, ['auto:false', 'background:stop']);
    await states.close();
    sut.dispose();
    await Future<void>.delayed(Duration.zero);
    await Future<void>.delayed(Duration.zero);
    expect(calls.where((call) => call == 'background:stop'), hasLength(2));
  });

  test('권한 철회는 state에 반영되지만 서비스는 계속 켜 둔다', () async {
    final calls = <String>[];
    final states = StreamController<LocationServiceState>.broadcast();
    var current = state(gps: true, alwaysAllowed: true);
    final sut = controller(
      hasToken: () async => true,
      refresh: () async => current,
      states: states.stream,
      calls: calls,
    );

    await sut.start();
    current = state(gps: true, alwaysAllowed: false);
    await sut.refresh();

    expect(sut.state, current);
    expect(calls, [
      'monitor:start',
      'auto:true',
      'background:start',
      'auto:true',
      'background:start',
    ]);
    await states.close();
    sut.dispose();
  });

  test('명시적 refresh는 같은 준비 상태에서도 자동 시작 설정을 다시 적용한다', () async {
    final calls = <String>[];
    final states = StreamController<LocationServiceState>.broadcast();
    final ready = state(gps: true, alwaysAllowed: true);
    final sut = controller(
      hasToken: () async => true,
      refresh: () async => ready,
      states: states.stream,
      calls: calls,
    );

    await sut.start();
    await sut.refresh();

    expect(calls.where((call) => call == 'auto:true'), hasLength(2));
    await states.close();
    sut.dispose();
  });

  test('중복 start는 새 listener를 만들지 않고 refresh만 한다', () async {
    final calls = <String>[];
    final states = StreamController<LocationServiceState>.broadcast();
    var refreshes = 0;
    final sut = controller(
      hasToken: () async => true,
      refresh: () async {
        refreshes++;
        return state(gps: true, alwaysAllowed: true);
      },
      states: states.stream,
      calls: calls,
    );

    await sut.start();
    await sut.start();
    expect(refreshes, 2);
    expect(calls.where((call) => call == 'monitor:start'), hasLength(1));
    await states.close();
    sut.dispose();
  });

  test('실패한 작업 뒤에도 다음 refresh는 직렬 큐에서 실행된다', () async {
    final calls = <String>[];
    final states = StreamController<LocationServiceState>.broadcast();
    var shouldFail = true;
    final sut = controller(
      hasToken: () async => true,
      refresh: () async => state(gps: true, alwaysAllowed: true),
      states: states.stream,
      calls: calls,
      setAutoStart: (enabled) async {
        calls.add('auto:$enabled');
        if (shouldFail) throw StateError('configure failed');
      },
    );

    await sut.start();
    shouldFail = false;
    await sut.refresh();
    expect(calls.where((call) => call == 'auto:true'), hasLength(2));
    expect(calls, contains('background:start'));
    await states.close();
    sut.dispose();
  });

  test('빠른 start-stop-start에서 늦은 첫 refresh는 마지막 시작을 되돌리지 않는다', () async {
    final calls = <String>[];
    final states = StreamController<LocationServiceState>.broadcast();
    final firstRefresh = Completer<LocationServiceState>();
    var refreshCount = 0;
    final sut = controller(
      hasToken: () async => true,
      refresh: () {
        refreshCount++;
        if (refreshCount == 1) return firstRefresh.future;
        return Future.value(state(gps: true, alwaysAllowed: true));
      },
      states: states.stream,
      calls: calls,
    );

    final firstStart = sut.start();
    await Future<void>.delayed(Duration.zero);
    await Future<void>.delayed(Duration.zero);
    expect(refreshCount, 1);
    final stop = sut.stop();
    final secondStart = sut.start();
    firstRefresh.complete(state(gps: false, alwaysAllowed: false));
    await Future.wait([firstStart, stop, secondStart]);

    expect(sut.state, state(gps: true, alwaysAllowed: true));
    expect(calls.last, 'background:start');
    await states.close();
    sut.dispose();
  });
}
