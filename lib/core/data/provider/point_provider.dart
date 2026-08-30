import 'package:flutter/foundation.dart';
import 'package:widyu/core/data/repository/point/point_repository.dart';
import 'package:widyu/core/model/api/api_result.dart';

class PointProvider with ChangeNotifier {
  final PointRepository _repository;

  PointProvider({required PointRepository repository})
      : _repository = repository;

  Future<ApiResult<int>>? _inFlight;
  int? _point;
  bool _isLoading = false;

  int? get point => _point;
  bool get isLoading => _isLoading;

  /// 다른 화면의 응답에 실려 온 값을 반영한다.
  void sync(int? point) {
    if (point == null || point == _point) return;
    _point = point;
    notifyListeners();
  }

  /// 아직 값을 모를 때만 서버에서 읽어온다.
  ///
  /// 포인트를 응답에 담아주지 않는 화면이나, 다른 조회가 실패했을 때의 대비책이다.
  Future<void> ensureLoaded() async {
    if (_point != null) return;
    await _fetchPoints();
  }

  /// 포인트가 늘어나는 동작(복용 인증, 걷기 목표 달성, 앨범 업로드) 뒤에 호출한다.
  Future<void> refresh() async {
    await _fetchPoints();
  }

  /// 여러 화면이 같은 시점에 불러도 요청은 한 번만 나간다.
  Future<ApiResult<int>> _fetchPoints() {
    return _inFlight ??= _requestPoints();
  }

  Future<ApiResult<int>> _requestPoints() async {
    // 화면이 만들어지는 도중(ChangeNotifierProvider.create)에 호출되므로,
    // 다른 화면이 build 중일 때 알림이 나가지 않도록 한 틱 미룬다.
    await Future.microtask(() {});

    _isLoading = true;
    notifyListeners();

    final result = await _repository.fetchPoints();
    if (result is Success<int>) {
      _point = result.data;
    }

    _isLoading = false;
    _inFlight = null;
    notifyListeners();
    return result;
  }

  /// 로그아웃처럼 사용자가 바뀔 때 비운다.
  void clear() {
    _point = null;
    notifyListeners();
  }
}
