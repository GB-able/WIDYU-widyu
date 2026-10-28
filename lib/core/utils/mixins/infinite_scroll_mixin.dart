import 'package:flutter/foundation.dart';
import 'package:widyu/core/log/log.dart';
import 'package:widyu/core/model/api/infinite_page_result.dart';

mixin InfiniteScrollMixin<T> on ChangeNotifier {
  final List<T> _items = [];
  bool _disposed = false;
  int _requestGeneration = 0;

  @protected
  int get requestGeneration => _requestGeneration;

  @protected
  bool isRequestCurrent(int generation) =>
      !_disposed && generation == _requestGeneration;

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  String? _nextCursor;
  bool _hasNext = true;
  bool _isLoading = false;
  bool _isLoadingMore = false;
  bool _hasError = false;

  List<T> get items => List.unmodifiable(_items);
  bool get isLoading => _isLoading && _items.isEmpty;
  bool get isLoadingMore => _isLoadingMore;
  bool get hasError => _hasError;
  bool get hasNext => _hasNext;
  bool get isEmpty => _items.isEmpty;

  Future<InfinitePageResult<T>> fetch(String? cursor);

  Future<void> init() async {
    if (_disposed) return;
    final generation = ++_requestGeneration;
    _isLoadingMore = false;
    _isLoading = true;
    _hasError = false;
    notifyListeners();

    try {
      final result = await fetch(null);
      if (_disposed || generation != _requestGeneration) return;
      _items
        ..clear()
        ..addAll(result.items);
      _nextCursor = result.nextCursor;
      _hasNext = result.hasNext;
    } catch (e, stack) {
      if (_disposed || generation != _requestGeneration) return;
      WiduLog.ui.w('$runtimeType 첫 페이지 불러오기 실패', error: e, stackTrace: stack);
      _hasError = true;
    } finally {
      if (!_disposed && generation == _requestGeneration) {
        _isLoading = false;
        notifyListeners();
      }
    }
  }

  Future<void> loadMore() async {
    if (_disposed || _isLoading || _isLoadingMore || !_hasNext || _hasError) {
      return;
    }

    final generation = _requestGeneration;
    _isLoadingMore = true;
    notifyListeners();

    try {
      final result = await fetch(_nextCursor);
      if (_disposed || generation != _requestGeneration) return;
      _items.addAll(result.items);
      _nextCursor = result.nextCursor;
      _hasNext = result.hasNext;
    } catch (e, stack) {
      if (_disposed || generation != _requestGeneration) return;
      WiduLog.ui.w('$runtimeType 다음 페이지 불러오기 실패', error: e, stackTrace: stack);
      _hasError = true;
    } finally {
      if (!_disposed && generation == _requestGeneration) {
        _isLoadingMore = false;
        notifyListeners();
      }
    }
  }

  Future<void> retry() async {
    if (_disposed) return;
    _hasError = false;
    notifyListeners();
    return isEmpty ? init() : loadMore();
  }

  void removeWhere(bool Function(T) test) {
    if (!_items.any(test)) return;
    _items.removeWhere(test);
    notifyListeners();
  }
}
