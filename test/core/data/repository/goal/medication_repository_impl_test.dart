import 'package:flutter_test/flutter_test.dart';
import 'package:medication_alarm/medication_alarm.dart';
import 'package:widyu/core/data/repository/goal/medication_repository_impl.dart';
import 'package:widyu/core/data/source/goal/medication_alarm_local_data_source.dart';
import 'package:widyu/core/data/source/goal/medication_remote_data_source.dart';
import 'package:widyu/core/model/api/api_response.dart';

class _Remote extends Fake implements MedicationRemoteDataSource {
  @override
  Future<ApiResponse<MedicationSchedule>> fetchMedicationSchedule(
          String memberId) async =>
      ApiResponse(
        statusCode: 200,
        code: '',
        message: '',
        data: MedicationSchedule(
          memberId: memberId,
          revision: 1,
          timeZone: 'UTC',
          schedules: const [],
          excludedOccurrenceIds: const {},
        ),
      );
}

class _Local extends Fake implements MedicationAlarmLocalDataSource {
  final applied = <String>[];

  @override
  Future<Map<String, dynamic>> state() async => {
        'memberId': 'm',
        'sessionId': 's',
        'capabilities': {'timeZone': 'Asia/Seoul'},
      };

  @override
  Future<Map<String, dynamic>> applySchedule({
    required String sessionId,
    required Map<String, dynamic> schedule,
    required List<Map<String, dynamic>> groups,
  }) async {
    applied.add('$sessionId:${schedule['timeZone']}');
    return {};
  }
}

MedicationRepositoryImpl _repository(_Local local, String member) =>
    MedicationRepositoryImpl(
      remoteDataSource: _Remote(),
      localDataSource: local,
      currentMember: () async => member,
    );

void main() {
  test('현재 회원 세션에 기기 타임존으로 스케줄을 적용한다', () async {
    final local = _Local();
    await _repository(local, 'm').syncAlarmSchedule();
    expect(local.applied, ['s:Asia/Seoul']);
  });

  test('로그인 회원과 알람 세션 회원이 다르면 적용하지 않는다', () async {
    final local = _Local();
    await _repository(local, 'other').syncAlarmSchedule();
    expect(local.applied, isEmpty);
  });
}
