import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:widyu/core/data/repository/myPage/my_page_repository.dart';
import 'package:widyu/core/data/repository/point/point_repository.dart';
import 'package:widyu/core/di/providers.dart';
import 'package:widyu/core/model/api/api_result.dart';
import 'package:widyu/core/model/myPage/point/point_history.dart';
import 'package:widyu/feature/point/point_ui_event.dart';
import 'package:widyu/feature/point/point_ui_model.dart';
import 'package:widyu/feature/point/point_ui_state.dart';

part 'point_view_model.g.dart';

@riverpod
class PointViewModel extends _$PointViewModel {
  final _uiEvent = StreamController<PointUiEvent>.broadcast();

  // 일회성 이벤트는 state가 아니라 stream으로 내보낸다.
  // ignore: riverpod_lint/avoid_public_notifier_properties
  Stream<PointUiEvent> get uiEvent => _uiEvent.stream;

  MyPageRepository get _repository => ref.read(myPageRepositoryProvider);
  PointRepository get _pointRepository => ref.read(pointRepositoryProvider);

  @override
  PointUiState build() {
    // onDispose는 다시 빌드될 때도 불리므로, 실제로 폐기될 때만 닫는다.
    ref.onDispose(() {
      if (!ref.mounted) _uiEvent.close();
    });
    unawaited(Future.microtask(_start));
    return PointUiState(
      isLoading: true,
      point: _pointRepository.currentStatus.point,
    );
  }

  void _start() {
    if (!ref.mounted) return;
    // 구독하면 최신 값이 다시 전달된다. 전달 시점이 stream 구현에 따라 다르므로
    // build() 중에 state를 쓰지 않도록 build() 뒤에 구독한다.
    final pointStatus = _pointRepository.status.listen((status) {
      state = state.copyWith(point: status.point);
    });
    ref.onDispose(pointStatus.cancel);
    unawaited(_fetchPointHistory());
  }

  Future<void> _fetchPointHistory() async {
    final pointRepository = _pointRepository;
    final pointRevision = pointRepository.revision;
    state = state.copyWith(isLoading: true);

    final result = await _repository.fetchPointHistory();
    // 화면이 먼저 닫혀도 세션 포인트는 갱신한다(기존 동작).
    if (result is Success<PointHistory>) {
      pointRepository.sync(
        result.data.currentPoints,
        revision: pointRevision,
      );
    }
    if (!ref.mounted) return;
    if (result is Success) {
      final data = (result as Success<PointHistory>).data;
      state = state.copyWith(
        histories: data.histories
            .map((point) => point.toUiModel())
            .toList(growable: false),
      );
    } else {
      _uiEvent.add(const FetchPointFailure());
    }
    state = state.copyWith(isLoading: false);
  }
}
