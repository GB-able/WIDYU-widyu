enum WalkPermissionStatus { unknown, granted, denied, unavailable, error }

abstract class WalkLocalDataSource {
  String get stepSource;

  WalkPermissionStatus get permissionStatus;

  bool get backgroundReadGranted;

  Future<bool> ensurePermission();

  Future<bool> canReadInBackground();

  Future<int?> readSteps(DateTime start, DateTime end);

  Future<Map<String, dynamic>> readState(String memberId);

  Future<void> saveState(String memberId, Map<String, dynamic> state);

  Future<String?> acquireLock(String name);

  Future<bool> ownsLock(String name, String owner);

  Future<void> releaseLock(String name, String owner);
}
