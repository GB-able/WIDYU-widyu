import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:widyu/core/data/repository/goal/goal_repository.dart';
import 'package:widyu/core/data/repository/goal/walk_repository.dart';
import 'package:widyu/core/data/repository/location/location_repository.dart';
import 'package:widyu/core/data/repository/point/point_repository.dart';
import 'package:widyu/core/di/providers.dart';
import 'package:widyu/core/model/api/api_result.dart';
import 'package:widyu/core/model/goal/goal_home_response.dart';
import 'package:widyu/core/model/goal/hospital/daily_health_schedule.dart';
import 'package:widyu/core/model/goal/medication/medication_point_result.dart';
import 'package:widyu/core/utils/extensions/walk_extension.dart';
import 'package:widyu/core/utils/find_route.dart';
import 'package:widyu/feature/goal/main/goal_ui_event.dart';
import 'package:widyu/feature/goal/main/goal_ui_state.dart';

part 'goal_view_model.g.dart';

@riverpod
class GoalViewModel extends _$GoalViewModel {
  String? _loadedDay;

  final _uiEvent = StreamController<GoalUiEvent>.broadcast();

  // 일회성 이벤트는 state가 아니라 stream으로 내보낸다.
  // ignore: riverpod_lint/avoid_public_notifier_properties
  Stream<GoalUiEvent> get uiEvent => _uiEvent.stream;

  GoalRepository get _repository => ref.read(goalRepositoryProvider);
  PointRepository get _pointRepository => ref.read(pointRepositoryProvider);
  WalkRepository get _walkRepository => ref.read(walkRepositoryProvider);
  LocationRepository get _locationRepository =>
      ref.read(locationRepositoryProvider);

  @override
  GoalUiState build() {
    // onDispose는 다시 빌드될 때도 불리므로, 실제로 폐기될 때만 닫는다.
    ref.onDispose(() {
      if (!ref.mounted) _uiEvent.close();
    });
    unawaited(Future.microtask(_start));
    return GoalUiState(point: _pointRepository.currentStatus.point);
  }

  void _start() {
    if (!ref.mounted) return;
    // 구독하면 최신 값이 다시 전달된다. 전달 시점이 stream 구현에 따라 다르므로
    // build() 중에 state를 쓰지 않도록 build() 뒤에 구독한다.
    final pointStatus = _pointRepository.status.listen((status) {
      state = state.copyWith(point: status.point);
    });
    ref.onDispose(pointStatus.cancel);
    unawaited(ref.read(walkTrackerProvider).start());
    unawaited(refresh());
    final medicationChanges = ref
        .read(medicationRepositoryProvider)
        .medicationChanges
        .listen((_) => unawaited(refresh(showLoading: false)));
    ref.onDispose(medicationChanges.cancel);
    final dayTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      if (_loadedDay != DateTime.now().walkDate) {
        unawaited(refresh(showLoading: false));
      }
    });
    ref.onDispose(dayTimer.cancel);
  }

  void _emit(GoalUiEvent event) {
    if (ref.mounted) _uiEvent.add(event);
  }

  Future<void> refresh({bool showLoading = true}) async {
    final requestedDay = DateTime.now().walkDate;
    _loadedDay = requestedDay;
    if (showLoading) {
      state = state.copyWith(isLoading: true);
    }

    final home = await _repository.fetchGoalHome();
    if (!ref.mounted) return;
    unawaited(_pointRepository.refresh());

    switch (home) {
      case Success<GoalHomeResponse>(:final data):
        final walk = data.walk;
        if (walk != null) {
          _walkRepository.applyServerSteps(
            walk.actual,
            date: requestedDay,
            goal: walk.goal,
          );
        }

        state = state.copyWith(
          isLoading: false,
          hasError: false,
          medicine: data.medicine,
          stepGoal: walk?.goal ?? 0,
          visits: data.todaySchedules,
        );
      case Failure<GoalHomeResponse>():
        // 화면에 데이터가 있는 상태의 조용한 갱신 실패는 기존 화면을 둔다.
        if (showLoading || state.isLoading) {
          state = state.copyWith(isLoading: false, hasError: true);
        }
    }
  }

  void onMedicationVerified(MedicationPointResult result) {
    _emit(VerifyMedicationSuccess(result.earnedPoints, result.currentPoints));
  }

  Future<void> findRoute(DailyHealthSchedule visit) => findRouteTo(
        locationRepository: _locationRepository,
        address: visit.placeAddress ?? visit.scheduleName,
        latitude: visit.latitude,
        longitude: visit.longitude,
      );
}
