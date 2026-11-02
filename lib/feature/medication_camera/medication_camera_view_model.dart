import 'dart:async';
import 'dart:io';

import 'package:medication_alarm/medication_alarm.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:widyu/core/data/repository/goal/medication_repository.dart';
import 'package:widyu/core/data/repository/point/point_repository.dart';
import 'package:widyu/core/di/providers.dart';
import 'package:widyu/core/log/log.dart';
import 'package:widyu/core/model/goal/medication/medication_point_result.dart';
import 'package:widyu/feature/medication_camera/medication_camera_ui_event.dart';
import 'package:widyu/feature/medication_camera/medication_camera_ui_state.dart';

part 'medication_camera_view_model.g.dart';

/// [group]은 라우트로 받은 복용 회차 묶음이다. Map은 객체 동일성으로 비교되므로
/// 화면이 처음 받은 Map을 고정해 넘겨야 화면마다 ViewModel 하나가 유지된다.
@riverpod
class MedicationCameraViewModel extends _$MedicationCameraViewModel {
  final _pending = <MedicationOccurrence>[];
  final _uiEvent = StreamController<MedicationCameraUiEvent>.broadcast();

  // 일회성 이벤트는 state가 아니라 stream으로 내보낸다.
  // ignore: riverpod_lint/avoid_public_notifier_properties
  Stream<MedicationCameraUiEvent> get uiEvent => _uiEvent.stream;

  MedicationRepository get _medicationRepository =>
      ref.read(medicationRepositoryProvider);
  PointRepository get _pointRepository => ref.read(pointRepositoryProvider);

  @override
  MedicationCameraUiState build(Map<String, dynamic> group) {
    // 다시 빌드되면 회차를 처음부터 다시 확인하므로 이전 목록을 비운다.
    _pending.clear();
    // onDispose는 다시 빌드될 때도 불리므로, 실제로 폐기될 때만 닫는다.
    ref.onDispose(() {
      if (!ref.mounted) _uiEvent.close();
    });
    unawaited(Future.microtask(_load));
    return MedicationCameraUiState(doseLabel: _doseLabel(group));
  }

  static String? _doseLabel(Map<String, dynamic> group) {
    final occurrences = group['occurrences'];
    if (occurrences is! List) return null;
    final dose = occurrences.fold<double>(0, (sum, item) {
      if (item is! Map || item['doseCount'] is! num) return sum;
      return sum + (item['doseCount'] as num).toDouble();
    });
    if (dose == 0) return null;
    return dose == dose.truncateToDouble()
        ? dose.toInt().toString()
        : dose.toStringAsFixed(1);
  }

  Future<void> _load() async {
    if (!ref.mounted) return;
    var expired = false;
    try {
      final alarmState = await _medicationRepository.alarmState();
      if (alarmState['memberId'] == group['memberId']) {
        final now = DateTime.now();
        for (final target
            in (group['occurrences'] as List).cast<Map<dynamic, dynamic>>()) {
          final occurrence =
              MedicationOccurrence.fromJson(Map<String, dynamic>.from(target));
          if (occurrence.canVerify(now)) {
            _pending.add(occurrence);
          } else {
            expired = true;
          }
        }
      }
    } catch (_) {}
    if (!ref.mounted) return;
    if (_pending.isEmpty) {
      _uiEvent.add(
          expired ? const VerifyWindowClosed() : const OccurrenceNotFound());
      return;
    }
    state = state.copyWith(isReady: true);
  }

  void setPermissionDenied(bool denied) {
    if (!ref.mounted) return;
    state = state.copyWith(isPermissionDenied: denied);
  }

  Future<void> submit(File photo) async {
    if (state.isBusy) return;
    state = state.copyWith(isBusy: true);
    // 화면이 먼저 닫혀도 인증과 포인트 갱신은 끝까지 한다(기존 동작).
    final medicationRepository = _medicationRepository;
    final pointRepository = _pointRepository;
    try {
      late MedicationPointResult result;
      for (final occurrence in [..._pending]) {
        result = await medicationRepository.verifyMedication(occurrence, photo);
        _pending.remove(occurrence);
      }
      // 인증한 복용 횟수는 약 복용 정보라 남기지 않는다(docs/logging-strategy.md §6.1).
      WiduLog.ui.i('약 복용 인증 성공 earnedPoints=${result.earnedPoints}');
      await pointRepository.refresh();
      if (ref.mounted) _uiEvent.add(VerifySuccess(result));
    } catch (e) {
      if (!ref.mounted) return;
      state = state.copyWith(isBusy: false);
      _uiEvent.add(VerifyFailure(e is StateError ? e.message : e.toString()));
    }
  }
}
