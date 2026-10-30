import 'dart:async';
import 'dart:io';

import 'package:medication_alarm/medication_alarm.dart';
import 'package:widyu/core/data/repository/goal/medication_repository.dart';
import 'package:widyu/core/data/source/goal/medication_alarm_local_data_source.dart';
import 'package:widyu/core/data/source/goal/medication_remote_data_source.dart';
import 'package:widyu/core/log/log.dart';
import 'package:widyu/core/model/api/api_result.dart';
import 'package:widyu/core/model/goal/medication/medication_point_result.dart';
import 'package:widyu/core/utils/extensions/api_result_extension.dart';

typedef _Session = ({
  String member,
  String session,
  Map<String, dynamic> state
});

class MedicationRepositoryImpl extends MedicationRepository {
  final MedicationRemoteDataSource _remoteDataSource;
  final MedicationAlarmLocalDataSource _localDataSource;
  final Future<String?> Function() _currentMember;
  final _medicationChanges = StreamController<void>.broadcast();
  int? _scheduleRevision;
  Future<void>? _syncing;
  bool _syncAgain = false;

  MedicationRepositoryImpl({
    required MedicationRemoteDataSource remoteDataSource,
    required MedicationAlarmLocalDataSource localDataSource,
    required Future<String?> Function() currentMember,
  })  : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource,
        _currentMember = currentMember;

  @override
  Stream<void> get medicationChanges => _medicationChanges.stream;

  @override
  Stream<void> get alarmChanges => _localDataSource.changes;

  @override
  Future<MedicationPointResult> verifyMedication(
      MedicationOccurrence occurrence, File proofImage) async {
    final current = await _session();
    if (current == null) throw StateError('로그인이 필요해요.');
    final point = switch (await _remoteDataSource.verifyMedication(
        scheduleId: occurrence.scheduleId,
        proofImages: [proofImage]).toApiResult()) {
      Success(:final data) => data,
      Failure(:final message) => throw StateError(message),
    };
    _medicationChanges.add(null);
    if ((await _session())?.session != current.session) return point;
    await _localDataSource
        .complete(sessionId: current.session, occurrenceIds: [occurrence.id]);
    unawaited(syncAlarmSchedule());
    return point;
  }

  @override
  Future<void> syncAlarmSchedule() {
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
    } while (_syncAgain);
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
        schedule = await _fetchSchedule(member);
      } catch (_) {
        if (state['schedule'] is Map) {
          await _apply(session,
              Map<String, dynamic>.from(state['schedule'] as Map), timeZone);
        }
        rethrow;
      }
      if (schedule.memberId != member ||
          (await _session())?.session != session) {
        return;
      }
      WiduLog.data.d('약 복용 일정 revision ${state['revision']} → '
          '${schedule.revision}, schedules=${schedule.schedules.length}');
      final status = await _apply(session, schedule.toJson(), timeZone);
      WiduLog.data.d('약 복용 알림 적용 status=${status['status']} '
          'applied=${status['appliedRevision']} '
          'count=${status['scheduledCount']} failures=${status['failures']}');
    } catch (e, stack) {
      WiduLog.data.w('약 복용 일정 동기화 실패', error: e, stackTrace: stack);
    }
  }

  Future<MedicationSchedule> _fetchSchedule(String member) async {
    final schedule = switch (
        await _remoteDataSource.fetchMedicationSchedule(member).toApiResult()) {
      Success(:final data) => data,
      Failure(:final statusCode) =>
        throw StateError('알람 일정 조회 실패: HTTP $statusCode'),
    };
    final previous = _scheduleRevision;
    _scheduleRevision = schedule.revision;
    if (previous != null && previous != schedule.revision) {
      _medicationChanges.add(null);
    }
    return schedule;
  }

  Future<Map<String, dynamic>> _apply(
      String session, Map<String, dynamic> json, String timeZone) {
    final schedule =
        MedicationSchedule.fromJson({...json, 'timeZone': timeZone});
    return _localDataSource.applySchedule(
        sessionId: session,
        schedule: schedule.toJson(),
        groups: schedule.groups(DateTime.now()));
  }

  Future<_Session?> _session() async {
    final member = await _currentMember();
    final state = await _localDataSource.state();
    final session = state['sessionId'];
    if (member == null || state['memberId'] != member || session is! String) {
      return null;
    }
    return (member: member, session: session, state: state);
  }

  @override
  Future<Map<String, dynamic>> alarmCapabilities() =>
      _localDataSource.capabilities();

  @override
  Future<Map<String, dynamic>> requestAlarmPermission() =>
      _localDataSource.requestPermissions();

  @override
  Future<Map<String, dynamic>> activateAlarm(String memberId) =>
      _localDataSource.activate(memberId);

  @override
  Future<Map<String, dynamic>> alarmState() => _localDataSource.state();

  @override
  Future<Map<String, dynamic>> activeAlarmGroup() =>
      _localDataSource.activeGroup();

  @override
  Future<void> stopAlarm(String groupId) => _localDataSource.stop(groupId);

  @override
  Future<void> clearAlarmSession() => _localDataSource.clearSession();

  @override
  Future<Map<String, dynamic>> pendingAlarmLaunch() =>
      _localDataSource.pendingLaunch();

  @override
  Future<void> acknowledgeAlarmLaunch(String eventId) =>
      _localDataSource.acknowledgeLaunch(eventId);
}
