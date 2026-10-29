import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:widyu/core/data/repository/point/point_repository.dart';
import 'package:widyu/core/data/source/point/point_remote_data_source.dart';
import 'package:widyu/core/model/api/api_result.dart';
import 'package:widyu/core/utils/extensions/api_result_extension.dart';

class PointRepositoryImpl extends PointRepository {
  final PointRemoteDataSource _remoteDataSource;

  PointRepositoryImpl({required PointRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource {
    // 세션에서 처음 읽힐 때 생성되므로 바로 불러와 둔다. (앨범 진입 시 잠금 해제 다이얼로그가 포인트를 알 수 있도록)
    unawaited(_fetchPoints());
  }

  final _status =
      BehaviorSubject<PointStatus>.seeded((point: null, isLoading: false));
  Future<void> _requestQueue = Future<void>.value();
  int _queuedRequests = 0;
  int? _point;
  bool _isLoading = false;
  bool _disposed = false;

  @override
  void dispose() {
    _disposed = true;
    _status.close();
  }

  @override
  Stream<PointStatus> get status => _status.stream;

  @override
  PointStatus get currentStatus => (point: _point, isLoading: _isLoading);

  void _emit() {
    if (_disposed) return;
    _status.add(currentStatus);
  }

  @override
  void sync(int? point) {
    if (_disposed || point == null || point == _point) return;
    _point = point;
    _emit();
  }

  @override
  Future<void> refresh() async {
    if (_disposed) return;
    await _fetchPoints();
  }

  Future<void> _fetchPoints() {
    if (_disposed) return Future.value();

    _queuedRequests++;
    if (!_isLoading) {
      _isLoading = true;
      _emit();
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
      _emit();
    });
  }

  Future<void> _requestPoints() async {
    await Future.microtask(() {});
    if (_disposed) return;

    final result = await _remoteDataSource.fetchPoints().toApiResult();
    if (_disposed) return;
    if (result is Success<int>) {
      _point = result.data;
      _emit();
    }
  }
}
