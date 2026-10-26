import 'dart:async';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:medication_alarm/medication_alarm.dart';
import 'package:widyu/core/data/provider/point_provider.dart';
import 'package:widyu/core/data/repository/goal/medication_repository.dart';
import 'package:widyu/core/model/goal/medication/medication_point_result.dart';
import 'package:widyu/feature/medication_camera/medication_camera_ui_event.dart';
import 'package:widyu/feature/medication_camera/medication_camera_view_model.dart';

class _Alarm extends Fake implements MedicationRepository {
  final verified = <int>[];
  Future<MedicationPointResult> Function(MedicationOccurrence) onVerify =
      (_) async => const MedicationPointResult(earnedPoints: 10);

  @override
  Future<Map<String, dynamic>> alarmState() async => {'memberId': '1'};

  @override
  Future<MedicationPointResult> verifyMedication(
      MedicationOccurrence occurrence, File photo) {
    verified.add(occurrence.scheduleId);
    return onVerify(occurrence);
  }
}

class _Point extends Fake implements PointProvider {
  @override
  Future<void> refresh() async {}
}

void main() {
  final photo = File('/tmp/pill.jpg');

  Future<(MedicationCameraViewModel, _Alarm, List<MedicationCameraUiEvent>)>
      setUp({List<int> scheduleIds = const [7]}) async {
    final alarm = _Alarm();
    final vm = MedicationCameraViewModel(
      medicationRepository: alarm,
      pointProvider: _Point(),
      group: {
        'memberId': '1',
        'occurrences': [
          for (final id in scheduleIds)
            {'scheduleId': id, 'localDate': '2026-10-19'},
        ],
      },
    );
    final events = <MedicationCameraUiEvent>[];
    final subscription = vm.uiEvent.listen(events.add);
    addTearDown(() async {
      await subscription.cancel();
      vm.dispose();
    });
    await vm.load();
    return (vm, alarm, events);
  }

  test('인증 실패 시 실패를 알리고 다시 촬영할 수 있다', () async {
    final (vm, alarm, events) = await setUp();
    alarm.onVerify = (_) async => throw StateError('error');
    await vm.submit(photo);
    await Future<void>.delayed(Duration.zero);
    expect(events.single, isA<VerifyFailure>());
    expect(vm.uiState.isBusy, isFalse);
  });

  test('인증 업로드 중에는 로딩 상태이고 중복 업로드하지 않는다', () async {
    final (vm, alarm, events) = await setUp();
    final upload = Completer<MedicationPointResult>();
    alarm.onVerify = (_) => upload.future;
    final submit = vm.submit(photo);
    expect(vm.uiState.isBusy, isTrue);
    await vm.submit(photo);
    expect(alarm.verified, [7]);
    upload.complete(const MedicationPointResult(earnedPoints: 10));
    await submit;
    await Future<void>.delayed(Duration.zero);
    expect(events.single, isA<VerifySuccess>());
  });

  test('일부 회차만 성공하면 재시도 때 실패한 회차만 다시 보낸다', () async {
    final (vm, alarm, events) = await setUp(scheduleIds: [7, 8]);
    alarm.onVerify = (occurrence) async => occurrence.scheduleId == 8
        ? throw StateError('error')
        : const MedicationPointResult(earnedPoints: 10);
    await vm.submit(photo);
    alarm.onVerify = (_) async => const MedicationPointResult(earnedPoints: 10);
    await vm.submit(photo);
    await Future<void>.delayed(Duration.zero);
    expect(alarm.verified, [7, 8, 8]);
    expect(events.last, isA<VerifySuccess>());
  });
}
