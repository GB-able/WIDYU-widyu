import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:widyu/core/data/repository/myPage/my_page_repository.dart';
import 'package:widyu/core/model/api/api_result.dart';
import 'package:widyu/core/model/myPage/code/family_code.dart';
import 'package:widyu/feature/management/management_ui_event.dart';
import 'package:widyu/feature/management/management_ui_state.dart';

class ManagementViewModel with ChangeNotifier {
  final MyPageRepository _repository;

  ManagementUiState _uiState = const ManagementUiState();
  ManagementUiState get uiState => _uiState;

  final _uiEvent = StreamController<ManagementUiEvent>.broadcast();
  Stream<ManagementUiEvent> get uiEvent => _uiEvent.stream;

  ManagementViewModel({required MyPageRepository repository})
      : _repository = repository {
    _fetchFamilyCode();
  }

  Future<void> _fetchFamilyCode() async {
    _uiState = _uiState.copyWith(isLoading: true);
    notifyListeners();

    final result = await _repository.fetchFamilyCode();
    if (result is Success) {
      final data = (result as Success<FamilyCode>).data;
      _uiState = _uiState.copyWith(familyCode: data.familyCode);
    } else {
      _uiEvent.add(const FetchFamilyCodeFailure());
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
