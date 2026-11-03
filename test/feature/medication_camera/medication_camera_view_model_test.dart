import 'dart:async';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medication_alarm/medication_alarm.dart';
import 'package:widyu/core/data/repository/goal/medication_repository.dart';
import 'package:widyu/core/data/repository/point/point_repository.dart';
import 'package:widyu/core/di/providers.dart';
import 'package:widyu/core/model/goal/medication/medication_point_result.dart';
import 'package:widyu/feature/medication_camera/medication_camera_ui_event.dart';
import 'package:widyu/feature/medication_camera/medication_camera_ui_state.dart';
import 'package:widyu/feature/medication_camera/medication_camera_view_model.dart';

class _Alarm extends Fake implements MedicationRepository {
  final verified = <int>[];
  Completer<Map<String, dynamic>>? pendingState;
  int stateCalls = 0;
  Future<MedicationPointResult> Function(MedicationOccurrence) onVerify =
      (_) async => const MedicationPointResult(earnedPoints: 10);

  @override
  Future<Map<String, dynamic>> alarmState() {
    stateCalls++;
    return pendingState?.future ?? Future.value({'memberId': '1'});
  }

  @override
  Future<MedicationPointResult> verifyMedication(
      MedicationOccurrence occurrence, File photo) {
    verified.add(occurrence.scheduleId);
    return onVerify(occurrence);
  }
}

class _Point extends Fake implements PointRepository {
  int refreshed = 0;

  @override
  Future<void> refresh() async => refreshed++;
}

void main() {
  final photo = File('/tmp/pill.jpg');
  late _Alarm alarm;
  late _Point point;
  late ProviderContainer container;
  late List<MedicationCameraUiEvent> events;

  setUp(() {
    alarm = _Alarm();
    point = _Point();
    container = ProviderContainer.test(overrides: [
      medicationRepositoryProvider.overrideWithValue(alarm),
      pointRepositoryProvider.overrideWithValue(point),
    ]);
    events = [];
  });

  // 첫 listen에서 build()가 실행되고 회차 확인은 다음 microtask에 시작한다.
  MedicationCameraViewModelProvider listen({
    List<int> scheduleIds = const [7],
    DateTime? scheduledAt,
  }) {
    final group = <String, dynamic>{
      'memberId': '1',
      'occurrences': [
        for (final id in scheduleIds)
          {
            'scheduleId': id,
            'localDate': '2026-10-19',
            'doseCount': 1,
            if (scheduledAt != null)
              'scheduledAt': scheduledAt.millisecondsSinceEpoch,
          },
      ],
    };
    final provider = medicationCameraViewModelProvider(group);
    container.listen(provider, (_, __) {});
    container.read(provider.notifier).uiEvent.listen(events.add);
    return provider;
  }

  Future<MedicationCameraViewModelProvider> start({
    List<int> scheduleIds = const [7],
    DateTime? scheduledAt,
  }) async {
    final provider = listen(scheduleIds: scheduleIds, scheduledAt: scheduledAt);
    await pumpEventQueue();
    return provider;
  }

  MedicationCameraUiState stateOf(MedicationCameraViewModelProvider provider) =>
      container.read(provider);

  test('복용 회차를 확인하면 촬영할 수 있고 정 수를 표시한다', () async {
    final provider = await start(scheduleIds: [7, 8]);
    expect(stateOf(provider).isReady, isTrue);
    expect(stateOf(provider).doseLabel, '2');
    expect(events, isEmpty);
  });

  test('인증 가능 시간이 지난 회차는 만료로 알린다', () async {
    await start(scheduledAt: DateTime.now().subtract(const Duration(hours: 2)));
    expect(events.single, isA<VerifyWindowClosed>());
    expect(alarm.verified, isEmpty);
  });

  test('인증 실패 시 실패를 알리고 다시 촬영할 수 있다', () async {
    final provider = await start();
    alarm.onVerify = (_) async => throw StateError('error');
    await container.read(provider.notifier).submit(photo);
    await pumpEventQueue();
    expect(events.single, isA<VerifyFailure>());
    expect(stateOf(provider).isBusy, isFalse);
  });

  test('인증 업로드 중에는 로딩 상태이고 중복 업로드하지 않는다', () async {
    final provider = await start();
    final viewModel = container.read(provider.notifier);
    final upload = Completer<MedicationPointResult>();
    alarm.onVerify = (_) => upload.future;
    final submit = viewModel.submit(photo);
    expect(stateOf(provider).isBusy, isTrue);
    await viewModel.submit(photo);
    expect(alarm.verified, [7]);
    upload.complete(const MedicationPointResult(earnedPoints: 10));
    await submit;
    await pumpEventQueue();
    expect(point.refreshed, 1);
    expect(events.single, isA<VerifySuccess>());
  });

  test('일부 회차만 성공하면 재시도 때 실패한 회차만 다시 보낸다', () async {
    final provider = await start(scheduleIds: [7, 8]);
    final viewModel = container.read(provider.notifier);
    alarm.onVerify = (occurrence) async => occurrence.scheduleId == 8
        ? throw StateError('error')
        : const MedicationPointResult(earnedPoints: 10);
    await viewModel.submit(photo);
    alarm.onVerify = (_) async => const MedicationPointResult(earnedPoints: 10);
    await viewModel.submit(photo);
    await pumpEventQueue();
    expect(alarm.verified, [7, 8, 8]);
    expect(events.last, isA<VerifySuccess>());
  });

  test('회차 확인 시작 전에 폐기되면 확인하지 않는다', () async {
    listen();
    container.dispose();
    // 이 VM은 회차 확인을 try/catch로 감싸 첫 줄 가드가 없어도 통과한다(패턴 일관성용 가드).
    await pumpEventQueue();
    expect(alarm.stateCalls, 0);
    expect(events, isEmpty);
  });

  test('회차 확인 중 폐기되면 상태와 이벤트를 쓰지 않는다', () async {
    alarm.pendingState = Completer();
    listen();
    await pumpEventQueue();

    container.dispose();
    alarm.pendingState!.complete({'memberId': '1'});
    // 가드가 없으면 닫힌 이벤트 stream이나 폐기된 state에 쓰다가 예외가 나서 실패한다.
    await pumpEventQueue();
    expect(events, isEmpty);
  });

  test('인증 중 폐기돼도 인증과 포인트 갱신은 끝까지 하고 이벤트는 쓰지 않는다', () async {
    final provider = await start(scheduleIds: [7, 8]);
    final upload = Completer<MedicationPointResult>();
    alarm.onVerify = (_) => upload.future;
    final submit = container.read(provider.notifier).submit(photo);
    await pumpEventQueue();

    container.dispose();
    upload.complete(const MedicationPointResult(earnedPoints: 10));
    await submit;
    await pumpEventQueue();
    expect(alarm.verified, [7, 8]);
    expect(point.refreshed, 1);
    expect(events, isEmpty);
  });

  test('인증 실패 뒤 폐기돼 있으면 상태와 이벤트를 쓰지 않는다', () async {
    final provider = await start();
    final upload = Completer<MedicationPointResult>();
    alarm.onVerify = (_) => upload.future;
    final submit = container.read(provider.notifier).submit(photo);
    await pumpEventQueue();

    container.dispose();
    upload.completeError(StateError('error'));
    // 가드가 없으면 폐기된 state에 쓰다가 예외가 submit 밖으로 나가서 실패한다.
    await submit;
    await pumpEventQueue();
    expect(events, isEmpty);
  });

  test('다시 빌드돼도 같은 회차를 두 번 인증하지 않는다', () async {
    final provider = await start();
    container.invalidate(provider);
    container.read(provider);
    await pumpEventQueue();

    await container.read(provider.notifier).submit(photo);
    expect(alarm.verified, [7]);
  });
}
