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

  void sync(int? point) {
    if (point == null || point == _point) return;
    _point = point;
    notifyListeners();
  }

  Future<void> ensureLoaded() async {
    if (_point != null) return;
    await _fetchPoints();
  }

  Future<void> refresh() async {
    await _fetchPoints();
  }

  Future<ApiResult<int>> _fetchPoints() {
    return _inFlight ??= _requestPoints();
  }

  Future<ApiResult<int>> _requestPoints() async {
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

  void clear() {
    _point = null;
    notifyListeners();
  }
}
