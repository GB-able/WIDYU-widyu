import 'package:flutter/material.dart';
import 'package:widyu/core/data/repository/myPage/my_page_repository.dart';
import 'package:widyu/core/model/api/api_result.dart' as api;
import 'package:widyu/core/model/myPage/user.dart';
import 'package:widyu/feature/myPage/my_page_ui_state.dart';

class MyPageViewModel with ChangeNotifier {
  final MyPageRepository _repository;

  MyPageUiState _uiState = const Loading();
  MyPageUiState get uiState => _uiState;

  MyPageViewModel({required MyPageRepository repository})
      : _repository = repository {
    _fetchUser();
  }

  Future<void> _fetchUser() async {
    _uiState = const Loading();
    notifyListeners();

    final result = await _repository.fetchUser();
    if (result is api.Success) {
      final user = (result as api.Success<User>).data;
      _uiState = Success(
        profileImage: user.profileImage,
        name: user.name,
        points: user.points,
      );
    } else {
      _uiState = const Failure();
    }
    notifyListeners();
  }
}
