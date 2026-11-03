import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:widyu/core/data/repository/myPage/my_page_repository.dart';
import 'package:widyu/core/di/providers.dart';
import 'package:widyu/core/model/api/api_result.dart';
import 'package:widyu/core/model/myPage/code/family_code.dart';
import 'package:widyu/feature/management/management_ui_event.dart';
import 'package:widyu/feature/management/management_ui_state.dart';

part 'management_view_model.g.dart';

@riverpod
class ManagementViewModel extends _$ManagementViewModel {
  final _uiEvent = StreamController<ManagementUiEvent>.broadcast();

  // 일회성 이벤트는 state가 아니라 stream으로 내보낸다.
  // ignore: riverpod_lint/avoid_public_notifier_properties
  Stream<ManagementUiEvent> get uiEvent => _uiEvent.stream;

  MyPageRepository get _repository => ref.read(myPageRepositoryProvider);

  @override
  ManagementUiState build() {
    // onDispose는 다시 빌드될 때도 불리므로, 실제로 폐기될 때만 닫는다.
    ref.onDispose(() {
      if (!ref.mounted) _uiEvent.close();
    });
    unawaited(Future.microtask(_fetchFamilyCode));
    return const ManagementUiState();
  }

  Future<void> _fetchFamilyCode() async {
    if (!ref.mounted) return;
    state = state.copyWith(isLoading: true);

    final result = await _repository.fetchFamilyCode();
    if (!ref.mounted) return;
    if (result is Success) {
      final data = (result as Success<FamilyCode>).data;
      state = state.copyWith(familyCode: data.familyCode);
    } else {
      _uiEvent.add(const FetchFamilyCodeFailure());
    }
    state = state.copyWith(isLoading: false);
  }
}
