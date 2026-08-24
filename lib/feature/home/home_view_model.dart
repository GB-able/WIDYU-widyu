import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:widyu/core/data/repository/heartRate/heart_rate_repository.dart';
import 'package:widyu/core/data/repository/home/home_repository.dart';
import 'package:widyu/core/data/repository/location/location_repository.dart';
import 'package:widyu/core/data/repository/myPage/my_page_repository.dart';
import 'package:widyu/core/data/repository/notification/notification_repository.dart';
import 'package:widyu/core/model/api/api_result.dart';
import 'package:widyu/core/model/camera/camera_capture_result.dart';
import 'package:widyu/core/model/heartRate/heart_rate_response.dart';
import 'package:widyu/core/model/heartRate/heart_rate_status.dart';
import 'package:widyu/core/model/home/medication_status.dart';
import 'package:widyu/core/model/home/senior_card.dart';
import 'package:widyu/core/model/location/user_location.dart';
import 'package:widyu/core/model/myPage/user/user.dart';
import 'package:widyu/core/utils/camera_manager.dart';
import 'package:widyu/core/utils/kakao_map_launcher.dart';
import 'package:widyu/feature/home/home_ui_event.dart';
import 'package:widyu/feature/home/home_ui_state.dart';

class HomeViewModel with ChangeNotifier {
  final HomeRepository _homeRepository;
  final MyPageRepository _myPageRepository;
  final NotificationRepository _notificationRepository;
  final HeartRateRepository _heartRateRepository;
  final LocationRepository _locationRepository;

  HomeUiState _uiState = HomeUiState.init();
  HomeUiState get uiState => _uiState;

  final _uiEvent = StreamController<HomeUiEvent>.broadcast();
  Stream<HomeUiEvent> get uiEvent => _uiEvent.stream;

  StreamSubscription? _watchConnection;

  // 갱신용 타이머
  Timer? _medicationTicker;
  MedicationSummary? _medicine;

  // 중복 탭으로 카카오맵이 두 번 열리는 것을 막는다
  bool _isOpeningRoute = false;

  HomeViewModel({
    required HomeRepository homeRepository,
    required MyPageRepository myPageRepository,
    required NotificationRepository notificationRepository,
    required HeartRateRepository heartRateRepository,
    required LocationRepository locationRepository,
    required Future<bool> isPaired,
  })  : _homeRepository = homeRepository,
        _heartRateRepository = heartRateRepository,
        _notificationRepository = notificationRepository,
        _myPageRepository = myPageRepository,
        _locationRepository = locationRepository {
    unawaited(_fetchUser());
    unawaited(_observeWatchConnection(isPaired));
    unawaited(fetchHeartRate());
    unawaited(_fetchSeniorCard());
    _medicationTicker = Timer.periodic(
      const Duration(seconds: 30),
      (_) => _applyMedicationStatus(),
    );
  }

  Future<void> refreshSeniorCard() => _fetchSeniorCard();

  /// 시스템 기본 카메라 앱으로 약 복용 인증 사진을 촬영한다.
  Future<void> takeMedicationPhoto() async {
    final result = await CameraManager.takePhoto();
    switch (result) {
      case CameraCaptureSuccess():
        _uiEvent.add(const TakeMedicationPhotoSuccess());
      case CameraCaptureCanceled():
        break;
      case CameraPermissionDenied():
        _uiEvent.add(const RequestCameraPermissionFailure());
      case CameraPermissionPermanentlyDenied():
        _uiEvent.add(const RequestCameraPermissionPermanentlyFailure());
      case CameraCaptureFailure():
        _uiEvent.add(const OpenCameraFailure());
    }
  }

  /// 건강 일정 장소로 향하는 카카오맵 길찾기를 연다.
  /// 현재 위치를 못 얻어도 목적지만으로 길찾기를 열 수 있으므로 위치 실패는 막지 않는다.
  Future<void> openHealthScheduleRoute() async {
    if (_isOpeningRoute) return;

    final latitude = _uiState.healthScheduleLatitude;
    final longitude = _uiState.healthScheduleLongitude;
    if (latitude == null || longitude == null) {
      _uiEvent.add(const HealthSchedulePlaceUnavailable());
      return;
    }

    _isOpeningRoute = true;
    try {
      final current = await _locationRepository.getCurrentLocation();
      final isOpened = await KakaoMapLauncher.openRoute(
        destination: UserLocation(latitude: latitude, longitude: longitude),
        start: current,
        destinationName: _uiState.healthSchedulePlace,
        routeType: KakaoMapRouteType.publicTransit,
      );
      if (!isOpened) {
        _uiEvent.add(const OpenKakaoMapFailure());
      }
    } finally {
      _isOpeningRoute = false;
    }
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
      final goal = data.walk?.goal ?? 0;
      final actual = data.walk?.actual ?? 0;
      final schedule = data.healthSchedule;
      _medicine = data.medicine;
      _uiState = _uiState.copyWith(
        thumbnails: albums
            .map((album) => album.thumbnailUrl)
            .whereType<String>()
            .where((url) => url.isNotEmpty)
            .toList(),
        stepProgress: goal == 0 ? 0.0 : (actual / goal) * 100,
        healthSchedulePlace: schedule?.placeAddress,
        healthScheduleLatitude: schedule?.latitude,
        healthScheduleLongitude: schedule?.longitude,
      );
      _applyMedicationStatus();
    } else {
      _uiEvent.add(const FetchSeniorCardFailure());
    }
    _uiState = _uiState.copyWith(isSeniorCardLoading: false);
    notifyListeners();
  }

  void _applyMedicationStatus() {
    final next =
        resolveMedicationStatus(medicine: _medicine, now: DateTime.now());
    if (next == _uiState.medicationStatus) return;
    _uiState = _uiState.copyWith(medicationStatus: next);
    notifyListeners();
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
      case 'EMERGENCY':
        return HeartRateStatus.emergency;
      default:
        return HeartRateStatus.unknown;
    }
  }

  @override
  void dispose() {
    _watchConnection?.cancel();
    _medicationTicker?.cancel();
    _uiEvent.close();
    super.dispose();
  }
}
