import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:widyu/core/data/provider/point_provider.dart';
import 'package:widyu/core/data/repository/myPage/my_page_repository.dart';
import 'package:widyu/core/model/api/api_result.dart';
import 'package:widyu/core/model/myPage/point/point_history.dart';
import 'package:widyu/feature/point/point_ui_event.dart';
import 'package:widyu/feature/point/point_ui_model.dart';
import 'package:widyu/feature/point/point_ui_state.dart';

class PointViewModel with ChangeNotifier {
  final MyPageRepository _repository;
  final PointProvider _pointProvider;

  PointUiState _uiState = const PointUiState();
  PointUiState get uiState => _uiState;

  final _uiEvent = StreamController<PointUiEvent>.broadcast();
  Stream<PointUiEvent> get uiEvent => _uiEvent.stream;

  PointViewModel({
    required MyPageRepository repository,
    required PointProvider pointProvider,
  })  : _repository = repository,
        _pointProvider = pointProvider {
    _fetchPointHistory();
  }

  Future<void> _fetchPointHistory() async {
    _uiState = _uiState.copyWith(isLoading: true);
    notifyListeners();

    final result = await _repository.fetchPointHistory();
    if (result is Success) {
      final data = (result as Success<PointHistory>).data;
      _pointProvider.sync(data.currentPoints);
      _uiState = _uiState.copyWith(
        histories: data.histories
            .map((point) => point.toUiModel())
            .toList(growable: false),
      );
      notifyListeners();
    } else {
      _uiEvent.add(const FetchPointFailure());
    }
    _uiState = _uiState.copyWith(isLoading: false);
    notifyListeners();
  }

  @override
  void dispose() {
    _uiEvent.close();
    super.dispose();
  }
}
