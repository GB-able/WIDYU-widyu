import 'dart:async';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:widyu/core/log/log.dart';
import 'package:widyu/core/model/api/infinite_page_result.dart';

part 'infinite_scroll.freezed.dart';

@freezed
abstract class InfiniteScrollState<T> with _$InfiniteScrollState<T> {
  const InfiniteScrollState._();

  const factory InfiniteScrollState({
    @Default([]) List<T> items,
    String? nextCursor,
    @Default(true) bool hasNext,
    @Default(false) bool isFetching,
    @Default(false) bool isLoadingMore,
    @Default(false) bool hasError,
  }) = _InfiniteScrollState<T>;

  bool get isLoading => isFetching && items.isEmpty;
  bool get isEmpty => items.isEmpty;

  InfiniteScrollState<T> replaceWhere(
    bool Function(T) test,
    T Function(T) replace,
  ) =>
      copyWith(
        items: [for (final item in items) test(item) ? replace(item) : item],
      );

  InfiniteScrollState<T> removeWhere(bool Function(T) test) =>
      copyWith(items: items.where((item) => !test(item)).toList());
}

class InfiniteScroller<T> {
  InfiniteScroller({
    required this.fetch,
    required this.read,
    required this.write,
    required this.mounted,
  });

  final Future<InfinitePageResult<T>> Function(String? cursor) fetch;
  final InfiniteScrollState<T> Function() read;
  final void Function(InfiniteScrollState<T>) write;
  final bool Function() mounted;

  int _generation = 0;

  // fetch 안에서 응답이 아직 유효한지 확인할 때 쓴다.
  int get generation => _generation;

  bool isCurrent(int generation) => mounted() && generation == _generation;

  void update(
    InfiniteScrollState<T> Function(InfiniteScrollState<T> current) change,
  ) {
    if (!mounted()) return;
    _write(change(read()));
  }

  void _write(InfiniteScrollState<T> next) {
    write(next);
    if (_isEmptyWithNext(next)) {
      scheduleMicrotask(() {
        if (mounted() && _isEmptyWithNext(read())) unawaited(loadMore());
      });
    }
  }

  bool _isEmptyWithNext(InfiniteScrollState<T> list) =>
      list.isEmpty &&
      list.hasNext &&
      !list.isFetching &&
      !list.isLoadingMore &&
      !list.hasError;

  Future<void> init() async {
    if (!mounted()) return;
    final generation = ++_generation;
    _write(read().copyWith(
      isFetching: true,
      isLoadingMore: false,
      hasError: false,
    ));
    try {
      final result = await fetch(null);
      if (!isCurrent(generation)) return;
      _write(read().copyWith(
        items: result.items,
        nextCursor: result.nextCursor,
        hasNext: result.hasNext,
        isFetching: false,
      ));
    } catch (e, stack) {
      if (!isCurrent(generation)) return;
      WiduLog.ui.w('첫 페이지 불러오기 실패', error: e, stackTrace: stack);
      _write(read().copyWith(isFetching: false, hasError: true));
    }
  }

  Future<void> loadMore() async {
    final current = read();
    if (!mounted() ||
        current.isFetching ||
        current.isLoadingMore ||
        !current.hasNext ||
        current.hasError) {
      return;
    }
    final generation = _generation;
    _write(current.copyWith(isLoadingMore: true));
    try {
      final result = await fetch(current.nextCursor);
      if (!isCurrent(generation)) return;
      final latest = read();
      _write(latest.copyWith(
        items: [...latest.items, ...result.items],
        nextCursor: result.nextCursor,
        hasNext: result.hasNext,
        isLoadingMore: false,
      ));
    } catch (e, stack) {
      if (!isCurrent(generation)) return;
      WiduLog.ui.w('다음 페이지 불러오기 실패', error: e, stackTrace: stack);
      _write(read().copyWith(isLoadingMore: false, hasError: true));
    }
  }

  Future<void> retry() {
    if (!mounted()) return Future.value();
    _write(read().copyWith(hasError: false));
    return read().isEmpty ? init() : loadMore();
  }
}
