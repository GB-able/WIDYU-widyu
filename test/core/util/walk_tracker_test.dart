import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:widyu/core/data/repository/goal/walk_repository_impl.dart';
import 'package:widyu/core/data/repository/point/point_repository.dart';
import 'package:widyu/core/data/source/goal/walk_local_data_source.dart';
import 'package:widyu/core/data/source/goal/walk_remote_data_source.dart';
import 'package:widyu/core/model/api/api_response.dart';
import 'package:widyu/core/model/goal/walk/walk_detail.dart';
import 'package:widyu/core/model/goal/walk/walk_sync_response.dart';
import 'package:widyu/core/storage/storage_key.dart';
import 'package:widyu/core/util/extension/walk_extension.dart';
import 'package:widyu/core/util/walk_tracker.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late _Local local;
  late WalkRepositoryImpl repository;
  late WalkTracker tracker;
  late _Point point;
  final today = DateTime.now().walkDate;

  setUp(() async {
    FlutterSecureStorage.setMockInitialValues({
      StorageKey.widyuAccessToken.name: 'access',
      StorageKey.widyuRefreshToken.name: 'refresh',
      StorageKey.memberId.name: '1',
    });
    local = _Local();
    repository = WalkRepositoryImpl(
      localDataSource: local,
      remoteDataSource: _Remote(),
    );
    point = _Point();
    tracker = WalkTracker(repository: repository, pointRepository: point);
    await tracker.start();
    await pumpEventQueue();
  });

  tearDown(() {
    tracker.dispose();
    repository.dispose();
    local.close();
  });

  test('앱 진입 시 센서값을 표시하고 동기화한다', () {
    expect(repository.currentTodaySteps, 120);
    expect(local.syncCount, 1);
  });

  test('서버값이 더 크면 서버값을 보여준다', () {
    repository.applyServerSteps(999, date: today, goal: 5000);
    expect(repository.currentTodaySteps, 999);
    expect(local.syncCount, 1);
  });

  test('목표 달성 시 하루 한 번만 동기화한다', () async {
    repository.applyServerSteps(0, date: today, goal: 100);
    await Future<void>.delayed(Duration.zero);
    expect(local.syncCount, 2);
    local.sensorSteps = 130;
    await tracker.refresh();
    expect(repository.currentTodaySteps, 130);
    expect(local.syncCount, 2);
  });

  test('실시간 센서 증가분을 더하고 건강값 반영 뒤에는 기준을 다시 잡는다', () async {
    local.live.add(1000);
    local.live.add(1003);
    await Future<void>.delayed(Duration.zero);
    expect(repository.currentTodaySteps, 123);
    local.sensorSteps = 130;
    await tracker.refresh();
    local.live.add(1005);
    await Future<void>.delayed(Duration.zero);
    expect(repository.currentTodaySteps, 130);
    local.live.add(1007);
    await Future<void>.delayed(Duration.zero);
    expect(repository.currentTodaySteps, 132);
    local.live.add(2);
    await Future<void>.delayed(Duration.zero);
    expect(repository.currentTodaySteps, 132);
    local.live.add(4);
    await Future<void>.delayed(Duration.zero);
    expect(repository.currentTodaySteps, 134);
  });

  test('건강값이 표시값보다 작으면 표시값을 유지한다', () async {
    local.live.add(1000);
    local.live.add(1010);
    await Future<void>.delayed(Duration.zero);
    expect(repository.currentTodaySteps, 130);
    local.sensorSteps = 125;
    await tracker.refresh();
    expect(repository.currentTodaySteps, 130);
  });

  test('실시간 값이 목표를 넘으면 바로 동기화한다', () async {
    repository.applyServerSteps(0, date: today, goal: 125);
    await Future<void>.delayed(Duration.zero);
    expect(local.syncCount, 1);
    local.sensorSteps = 126;
    local.live.add(1000);
    local.live.add(1006);
    await Future<void>.delayed(Duration.zero);
    expect(repository.currentTodaySteps, 126);
    expect(local.syncCount, 2);
  });

  test('백그라운드 전환과 복귀 시 동기화한다', () async {
    tracker.didChangeAppLifecycleState(AppLifecycleState.paused);
    await Future<void>.delayed(Duration.zero);
    expect(local.syncCount, 2);
    tracker.didChangeAppLifecycleState(AppLifecycleState.resumed);
    await Future<void>.delayed(Duration.zero);
    expect(local.syncCount, 3);
    expect(point.refreshCount, 1);
  });
}

class _Local extends Fake implements WalkLocalDataSource {
  int sensorSteps = 120;
  int syncCount = 0;
  final live = StreamController<int>.broadcast();
  final _state = <String, Map<String, dynamic>>{};

  void close() => live.close();

  @override
  String get stepSource => 'test';

  @override
  Future<bool> ensurePermission() async => true;

  @override
  Future<bool> canReadInBackground() async => true;

  @override
  Future<int?> readSteps(DateTime start, DateTime end) async => sensorSteps;

  @override
  Stream<int> get liveStepCounts => live.stream;

  @override
  Future<Map<String, dynamic>> readState(String memberId) async =>
      _state[memberId] ?? <String, dynamic>{};

  @override
  Future<void> saveState(String memberId, Map<String, dynamic> state) async =>
      _state[memberId] = state;

  @override
  Future<String?> acquireLock(String name) async {
    syncCount++;
    return 'owner';
  }

  @override
  Future<bool> ownsLock(String name, String owner) async => true;

  @override
  Future<void> releaseLock(String name, String owner) async {}
}

class _Point extends Fake implements PointRepository {
  int refreshCount = 0;

  @override
  Future<void> refresh() async => refreshCount++;
}

class _Remote extends Fake implements WalkRemoteDataSource {
  @override
  Future<ApiResponse<WalkDetail>> fetchToday() async => ApiResponse(
        statusCode: 200,
        code: 'OK',
        message: 'OK',
        data: const WalkDetail(goal: 5000, actual: 0),
      );

  @override
  Future<ApiResponse<WalkSyncResponse>> sync({
    required int steps,
    required String date,
  }) async =>
      ApiResponse(
        statusCode: 200,
        code: 'OK',
        message: 'OK',
        data: const WalkSyncResponse(achieved: false),
      );
}
