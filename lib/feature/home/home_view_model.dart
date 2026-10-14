import 'dart:async';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:widyu/core/data/repository/heartRate/heart_rate_repository.dart';
import 'package:widyu/core/data/repository/home/home_repository.dart';
import 'package:widyu/core/data/repository/location/location_repository.dart';
import 'package:widyu/core/data/repository/myPage/my_page_repository.dart';
import 'package:widyu/core/data/repository/notification/notification_repository.dart';
import 'package:widyu/core/model/api/api_result.dart';
import 'package:widyu/core/model/heartRate/heart_rate_response.dart';
import 'package:widyu/core/model/heartRate/heart_rate_status.dart';
import 'package:widyu/core/model/home/medication_status.dart';
import 'package:widyu/core/model/home/senior_card.dart';
import 'package:widyu/core/model/location/user_location.dart';
import 'package:widyu/core/model/myPage/user/user.dart';
import 'package:widyu/core/model/notification/notification_page.dart';
import 'package:widyu/core/model/permission/permission_type.dart';
import 'package:widyu/core/model/permission/permission_recovery_prompt.dart';
import 'package:widyu/core/utils/background_location_notice_controller.dart';
import 'package:widyu/core/utils/kakao_map_launcher.dart';
import 'package:widyu/core/utils/permission_manager.dart';
import 'package:widyu/core/utils/permission_recovery_controller.dart';
import 'package:widyu/feature/home/home_ui_event.dart';
import 'package:widyu/feature/home/home_ui_state.dart';
import 'package:widyu/feature/home/notification_ui_model.dart';

enum _CameraPermissionOutcome {
  ready,
  settingsGranted,
  denied,
  settingsDenied,
  canceled,
  settingsLaunchFailed,
}

class HomeViewModel with ChangeNotifier {
  final HomeRepository _homeRepository;
  final MyPageRepository _myPageRepository;
  final NotificationRepository _notificationRepository;
  final HeartRateRepository _heartRateRepository;
  final LocationRepository _locationRepository;
  final PermissionRecoveryController _permissionRecoveryController;

  /// 소유권은 main.dart 의 Provider 에 있으므로 여기서 dispose 하지 않는다.
  final BackgroundLocationNoticeController _noticeController;
  final Future<bool> Function({
    required UserLocation destination,
    UserLocation? start,
    String? destinationName,
    required KakaoMapRouteType routeType,
  }) _openRoute;

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
  bool _isTakingMedicationPhoto = false;
  bool _isDisposed = false;

  HomeViewModel({
    required HomeRepository homeRepository,
    required MyPageRepository myPageRepository,
    required NotificationRepository notificationRepository,
    required HeartRateRepository heartRateRepository,
    required LocationRepository locationRepository,
    PermissionRecoveryController? permissionRecoveryController,
    BackgroundLocationNoticeController? noticeController,
    Future<bool> Function({
      required UserLocation destination,
      UserLocation? start,
      String? destinationName,
      required KakaoMapRouteType routeType,
    })? openRoute,
  })  : _homeRepository = homeRepository,
        _heartRateRepository = heartRateRepository,
        _notificationRepository = notificationRepository,
        _myPageRepository = myPageRepository,
        _locationRepository = locationRepository,
        _permissionRecoveryController =
            permissionRecoveryController ?? PermissionRecoveryController(),
        _noticeController =
            noticeController ?? BackgroundLocationNoticeController(),
        _openRoute = openRoute ?? KakaoMapLauncher.openRoute {
    unawaited(_fetchNotification());
    unawaited(_fetchUser());
    _observeWatchConnection();
    unawaited(fetchHeartRate());
    unawaited(_fetchSeniorCard());
    unawaited(_evaluateBackgroundLocationNotice());
    _medicationTicker = Timer.periodic(
      const Duration(seconds: 30),
      (_) => _applyMedicationStatus(),
    );
  }

  Future<void> refreshSeniorCard() => _fetchSeniorCard();

  Future<void> _evaluateBackgroundLocationNotice() async {
    final shouldShow = await _noticeController.claimNoticeIfNeeded();
    if (_isDisposed || !shouldShow) return;
    _uiEvent.add(const ShowBackgroundLocationNotice());
  }

  Future<void> openBackgroundLocationSettings() async {
    final result = await _noticeController.openSettingsAndRecheck();
    if (_isDisposed) return;
    if (result == PermissionSettingsResult.launchFailed) {
      _uiEvent.add(const BackgroundLocationSettingsLaunchFailure());
    }
  }

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

  Future<void> takeMedicationPhoto(
      {PermissionRecoveryPrompt? showPrompt}) async {
    // 업로드 중에 다시 촬영해 같은 회차를 두 번 인증하는 것을 막는다
    if (_isDisposed ||
        _isTakingMedicationPhoto ||
        _uiState.isVerifyingMedication) {
      return;
    }
    _isTakingMedicationPhoto = true;
    try {
      final outcome = await _resolveCameraPermission(
        showPrompt ?? _cancelPermissionPrompt,
      );
      if (_isDisposed) return;
      switch (outcome) {
        case _CameraPermissionOutcome.ready:
          final scheduleId = _medicine?.medicineScheduleId;
          _uiEvent.add(scheduleId == null
              ? const MedicationScheduleUnavailable()
              : NavigateToMedicationCamera(
                  scheduleId,
                  doseCount: _medicine?.nextDoseCount,
                ));
        case _CameraPermissionOutcome.settingsGranted:
          _uiEvent.add(const CameraPermissionSettingsGranted());
        case _CameraPermissionOutcome.denied:
          _uiEvent.add(const RequestCameraPermissionFailure());
        case _CameraPermissionOutcome.settingsDenied:
          _uiEvent.add(const CameraPermissionSettingsDenied());
        case _CameraPermissionOutcome.settingsLaunchFailed:
          _uiEvent.add(const CameraPermissionSettingsLaunchFailure());
        case _CameraPermissionOutcome.canceled:
          break;
      }
    } finally {
      _isTakingMedicationPhoto = false;
    }
  }

  /// 촬영 화면에서 돌아온 사진으로 복용을 인증한다.
  Future<void> verifyMedication(int scheduleId, String imagePath) async {
    if (_isDisposed || _uiState.isVerifyingMedication) return;
    _uiState = _uiState.copyWith(isVerifyingMedication: true);
    notifyListeners();

    final result =
        await _homeRepository.verifyMedication(scheduleId, File(imagePath));
    if (_isDisposed) return;

    // 로딩을 먼저 걷어낸 뒤 결과를 알려 다이얼로그와 겹치지 않게 한다.
    _uiState = _uiState.copyWith(isVerifyingMedication: false);
    notifyListeners();
    switch (result) {
      case Success(:final data):
        _uiEvent.add(ShowMedicationReward(
          earnedPoints: data.earnedPoints,
          currentPoints: data.currentPoints,
        ));
        unawaited(_fetchSeniorCard());
      case Failure():
        _uiEvent.add(const VerifyMedicationFailure());
    }
  }

  Future<_CameraPermissionOutcome> _resolveCameraPermission(
    PermissionRecoveryPrompt showPrompt,
  ) async {
    var openedSettings = false;
    final permission = await _permissionRecoveryController.ensurePermission(
      PermissionType.camera,
      showPrompt: (type, mode) async {
        final action = await showPrompt(type, mode);
        if (mode == PermissionRecoveryMode.settings &&
            action == PermissionRecoveryAction.openSettings) {
          openedSettings = true;
        }
        return action;
      },
    );

    return switch (permission) {
      PermissionRequestResult.granted => openedSettings
          ? _CameraPermissionOutcome.settingsGranted
          : _CameraPermissionOutcome.ready,
      PermissionRequestResult.denied ||
      PermissionRequestResult.permanentlyDenied ||
      PermissionRequestResult.restricted ||
      PermissionRequestResult.unsupported =>
        openedSettings
            ? _CameraPermissionOutcome.settingsDenied
            : _CameraPermissionOutcome.denied,
      PermissionRequestResult.settingsLaunchFailed =>
        _CameraPermissionOutcome.settingsLaunchFailed,
      PermissionRequestResult.canceled => _CameraPermissionOutcome.canceled,
    };
  }

  /// 건강 일정 장소로 향하는 카카오맵 길찾기를 연다.
  /// 현재 위치를 못 얻어도 목적지만으로 길찾기를 열 수 있으므로 위치 실패는 막지 않는다.
  Future<void> openHealthScheduleRoute(
      {PermissionRecoveryPrompt? showPrompt}) async {
    if (_isOpeningRoute || _isDisposed) return;

    final latitude = _uiState.healthScheduleLatitude;
    final longitude = _uiState.healthScheduleLongitude;
    if (latitude == null || longitude == null) {
      _uiEvent.add(const HealthSchedulePlaceUnavailable());
      return;
    }

    _isOpeningRoute = true;
    try {
      final current = await _resolveRouteStart(
        showPrompt ?? _cancelPermissionPrompt,
      );
      if (_isDisposed) return;
      final isOpened = await _openRoute(
        destination: UserLocation(latitude: latitude, longitude: longitude),
        start: current,
        destinationName: _uiState.healthSchedulePlace,
        routeType: KakaoMapRouteType.publicTransit,
      );
      if (_isDisposed) return;
      if (!isOpened) {
        _uiEvent.add(const OpenKakaoMapFailure());
      }
    } finally {
      _isOpeningRoute = false;
    }
  }

  Future<UserLocation?> _resolveRouteStart(
    PermissionRecoveryPrompt showPrompt,
  ) async {
    final permission = await _permissionRecoveryController.ensurePermission(
      PermissionType.location,
      showPrompt: showPrompt,
    );
    if (_isDisposed) return null;

    switch (permission) {
      case PermissionRequestResult.granted:
        return _locationRepository.getCurrentLocation();
      case PermissionRequestResult.settingsLaunchFailed:
        _uiEvent.add(const LocationPermissionSettingsLaunchFailure());
      case PermissionRequestResult.denied:
      case PermissionRequestResult.permanentlyDenied:
      case PermissionRequestResult.restricted:
      case PermissionRequestResult.unsupported:
        _uiEvent.add(const LocationPermissionUnavailable());
      case PermissionRequestResult.canceled:
        break;
    }
    return null;
  }

  static Future<PermissionRecoveryAction> _cancelPermissionPrompt(
    PermissionType _,
    PermissionRecoveryMode __,
  ) async =>
      PermissionRecoveryAction.cancel;

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

  void _observeWatchConnection() {
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
    _isDisposed = true;
    _permissionRecoveryController.dispose();
    _watchConnection?.cancel();
    _medicationTicker?.cancel();
    _uiEvent.close();
    super.dispose();
  }
}
