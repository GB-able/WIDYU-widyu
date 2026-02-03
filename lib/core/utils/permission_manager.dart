import 'package:permission_handler/permission_handler.dart';

class PermissionManager {
  static Future<bool> checkLocationPermission() async {
    var status = await Permission.location.request();

    if (!status.isGranted) {
      if (status.isPermanentlyDenied) {
        openAppSettings();
      }
      return false;
    }

    var backgroundStatus = await Permission.locationAlways.request();

    if (!backgroundStatus.isGranted) {
      if (backgroundStatus.isPermanentlyDenied) {
        openAppSettings();
      }
      return false;
    }

    return true;
  }
}
