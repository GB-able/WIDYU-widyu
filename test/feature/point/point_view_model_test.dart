import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:widyu/core/data/repository/myPage/my_page_repository.dart';
import 'package:widyu/core/data/repository/point/point_repository.dart';
import 'package:widyu/core/di/providers.dart';
import 'package:widyu/core/model/api/api_result.dart';
import 'package:widyu/core/model/myPage/point/point_history.dart';
import 'package:widyu/feature/point/point_ui_event.dart';
import 'package:widyu/feature/point/point_view_model.dart';

class _Repository extends Fake implements MyPageRepository {
  final pending = Completer<ApiResult<PointHistory>>();
  int calls = 0;

  @override
  Future<ApiResult<PointHistory>> fetchPointHistory() {
    calls++;
    return pending.future;
  }
}

class _Point extends Fake implements PointRepository {
  final _status = StreamController<PointStatus>.broadcast();

  @override
  Stream<PointStatus> get status => _status.stream;

  @override
  PointStatus get currentStatus => (point: 10, isLoading: false);

  int? synced;

  @override
  int get revision => 0;

  @override
  void sync(int? point, {required int revision}) => synced = point;

  void emit(int point) => _status.add((point: point, isLoading: false));
}

void main() {
  late _Repository repository;
  late _Point point;
  late ProviderContainer container;
  late List<PointUiEvent> events;

  setUp(() {
    repository = _Repository();
    point = _Point();
    container = ProviderContainer.test(overrides: [
      myPageRepositoryProvider.overrideWithValue(repository),
      pointRepositoryProvider.overrideWithValue(point),
    ]);
    events = [];
  });

  // 첫 listen에서 build()가 실행되고 조회는 다음 microtask에 시작한다.
  // setUp과 테스트 본문 사이에도 microtask가 돌므로 테스트 안에서 부른다.
  void listen() {
    container.listen(pointViewModelProvider, (_, __) {});
    container.read(pointViewModelProvider.notifier).uiEvent.listen(events.add);
  }

  test('조회 시작 전에 폐기되면 조회하지 않는다', () async {
    listen();
    container.dispose();
    // 가드가 없으면 폐기된 Notifier의 state에 접근하다가 예외가 나서 실패한다.
    await pumpEventQueue();
    expect(repository.calls, 0);
    expect(events, isEmpty);
  });

  test('조회 중 폐기되면 상태와 이벤트를 쓰지 않는다', () async {
    listen();
    await pumpEventQueue();
    expect(repository.calls, 1);

    container.dispose();
    repository.pending.complete(const ApiResult.failure('error'));
    // 가드가 없으면 폐기된 Notifier의 state나 닫힌 이벤트 stream에 쓰다가 예외가 나서 실패한다.
    await pumpEventQueue();
    expect(events, isEmpty);
  });

  test('현재 포인트로 시작하고 포인트가 바뀌면 반영한다', () async {
    listen();
    expect(container.read(pointViewModelProvider).point, 10);

    await pumpEventQueue();
    point.emit(20);
    await pumpEventQueue();
    expect(container.read(pointViewModelProvider).point, 20);
  });

  test('조회 중 폐기돼도 세션 포인트는 갱신한다', () async {
    listen();
    await pumpEventQueue();

    container.dispose();
    repository.pending.complete(
      const ApiResult.success(PointHistory(currentPoints: 30, histories: [])),
    );
    await pumpEventQueue();
    expect(point.synced, 30);
  });
}
