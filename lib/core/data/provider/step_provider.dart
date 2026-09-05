import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:widyu/core/data/provider/point_provider.dart';
import 'package:widyu/core/data/repository/goal/walk_repository.dart';
import 'package:widyu/core/model/api/api_result.dart';
import 'package:widyu/core/utils/extensions/date_extension.dart';

// [TODO] 추후 로직 변경. 현재는 포그라운드에서만 동작하고 자체 센서로 구현함. 추후 위치 기반 카운팅 방식으로 변경
class StepProvider with ChangeNotifier, WidgetsBindingObserver {
  final WalkRepository _repository;
  final PointProvider _pointProvider;

  StepProvider({
    required WalkRepository repository,
    required PointProvider pointProvider,
  })  : _repository = repository,
        _pointProvider = pointProvider;

  // [NOTICE] 서버에 올리는 최소 증가분
  static const _syncThreshold = 100;

  StreamSubscription<int>? _subscription;

  int _steps = 0;
  int _syncedSteps = 0;
  DateTime? _countedDate;
  bool _isSyncing = false;
  bool _isAchieved = false;

  int get steps => _steps;
  bool get isTracking => _subscription != null;

  Future<void> start() async {
    if (_subscription != null) return;
    if (!await _repository.ensurePermission()) return;
    if (_subscription != null) return;

    _subscription = _repository.observeStepDelta().listen(
      _onStepDelta,
      onError: (Object error) {
        debugPrint('[StepProvider] 걸음 수 센서 오류: $error');
      },
    );
    WidgetsBinding.instance.addObserver(this);
    notifyListeners();
  }

  // [NOTICE] 백그라운드 전환 시 걸음 수 동기화
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.hidden) {
      unawaited(_sync(threshold: 1));
    }
  }

  void applyServerSteps(int serverSteps) {
    _resetIfDateChanged();
    if (serverSteps <= _steps) return;

    _steps = serverSteps;
    _syncedSteps = serverSteps;
    notifyListeners();
  }

  void _onStepDelta(int delta) {
    _resetIfDateChanged();
    if (delta <= 0) return;

    _steps += delta;
    notifyListeners();
    unawaited(_syncIfNeeded());
  }

  /// [NOTICE] 날짜 변경 시 걸음수 초기화
  void _resetIfDateChanged() {
    final today = DateTime.now().onlyDateTime;
    if (_countedDate == today) return;

    _countedDate = today;
    _steps = 0;
    _syncedSteps = 0;
    _isAchieved = false;
  }

  Future<void> _syncIfNeeded() => _sync(threshold: _syncThreshold);

  Future<void> _sync({required int threshold}) async {
    if (_isSyncing || _steps - _syncedSteps < threshold) return;

    _isSyncing = true;
    // [NOTICE] 요청 중에도 걸음은 계속 늘어나므로 실제로 보낸 값을 따로 저장
    final sending = _steps;
    final result = await _repository.syncSteps(sending);
    _isSyncing = false;

    switch (result) {
      case Success<bool>(:final data):
        _syncedSteps = sending;
        if (data && !_isAchieved) {
          _isAchieved = true;
          unawaited(_pointProvider.refresh());
        }
      case Failure<bool>(:final message):
        debugPrint('[StepProvider] 걸음 수 연동 실패: $message');
    }
  }

  @override
  void dispose() {
    if (_subscription != null) WidgetsBinding.instance.removeObserver(this);
    _subscription?.cancel();
    super.dispose();
  }
}
