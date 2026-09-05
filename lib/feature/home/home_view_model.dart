import 'dart:async';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:widyu/core/data/provider/point_provider.dart';
import 'package:widyu/core/data/repository/goal/goal_repository.dart';
import 'package:widyu/core/data/repository/heartRate/heart_rate_repository.dart';
import 'package:widyu/core/data/repository/home/home_repository.dart';
import 'package:widyu/core/data/repository/location/location_repository.dart';
import 'package:widyu/core/data/repository/myPage/my_page_repository.dart';
import 'package:widyu/core/data/repository/notification/notification_repository.dart';
import 'package:widyu/core/model/api/api_result.dart';
import 'package:widyu/core/model/camera/camera_capture_result.dart';
import 'package:widyu/core/model/goal/medicine/medicine_point_result.dart';
import 'package:widyu/core/model/heartRate/heart_rate_response.dart';
import 'package:widyu/core/model/heartRate/heart_rate_status.dart';
import 'package:widyu/core/model/home/medication_status.dart';
import 'package:widyu/core/model/home/senior_card.dart';
import 'package:widyu/core/model/location/user_location.dart';
import 'package:widyu/core/model/myPage/user/user.dart';
import 'package:widyu/core/model/notification/notification_page.dart';
import 'package:widyu/core/utils/camera_manager.dart';
import 'package:widyu/core/utils/kakao_map_launcher.dart';
import 'package:widyu/feature/home/home_ui_event.dart';
import 'package:widyu/feature/home/home_ui_state.dart';
import 'package:widyu/feature/home/notification_ui_model.dart';

class HomeViewModel with ChangeNotifier {
  final HomeRepository _homeRepository;
  final MyPageRepository _myPageRepository;
  final NotificationRepository _notificationRepository;
  final HeartRateRepository _heartRateRepository;
  final LocationRepository _locationRepository;
  final GoalRepository _goalRepository;
  final PointProvider _pointProvider;

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

  // 인증 요청이 끝나기 전에 카메라가 다시 열리는 것을 막는다
  bool _isVerifyingMedication = false;

  HomeViewModel({
    required HomeRepository homeRepository,
    required MyPageRepository myPageRepository,
    required NotificationRepository notificationRepository,
    required HeartRateRepository heartRateRepository,
    required LocationRepository locationRepository,
    required GoalRepository goalRepository,
    required PointProvider pointProvider,
  })  : _homeRepository = homeRepository,
        _heartRateRepository = heartRateRepository,
        _notificationRepository = notificationRepository,
        _myPageRepository = myPageRepository,
        _locationRepository = locationRepository,
        _goalRepository = goalRepository,
        _pointProvider = pointProvider {
    unawaited(_fetchNotification());
    unawaited(_fetchUser());
    unawaited(_observeWatchConnection());
    unawaited(fetchHeartRate());
    unawaited(_fetchSeniorCard());
    _medicationTicker = Timer.periodic(
      const Duration(seconds: 30),
      (_) => _applyMedicationStatus(),
    );
  }

  Future<void> refreshSeniorCard() => _fetchSeniorCard();

  Future<void> markNotificationAsRead(int notificationId) async {
    final previous = _uiState.notifications;
    final index =
        previous.indexWhere((it) => it.notificationId == notificationId);
    if (index == -1) return;

    final removed = previous[index];
    _uiState = _uiState.copyWith(
      notifications: [...previous]..removeAt(index),
    );
    notifyListeners();

    final result = await _notificationRepository.markAsRead(notificationId);
    if (result is Success) return;

    final current = [..._uiState.notifications];
    current.insert(index.clamp(0, current.length), removed);
    _uiEvent.add(const MarkNotificationAsReadFailure());
    _uiState = _uiState.copyWith(notifications: current);
    notifyListeners();
  }

  Future<void> takeMedicationPhoto() async {
    if (_isVerifyingMedication) return;

    final result = await CameraManager.takePhoto();
    switch (result) {
      case CameraCaptureSuccess(:final filePath):
        await _verifyMedication(File(filePath));
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

  /// 촬영한 사진으로 복용을 인증하고 카드와 포인트를 갱신한다.
  Future<void> _verifyMedication(File proofImage) async {
    final scheduleId = _medicine?.medicineScheduleId;
    if (scheduleId == null) {
      _uiEvent.add(const VerifyMedicationFailure('복용 일정 정보가 없어요.'));
      return;
    }

    _isVerifyingMedication = true;
    try {
      final result = await _goalRepository.verifyMedication(
        scheduleId: scheduleId,
        proofImage: proofImage,
      );

      switch (result) {
        case Success<MedicinePointResult>():
          final earned = result.data.earnedPoints;
          final total = result.data.currentPoints + earned;
          _pointProvider.sync(total);
          _uiEvent.add(
            VerifyMedicationSuccess(earnedPoint: earned, totalPoint: total),
          );
          // 복용 횟수와 다음 회차가 바뀌므로 카드를 다시 읽는다.
          // 리워드 다이얼로그 뒤에서 캐러셀이 로딩으로 깜빡이지 않게 한다.
          await _fetchSeniorCard(showLoading: false);
        case Failure<MedicinePointResult>():
          _uiEvent.add(VerifyMedicationFailure(result.message));
      }
    } finally {
      _isVerifyingMedication = false;
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

  Future<void> _fetchNotification() async {
    _uiState = _uiState.copyWith(isNotificationLoading: true);
    notifyListeners();

    final result = await _notificationRepository.fetchNotificationPage(null);
    if (result is Success) {
      final data = (result as Success<NotificationPage>).data;
      final notifications = data.notifications;
      _uiState = _uiState.copyWith(notifications: notifications.toUiModel());
    } else {
      _uiEvent.add(const FetchNotificationFailure());
    }
    _uiState = _uiState.copyWith(isNotificationLoading: false);
    notifyListeners();
  }

  Future<void> _fetchSeniorCard({bool showLoading = true}) async {
    if (showLoading) {
      _uiState = _uiState.copyWith(isSeniorCardLoading: true);
      notifyListeners();
    }

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
        stepCount: actual,
        stepGoal: goal,
        healthSchedulePlace: schedule?.placeAddress,
        healthScheduleLatitude: schedule?.latitude,
        healthScheduleLongitude: schedule?.longitude,
      );
      _applyMedicationStatus();
    } else {
      _uiEvent.add(const FetchSeniorCardFailure());
    }
    if (showLoading) {
      _uiState = _uiState.copyWith(isSeniorCardLoading: false);
    }
    notifyListeners();
  }

  void _applyMedicationStatus() {
    final next =
        resolveMedicationStatus(medicine: _medicine, now: DateTime.now());
    if (next == _uiState.medicationStatus) return;
    _uiState = _uiState.copyWith(medicationStatus: next);
    notifyListeners();
  }

  Future<void> _observeWatchConnection() async {
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
