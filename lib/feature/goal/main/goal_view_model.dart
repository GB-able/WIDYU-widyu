import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:widyu/core/data/repository/goal/goal_repository.dart';
import 'package:widyu/core/data/repository/goal/walk_repository.dart';
import 'package:widyu/core/data/repository/location/location_repository.dart';
import 'package:widyu/core/data/repository/point/point_repository.dart';
import 'package:widyu/core/di/providers.dart';
import 'package:widyu/core/model/api/api_result.dart';
import 'package:widyu/core/model/goal/goal_home_response.dart';
import 'package:widyu/core/model/goal/medication/medication_point_result.dart';
import 'package:widyu/core/model/goal/weekly_goal_status_response.dart';
import 'package:widyu/core/model/location/user_location.dart';
import 'package:widyu/core/utils/extensions/walk_extension.dart';
import 'package:widyu/core/utils/kakao_map_launcher.dart';
import 'package:widyu/core/utils/show_toast.dart';
import 'package:widyu/feature/goal/main/goal_ui_event.dart';
import 'package:widyu/feature/goal/main/goal_ui_state.dart';

part 'goal_view_model.g.dart';

@riverpod
class GoalViewModel extends _$GoalViewModel {
  Timer? _countdownTimer;
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
      _countdownTimer?.cancel();
      if (!ref.mounted) _uiEvent.close();
    });
    unawaited(Future.microtask(_start));
    return GoalUiState(
      point: _pointRepository.currentStatus.point,
      steps: _walkRepository.currentTodaySteps,
    );
  }

  void _start() {
    if (!ref.mounted) return;
    // 구독하면 최신 값이 다시 전달된다. 전달 시점이 stream 구현에 따라 다르므로
    // build() 중에 state를 쓰지 않도록 build() 뒤에 구독한다.
    final pointStatus = _pointRepository.status.listen((status) {
      state = state.copyWith(point: status.point);
    });
    ref.onDispose(pointStatus.cancel);
    final todaySteps = _walkRepository.todaySteps.listen((steps) {
      state = state.copyWith(steps: steps);
    });
    ref.onDispose(todaySteps.cancel);
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
      _countdownTimer?.cancel();
      state = state.copyWith(
        cards: const GoalCardsState.loading(),
        isWeeklyLoading: true,
      );
    }

    final results = await Future.wait<Object>([
      _repository.fetchGoalHome(),
      _repository.fetchWeeklyStatus(),
    ]);
    if (!ref.mounted) return;
    unawaited(_pointRepository.refresh());
    final home = results[0] as ApiResult<GoalHomeResponse>;
    final weekly = results[1] as ApiResult<List<GoalRateStatus>>;

    switch (home) {
      case Success<GoalHomeResponse>():
        final medicine = home.data.medicine;
        final remaining =
            medicine?.verifyRemainingAt(DateTime.now()) ?? Duration.zero;

        final walk = home.data.walk;
        if (walk != null) {
          _walkRepository.applyServerSteps(
            walk.actual,
            date: requestedDay,
            goal: walk.goal,
          );
        }

        state = state.copyWith(
          cards: GoalCardsState.data(
            medicine: medicine,
            walk: home.data.walk,
            hospital: home.data.hospital,
            verifyRemaining: remaining,
            verifyStatus: medicine?.isDoneAt(DateTime.now()) == true
                ? MedicationVerifyStatus.verified
                : remaining > Duration.zero
                    ? MedicationVerifyStatus.pending
                    : MedicationVerifyStatus.expired,
          ),
        );
      case Failure<GoalHomeResponse>():
        if (showLoading || state.cards is GoalCardsLoading) {
          state = state.copyWith(cards: const GoalCardsState.error());
        }
    }

    switch (weekly) {
      case Success<List<GoalRateStatus>>():
        state = state.copyWith(
          isWeeklyLoading: false,
          weeklyStatuses: weekly.data,
        );
      case Failure<List<GoalRateStatus>>():
        state = state.copyWith(
          isWeeklyLoading: false,
          weeklyStatuses: showLoading ? const [] : state.weeklyStatuses,
        );
        if (showLoading && state.cards is! GoalCardsError) {
          _emit(const FetchWeeklyStatusFailure());
        }
    }

    _startCountdownIfNeeded();
  }

  GoalCardsData? get _cards {
    final cards = state.cards;
    return cards is GoalCardsData ? cards : null;
  }

  void _updateCards(GoalCardsData cards) {
    state = state.copyWith(cards: cards);
  }

  void _startCountdownIfNeeded() {
    _countdownTimer?.cancel();

    // 인증 완료 상태여도 마감 전이면 "인증 가능 시간 -> 만료"로 카드가 한 번 더 바뀐다.
    final medicine = _cards?.medicine;
    if (medicine == null || medicine.isVerifyExpiredAt(DateTime.now())) return;

    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      final cards = _cards;
      final medicine = cards?.medicine;
      if (cards == null || medicine == null) {
        _countdownTimer?.cancel();
        return;
      }

      // 인증 대기 -> 인증 가능으로 넘어가면 남은 시간의 기준이 바뀌므로 매초 다시 구한다.
      final now = DateTime.now();
      final remaining = medicine.verifyRemainingAt(now);

      if (medicine.isVerifyExpiredAt(now)) {
        _updateCards(
          cards.copyWith(
            verifyRemaining: Duration.zero,
            verifyStatus: cards.verifyStatus == MedicationVerifyStatus.verified
                ? MedicationVerifyStatus.verified
                : MedicationVerifyStatus.expired,
          ),
        );
        _countdownTimer?.cancel();
      } else {
        _updateCards(cards.copyWith(verifyRemaining: remaining));
      }
    });
  }

  void onMedicationVerified(MedicationPointResult result) {
    _emit(VerifyMedicationSuccess(result.earnedPoints, result.currentPoints));
  }

  Future<void> findRoute() async {
    final hospital = _cards?.hospital;
    if (hospital == null) return;

    final latitude = hospital.latitude;
    final longitude = hospital.longitude;
    final address = hospital.address;

    try {
      var isOpened = false;
      if (latitude != null && longitude != null) {
        final current = await _locationRepository.getCurrentLocation();
        isOpened = await KakaoMapLauncher.openRoute(
          destination: UserLocation(latitude: latitude, longitude: longitude),
          start: current,
          destinationName: address,
        );
      }
      if (!isOpened) {
        final uri = Uri.https('www.google.com', '/maps/search/', {
          'api': '1',
          'query': address,
        });
        final launched = await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
        if (!launched) {
          throw Exception('다른 지도 맵 열기 실패');
        }
      }
    } catch (e) {
      showToast('길을 안내할 수 없습니다.');
    }
  }
}
