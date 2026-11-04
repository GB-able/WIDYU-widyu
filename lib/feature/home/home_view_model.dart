import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:widyu/core/data/repository/goal/walk_repository.dart';
import 'package:widyu/core/data/repository/heartRate/heart_rate_repository.dart';
import 'package:widyu/core/data/repository/home/home_repository.dart';
import 'package:widyu/core/data/repository/location/location_repository.dart';
import 'package:widyu/core/data/repository/notification/notification_repository.dart';
import 'package:widyu/core/data/repository/user/user_repository.dart';
import 'package:widyu/core/di/providers.dart';
import 'package:widyu/core/log/log.dart';
import 'package:widyu/core/model/api/api_result.dart';
import 'package:widyu/core/model/goal/medication/medication_point_result.dart';
import 'package:widyu/core/model/heartRate/heart_rate_response.dart';
import 'package:widyu/core/model/heartRate/heart_rate_status.dart';
import 'package:widyu/core/model/home/medication_status.dart';
import 'package:widyu/core/model/home/senior_card.dart';
import 'package:widyu/core/model/location/user_location.dart';
import 'package:widyu/core/model/notification/notification_page.dart';
import 'package:widyu/core/model/permission/permission_recovery_prompt.dart';
import 'package:widyu/core/model/permission/permission_type.dart';
import 'package:widyu/core/utils/background_location_notice_controller.dart';
import 'package:widyu/core/utils/extensions/walk_extension.dart';
import 'package:widyu/core/utils/kakao_map_launcher.dart';
import 'package:widyu/core/utils/permission_manager.dart';
import 'package:widyu/core/utils/permission_recovery_controller.dart';
import 'package:widyu/feature/home/home_ui_event.dart';
import 'package:widyu/feature/home/home_ui_state.dart';
import 'package:widyu/feature/home/notification_ui_model.dart';

part 'home_view_model.g.dart';

enum _CameraPermissionOutcome {
  ready,
  settingsGranted,
  denied,
  settingsDenied,
  canceled,
  settingsLaunchFailed,
}

@riverpod
class HomeViewModel extends _$HomeViewModel {
  late PermissionRecoveryController _permissionRecoveryController;

  final _uiEvent = StreamController<HomeUiEvent>.broadcast();

  // 일회성 이벤트는 state가 아니라 stream으로 내보낸다.
  // ignore: riverpod_lint/avoid_public_notifier_properties
  Stream<HomeUiEvent> get uiEvent => _uiEvent.stream;

  MedicationSummary? _medicine;
  String? _seniorCardDay;

  // 중복 탭으로 카카오맵이 두 번 열리는 것을 막는다
  bool _isOpeningRoute = false;
  bool _isTakingMedicationPhoto = false;

  HomeRepository get _homeRepository => ref.read(homeRepositoryProvider);
  UserRepository get _userRepository => ref.read(userRepositoryProvider);
  NotificationRepository get _notificationRepository =>
      ref.read(notificationRepositoryProvider);
  HeartRateRepository get _heartRateRepository =>
      ref.read(heartRateRepositoryProvider);
  LocationRepository get _locationRepository =>
      ref.read(locationRepositoryProvider);
  WalkRepository get _walkRepository => ref.read(walkRepositoryProvider);
  BackgroundLocationNoticeController get _noticeController =>
      ref.read(backgroundLocationNoticeControllerProvider);
  KakaoMapRouteOpener get _openRoute => ref.read(kakaoMapRouteOpenerProvider);

  @override
  HomeUiState build() {
    // onDispose는 다시 빌드될 때도 불리므로, 실제로 폐기될 때만 닫는다.
    ref.onDispose(() {
      if (!ref.mounted) _uiEvent.close();
    });
    // 화면과 함께 폐기되어 대기 중인 권한 요청을 취소하도록 watch로 붙잡는다.
    _permissionRecoveryController =
        ref.watch(homePermissionRecoveryControllerProvider);
    _medicine = null;
    unawaited(Future.microtask(_start));
    return HomeUiState.init().copyWith(
      isUserLoading: true,
      isHeartRateLoading: true,
      isNotificationLoading: true,
      isSeniorCardLoading: true,
      steps: _walkRepository.currentTodaySteps,
    );
  }

  void _start() {
    if (!ref.mounted) return;
    // 구독하면 최신 값이 다시 전달된다. 전달 시점이 stream 구현에 따라 다르므로
    // build() 중에 state를 쓰지 않도록 build() 뒤에 구독한다.
    final todaySteps = _walkRepository.todaySteps.listen((steps) {
      state = state.copyWith(steps: steps);
    });
    ref.onDispose(todaySteps.cancel);
    unawaited(_fetchNotification());
    _observeUser();
    _observeWatchConnection();
    unawaited(fetchHeartRate());
    unawaited(_fetchSeniorCard());
    unawaited(_evaluateBackgroundLocationNotice());
    final medicationChanges = ref
        .read(medicationRepositoryProvider)
        .medicationChanges
        .listen((_) => unawaited(_fetchSeniorCard()));
    ref.onDispose(medicationChanges.cancel);
    // 갱신용 타이머
    final medicationTicker = Timer.periodic(
      const Duration(seconds: 30),
      (_) {
        if (_seniorCardDay != DateTime.now().walkDate) {
          unawaited(_fetchSeniorCard());
        } else {
          _applyMedicationStatus();
        }
      },
    );
    ref.onDispose(medicationTicker.cancel);
  }

  Future<void> takeMedicationPhoto(
      {PermissionRecoveryPrompt? showPrompt}) async {
    if (!ref.mounted || _isTakingMedicationPhoto) return;
    _isTakingMedicationPhoto = true;
    try {
      final outcome = await _resolveCameraPermission(
        showPrompt ?? _cancelPermissionPrompt,
      );
      if (!ref.mounted) return;
      switch (outcome) {
        case _CameraPermissionOutcome.ready:
          final status = state.medicationStatus;
          final available = status is MedicationAvailable ? status : null;
          final scheduleId =
              available?.scheduleId ?? _medicine?.medicineScheduleId;
          _emit(scheduleId == null
              ? const MedicationScheduleUnavailable()
              : NavigateToMedicationCamera(
                  scheduleId,
                  doseCount: available?.doseCount ?? _medicine?.nextDoseCount,
                ));
        case _CameraPermissionOutcome.settingsGranted:
          _emit(const CameraPermissionSettingsGranted());
        case _CameraPermissionOutcome.denied:
          _emit(const RequestCameraPermissionFailure());
        case _CameraPermissionOutcome.settingsDenied:
          _emit(const CameraPermissionSettingsDenied());
        case _CameraPermissionOutcome.settingsLaunchFailed:
          _emit(const CameraPermissionSettingsLaunchFailure());
        case _CameraPermissionOutcome.canceled:
          break;
      }
    } finally {
      _isTakingMedicationPhoto = false;
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

  void onMedicationVerified(MedicationPointResult result) {
    _emit(ShowMedicationReward(result));
  }

  void _emit(HomeUiEvent event) {
    if (ref.mounted) _uiEvent.add(event);
  }

  Future<void> _evaluateBackgroundLocationNotice() async {
    final shouldShow = await _noticeController.claimNoticeIfNeeded();
    if (shouldShow) _emit(const ShowBackgroundLocationNotice());
  }

  Future<void> openBackgroundLocationSettings() async {
    if (!ref.mounted) return;
    final result = await _noticeController.openSettingsAndRecheck();
    if (result == PermissionSettingsResult.launchFailed) {
      _emit(const BackgroundLocationSettingsLaunchFailure());
    }
  }

  Future<void> markNotificationAsRead(int notificationId) async {
    final previous = state.notifications;
    final index = previous.indexWhere(
      (it) => it.notificationId == notificationId,
    );
    if (index == -1) return;

    final removed = previous[index];
    state = state.copyWith(notifications: [...previous]..removeAt(index));

    final result =
        await _notificationRepository.readNotification(notificationId);
    if (result is Success) {
      WiduLog.ui.i('알림 읽음 처리 성공 notificationId=$notificationId');
      return;
    }
    if (!ref.mounted) return;

    final current = [...state.notifications];
    current.insert(index.clamp(0, current.length), removed);
    _emit(const MarkNotificationAsReadFailure());
    state = state.copyWith(notifications: current);
  }

  /// 건강 일정 장소로 향하는 카카오맵 길찾기를 연다.
  /// 현재 위치를 못 얻어도 목적지만으로 길찾기를 열 수 있으므로 위치 실패는 막지 않는다.
  Future<void> openHealthScheduleRoute(
      {PermissionRecoveryPrompt? showPrompt}) async {
    if (_isOpeningRoute || !ref.mounted) return;

    final latitude = state.healthScheduleLatitude;
    final longitude = state.healthScheduleLongitude;
    if (latitude == null || longitude == null) {
      _emit(const HealthSchedulePlaceUnavailable());
      return;
    }

    _isOpeningRoute = true;
    try {
      final current = await _resolveRouteStart(
        showPrompt ?? _cancelPermissionPrompt,
      );
      if (!ref.mounted) return;
      final isOpened = await _openRoute(
        destination: UserLocation(latitude: latitude, longitude: longitude),
        start: current,
        destinationName: state.healthSchedulePlace,
        routeType: KakaoMapRouteType.publicTransit,
      );
      if (!isOpened) _emit(const OpenKakaoMapFailure());
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
    if (!ref.mounted) return null;

    switch (permission) {
      case PermissionRequestResult.granted:
        return _locationRepository.getCurrentLocation();
      case PermissionRequestResult.settingsLaunchFailed:
        _emit(const LocationPermissionSettingsLaunchFailure());
      case PermissionRequestResult.denied:
      case PermissionRequestResult.permanentlyDenied:
      case PermissionRequestResult.restricted:
      case PermissionRequestResult.unsupported:
        _emit(const LocationPermissionUnavailable());
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
    state = state.copyWith(isHeartRateLoading: true);

    final result = await _heartRateRepository.fetchHeartRate();
    if (!ref.mounted) return;
    if (result is Success) {
      final data = (result as Success<HeartRateResponse>).data;
      state = state.copyWith(
        heartRate: data.heartRate,
        heartRateStatus: _convertToHeartRateStatus(data.heartRateStatus),
        measuredAt: data.measuredAt,
      );
    } else {
      _emit(const FetchHeartRateFailure());
    }
    state = state.copyWith(isHeartRateLoading: false);
  }

  /// 세션에 캐시된 사용자 정보를 구독한다. 프로필에서 이름을 바꾸면 바로 반영된다.
  void _observeUser() {
    final userRepository = _userRepository;
    // 조회를 먼저 시작해 구독 시 '조회 중'을 받도록 한다.
    final loading = userRepository.ensureLoaded();
    final user = userRepository.status.listen((status) {
      state = state.copyWith(
        name: status.user?.name ?? state.name,
        isUserLoading: status.user == null && status.isLoading,
      );
    });
    ref.onDispose(user.cancel);
    unawaited(loading.then((isLoaded) {
      if (!isLoaded) _emit(const FetchUserFailure());
    }));
  }

  Future<void> _fetchNotification() async {
    state = state.copyWith(isNotificationLoading: true);

    final result = await _notificationRepository.fetchNotificationPage(null);
    if (!ref.mounted) return;
    if (result is Success) {
      final data = (result as Success<NotificationPage>).data;
      final notifications = data.notifications;
      state = state.copyWith(notifications: notifications.toUiModel());
    } else {
      _emit(const FetchNotificationFailure());
    }
    state = state.copyWith(isNotificationLoading: false);
  }

  Future<void> _fetchSeniorCard() async {
    final requestedDay = DateTime.now().walkDate;
    _seniorCardDay = requestedDay;
    final walkRepository = _walkRepository;
    state = state.copyWith(isSeniorCardLoading: true);

    final result = await _homeRepository.fetchSeniorCard();
    final data = result is Success<SeniorCard> ? result.data : null;
    // 화면이 먼저 닫혀도 서버 걸음 수는 반영한다(기존 동작).
    final walk = data?.walk;
    if (walk?.actual case final actual?) {
      walkRepository.applyServerSteps(
        actual,
        date: requestedDay,
        goal: walk?.goal,
      );
    }
    if (!ref.mounted) return;
    if (data != null) {
      final albums = data.albums;
      final schedule = data.healthSchedule;
      _medicine = data.medicine;
      state = state.copyWith(
        thumbnails: albums
            .map((album) => album.thumbnailUrl)
            .whereType<String>()
            .where((url) => url.isNotEmpty)
            .toList(),
        stepGoal: walk?.goal ?? 0,
        healthSchedulePlace: schedule?.placeAddress,
        healthScheduleLatitude: schedule?.latitude,
        healthScheduleLongitude: schedule?.longitude,
      );
      _applyMedicationStatus();
    } else {
      _emit(const FetchSeniorCardFailure());
    }
    state = state.copyWith(isSeniorCardLoading: false);
  }

  void _applyMedicationStatus() {
    final next = resolveMedicationStatus(
      medicine: _medicine,
      now: DateTime.now(),
    );
    if (next == state.medicationStatus) return;
    state = state.copyWith(medicationStatus: next);
  }

  void _observeWatchConnection() {
    final watchConnection =
        _heartRateRepository.observeConnection().listen((isWearing) {
      state = state.copyWith(isWearing: isWearing);
    });
    ref.onDispose(watchConnection.cancel);
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
}
