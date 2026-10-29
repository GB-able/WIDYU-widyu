typedef PointStatus = ({int? point, bool isLoading});

abstract class PointRepository {
  /// 현재 포인트와 조회 중 여부. 구독 시 최신 값을 먼저 받는다.
  Stream<PointStatus> get status;
  PointStatus get currentStatus;
  Future<void> refresh();
  void sync(int? point);
  void dispose();
}
