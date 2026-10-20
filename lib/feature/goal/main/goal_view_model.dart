import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:widyu/core/data/provider/point_provider.dart';
import 'package:widyu/core/data/provider/walk_provider.dart';
import 'package:widyu/core/data/repository/goal/goal_repository.dart';
import 'package:widyu/core/data/repository/goal/medication_repository.dart';
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
  final WalkProvider _stepProvider;
  final LocationRepository _locationRepository;
  Timer? _countdownTimer;
  Timer? _dayTimer;
  String? _loadedDay;
  late final StreamSubscription<void> _medicationChanges;

  GoalUiState _uiState = const GoalUiState();
  GoalUiState get uiState => _uiState;

  final _uiEvent = StreamController<GoalUiEvent>.broadcast();
  Stream<GoalUiEvent> get uiEvent => _uiEvent.stream;

  GoalViewModel({
    required GoalRepository repository,
    required PointProvider pointProvider,
    required WalkProvider stepProvider,
    required LocationRepository locationRepository,
    required MedicationRepository medicationRepository,
  })  : _repository = repository,
        _pointProvider = pointProvider,
        _stepProvider = stepProvider,
        _locationRepository = locationRepository {
    unawaited(_stepProvider.start());
    unawaited(refresh());
    _medicationChanges = medicationRepository.medicationChanges
        .listen((_) => unawaited(refresh(showLoading: false)));
    _dayTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      if (_loadedDay != _stepProvider.today) {
        unawaited(refresh(showLoading: false));
      }
    });
  }

  @override
  void notifyListeners() {
    if (!_uiEvent.isClosed) super.notifyListeners();
  }

  void _emit(GoalUiEvent event) {
    if (!_uiEvent.isClosed) _uiEvent.add(event);
  }

  Future<void> refresh({bool showLoading = true}) async {
    final requestedDay = _stepProvider.today;
    _loadedDay = requestedDay;
    if (showLoading) {
      _countdownTimer?.cancel();
      _uiState = _uiState.copyWith(
        cards: const GoalCardsState.loading(),
        isWeeklyLoading: true,
      );
      notifyListeners();
    }

    final results = await Future.wait<Object>([
      _repository.fetchGoalHome(),
      _repository.fetchWeeklyStatus(),
    ]);
    if (_uiEvent.isClosed) return;
    unawaited(_pointProvider.refresh());
    final home = results[0] as ApiResult<GoalHomeResponse>;
    final weekly = results[1] as ApiResult<List<GoalRateStatus>>;

    switch (home) {
      case Success<GoalHomeResponse>():
        final medicine = home.data.medicine;
        final remaining =
            medicine?.verifyRemainingAt(DateTime.now()) ?? Duration.zero;

        final walk = home.data.walk;
        if (walk != null) {
          _stepProvider.applyServerSteps(walk.actual, date: requestedDay);
        }

        _uiState = _uiState.copyWith(
          cards: GoalCardsState.data(
            medicine: medicine,
            walk: home.data.walk,
            hospital: home.data.hospital,
            verifyRemaining: remaining,
            verifyStatus: medicine?.proofImage != null
                ? MedicationVerifyStatus.verified
                : remaining > Duration.zero
                    ? MedicationVerifyStatus.pending
                    : MedicationVerifyStatus.expired,
          ),
        );
      case Failure<GoalHomeResponse>():
        if (showLoading || _uiState.cards is GoalCardsLoading) {
          _uiState = _uiState.copyWith(cards: const GoalCardsState.error());
        }
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
          weeklyStatuses: showLoading ? const [] : _uiState.weeklyStatuses,
        );
        if (showLoading && _uiState.cards is! GoalCardsError) {
          _emit(const FetchWeeklyStatusFailure());
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
      notifyListeners();
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
          routeType: KakaoMapRouteType.publicTransit,
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
    _dayTimer?.cancel();
    _medicationChanges.cancel();
    _uiEvent.close();
    super.dispose();
  }
}
