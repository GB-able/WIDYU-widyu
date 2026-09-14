enum StepPermissionStatus { unknown, granted, denied, unavailable, error }

abstract class WalkLocalDataSource {
  String get stepSource;

  StepPermissionStatus get permissionStatus;

  bool get backgroundReadGranted;

  Future<bool> ensurePermission();

  Future<bool> canReadInBackground();

  Future<int?> readSteps(DateTime start, DateTime end);
}
