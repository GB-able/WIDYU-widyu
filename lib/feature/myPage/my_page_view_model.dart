import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:widyu/core/data/repository/myPage/my_page_repository.dart';
import 'package:widyu/core/model/api/api_result.dart' as api;
import 'package:widyu/core/model/myPage/user/user.dart';
import 'package:widyu/feature/myPage/my_page_ui_state.dart';

class MyPageViewModel with ChangeNotifier {
  final MyPageRepository _repository;

  MyPageUiState _uiState = const Loading();
  MyPageUiState get uiState => _uiState;

  String _appVersion = '';
  String get appVersion => _appVersion;

  MyPageViewModel({required MyPageRepository repository})
      : _repository = repository {
    fetchUser();
    _fetchAppVersion();
  }

  Future<void> fetchUser() async {
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

  Future<void> _fetchAppVersion() async {
    final info = await PackageInfo.fromPlatform();
    _appVersion = info.version;
    notifyListeners();
  }
}
