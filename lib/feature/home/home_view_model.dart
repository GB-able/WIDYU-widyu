import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:widyu/core/data/repository/heartRate/heart_rate_repository.dart';
import 'package:widyu/core/data/repository/home/home_repository.dart';
import 'package:widyu/core/data/repository/myPage/my_page_repository.dart';
import 'package:widyu/core/data/repository/notification/notification_repository.dart';
import 'package:widyu/core/model/api/api_result.dart';
import 'package:widyu/core/model/heartRate/heart_rate_response.dart';
import 'package:widyu/core/model/heartRate/heart_rate_status.dart';
import 'package:widyu/core/model/home/senior_card.dart';
import 'package:widyu/core/model/myPage/user/user.dart';
import 'package:widyu/feature/home/home_ui_event.dart';
import 'package:widyu/feature/home/home_ui_state.dart';

class HomeViewModel with ChangeNotifier {
  final HomeRepository _homeRepository;
  final MyPageRepository _myPageRepository;
  final NotificationRepository _notificationRepository;
  final HeartRateRepository _heartRateRepository;

  HomeUiState _uiState = HomeUiState.init();
  HomeUiState get uiState => _uiState;

  final _uiEvent = StreamController<HomeUiEvent>.broadcast();
  Stream<HomeUiEvent> get uiEvent => _uiEvent.stream;

  StreamSubscription? _watchConnection;

  HomeViewModel({
    required HomeRepository homeRepository,
    required MyPageRepository myPageRepository,
    required NotificationRepository notificationRepository,
    required HeartRateRepository heartRateRepository,
    required Future<bool> isPaired,
  })  : _homeRepository = homeRepository,
        _heartRateRepository = heartRateRepository,
        _notificationRepository = notificationRepository,
        _myPageRepository = myPageRepository {
    unawaited(_fetchUser());
    unawaited(_observeWatchConnection(isPaired));
    unawaited(fetchHeartRate());
    unawaited(_fetchSeniorCard());
  }

  Future<void> fetchHeartRate() async {
    _uiState = _uiState.copyWith(isHeartRateLoading: true);
    notifyListeners();

    final result = await _heartRateRepository.fetchHeartRate();
    if (result is Success) {
      final data = (result as Success<HeartRateResponse>).data;
      _uiState = _uiState.copyWith(
        heartRate: data.heartRate,
        heartRateStatus: _convertToHeartRateStatus(data.heartRateStatus),
        measuredAt: data.measuredAt,
      );
    } else {
      _uiEvent.add(const FetchHeartRateFailure());
    }
    _uiState = _uiState.copyWith(isHeartRateLoading: false);
    notifyListeners();
  }

  Future<void> _fetchUser() async {
    _uiState = _uiState.copyWith(isUserLoading: true);
    notifyListeners();

    final result = await _myPageRepository.fetchUser();
    if (result is Success) {
      final data = (result as Success<User>).data;
      _uiState = _uiState.copyWith(name: data.name);
    } else {
      _uiEvent.add(const FetchUserFailure());
    }
    _uiState = _uiState.copyWith(isUserLoading: false);
    notifyListeners();
  }

  Future<void> _fetchSeniorCard() async {
    _uiState = _uiState.copyWith(isSeniorCardLoading: true);
    notifyListeners();

    final result = await _homeRepository.fetchSeniorCard();
    if (result is Success) {
      final data = (result as Success<SeniorCard>).data;
      final albums = data.albums;
      final medicine = data.medicine;
      final goal = data.walk?.goal ?? 0;
      final actual = data.walk?.actual ?? 0;
      _uiState = _uiState.copyWith(
        thumbnails: albums
            .map((album) => album.thumbnailUrl)
            .whereType<String>()
            .where((url) => url.isNotEmpty)
            .toList(),
        todayTakenCount: medicine?.todayTakenCount ?? 0,
        todayTotalCount: medicine?.todayTotalCount ?? 0,
        nextDoseRemainingTime:
            _calcNextDoseRemainingTime(medicine?.nextAlarmTime),
        stepProgress: goal == 0 ? 0.0 : (actual / goal) * 100,
      );
    } else {
      _uiEvent.add(const FetchSeniorCardFailure());
    }
    _uiState = _uiState.copyWith(isSeniorCardLoading: false);
    notifyListeners();
  }

  Duration _calcNextDoseRemainingTime(String? nextAlarmTime) {
    if (nextAlarmTime == null || nextAlarmTime.isEmpty) return Duration.zero;

    final parts = nextAlarmTime.split(':');
    final hour = int.tryParse(parts[0]);
    final minute = parts.length > 1 ? int.tryParse(parts[1]) : null;
    if (hour == null || minute == null) return Duration.zero;

    final now = DateTime.now();
    var deadline = DateTime(now.year, now.month, now.day, hour, minute)
        .add(const Duration(minutes: 30));

    if (deadline.isBefore(now)) {
      deadline = deadline.add(const Duration(days: 1));
    }

    return deadline.difference(now);
  }

  Future<void> _observeWatchConnection(Future<bool> isPaired) async {
    final isWearing = await isPaired;
    _uiState = _uiState.copyWith(isWearing: isWearing);
    notifyListeners();

    _watchConnection =
        _heartRateRepository.observeConnection().listen((isWearing) {
      _uiState = _uiState.copyWith(isWearing: isWearing);
      notifyListeners();
    });
  }

  HeartRateStatus _convertToHeartRateStatus(String status) {
    switch (status) {
      case 'NORMAL':
        return HeartRateStatus.normal;
      case 'ANOMALY':
        return HeartRateStatus.anomaly;
      default:
        return HeartRateStatus.unknown;
    }
  }

  @override
  void dispose() {
    _watchConnection?.cancel();
    _uiEvent.close();
    super.dispose();
  }
}
