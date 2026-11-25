import 'dart:async';

import 'package:clock/clock.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:widyu/core/data/repository/goal/goal_repository.dart';
import 'package:widyu/core/data/repository/goal/medication_repository.dart';
import 'package:widyu/core/di/providers.dart';
import 'package:widyu/core/model/api/api_result.dart';
import 'package:widyu/core/model/goal/hospital/daily_health_schedule.dart';
import 'package:widyu/core/model/goal/monthly/daily_medicine_schedule.dart';
import 'package:widyu/core/model/goal/monthly/walk_daily.dart';
import 'package:widyu/core/util/refresh_signals.dart';
import 'package:widyu/feature/goal/monthly/monthly_goal_screen.dart';
import 'package:widyu/feature/goal/monthly/monthly_goal_ui_state.dart';
import 'package:widyu/feature/goal/monthly/monthly_goal_view_model.dart';

class _Goal extends Fake implements GoalRepository {
  final medicineCalls = <DateTime>[];
  final healthMonths = <(int, int)>[];
  Map<(int, int), Set<int>> healthDays = {};
  bool walksFail = false;

  @override
  Future<ApiResult<Set<int>>> fetchHealthScheduleDays({
    required int year,
    required int month,
  }) async {
    healthMonths.add((year, month));
    return ApiResult.success(healthDays[(year, month)] ?? {});
  }

  @override
  Future<ApiResult<List<DailyMedicineSchedule>>> fetchDailyMedicines(
    DateTime date,
  ) async {
    medicineCalls.add(date);
    return const ApiResult.success([]);
  }

  @override
  Future<ApiResult<List<DailyHealthSchedule>>> fetchDailyHealthSchedules(
    DateTime date,
  ) async =>
      const ApiResult.success([]);

  @override
  Future<ApiResult<List<WalkDaily>>> fetchMonthlyWalks({
    required int year,
    required int month,
  }) async =>
      walksFail ? const ApiResult.failure('실패') : const ApiResult.success([]);
}

class _Medication extends Fake implements MedicationRepository {
  // 테스트 하나가 끝나면 함께 버려지는 가짜 스트림이라 닫지 않는다.
  // ignore: close_sinks
  final changes = StreamController<void>.broadcast();

  @override
  Stream<void> get medicationChanges => changes.stream;
}

void main() {
  test('지난 날짜는 다시 조회하지 않고, 오늘과 약 인증 뒤에는 다시 조회한다', () async {
    final goal = _Goal();
    final medication = _Medication();
    final container = ProviderContainer.test(overrides: [
      goalRepositoryProvider.overrideWithValue(goal),
      medicationRepositoryProvider.overrideWithValue(medication),
    ]);
    final today = DateTime(2026, 11, 23);
    final past = DateTime(2026, 11, 10);

    await withClock(Clock.fixed(today.add(const Duration(hours: 9))), () async {
      container.listen(monthlyGoalViewModelProvider, (_, __) {});
      final viewModel = container.read(monthlyGoalViewModelProvider.notifier);
      await pumpEventQueue();

      Future<void> select(DateTime day) async {
        viewModel.selectDay(day);
        await pumpEventQueue();
      }

      await select(past);
      await select(today);
      await select(past);
      expect(container.read(monthlyGoalViewModelProvider).day?.date, past);

      medication.changes.add(null);
      await pumpEventQueue();
      // 처음 오늘 → 지난 날 → 오늘 → (지난 날은 캐시) → 인증 뒤 지난 날 다시 조회
      expect(goal.medicineCalls, [today, past, today, past]);
    });
  });

  // table_calendar가 빌드 중에 페이지를 옮기며 보내는 스크롤 알림에 setState하면
  // 예외가 나고 이어서 LateInitializationError로 달력이 깨졌다.
  testWidgets('화살표로 두 달 넘기고 오늘로 돌아와도 예외가 없다', (tester) async {
    await initializeDateFormatting('ko_KR');
    await withClock(Clock.fixed(DateTime(2026, 11, 23, 9)), () async {
      await tester.pumpWidget(ProviderScope(
        overrides: [
          goalRepositoryProvider.overrideWithValue(_Goal()),
          medicationRepositoryProvider.overrideWithValue(_Medication()),
        ],
        child: const MaterialApp(home: MonthlyGoalScreen()),
      ));
      await tester.pumpAndSettle();
      await tester.tap(find.text('13'));
      await tester.pumpAndSettle();

      final title = find.text('2026년 11월');
      final nextArrow = tester.getTopRight(title) +
          Offset(27, tester.getSize(title).height / 2);
      await tester.tapAt(nextArrow);
      await tester.pumpAndSettle();
      expect(find.text('2026년 12월'), findsOneWidget);
      // 두 달 이상 떨어진 달에서 돌아오면 table_calendar가 빌드 중에 페이지를 건너뛴다.
      await tester.tapAt(nextArrow);
      await tester.pumpAndSettle();
      expect(find.text('2027년 1월'), findsOneWidget);

      await tester.tap(find.text('오늘로 돌아가기'));
      await tester.pumpAndSettle();
      expect(find.text('2026년 11월'), findsOneWidget);
    });
  });

  test('걷기를 못 받으면 오류로 보이고, 캐시하지 않아 다시 고르면 다시 조회한다', () async {
    final goal = _Goal()..walksFail = true;
    final container = ProviderContainer.test(overrides: [
      goalRepositoryProvider.overrideWithValue(goal),
      medicationRepositoryProvider.overrideWithValue(_Medication()),
    ]);
    final today = DateTime(2026, 11, 23);
    final past = DateTime(2026, 11, 10);

    await withClock(Clock.fixed(today.add(const Duration(hours: 9))), () async {
      container.listen(monthlyGoalViewModelProvider, (_, __) {});
      final viewModel = container.read(monthlyGoalViewModelProvider.notifier);
      await pumpEventQueue();

      viewModel.selectDay(past);
      await pumpEventQueue();
      expect(container.read(monthlyGoalViewModelProvider).hasDayError, isTrue);

      goal.walksFail = false;
      viewModel.selectDay(today);
      await pumpEventQueue();
      viewModel.selectDay(past);
      await pumpEventQueue();
      expect(container.read(monthlyGoalViewModelProvider).hasDayError, isFalse);
      expect(goal.medicineCalls.where((d) => d == past), hasLength(2));
    });
  });

  test('건강 일정이 삭제됐다는 푸시를 받으면 그 달을 다시 받아 지워진 날의 표시를 없앤다', () async {
    final goal = _Goal()
      ..healthDays = {
        (2026, 5): {10, 20},
      };
    final messages = StreamController<RemoteMessage>.broadcast();
    addTearDown(messages.close);
    final container = ProviderContainer.test(overrides: [
      goalRepositoryProvider.overrideWithValue(goal),
      medicationRepositoryProvider.overrideWithValue(_Medication()),
      refreshSignalsProvider.overrideWithValue(
        RefreshSignals(
            messages: messages.stream, resumes: const Stream.empty()),
      ),
    ]);

    await withClock(Clock.fixed(DateTime(2026, 5, 20, 9)), () async {
      container.listen(monthlyGoalViewModelProvider, (_, __) {});
      await pumpEventQueue();
      expect(container.read(monthlyGoalViewModelProvider).healthDays,
          {DateTime(2026, 5, 10), DateTime(2026, 5, 20)});

      goal.healthDays = {
        (2026, 5): {20},
      };
      messages.add(const RemoteMessage(
          data: {'notificationType': 'HEALTH_SCHEDULE_DELETED'}));
      await pumpEventQueue();

      expect(container.read(monthlyGoalViewModelProvider).healthDays,
          {DateTime(2026, 5, 20)});
      expect(
          goal.medicineCalls, [DateTime(2026, 5, 20), DateTime(2026, 5, 20)]);
    });
  });

  test('앱이 다시 열려 조용히 다시 받다 실패하면 로딩·오류 없이 보던 내용을 둔다', () async {
    final goal = _Goal();
    final resumes = StreamController<void>.broadcast();
    addTearDown(resumes.close);
    final container = ProviderContainer.test(overrides: [
      goalRepositoryProvider.overrideWithValue(goal),
      medicationRepositoryProvider.overrideWithValue(_Medication()),
      refreshSignalsProvider.overrideWithValue(
        RefreshSignals(messages: const Stream.empty(), resumes: resumes.stream),
      ),
    ]);

    await withClock(Clock.fixed(DateTime(2026, 5, 20, 9)), () async {
      final states = <MonthlyGoalUiState>[];
      container.listen(
          monthlyGoalViewModelProvider, (_, next) => states.add(next));
      await pumpEventQueue();
      final shown = container.read(monthlyGoalViewModelProvider).day;
      expect(shown, isNotNull);

      states.clear();
      goal.walksFail = true;
      resumes.add(null);
      await pumpEventQueue();

      expect(goal.medicineCalls, hasLength(2));
      expect(states.any((state) => state.isDayLoading || state.hasDayError),
          isFalse);
      expect(container.read(monthlyGoalViewModelProvider).day, shown);
    });
  });

  test('두 달에 걸친 주를 고르면 두 달의 건강 일정을 날짜로 모은다', () async {
    final goal = _Goal()
      ..healthDays = {
        (2026, 4): {30},
        (2026, 5): {1},
      };
    final container = ProviderContainer.test(overrides: [
      goalRepositoryProvider.overrideWithValue(goal),
      medicationRepositoryProvider.overrideWithValue(_Medication()),
    ]);

    await withClock(Clock.fixed(DateTime(2026, 5, 20, 9)), () async {
      container.listen(monthlyGoalViewModelProvider, (_, __) {});
      final viewModel = container.read(monthlyGoalViewModelProvider.notifier);
      await pumpEventQueue();

      // 2026년 5월 1일(금)의 주는 4월 26일 ~ 5월 2일이다.
      viewModel.selectDay(DateTime(2026, 5));
      await pumpEventQueue();

      expect(
        container.read(monthlyGoalViewModelProvider).healthDays,
        {DateTime(2026, 4, 30), DateTime(2026, 5)},
      );
      // 이미 받은 달은 다시 받지 않는다.
      expect(goal.healthMonths, [(2026, 5), (2026, 4)]);
    });
  });

  test('처음 연 날의 주가 이웃 달에 걸치면 그 달의 건강 일정도 받는다', () async {
    final goal = _Goal()
      ..healthDays = {
        (2026, 4): {30},
      };
    final container = ProviderContainer.test(overrides: [
      goalRepositoryProvider.overrideWithValue(goal),
      medicationRepositoryProvider.overrideWithValue(_Medication()),
    ]);

    // 2026년 5월 1일(금)에 열면 접힌 주에 4월 30일이 보인다.
    await withClock(Clock.fixed(DateTime(2026, 5, 1, 9)), () async {
      container.listen(monthlyGoalViewModelProvider, (_, __) {});
      await pumpEventQueue();

      expect(
        container.read(monthlyGoalViewModelProvider).healthDays,
        {DateTime(2026, 4, 30)},
      );
    });
  });

  test('오늘 걷기 재조회에 실패하면 이전에 받은 달 데이터가 있어도 오류로 보인다', () async {
    final goal = _Goal();
    final container = ProviderContainer.test(overrides: [
      goalRepositoryProvider.overrideWithValue(goal),
      medicationRepositoryProvider.overrideWithValue(_Medication()),
    ]);
    final today = DateTime(2026, 11, 23);

    await withClock(Clock.fixed(today.add(const Duration(hours: 9))), () async {
      container.listen(monthlyGoalViewModelProvider, (_, __) {});
      final viewModel = container.read(monthlyGoalViewModelProvider.notifier);
      await pumpEventQueue();
      expect(container.read(monthlyGoalViewModelProvider).hasDayError, isFalse);

      goal.walksFail = true;
      viewModel.selectDay(DateTime(2026, 11, 10));
      await pumpEventQueue();
      // 같은 달 지난 날은 받아 둔 걷기 데이터를 쓴다.
      expect(container.read(monthlyGoalViewModelProvider).hasDayError, isFalse);

      viewModel.selectDay(today);
      await pumpEventQueue();
      expect(container.read(monthlyGoalViewModelProvider).hasDayError, isTrue);
    });
  });

  testWidgets('5월 1일에 열고 달력을 접으면 4월 30일에도 건강 일정 아이콘이 보인다', (tester) async {
    await initializeDateFormatting('ko_KR');
    final goal = _Goal()
      ..healthDays = {
        (2026, 4): {30},
      };
    await withClock(Clock.fixed(DateTime(2026, 5, 1, 9)), () async {
      await tester.pumpWidget(ProviderScope(
        overrides: [
          goalRepositoryProvider.overrideWithValue(goal),
          medicationRepositoryProvider.overrideWithValue(_Medication()),
        ],
        child: const MaterialApp(home: MonthlyGoalScreen()),
      ));
      await tester.pumpAndSettle();
      // 펼친 5월 달력에서는 4월 날짜를 그리지 않는다.
      expect(find.byWidgetPredicate(_isHealthIcon), findsNothing);

      // 일정 목록을 위로 밀어 달력을 접는다.
      await tester.drag(find.text('5월 1일'), const Offset(0, -500));
      await tester.pumpAndSettle();

      final icon = find.byWidgetPredicate(_isHealthIcon);
      expect(icon, findsOneWidget);
      // 아이콘은 4월 30일(목) 칸, 5월 1일(금) 왼쪽에 있다.
      expect(
        tester.getCenter(icon).dx,
        closeTo(tester.getCenter(find.text('30').last).dx, 1),
      );
    });
  });
}

bool _isHealthIcon(Widget widget) =>
    widget is Image &&
    widget.image is AssetImage &&
    (widget.image as AssetImage).assetName.contains('img_24_health');
