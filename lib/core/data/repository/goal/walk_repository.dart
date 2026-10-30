import 'package:widyu/core/model/goal/walk/walk_sync_result.dart';

abstract class WalkRepository {
  /// 오늘 걸음 수. 구독 시 최신 값을 먼저 받는다.
  Stream<int> get todaySteps;
  int get currentTodaySteps;

  Future<bool> ensurePermission();

  /// 기기 센서의 누적 걸음 수 스트림. 앱이 보이는 동안만 구독한다.
  Stream<int> get liveStepCounts;

  /// 누적 센서값을 받아 마지막 건강값 기준 증가분을 오늘 걸음 수에 반영한다.
  void applyLiveCount(int count);

  /// 건강값을 다시 읽어 오늘 걸음 수의 기준을 갈아끼운다.
  Future<void> refreshTodaySteps();

  /// 목표 도달 등으로 서버 동기화가 필요할 때 이벤트를 보낸다.
  Stream<void> get syncRequests;

  Future<WalkSaveResult> sync({
    required String memberId,
    bool full = false,
    bool Function()? isCancelled,
    bool background = false,
  });

  void applyServerSteps(int serverSteps, {required String date, int? goal});
  void dispose();
}
