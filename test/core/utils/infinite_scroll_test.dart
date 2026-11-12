import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:widyu/core/model/api/infinite_page_result.dart';
import 'package:widyu/core/utils/infinite_scroll.dart';

void main() {
  late InfiniteScrollState<int> state;
  late List<Completer<InfinitePageResult<int>>> requests;
  late InfiniteScroller<int> scroller;

  setUp(() {
    state = const InfiniteScrollState<int>();
    requests = [];
    scroller = InfiniteScroller<int>(
      fetch: (_) {
        final completer = Completer<InfinitePageResult<int>>();
        requests.add(completer);
        return completer.future;
      },
      read: () => state,
      write: (next) => state = next,
      mounted: () => true,
    );
  });

  test('새 init이 시작되면 이전 요청 결과는 버린다', () async {
    final first = scroller.init();
    final second = scroller.init();
    requests[1]
        .complete(const InfinitePageResult(items: [2], nextCursor: null));
    requests[0].complete(
        const InfinitePageResult(items: [1], nextCursor: '1', hasNext: true));
    await Future.wait([first, second]);
    expect(state.items, [2]);
    expect(state.hasNext, isFalse);
    expect(state.isFetching, isFalse);
  });

  test('loadMore는 뒤에 이어 붙이고, 실패 후 retry로 다시 불러온다', () async {
    final init = scroller.init();
    requests[0].complete(
        const InfinitePageResult(items: [1], nextCursor: '1', hasNext: true));
    await init;

    final more = scroller.loadMore();
    requests[1].completeError(Exception('network'));
    await more;
    expect(state.hasError, isTrue);
    expect(state.items, [1]);

    final retry = scroller.retry();
    requests[2]
        .complete(const InfinitePageResult(items: [2], nextCursor: null));
    await retry;
    expect(state.items, [1, 2]);
    expect(state.hasError, isFalse);
  });

  test('받은 페이지가 비어도 다음 페이지가 있으면 이어서 불러온다', () async {
    final init = scroller.init();
    requests[0].complete(
        const InfinitePageResult(items: [], nextCursor: '1', hasNext: true));
    await init;
    await pumpEventQueue();

    expect(requests, hasLength(2));
    requests[1]
        .complete(const InfinitePageResult(items: [2], nextCursor: null));
    await pumpEventQueue();
    expect(state.items, [2]);
  });

  test('update로 목록이 비면 다음 페이지를 불러오고, 실패 상태에서는 멈춘다', () async {
    final init = scroller.init();
    requests[0].complete(
        const InfinitePageResult(items: [1], nextCursor: '1', hasNext: true));
    await init;

    scroller.update((list) => list.removeWhere((id) => id == 1));
    await pumpEventQueue();
    expect(requests, hasLength(2));

    requests[1].completeError(Exception('network'));
    await pumpEventQueue();
    expect(state.hasError, isTrue);
    expect(requests, hasLength(2));
  });
}
