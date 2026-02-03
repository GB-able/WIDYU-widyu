import 'package:permission_handler/permission_handler.dart';

class PermissionManager {
  static Future<void> requestLocationPermission() async {
    if (await checkLocationPermission()) return;

    var locationStatus = await Permission.location.request();
    if (locationStatus.isGranted) {
      await Permission.locationAlways.request();
    }
  }

  static Future<bool> checkLocationPermission() async {
    return await Permission.locationAlways.isGranted;
  }
}
