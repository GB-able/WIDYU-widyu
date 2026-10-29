import 'package:widyu/core/model/goal/walk/walk_sync_result.dart';

abstract class WalkRepository {
  /// 오늘 걸음 수. 구독 시 최신 값을 먼저 받는다.
  Stream<int> get todaySteps;
  int get currentTodaySteps;

  Future<bool> ensurePermission();

  Future<WalkSaveResult> sync({
    required String memberId,
    bool full = false,
    bool Function()? isCancelled,
    bool background = false,
  });

  void applyServerSteps(int serverSteps, {required String date});
  void dispose();
}
