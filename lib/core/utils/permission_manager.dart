import 'dart:io';

import 'package:flutter/services.dart';
import 'package:medication_alarm/medication_alarm.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:widyu/core/log/log.dart';
import 'package:widyu/core/model/permission/permission_type.dart';
import 'package:widyu/core/utils/settings_return_controller.dart';

/// 권한 요청 결과.
enum PermissionRequestResult {
  granted,
  denied,
  permanentlyDenied,
  restricted,
  unsupported,
  canceled,
  settingsLaunchFailed,
}

/// 설정 화면 복귀 뒤 새 권한 상태를 반영한 결과.
enum PermissionSettingsResult { granted, denied, launchFailed, canceled }

class PermissionManager {
  PermissionManager._();

  static const MethodChannel permissionPlatformChannel = MethodChannel(
    'widyu/permissions',
  );

  static Future<bool> isGranted(PermissionType type) async {
    return (await status(type)) == PermissionRequestResult.granted;
  }

  /// 현재 시스템 권한 상태. [restricted]와 [permanentlyDenied]를 구분한다.
  static Future<PermissionRequestResult> status(PermissionType type) async {
    try {
      switch (type) {
        case PermissionType.notification:
          // POST_NOTIFICATIONS의 영구 거절 이력을 보존하기 위해 플러그인 상태를 쓴다.
          final status = await Permission.notification.status;
          if (!Platform.isAndroid) return mapStatus(status);
          return mapNotificationStatus(
            status,
            androidSdkInt: await androidSdkInt(),
          );

        case PermissionType.alarm:
          // 정확한 알람(SCHEDULE_EXACT_ALARM).
          if (Platform.isIOS) {
            return _alarmKitResult(await MedicationAlarm().capabilities(),
                denied: PermissionRequestResult.denied);
          }
          if (!Platform.isAndroid) return PermissionRequestResult.unsupported;
          return mapStatus(await Permission.scheduleExactAlarm.status);

        case PermissionType.overlay:
          if (!Platform.isAndroid) return PermissionRequestResult.unsupported;
          return mapStatus(await Permission.systemAlertWindow.status);

        case PermissionType.id:
          // 런타임 권한이 아니다. (아래 request 주석 참고)
          return PermissionRequestResult.unsupported;

        case PermissionType.phone:
          // iOS 에는 대응 개념이 없다.
          if (!Platform.isAndroid) return PermissionRequestResult.unsupported;
          return mapStatus(await Permission.phone.status);

        case PermissionType.location:
          // 포그라운드 위치만 확인한다.
          return mapStatus(await Permission.location.status);

        case PermissionType.fitness:
          return mapStatus(await _fitnessPermission.status);

        case PermissionType.camera:
          // 사진 선택은 image_picker 가 Photo Picker 를 경유하므로 별도 권한이 필요 없다.
          // 화면 문구의 '저장 공간' 은 안내일 뿐 런타임 요청 대상이 아니다.
          return mapStatus(await Permission.camera.status);
      }
    } catch (e, stack) {
      WiduLog.data.w('$type 권한 확인 실패', error: e, stackTrace: stack);
      return PermissionRequestResult.denied;
    }
  }

  /// Android의 "다시 묻지 않음" 이전 거절 사유 표시 가능 여부.
  static Future<bool> shouldShowRationale(PermissionType type) async {
    final permission = _permissionForRationale(type);
    if (permission == null) return false;
    try {
      return await permission.shouldShowRequestRationale;
    } catch (e, stack) {
      WiduLog.data.w('$type 권한 안내 확인 실패', error: e, stackTrace: stack);
      return false;
    }
  }

  /// Android SDK 버전 조회 실패는 null로 두어 권한 상태를 추측하지 않는다.
  static Future<int?> androidSdkInt() async {
    try {
      return await permissionPlatformChannel.invokeMethod<int>(
        'getAndroidSdkInt',
      );
    } catch (_) {
      return null;
    }
  }

  /// 권한 요청. 이미 허용된 항목도 안전하게 다시 호출할 수 있다.
  static Future<PermissionRequestResult> request(PermissionType type) async {
    try {
      final current = await status(type);
      if (current != PermissionRequestResult.denied) return current;
      switch (type) {
        case PermissionType.notification:
          return mapStatus(await Permission.notification.request());

        case PermissionType.alarm:
          // 정확한 알람(SCHEDULE_EXACT_ALARM).
          // Android 12+ 에서는 인앱 다이얼로그가 아니라 시스템 설정 화면으로 이동한다.
          if (Platform.isIOS) {
            return _alarmKitResult(await MedicationAlarm().requestPermissions(),
                denied: PermissionRequestResult.permanentlyDenied);
          }
          if (!Platform.isAndroid) return PermissionRequestResult.unsupported;
          return mapStatus(await Permission.scheduleExactAlarm.request());

        case PermissionType.overlay:
          if (!Platform.isAndroid) return PermissionRequestResult.unsupported;
          return mapStatus(await Permission.systemAlertWindow.request());

        case PermissionType.id:
          // 런타임 권한이 아니므로 요청을 시도하지 않는다.
          return PermissionRequestResult.unsupported;

        case PermissionType.phone:
          // iOS 에는 대응 개념이 없으므로 요청하지 않는다.
          if (!Platform.isAndroid) return PermissionRequestResult.unsupported;
          return mapStatus(await Permission.phone.request());

        case PermissionType.location:
          // 포그라운드 위치만 요청한다.
          // '항상 허용' 은 설정 화면으로 이탈시키므로 requestBackgroundLocation() 으로 분리.
          return mapStatus(await Permission.location.request());

        case PermissionType.fitness:
          // Android 는 ACTIVITY_RECOGNITION, iOS 는 CoreMotion(sensors)
          return mapStatus(await _fitnessPermission.request());

        case PermissionType.camera:
          // 카메라만 요청한다. 갤러리 접근은 image_picker 의 Photo Picker 가
          // 권한 없이 처리하므로 READ_MEDIA_IMAGES 를 런타임에 요청하지 않는다.
          return mapStatus(await Permission.camera.request());
      }
    } catch (e, stack) {
      WiduLog.data.w('$type 권한 요청 실패', error: e, stackTrace: stack);
      return PermissionRequestResult.denied;
    }
  }

  /// 위치 '항상 허용'(ACCESS_BACKGROUND_LOCATION) 보유 여부.
  static Future<bool> isBackgroundLocationGranted() async {
    try {
      return await Permission.locationAlways.isGranted;
    } catch (e, stack) {
      WiduLog.data.w('위치 항상 허용 확인 실패', error: e, stackTrace: stack);
      return false;
    }
  }

  /// 위치 '항상 허용' 요청.
  /// 포그라운드 위치가 허용된 뒤에만 의미가 있고, 플랫폼에 따라 설정 화면으로 이동한다.
  static Future<PermissionRequestResult> requestBackgroundLocation() async {
    try {
      return mapStatus(await Permission.locationAlways.request());
    } catch (e, stack) {
      WiduLog.data.w('위치 항상 허용 요청 실패', error: e, stackTrace: stack);
      return PermissionRequestResult.denied;
    }
  }

  /// 기기의 위치 서비스(GPS) 자체가 켜져 있는지 여부. 권한과는 별개다.
  static Future<bool> isLocationServiceEnabled() async {
    try {
      return await Permission.location.serviceStatus.isEnabled;
    } catch (e, stack) {
      WiduLog.data.w('위치 서비스 상태 확인 실패', error: e, stackTrace: stack);
      return false;
    }
  }

  /// 앱 설정 화면으로 이동한다.
  static Future<bool> openSettings() async {
    try {
      return await openAppSettings();
    } catch (e, stack) {
      WiduLog.data.w('설정 화면 이동 실패', error: e, stackTrace: stack);
      return false;
    }
  }

  /// 설정 앱에서 돌아온 후에만 권한 상태를 다시 읽는다.
  static Future<PermissionSettingsResult> openSettingsAndRecheck(
    PermissionType type,
    SettingsReturnController controller, {
    Future<bool> Function(PermissionType type)? isGrantedReader,
  }) =>
      _openSettingsAndRead(
        controller,
        () => (isGrantedReader ?? isGranted)(type),
      );

  /// 위치 공유 설정에서는 포그라운드 허용과 별도로 '항상 허용'을 확인한다.
  static Future<PermissionSettingsResult>
      openSettingsAndRecheckBackgroundLocation(
    SettingsReturnController controller, {
    Future<bool> Function()? isGrantedReader,
  }) =>
          _openSettingsAndRead(
            controller,
            isGrantedReader ?? isBackgroundLocationGranted,
          );

  static Future<PermissionSettingsResult> _openSettingsAndRead(
    SettingsReturnController controller,
    Future<bool> Function() readPermission,
  ) async {
    final returnResult = await controller.open();
    switch (returnResult) {
      case SettingsReturnResult.launchFailed:
        return PermissionSettingsResult.launchFailed;
      case SettingsReturnResult.canceled:
        return PermissionSettingsResult.canceled;
      case SettingsReturnResult.returned:
        if (controller.isDisposed) return PermissionSettingsResult.canceled;
        final isAllowed = await readPermission();
        if (controller.isDisposed) return PermissionSettingsResult.canceled;
        return isAllowed
            ? PermissionSettingsResult.granted
            : PermissionSettingsResult.denied;
    }
  }

  static PermissionRequestResult _alarmKitResult(
    Map<String, dynamic> capabilities, {
    required PermissionRequestResult denied,
  }) {
    if (capabilities['mode'] != 'alarmKit') {
      return PermissionRequestResult.unsupported;
    }
    return capabilities['authorized'] == true
        ? PermissionRequestResult.granted
        : denied;
  }

  /// 동작 및 피트니스에 해당하는 플랫폼별 권한.
  static Permission get _fitnessPermission =>
      Platform.isIOS ? Permission.sensors : Permission.activityRecognition;

  static Permission? _permissionForRationale(PermissionType type) {
    switch (type) {
      case PermissionType.notification:
        return Permission.notification;
      case PermissionType.phone:
        return Platform.isAndroid ? Permission.phone : null;
      case PermissionType.location:
        return Permission.location;
      case PermissionType.fitness:
        return _fitnessPermission;
      case PermissionType.camera:
        return Permission.camera;
      case PermissionType.alarm:
      case PermissionType.overlay:
      case PermissionType.id:
        return null;
    }
  }

  /// permission_handler 상태를 앱의 복구 흐름 결과로 변환한다.
  static PermissionRequestResult mapStatus(PermissionStatus status) {
    if (status.isGranted || status.isLimited || status.isProvisional) {
      return PermissionRequestResult.granted;
    }
    if (status.isPermanentlyDenied) {
      return PermissionRequestResult.permanentlyDenied;
    }
    if (status.isRestricted) return PermissionRequestResult.restricted;
    return PermissionRequestResult.denied;
  }

  /// Android 13 미만은 앱 알림을 사용자가 시스템에서 끈 경우 다시 요청할 수 없다.
  /// SDK 조회를 못하면 상태를 추측하지 않고 원래 denied를 유지한다.
  static PermissionRequestResult mapNotificationStatus(
    PermissionStatus status, {
    required int? androidSdkInt,
  }) {
    final result = mapStatus(status);
    if (result == PermissionRequestResult.denied &&
        androidSdkInt != null &&
        androidSdkInt < 33) {
      return PermissionRequestResult.permanentlyDenied;
    }
    return result;
  }
}
