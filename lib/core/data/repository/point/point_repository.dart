typedef PointStatus = ({int? point, bool isLoading});

abstract class PointRepository {
  /// 현재 포인트와 조회 중 여부. 구독 시 최신 값을 먼저 받는다.
  Stream<PointStatus> get status;
  PointStatus get currentStatus;
  /// refresh가 시작될 때마다 오른다. 화면이 직접 받은 포인트를 [sync]할 때 쓴다.
  int get revision;
  Future<void> refresh();

  /// [revision]은 그 포인트를 요청하기 전에 읽은 값이다. 그 사이 refresh가 시작됐으면 무시한다.
  void sync(int? point, {required int revision});
  void dispose();
}
