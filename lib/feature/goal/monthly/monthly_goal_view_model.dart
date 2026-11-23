import 'dart:async';

import 'package:clock/clock.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:widyu/core/data/repository/goal/goal_repository.dart';
import 'package:widyu/core/di/providers.dart';
import 'package:widyu/core/model/api/api_result.dart';
import 'package:widyu/core/model/goal/hospital/daily_health_schedule.dart';
import 'package:widyu/core/model/goal/monthly/daily_medicine_schedule.dart';
import 'package:widyu/core/model/goal/monthly/walk_daily.dart';
import 'package:widyu/core/util/extension/date_extension.dart';
import 'package:widyu/core/util/find_route.dart';
import 'package:widyu/feature/goal/monthly/monthly_goal_ui_state.dart';

part 'monthly_goal_view_model.g.dart';

@riverpod
class MonthlyGoalViewModel extends _$MonthlyGoalViewModel {
  int _monthRequest = 0;
  int _dayRequest = 0;
  // 걷기는 날짜 단위 API가 없어 달 단위로 받아 둔다.
  final Map<DateTime, List<WalkDaily>> _walksByMonth = {};
  // 지난 날짜는 거의 바뀌지 않아 화면이 열려 있는 동안만 들고 있는다. 약을 인증하면 비운다.
  final Map<DateTime, MonthlyGoalDay> _pastDays = {};

  GoalRepository get _repository => ref.read(goalRepositoryProvider);

  @override
  MonthlyGoalUiState build() {
    final today = clock.now().onlyDateTime;
    unawaited(Future.microtask(_start));
    return MonthlyGoalUiState(
      today: today,
      focusedMonth: DateTime(today.year, today.month),
      selectedDay: today,
    );
  }

  void _start() {
    if (!ref.mounted) return;
    // 약 인증 뒤 상태가 바뀌면 보고 있는 날짜를 다시 받는다.
    final medicationChanges =
        ref.read(medicationRepositoryProvider).medicationChanges.listen((_) {
      _pastDays.clear();
      unawaited(_loadDay(state.selectedDay));
    });
    ref.onDispose(medicationChanges.cancel);
    unawaited(loadMonth(state.focusedMonth));
    unawaited(_loadDay(state.selectedDay));
  }

  Future<void> loadMonth(DateTime month) async {
    final target = DateTime(month.year, month.month);
    if (target.isBefore(state.firstMonth) || target.isAfter(state.lastMonth)) {
      return;
    }
    final request = ++_monthRequest;
    state = state.copyWith(focusedMonth: target, healthDays: {});

    final result = await _repository.fetchHealthScheduleDays(
      year: target.year,
      month: target.month,
    );
    if (!ref.mounted || request != _monthRequest) return;
    state = state.copyWith(
      healthDays: switch (result) {
        Success(:final data) => data,
        Failure() => <int>{},
      },
    );
  }

  Future<void> onPageChanged(DateTime focusedDay) async {
    if (focusedDay.isSameMonth(state.focusedMonth)) return;
    await loadMonth(focusedDay);
  }

  void selectDay(DateTime day) {
    final normalized = day.onlyDateTime;
    if (normalized.isSameDay(state.selectedDay)) return;
    state = state.copyWith(selectedDay: normalized);
    if (!normalized.isSameMonth(state.focusedMonth)) {
      unawaited(loadMonth(normalized));
    }
    unawaited(_loadDay(normalized));
  }

  void goToday() {
    // 오늘이 이미 선택돼 있어도 다른 달을 보고 있으면 이번 달로 돌아온다.
    if (!state.today.isSameMonth(state.focusedMonth)) {
      unawaited(loadMonth(state.today));
    }
    selectDay(state.today);
  }

  Future<void> retry() => _loadDay(state.selectedDay);

  Future<void> _loadDay(DateTime date) async {
    final request = ++_dayRequest;
    if (_pastDays[date] case final cached?) {
      state =
          state.copyWith(isDayLoading: false, hasDayError: false, day: cached);
      return;
    }
    state = state.copyWith(isDayLoading: true, hasDayError: false);

    final month = DateTime(date.year, date.month);
    final results = await Future.wait<Object>([
      _repository.fetchDailyMedicines(date),
      _repository.fetchDailyHealthSchedules(date),
      if (!_walksByMonth.containsKey(month) || date.isSameDay(state.today))
        _repository.fetchMonthlyWalks(year: date.year, month: date.month),
    ]);
    if (!ref.mounted || request != _dayRequest) return;

    if (results.length > 2) {
      if (results[2] case Success<List<WalkDaily>>(:final data)) {
        _walksByMonth[month] = data;
      }
    }
    final medicines = results[0] as ApiResult<List<DailyMedicineSchedule>>;
    final health = results[1] as ApiResult<List<DailyHealthSchedule>>;
    if (medicines is! Success<List<DailyMedicineSchedule>> ||
        health is! Success<List<DailyHealthSchedule>>) {
      state = state.copyWith(isDayLoading: false, hasDayError: true);
      return;
    }

    final day = MonthlyGoalDay(
      date: date,
      medicines: [...medicines.data]
        ..sort((a, b) => a.alarmTime.compareTo(b.alarmTime)),
      healthSchedules: [...health.data]
        ..sort((a, b) => a.scheduledAt.compareTo(b.scheduledAt)),
      walk: _walksByMonth[month]
          ?.where((walk) => walk.date.isSameDay(date))
          .firstOrNull,
    );
    if (date.isBefore(state.today)) _pastDays[date] = day;
    state = state.copyWith(isDayLoading: false, day: day);
  }

  Future<void> findRoute(DailyHealthSchedule schedule) => findRouteTo(
        locationRepository: ref.read(locationRepositoryProvider),
        address: schedule.placeAddress ?? schedule.scheduleName,
        latitude: schedule.latitude,
        longitude: schedule.longitude,
      );
}
