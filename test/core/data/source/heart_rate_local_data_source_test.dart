import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:widyu/core/data/source/heartRate/heart_rate_local_data_source_impl.dart';
import 'package:widyu/core/model/heartRate/heart_rate.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final messenger =
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
  const events = MethodChannel('com.widucorp.widu/heart_rate');
  const status = MethodChannel('com.widucorp.widu/heart_rate_status');
  const codec = StandardMethodCodec();
  late List<MethodCall> eventCalls;
  late List<MethodCall> statusCalls;

  setUp(() {
    eventCalls = [];
    statusCalls = [];
    messenger.setMockMethodCallHandler(events, (call) async {
      eventCalls.add(call);
      return null;
    });
    messenger.setMockMethodCallHandler(status, (call) async {
      statusCalls.add(call);
      return null;
    });
  });

  tearDown(() {
    debugDefaultTargetPlatformOverride = null;
    messenger.setMockMethodCallHandler(events, null);
    messenger.setMockMethodCallHandler(status, null);
  });

  test('iOS neither subscribes nor cancels the Android-only channel', () async {
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
    final source = HeartRateLocalDataSourceImpl();

    expect(await source.getHeartRates().toList(), isEmpty);
    expect(await source.observeConnection().toList(), [false]);
    final subscription = source.observeConnection().listen((_) {});
    await subscription.cancel();
    await source.sendHeartRateStatus('NORMAL');

    expect(eventCalls, isEmpty);
    expect(statusCalls, isEmpty);
  });

  test(
      'Android shares its subscription and releases it after the last listener',
      () async {
    debugDefaultTargetPlatformOverride = TargetPlatform.android;
    final source = HeartRateLocalDataSourceImpl();
    final sample = Completer<HeartRate>();
    final connected = Completer<bool>();
    final samples = source.getHeartRates().listen(sample.complete);
    final connection = source.observeConnection().listen(connected.complete);
    await Future<void>.delayed(Duration.zero);
    expect(eventCalls.map((call) => call.method), ['listen']);

    await messenger.handlePlatformMessage(
      events.name,
      codec.encodeSuccessEnvelope({'heartRate': 72, 'timestamp': 1000}),
      (_) {},
    );
    expect((await sample.future).heartRate, 72);
    expect(await connected.future, isTrue);
    await samples.cancel();
    expect(eventCalls.map((call) => call.method), ['listen']);
    await connection.cancel();
    await Future<void>.delayed(Duration.zero);
    expect(eventCalls.map((call) => call.method), ['listen', 'cancel']);

    await source.sendHeartRateStatus('NORMAL');
    expect(statusCalls.single.method, 'fetchHeartRateStatus');
    expect(statusCalls.single.arguments, {'heartRateStatus': 'NORMAL'});
  });
}
