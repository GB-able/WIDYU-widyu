import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:widyu/core/data/repository/incident/incident_repository.dart';
import 'package:widyu/core/model/api/api_result.dart';
import 'package:widyu/core/notification/safety_push_manager.dart';
import 'package:widyu/feature/safety_check/safety_check_ui_event.dart';
import 'package:widyu/feature/safety_check/safety_check_ui_state.dart';

class SafetyCheckViewModel extends ChangeNotifier {
  final IncidentRepository _repository;
  final String _incidentId;
  Timer? _deadlineTimer;
  Timer? _closeTimer;
  bool _deadlinePassed = false;
  bool _disposed = false;

  static const _defaultResponseWindow = Duration(seconds: 60);
  static const _resultDisplayDuration = Duration(seconds: 3);

  SafetyCheckUiState _uiState = const SafetyCheckUiState();
  SafetyCheckUiState get uiState => _uiState;

  final _uiEvent = StreamController<SafetyCheckUiEvent>.broadcast();
  Stream<SafetyCheckUiEvent> get uiEvent => _uiEvent.stream;

  SafetyCheckViewModel({
    required IncidentRepository repository,
    required String incidentId,
  })  : _repository = repository,
        _incidentId = incidentId;

  Future<void> start() async {
    _scheduleDeadline(_defaultResponseWindow);
    final result = await _repository.markPromptDisplayed(_incidentId);
    if (_disposed || _uiState.phase != SafetyCheckPhase.confirm) return;
    if (result case Success(:final data) when data.respondByMs != null) {
      final respondBy = DateTime.fromMillisecondsSinceEpoch(data.respondByMs!);
      _scheduleDeadline(respondBy.difference(DateTime.now()));
    }
  }

  Future<bool> respondOk() async {
    if (_uiState.phase != SafetyCheckPhase.confirm || _uiState.isSubmitting) {
      return false;
    }
    _update(_uiState.copyWith(isSubmitting: true));
    final result = await _repository.respondOk(_incidentId);
    if (_disposed) return false;
    switch (result) {
      case Success(:final data):
        _showResult(data.state == 'OK_CLOSED'
            ? SafetyCheckPhase.okay
            : SafetyCheckPhase.notOkay);
        return true;
      case Failure():
        _update(_uiState.copyWith(isSubmitting: false));
        if (_deadlinePassed) {
          _showResult(SafetyCheckPhase.notOkay);
        } else {
          _uiEvent.add(const RespondFailure());
        }
        return false;
    }
  }

  void _scheduleDeadline(Duration remaining) {
    _deadlineTimer?.cancel();
    _deadlineTimer = Timer(
      remaining.isNegative ? Duration.zero : remaining,
      () {
        _deadlinePassed = true;
        if (_uiState.isSubmitting) return;
        _showResult(SafetyCheckPhase.notOkay);
      },
    );
  }

  void _showResult(SafetyCheckPhase phase) {
    if (_uiState.phase != SafetyCheckPhase.confirm) return;
    _deadlineTimer?.cancel();
    SafetyPushManager.stopAlarm(_incidentId);
    _update(_uiState.copyWith(phase: phase, isSubmitting: false));
    _closeTimer = Timer(_resultDisplayDuration, () {
      if (!_disposed) _uiEvent.add(const CloseScreen());
    });
  }

  void _update(SafetyCheckUiState state) {
    if (_disposed) return;
    _uiState = state;
    notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    _deadlineTimer?.cancel();
    _closeTimer?.cancel();
    _uiEvent.close();
    super.dispose();
  }
}
