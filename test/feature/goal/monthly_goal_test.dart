import 'dart:async';

import 'package:clock/clock.dart';
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
import 'package:widyu/feature/goal/monthly/monthly_goal_screen.dart';
import 'package:widyu/feature/goal/monthly/monthly_goal_view_model.dart';

class _Goal extends Fake implements GoalRepository {
  final medicineCalls = <DateTime>[];

  @override
  Future<ApiResult<Set<int>>> fetchHealthScheduleDays({
    required int year,
    required int month,
  }) async =>
      const ApiResult.success({});

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
      const ApiResult.success([]);
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
  testWidgets('화살표로 달을 넘기고 오늘로 돌아와도 예외가 없다', (tester) async {
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

      await tester.tap(find.text('오늘로 돌아가기'));
      await tester.pumpAndSettle();
      expect(find.text('2026년 11월'), findsOneWidget);
    });
  });
}
