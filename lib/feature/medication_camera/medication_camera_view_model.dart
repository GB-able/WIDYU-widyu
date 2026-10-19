import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:medication_alarm/medication_alarm.dart';
import 'package:widyu/core/data/provider/medication_alarm_provider.dart';
import 'package:widyu/core/data/provider/point_provider.dart';
import 'package:widyu/core/model/goal/medication/medication_point_result.dart';
import 'package:widyu/feature/medication_camera/medication_camera_ui_event.dart';
import 'package:widyu/feature/medication_camera/medication_camera_ui_state.dart';

class MedicationCameraViewModel extends ChangeNotifier {
  final MedicationAlarmProvider _medicationAlarmProvider;
  final PointProvider _pointProvider;
  final Map<String, dynamic> _group;
  final _pending = <MedicationOccurrence>[];
  bool _disposed = false;

  MedicationCameraUiState _uiState = const MedicationCameraUiState();
  MedicationCameraUiState get uiState => _uiState;

  final _uiEvent = StreamController<MedicationCameraUiEvent>.broadcast();
  Stream<MedicationCameraUiEvent> get uiEvent => _uiEvent.stream;

  MedicationCameraViewModel({
    required MedicationAlarmProvider medicationAlarmProvider,
    required PointProvider pointProvider,
    required Map<String, dynamic> group,
  })  : _medicationAlarmProvider = medicationAlarmProvider,
        _pointProvider = pointProvider,
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
    try {
      await _medicationAlarmProvider.refreshState();
      if (_medicationAlarmProvider.state['memberId'] == _group['memberId']) {
        final now = DateTime.now();
        for (final target in (_group['occurrences'] as List).cast<Map>()) {
          final occurrence =
              MedicationOccurrence.fromJson(Map<String, dynamic>.from(target));
          if (occurrence.canVerify(now)) _pending.add(occurrence);
        }
      }
    } catch (_) {}
    if (_disposed) return;
    if (_pending.isEmpty) {
      _uiEvent.add(const OccurrenceNotFound());
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
        result = await _medicationAlarmProvider.verify(occurrence, photo);
        _pending.remove(occurrence);
      }
      await _pointProvider.refresh();
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
