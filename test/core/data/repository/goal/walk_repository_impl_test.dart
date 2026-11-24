import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:widyu/core/data/repository/goal/walk_repository_impl.dart';
import 'package:widyu/core/data/source/goal/walk_local_data_source.dart';
import 'package:widyu/core/data/source/goal/walk_remote_data_source.dart';
import 'package:widyu/core/model/api/api_response.dart';
import 'package:widyu/core/model/goal/walk/walk_detail.dart';
import 'package:widyu/core/model/goal/walk/walk_sync_response.dart';
import 'package:widyu/core/storage/storage_key.dart';
import 'package:widyu/core/util/extension/walk_extension.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late _LocalDataSource database;
  late _RemoteDataSource remote;
  late WalkRepositoryImpl repository;
  const today = '2026-09-14';

  setUp(() {
    FlutterSecureStorage.setMockInitialValues({StorageKey.memberId.name: '1'});
    database = _LocalDataSource();
    remote = _RemoteDataSource();
    repository = WalkRepositoryImpl(
      localDataSource: database,
      remoteDataSource: remote,
      now: () => DateTime.utc(2026, 9, 14),
    );
  });

  for (final status in [400, 403, 404, 422, 500, null]) {
    test('$status leaves steps pending and retries on the next sync', () async {
      remote.status = status;
      final result = await repository.sync(memberId: '1', background: true);
      expect(result.unauthorized, isFalse);
      expect(result.uploaded, 0);
      expect(database.days.values.every((day) => day['sent'] == null), isTrue);

      remote.status = 200;
      final retry = await repository.sync(memberId: '1', background: true);
      expect(remote.calls, 4);
      expect(retry.uploaded, 2);
      expect(retry.rewardChanged, isTrue);
      expect(database.days.values.every((day) => day['sent'] == 100), isTrue);
      expect(database.locked, isFalse);
    });
  }

  for (final throwUnauthorized in [false, true]) {
    test('final 401 ($throwUnauthorized) stops the batch and is returned',
        () async {
      remote.status = 401;
      remote.throwUnauthorized = throwUnauthorized;
      final result = await repository.sync(memberId: '1', background: true);
      expect(result.unauthorized, isTrue);
      expect(result.uploaded, 0);
      expect(remote.calls, 1);
      expect(database.days.values.every((day) => day['sent'] == null), isTrue);
      expect(database.locked, isFalse);
    });
  }

  test('successful days are not sent again', () async {
    await repository.sync(memberId: '1', background: true);
    final result = await repository.sync(memberId: '1', background: true);
    expect(remote.calls, 2);
    expect(result.uploaded, 0);
    expect(result.rewardChanged, isFalse);
  });

  test('걷기 목표가 없으면 건강값을 읽지도 올리지도 않는다', () async {
    remote.detail = null;
    database.health = 300;
    final result = await repository.sync(memberId: '1');
    expect(result.uploaded, 0);
    expect(remote.calls, 0);
    expect(database.reads, 0);
    repository.applyLiveCount(1000);
    repository.applyLiveCount(1010);
    await repository.refreshTodaySteps();
    expect(repository.currentTodaySteps, 0);
    expect(database.reads, 0);
  });

  test('목표가 없다가 생기면 그 시각 이후 걸음만 읽고 올린다', () async {
    var instant = DateTime.utc(2026, 9, 14, 3);
    final repo = WalkRepositoryImpl(
      localDataSource: database,
      remoteDataSource: remote,
      now: () => instant,
    );
    remote.detail = null;
    await repo.sync(memberId: '1');
    expect(database.days, isEmpty);
    expect(remote.calls, 0);

    instant = DateTime.utc(2026, 9, 14, 5);
    remote.detail = const WalkDetail(goal: 6400, actual: 0);
    await repo.sync(memberId: '1', full: true);
    expect(database.starts, isEmpty);

    instant = DateTime.utc(2026, 9, 14, 6);
    database.health = 50;
    final result = await repo.sync(memberId: '1', full: true);
    expect(database.starts.toSet(), {DateTime.utc(2026, 9, 14, 5)});
    expect(database.days.keys, ['2026-09-14']);
    expect(remote.sent, [50]);
    expect(result.uploaded, 1);

    database.starts.clear();
    await repo.refreshTodaySteps();
    expect(database.starts, [DateTime.utc(2026, 9, 14, 5)]);
  });

  test('처음 보는 상태에서 목표가 있으면 오늘 걸음만 올린다', () async {
    database.state = {};
    database.pastHealth = 5000;
    database.health = 300;
    final result = await repository.sync(memberId: '1', full: true);
    expect(database.days.keys, [today]);
    expect(remote.sent, [300]);
    expect(result.uploaded, 1);
  });

  test('건강값을 먼저 읽어도 더 큰 서버값을 보여준다', () async {
    repository.applyServerSteps(0, date: today, goal: 6400);
    database.health = 400;
    await repository.refreshTodaySteps();
    repository.applyServerSteps(7715, date: today, goal: 6400);
    expect(repository.currentTodaySteps, 7715);
  });

  test('실시간 값이 서버값보다 먼저 와도 서버값 위에 증가분만 더한다', () async {
    repository.applyServerSteps(0, date: today, goal: 6400);
    repository.applyLiveCount(1000);
    repository.applyServerSteps(7715, date: today, goal: 6400);
    repository.applyLiveCount(1010);
    expect(repository.currentTodaySteps, 7715);
    repository.applyLiveCount(1020);
    expect(repository.currentTodaySteps, 7725);
    database.health = 400;
    await repository.refreshTodaySteps();
    expect(repository.currentTodaySteps, 7725);
  });

  group('앱을 종료했다 다시 켜면', () {
    late WalkRepositoryImpl restarted;

    setUp(() async {
      database.state = {};
      database.health = 100;
      await repository.sync(memberId: '1');
      repository.applyLiveCount(1000);
      repository.applyLiveCount(1050);
      expect(repository.currentTodaySteps, 150);
      await repository.sync(memberId: '1', full: true);
      restarted = WalkRepositoryImpl(
        localDataSource: database,
        remoteDataSource: remote,
        now: () => DateTime.utc(2026, 9, 14),
      );
      await restarted.sync(memberId: '1', full: true);
      expect(restarted.currentTodaySteps, 150);
    });

    test('저장된 센서 기준점으로 종료 중 걸음을 바로 더한다', () {
      restarted.applyLiveCount(1250);
      expect(restarted.currentTodaySteps, 350);
    });

    test('재부팅으로 센서값이 기준점보다 작으면 쓰지 않는다', () {
      restarted.applyLiveCount(30);
      expect(restarted.currentTodaySteps, 150);
    });
  });

  test('자정을 넘긴 센서 증가분은 새 날에 더하지 않는다', () {
    var instant = DateTime.utc(2026, 9, 14, 14, 59, 58);
    final midnight = WalkRepositoryImpl(
      localDataSource: database,
      remoteDataSource: remote,
      now: () => instant,
    );
    midnight.applyServerSteps(500, date: today, goal: 6400);
    midnight.applyLiveCount(1000);
    instant = DateTime.utc(2026, 9, 14, 15, 0, 1);
    midnight.applyLiveCount(1002);
    expect(midnight.currentTodaySteps, 0);
    midnight.applyLiveCount(1003);
    expect(midnight.currentTodaySteps, 1);
  });

  test('재설치 후에는 서버값을 보정값으로 두고 이후 건강값을 더한다', () async {
    database.state = {};
    remote.detail = const WalkDetail(goal: 6400, actual: 6000);
    database.health = 0;
    final first = await repository.sync(memberId: '1');
    expect(first.steps, 6000);
    expect(remote.calls, 0);

    database.health = 2000;
    final background = WalkRepositoryImpl(
      localDataSource: database,
      remoteDataSource: remote,
      now: () => DateTime.utc(2026, 9, 14),
    );
    final second = await background.sync(memberId: '1', full: true);
    expect(second.steps, 8000);
    expect(remote.sent, [8000]);
  });

  test('Android 재설치 후에는 기록이 겹치지 않아 서버값에 건강값을 더한다', () async {
    database.stepSource = 'recordingApi';
    database.state = {};
    remote.detail = const WalkDetail(goal: 500, actual: 413);
    database.health = 56;
    final result = await repository.sync(memberId: '1');
    expect(result.steps, 469);
    expect(remote.sent, [469]);
  });

  test('자정을 걸쳐 받은 어제 서버값은 오늘 보정값으로 쓰지 않는다', () async {
    var instant = DateTime.utc(2026, 9, 14, 14, 59, 59);
    final midnight = WalkRepositoryImpl(
      localDataSource: database,
      remoteDataSource: remote,
      now: () => instant,
    );
    database.state = {};
    remote.detail = const WalkDetail(goal: 6400, actual: 8000);
    remote.onFetchToday = () => instant = DateTime.utc(2026, 9, 14, 15, 0, 1);
    database.health = 0;
    final result = await midnight.sync(memberId: '1');
    expect(result.steps, isNull);
    expect(remote.calls, 0);
    expect(database.state['days'], isNull);
  });
}

class _RemoteDataSource implements WalkRemoteDataSource {
  int? status = 200;
  bool throwUnauthorized = false;
  int calls = 0;
  final sent = <int>[];
  WalkDetail? detail = const WalkDetail(goal: 100, actual: 0);
  void Function()? onFetchToday;

  @override
  Future<ApiResponse<WalkDetail>> fetchToday() async {
    onFetchToday?.call();
    return ApiResponse(statusCode: 200, code: '', message: '', data: detail);
  }

  @override
  Future<ApiResponse<WalkSyncResponse>> sync({
    required int steps,
    required String date,
  }) async {
    calls++;
    sent.add(steps);
    if (status == null || throwUnauthorized) {
      final request = RequestOptions(path: '/goals/walks/sync');
      throw DioException(
        requestOptions: request,
        response: status == null
            ? null
            : Response(requestOptions: request, statusCode: status),
      );
    }
    return ApiResponse(
      statusCode: status,
      code: '',
      message: '',
      data: status == 200 ? const WalkSyncResponse(achieved: true) : null,
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _LocalDataSource implements WalkLocalDataSource {
  @override
  String stepSource = 'health';

  @override
  Future<bool> canReadInBackground() async => false;

  int? health;
  int? pastHealth;
  int reads = 0;
  final starts = <DateTime>[];

  @override
  Future<int?> readSteps(DateTime start, DateTime end) async {
    reads++;
    starts.add(start);
    return start.isBefore('2026-09-14'.walkStartOf) ? pastHealth : health;
  }

  Map<String, dynamic> state = {
    'source': 'health',
    'days': {
      '2026-09-13': <String, dynamic>{'total': 100},
      '2026-09-14': <String, dynamic>{
        'total': 100,
        // Previously saved backoff must not delay the next sync.
        'retryAt': DateTime.utc(2099).millisecondsSinceEpoch,
        'attempts': 9,
      },
    },
  };
  bool locked = false;

  @override
  Future<bool> hasDayInAnyState(String date) async => false;

  Map<String, dynamic> get days => state['days'] as Map<String, dynamic>;

  @override
  Future<Map<String, dynamic>> readState(String session) async => state;

  @override
  Future<void> saveState(String session, Map<String, dynamic> state) async {
    this.state = state;
  }

  @override
  Future<String?> acquireLock(String name) async {
    locked = true;
    return 'owner';
  }

  @override
  Future<bool> ownsLock(String name, String owner) async => locked;

  @override
  Future<void> releaseLock(String name, String owner) async {
    locked = false;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
