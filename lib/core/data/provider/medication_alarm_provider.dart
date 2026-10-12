import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:medication_alarm/medication_alarm.dart';
import 'package:widyu/core/data/repository/goal/medication_repository.dart';
import 'package:widyu/core/model/api/api_result.dart';
import 'package:widyu/core/model/goal/medication/medication_point_result.dart';

typedef _Session = ({
  String member,
  String session,
  Map<String, dynamic> state
});

class MedicationAlarmProvider extends ChangeNotifier {
  MedicationAlarmProvider({
    required MedicationRepository repository,
    required MedicationAlarm native,
    required Future<String?> Function() currentMember,
  })  : _repository = repository,
        _native = native,
        _currentMember = currentMember;

  final MedicationRepository _repository;
  final MedicationAlarm _native;
  final Future<String?> Function() _currentMember;
  Map<String, dynamic> state = {};
  bool _disposed = false;
  Future<void>? _syncing;
  bool _syncAgain = false;

  Future<void> activate(String member) => _native.activate(member);
  Future<Map<String, dynamic>> capabilities() => _native.capabilities();
  Future<Map<String, dynamic>> activeGroup() => _native.activeGroup();
  Future<void> stop(String groupId) => _native.stop(groupId);
  Future<Map<String, dynamic>> pendingLaunch() => _native.pendingLaunch();
  Future<void> acknowledgeLaunch(String eventId) =>
      _native.acknowledgeLaunch(eventId);

  Future<void> refreshState() async {
    final value = await _native.state();
    if (_disposed) return;
    state = value;
    notifyListeners();
  }

  Future<void> sync() {
    if (_syncing != null) {
      _syncAgain = true;
      return _syncing!;
    }
    return _syncing = _syncLoop().whenComplete(() => _syncing = null);
  }

  Future<void> _syncLoop() async {
    do {
      _syncAgain = false;
      await _sync();
    } while (_syncAgain && !_disposed);
  }

  Future<void> _sync() async {
    try {
      final current = await _session();
      if (current == null) return;
      final (:member, :session, :state) = current;
      final timeZone = (state['capabilities'] as Map?)?['timeZone'];
      if (timeZone is! String) throw StateError('기기 타임존을 읽지 못했어요.');
      final MedicationSchedule schedule;
      try {
        schedule = switch (await _repository.fetchMedicationSchedule(member)) {
          Success(:final data) => data,
          Failure(:final statusCode) =>
            throw StateError('알람 일정 조회 실패: HTTP $statusCode'),
        };
      } catch (_) {
        if (state['schedule'] is Map) {
          await _apply(session, Map<String, dynamic>.from(state['schedule'] as Map),
              timeZone);
        }
        rethrow;
      }
      if (_disposed ||
          schedule.memberId != member ||
          (await _session())?.session != session) {
        return;
      }
      debugPrint('[MedicationSync] revision ${state['revision']} → '
          '${schedule.revision}, schedules=${schedule.schedules.length}');
      final status = await _apply(session, schedule.toJson(), timeZone);
      debugPrint('[MedicationSync] applySchedule status=${status['status']} '
          'applied=${status['appliedRevision']} '
          'count=${status['scheduledCount']} failures=${status['failures']}');
      if (_disposed || (await _session())?.session != session) return;
      await refreshState();
    } catch (e) {
      debugPrint('[MedicationSync] sync 실패: $e');
    }
  }

  Future<Map<String, dynamic>> _apply(
      String session, Map<String, dynamic> json, String timeZone) {
    final schedule = MedicationSchedule.fromJson({...json, 'timeZone': timeZone});
    return _native.applySchedule(
        sessionId: session,
        schedule: schedule.toJson(),
        groups: schedule.groups(DateTime.now()));
  }

  Future<_Session?> _session() async {
    final member = await _currentMember();
    final state = await _native.state();
    final session = state['sessionId'];
    if (member == null || state['memberId'] != member || session is! String) {
      return null;
    }
    return (member: member, session: session, state: state);
  }

  Future<MedicationPointResult> verify(
      MedicationOccurrence occurrence, File photo) async {
    final current = await _session();
    if (current == null) throw StateError('로그인이 필요해요.');
    final point = switch (await _repository.verifyMedication(
        scheduleId: occurrence.scheduleId, proofImage: photo)) {
      Success(:final data) => data,
      Failure(:final message) => throw StateError(message),
    };
    if ((await _session())?.session != current.session) return point;
    await _native
        .complete(sessionId: current.session, occurrenceIds: [occurrence.id]);
    await refreshState();
    unawaited(sync());
    return point;
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
