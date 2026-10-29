import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:medication_alarm/medication_alarm.dart';
import 'package:widyu/core/data/repository/goal/medication_repository.dart';
import 'package:widyu/core/data/repository/point/point_repository.dart';
import 'package:widyu/core/log/log.dart';
import 'package:widyu/core/model/goal/medication/medication_point_result.dart';
import 'package:widyu/feature/medication_camera/medication_camera_ui_event.dart';
import 'package:widyu/feature/medication_camera/medication_camera_ui_state.dart';

class MedicationCameraViewModel extends ChangeNotifier {
  final MedicationRepository _medicationRepository;
  final PointRepository _pointRepository;
  final Map<String, dynamic> _group;
  final _pending = <MedicationOccurrence>[];
  bool _disposed = false;

  MedicationCameraUiState _uiState = const MedicationCameraUiState();
  MedicationCameraUiState get uiState => _uiState;

  final _uiEvent = StreamController<MedicationCameraUiEvent>.broadcast();
  Stream<MedicationCameraUiEvent> get uiEvent => _uiEvent.stream;

  MedicationCameraViewModel({
    required MedicationRepository medicationRepository,
    required PointRepository pointRepository,
    required Map<String, dynamic> group,
  })  : _medicationRepository = medicationRepository,
        _pointRepository = pointRepository,
        _group = group;

  String? get doseLabel {
    final occurrences = _group['occurrences'];
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

  Future<void> load() async {
    var expired = false;
    try {
      final state = await _medicationRepository.alarmState();
      if (state['memberId'] == _group['memberId']) {
        final now = DateTime.now();
        for (final target
            in (_group['occurrences'] as List).cast<Map<dynamic, dynamic>>()) {
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
    if (_disposed) return;
    if (_pending.isEmpty) {
      _uiEvent.add(
          expired ? const VerifyWindowClosed() : const OccurrenceNotFound());
      return;
    }
    _update(_uiState.copyWith(isReady: true));
  }

  void setPermissionDenied(bool denied) =>
      _update(_uiState.copyWith(isPermissionDenied: denied));

  Future<void> submit(File photo) async {
    if (_uiState.isBusy) return;
    _update(_uiState.copyWith(isBusy: true));
    try {
      late MedicationPointResult result;
      for (final occurrence in [..._pending]) {
        result =
            await _medicationRepository.verifyMedication(occurrence, photo);
        _pending.remove(occurrence);
      }
      // 인증한 복용 횟수는 약 복용 정보라 남기지 않는다(docs/logging-strategy.md §6.1).
      WiduLog.ui.i('약 복용 인증 성공 earnedPoints=${result.earnedPoints}');
      await _pointRepository.refresh();
      if (!_disposed) _uiEvent.add(VerifySuccess(result));
    } catch (_) {
      if (_disposed) return;
      _update(_uiState.copyWith(isBusy: false));
      _uiEvent.add(const VerifyFailure());
    }
  }

  void _update(MedicationCameraUiState state) {
    if (_disposed) return;
    _uiState = state;
    notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    _uiEvent.close();
    super.dispose();
  }
}
