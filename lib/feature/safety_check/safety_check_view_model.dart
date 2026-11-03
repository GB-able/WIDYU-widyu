import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:widyu/core/data/repository/incident/incident_repository.dart';
import 'package:widyu/core/di/providers.dart';
import 'package:widyu/core/model/api/api_result.dart';
import 'package:widyu/core/notification/safety_push_manager.dart';
import 'package:widyu/feature/safety_check/safety_check_ui_state.dart';

part 'safety_check_view_model.g.dart';

@riverpod
class SafetyCheckViewModel extends _$SafetyCheckViewModel {
  late IncidentRepository _repository;
  late String _incidentId;
  Timer? _deadlineTimer;
  Timer? _closeTimer;
  late bool _deadlinePassed;

  static const _defaultResponseWindow = Duration(seconds: 60);
  static const _resultDisplayDuration = Duration(seconds: 3);

  @override
  SafetyCheckUiState build(String incidentId) {
    _repository = ref.read(incidentRepositoryProvider);
    _incidentId = incidentId;
    _deadlinePassed = false;
    ref.onDispose(() {
      _deadlineTimer?.cancel();
      _closeTimer?.cancel();
    });
    unawaited(_start());
    return const SafetyCheckUiState();
  }

  Future<void> _start() async {
    _scheduleDeadline(_defaultResponseWindow);
    final result = await _repository.markPromptDisplayed(_incidentId);
    if (!ref.mounted || state.phase != SafetyCheckPhase.confirm) return;
    if (result case Success(:final data) when data.respondByMs != null) {
      final respondBy = DateTime.fromMillisecondsSinceEpoch(data.respondByMs!);
      _scheduleDeadline(respondBy.difference(DateTime.now()));
    }
  }

  Future<SafetyRespondResult> respondOk() async {
    if (state.phase != SafetyCheckPhase.confirm || state.isSubmitting) {
      return SafetyRespondResult.ignored;
    }
    state = state.copyWith(isSubmitting: true);
    final result = await _repository.respondOk(_incidentId);
    if (!ref.mounted) return SafetyRespondResult.ignored;
    switch (result) {
      case Success(:final data):
        _showResult(data.state == 'OK_CLOSED'
            ? SafetyCheckPhase.okay
            : SafetyCheckPhase.notOkay);
        return SafetyRespondResult.sent;
      case Failure():
        state = state.copyWith(isSubmitting: false);
        if (!_deadlinePassed) return SafetyRespondResult.failed;
        _showResult(SafetyCheckPhase.notOkay);
        return SafetyRespondResult.ignored;
    }
  }

  void _scheduleDeadline(Duration remaining) {
    _deadlineTimer?.cancel();
    _deadlineTimer = Timer(
      remaining.isNegative ? Duration.zero : remaining,
      () {
        _deadlinePassed = true;
        if (state.isSubmitting) return;
        _showResult(SafetyCheckPhase.notOkay);
      },
    );
  }

  void _showResult(SafetyCheckPhase phase) {
    if (state.phase != SafetyCheckPhase.confirm) return;
    _deadlineTimer?.cancel();
    SafetyPushManager.stopAlarm(_incidentId);
    state = state.copyWith(phase: phase, isSubmitting: false);
    _closeTimer = Timer(_resultDisplayDuration, () {
      if (ref.mounted) state = state.copyWith(closed: true);
    });
  }
}
