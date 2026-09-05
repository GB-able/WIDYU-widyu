abstract class WalkLocalDataSource {
  Future<bool> ensurePermission();

  /// 직전 이벤트 이후 늘어난 걸음 수.
  Stream<int> observeStepDelta();
}
