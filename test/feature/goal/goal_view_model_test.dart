import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:widyu/core/data/repository/goal/goal_repository.dart';
import 'package:widyu/core/data/repository/goal/medication_repository.dart';
import 'package:widyu/core/data/repository/goal/walk_repository.dart';
import 'package:widyu/core/data/repository/point/point_repository.dart';
import 'package:widyu/core/di/providers.dart';
import 'package:widyu/core/model/api/api_result.dart';
import 'package:widyu/core/model/goal/goal_home_response.dart';
import 'package:widyu/core/model/goal/medication/medication.dart';
import 'package:widyu/core/model/goal/walk/walk.dart';
import 'package:widyu/core/model/goal/weekly_goal_status_response.dart';
import 'package:widyu/core/utils/extensions/walk_extension.dart';
import 'package:widyu/core/utils/walk_tracker.dart';
import 'package:widyu/feature/goal/main/goal_ui_event.dart';
import 'package:widyu/feature/goal/main/goal_ui_state.dart';
import 'package:widyu/feature/goal/main/goal_view_model.dart';

class _Goal extends Fake implements GoalRepository {
  ApiResult<GoalHomeResponse> home = const ApiResult.success(
    GoalHomeResponse(
      medicine: null,
      walk: Walk(goal: 5000, actual: 1234),
      hospital: null,
    ),
  );
  ApiResult<List<GoalRateStatus>> weekly = const ApiResult.success([]);
  Completer<void>? pending;
  int calls = 0;

  @override
  Future<ApiResult<GoalHomeResponse>> fetchGoalHome() async {
    calls++;
    await pending?.future;
    return home;
  }

  @override
  Future<ApiResult<List<GoalRateStatus>>> fetchWeeklyStatus() async {
    await pending?.future;
    return weekly;
  }
}

class _Point extends Fake implements PointRepository {
  final _status = StreamController<PointStatus>.broadcast();
  int refreshes = 0;

  @override
  Stream<PointStatus> get status => _status.stream;

  @override
  PointStatus get currentStatus => (point: 10, isLoading: false);

  @override
  Future<void> refresh() async => refreshes++;

  void emit(int point) => _status.add((point: point, isLoading: false));
}

class _Walk extends Fake implements WalkRepository {
  final _steps = StreamController<int>.broadcast();
  final applied = <(int, String, int?)>[];

  @override
  Stream<int> get todaySteps => _steps.stream;

  @override
  int get currentTodaySteps => 7;

  @override
  void applyServerSteps(int serverSteps, {required String date, int? goal}) =>
      applied.add((serverSteps, date, goal));

  void emit(int steps) => _steps.add(steps);
}

class _Medication extends Fake implements MedicationRepository {
  // 테스트 하나가 끝나면 함께 버려지는 가짜 스트림이라 닫지 않는다.
  // ignore: close_sinks
  final changes = StreamController<void>.broadcast();

  @override
  Stream<void> get medicationChanges => changes.stream;
}

class _Tracker extends Fake implements WalkTracker {
  int starts = 0;

  @override
  Future<void> start() async => starts++;
}

void main() {
  late _Goal goal;
  late _Point point;
  late _Walk walk;
  late _Medication medication;
  late _Tracker tracker;
  late ProviderContainer container;
  late List<GoalUiEvent> events;

  setUp(() {
    goal = _Goal();
    point = _Point();
    walk = _Walk();
    medication = _Medication();
    tracker = _Tracker();
    container = ProviderContainer.test(overrides: [
      goalRepositoryProvider.overrideWithValue(goal),
      pointRepositoryProvider.overrideWithValue(point),
      walkRepositoryProvider.overrideWithValue(walk),
      medicationRepositoryProvider.overrideWithValue(medication),
      walkTrackerProvider.overrideWithValue(tracker),
    ]);
    events = [];
  });

  // 첫 listen에서 build()가 실행되고 조회는 다음 microtask에 시작한다.
  // setUp과 테스트 본문 사이에도 microtask가 돌므로 테스트 안에서 부른다.
  void listen() {
    container.listen(goalViewModelProvider, (_, __) {});
    container.read(goalViewModelProvider.notifier).uiEvent.listen(events.add);
  }

  GoalUiState state() => container.read(goalViewModelProvider);

  test('처음에는 현재 포인트·걸음 수와 로딩을 보여 준다', () {
    listen();
    expect(state().point, 10);
    expect(state().steps, 7);
    expect(state().isLoading, isTrue);
  });

  test('조회 시작 전에 폐기되면 조회하지 않는다', () async {
    listen();
    container.dispose();
    await pumpEventQueue();
    expect(goal.calls, 0);
    expect(tracker.starts, 0);
  });

  test('조회에 성공하면 카드와 주간 현황을 보여 주고 포인트·걸음 수를 갱신한다', () async {
    listen();
    await pumpEventQueue();

    expect(state().cards, isA<GoalCardsData>());
    expect(state().isLoading, isFalse);
    expect(tracker.starts, 1);
    expect(point.refreshes, 1);
    expect(walk.applied.single, (1234, DateTime.now().walkDate, 5000));
    expect(events, isEmpty);
  });

  test('주간 현황만 실패하면 안내 이벤트를 보낸다', () async {
    goal.weekly = const ApiResult.failure('error');
    listen();
    await pumpEventQueue();

    expect(state().cards, isA<GoalCardsData>());
    expect(events.single, isA<FetchWeeklyStatusFailure>());
  });

  test('조회 중 폐기되면 상태·이벤트를 쓰지 않고 포인트·걸음 수도 갱신하지 않는다', () async {
    goal
      ..weekly = const ApiResult.failure('error')
      ..pending = Completer();
    listen();
    await pumpEventQueue();
    expect(goal.calls, 1);

    container.dispose();
    goal.pending!.complete();
    // 가드가 없으면 폐기된 state에 쓰거나 닫힌 이벤트 stream에 보낸다.
    // 기존에도 폐기 확인이 포인트·걸음 수 갱신보다 앞에 있었다.
    await pumpEventQueue();
    expect(events, isEmpty);
    expect(point.refreshes, 0);
    expect(walk.applied, isEmpty);
  });

  test('포인트·걸음 수가 바뀌면 반영하고, 약 복용이 바뀌면 로딩 없이 다시 조회한다', () async {
    listen();
    await pumpEventQueue();

    point.emit(30);
    walk.emit(100);
    await pumpEventQueue();
    expect(state().point, 30);
    expect(state().steps, 100);

    goal.pending = Completer();
    medication.changes.add(null);
    await pumpEventQueue();
    expect(goal.calls, 2);
    expect(state().isLoading, isFalse);
  });

  testWidgets('폐기되면 타이머와 구독을 정리한다', (tester) async {
    // 복용 시간이 없으면 만료로 보지 않아 남은 시간 타이머가 1초마다 돈다.
    goal.home = const ApiResult.success(
      GoalHomeResponse(
        medicine: Medication(
          medicineScheduleId: 1,
          takenCount: 0,
          totalCount: 1,
          nextDoseCount: 1,
          nextAlarmTime: '',
          proofImage: null,
          scheduleStatuses: [],
        ),
        walk: null,
        hospital: null,
      ),
    );
    listen();
    await tester.pump();
    expect(goal.calls, 1);

    container.dispose();
    // 구독이나 남은 시간 타이머가 남아 있으면 폐기된 state를 쓰다가 예외가 난다.
    point.emit(30);
    walk.emit(100);
    medication.changes.add(null);
    await tester.pump(const Duration(seconds: 2));
    expect(goal.calls, 1);
    // 날짜 확인 타이머(30초)가 남아 있으면 testWidgets가 끝날 때 남은 타이머로 실패한다.
  });
}
