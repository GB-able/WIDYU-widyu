import 'dart:async';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:widyu/core/data/provider/point_provider.dart';
import 'package:widyu/core/data/provider/step_provider.dart';
import 'package:widyu/core/data/repository/goal/goal_repository.dart';
import 'package:widyu/core/data/repository/location/location_repository.dart';
import 'package:widyu/core/model/api/api_result.dart';
import 'package:widyu/core/model/goal/goal_home_response.dart';
import 'package:widyu/core/model/goal/medication/medication_point_result.dart';
import 'package:widyu/core/model/goal/weekly_goal_status_response.dart';
import 'package:widyu/core/model/location/user_location.dart';
import 'package:widyu/core/utils/kakao_map_launcher.dart';
import 'package:widyu/core/utils/show_toast.dart';
import 'package:widyu/feature/goal/main/goal_ui_event.dart';
import 'package:widyu/feature/goal/main/goal_ui_state.dart';

class GoalViewModel with ChangeNotifier {
  final GoalRepository _repository;
  final PointProvider _pointProvider;
  final StepProvider _stepProvider;
  final LocationRepository _locationRepository;
  Timer? _countdownTimer;

  GoalUiState _uiState = const GoalUiState();
  GoalUiState get uiState => _uiState;

  final _uiEvent = StreamController<GoalUiEvent>.broadcast();
  Stream<GoalUiEvent> get uiEvent => _uiEvent.stream;

  GoalViewModel(
      {required GoalRepository repository,
      required PointProvider pointProvider,
      required StepProvider stepProvider,
      required LocationRepository locationRepository})
      : _repository = repository,
        _pointProvider = pointProvider,
        _stepProvider = stepProvider,
        _locationRepository = locationRepository {
    unawaited(_stepProvider.start());
    refresh();
  }

  Future<void> refresh() async {
    _countdownTimer?.cancel();
    _uiState = _uiState.copyWith(
      cards: const GoalCardsState.loading(),
      isWeeklyLoading: true,
    );
    notifyListeners();

    final homeFuture = _repository.fetchGoalHome();
    final weeklyFuture = _repository.fetchWeeklyStatus();
    final home = await homeFuture;
    final weekly = await weeklyFuture;

    unawaited(_pointProvider.ensureLoaded());

    switch (home) {
      case Success<GoalHomeResponse>():
        final medicine = home.data.medicine;
        final remaining =
            medicine?.verifyRemainingAt(DateTime.now()) ?? Duration.zero;

        // 서버가 아는 오늘 걸음 수를 센서 카운터의 기준점으로 삼는다.
        _stepProvider.applyServerSteps(home.data.walk?.actual ?? 0);

        _uiState = _uiState.copyWith(
          cards: GoalCardsState.data(
            medicine: medicine,
            walk: home.data.walk,
            hospital: home.data.hospital,
            verifyRemaining: remaining,
            // 이미 인증한 회차면 남은 시간과 무관하게 완료로 본다.
            verifyStatus: medicine?.proofImage != null
                ? MedicationVerifyStatus.verified
                : remaining > Duration.zero
                    ? MedicationVerifyStatus.pending
                    : MedicationVerifyStatus.expired,
          ),
        );
      case Failure<GoalHomeResponse>():
        _uiState = _uiState.copyWith(
          cards: const GoalCardsState.error(),
        );
    }

    switch (weekly) {
      case Success<List<GoalRateStatus>>():
        _uiState = _uiState.copyWith(
          isWeeklyLoading: false,
          weeklyStatuses: weekly.data,
        );
      case Failure<List<GoalRateStatus>>():
        _uiState = _uiState.copyWith(
          isWeeklyLoading: false,
          weeklyStatuses: const [],
        );
        // 카드 에러뷰가 이미 실패를 말하고 있으면 토스트를 겹치지 않는다.
        if (_uiState.cards is! GoalCardsError) {
          _uiEvent.add(const FetchWeeklyStatusFailure());
        }
    }

    _startCountdownIfNeeded();
    notifyListeners();
  }

  GoalCardsData? get _cards {
    final cards = _uiState.cards;
    return cards is GoalCardsData ? cards : null;
  }

  void _updateCards(GoalCardsData cards) {
    _uiState = _uiState.copyWith(cards: cards);
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
        _updateCards(cards.copyWith(
          verifyRemaining: Duration.zero,
          verifyStatus: cards.verifyStatus == MedicationVerifyStatus.verified
              ? MedicationVerifyStatus.verified
              : MedicationVerifyStatus.expired,
        ));
        _countdownTimer?.cancel();
      } else {
        _updateCards(cards.copyWith(verifyRemaining: remaining));
      }
      notifyListeners();
    });
  }

  Future<void> verifyMedication(File photo) async {
    final cards = _cards;
    final medicine = cards?.medicine;
    if (cards == null || medicine == null) return;

    final scheduleId = medicine.medicineScheduleId;

    _updateCards(cards.copyWith(
      medicine: medicine.copyWith(takenCount: medicine.takenCount + 1),
      verifyStatus: MedicationVerifyStatus.verified,
      proofPhoto: photo,
    ));
    // 인증 완료여도 마감 시각에 카드가 한 번 더 바뀌므로 타이머는 계속 돌린다.
    _startCountdownIfNeeded();
    notifyListeners();

    final result = await _repository.verifyMedication(
      scheduleId: scheduleId,
      proofImage: photo,
    );

    switch (result) {
      case Success<MedicationPointResult>():
        _pointProvider
            .sync(result.data.currentPoints + result.data.earnedPoints);
        _uiEvent.add(VerifyMeidcineSuccess(
          result.data.earnedPoints,
          result.data.currentPoints,
        ));
        return;
      case Failure<MedicationPointResult>():
        // 실패하면 인증 전 상태로 되돌리고 카운트다운을 다시 돌린다.
        _updateCards(cards);
        _startCountdownIfNeeded();
        _uiEvent.add(VerifyMedicationFailure(result.message));
        notifyListeners();
    }
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
          routeType: KakaoMapRouteType.publicTransit,
        );
      }
      if (!isOpened) {
        final uri = Uri.https('www.google.com', '/maps/search/', {
          'api': '1',
          'query': address,
        });
        final launched =
            await launchUrl(uri, mode: LaunchMode.externalApplication);
        if (!launched) {
          throw Exception("다른 지도 맵 열기 실패");
        }
      }
    } catch (e) {
      showToast("길을 안내할 수 없습니다.");
    }
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _uiEvent.close();
    super.dispose();
  }
}
