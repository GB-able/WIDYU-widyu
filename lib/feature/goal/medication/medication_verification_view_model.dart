import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:medication_alarm/medication_alarm.dart';
import 'package:widyu/core/data/provider/medication_alarm_provider.dart';
import 'package:widyu/core/data/provider/point_provider.dart';
import 'package:widyu/core/model/goal/medication/medication_point_result.dart';
import 'package:widyu/feature/goal/medication/medication_verification_ui_event.dart';
import 'package:widyu/feature/goal/medication/medication_verification_ui_state.dart';

class MedicationVerificationViewModel extends ChangeNotifier {
  final MedicationAlarmProvider _medicationAlarmProvider;
  final PointProvider _pointProvider;
  final Map<String, dynamic> _group;
  final _pending = <MedicationOccurrence>[];
  bool _disposed = false;

  MedicationVerificationUiState _uiState =
      const MedicationVerificationUiState();
  MedicationVerificationUiState get uiState => _uiState;

  final _uiEvent = StreamController<MedicationVerificationUiEvent>.broadcast();
  Stream<MedicationVerificationUiEvent> get uiEvent => _uiEvent.stream;

  MedicationVerificationViewModel({
    required MedicationAlarmProvider medicationAlarmProvider,
    required PointProvider pointProvider,
    required Map<String, dynamic> group,
  })  : _medicationAlarmProvider = medicationAlarmProvider,
        _pointProvider = pointProvider,
        _group = group;

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

  void setPhoto(File photo) => _update(_uiState.copyWith(photo: photo));

  Future<void> submit() async {
    final photo = _uiState.photo;
    if (_uiState.isBusy || photo == null) return;
    _update(_uiState.copyWith(isBusy: true));
    try {
      late MedicationPointResult result;
      for (final occurrence in _pending) {
        result = await _medicationAlarmProvider.verify(occurrence, photo);
      }
      await _pointProvider.refresh();
      if (!_disposed) _uiEvent.add(VerifySuccess(result));
    } catch (_) {
      if (_disposed) return;
      _update(_uiState.copyWith(isBusy: false));
      _uiEvent.add(const VerifyFailure());
    }
  }

  void _update(MedicationVerificationUiState state) {
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
