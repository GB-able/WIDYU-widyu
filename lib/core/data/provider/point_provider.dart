import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:widyu/core/data/repository/point/point_repository.dart';
import 'package:widyu/core/model/api/api_result.dart';

class PointProvider with ChangeNotifier {
  final PointRepository _repository;

  PointProvider({required PointRepository repository})
      : _repository = repository {
    unawaited(_fetchPoints());
  }

  Future<void> _requestQueue = Future<void>.value();
  int _queuedRequests = 0;
  int? _point;
  bool _isLoading = false;
  bool _disposed = false;

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  int? get point => _point;
  bool get isLoading => _isLoading;

  void sync(int? point) {
    if (_disposed || point == null || point == _point) return;
    _point = point;
    notifyListeners();
  }

  Future<void> refresh() async {
    if (_disposed) return;
    await _fetchPoints();
  }

  Future<void> _fetchPoints() {
    if (_disposed) return Future.value();

    _queuedRequests++;
    if (!_isLoading) {
      _isLoading = true;
      notifyListeners();
    }

    final request = _requestQueue.then((_) => _requestPoints());
    _requestQueue = request.then<void>(
      (_) {},
      onError: (Object error, StackTrace stackTrace) {},
    );

    return request.whenComplete(() {
      _queuedRequests--;
      if (_disposed || _queuedRequests > 0) return;
      _isLoading = false;
      notifyListeners();
    });
  }

  Future<void> _requestPoints() async {
    await Future.microtask(() {});
    if (_disposed) return;

    final result = await _repository.fetchPoints();
    if (_disposed) return;
    if (result is Success<int>) {
      _point = result.data;
    }
  }
}
