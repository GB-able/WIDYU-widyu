import 'package:permission_handler/permission_handler.dart';

class PermissionManager {
  static Future<bool> checkLocationPermission() async {
    var status = await Permission.location.status;
    if (status.isDenied) {
      status = await Permission.location.request();
    }
    if (status.isPermanentlyDenied) {
      // 설정 이동 다이얼로그 추후 구현 예정
      openAppSettings();
      return false;
    }

    var backgroundStatus = await Permission.locationAlways.status;
    if (backgroundStatus.isDenied) {
      backgroundStatus = await Permission.locationAlways.request();
    }

    // 거절 시 설정 이동 다이얼로그 추후 구현 예정
    return backgroundStatus.isGranted;
  }
}
