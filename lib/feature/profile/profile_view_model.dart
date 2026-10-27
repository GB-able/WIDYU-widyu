import 'dart:async';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:widyu/core/data/repository/myPage/my_page_repository.dart';
import 'package:widyu/core/model/api/api_result.dart';
import 'package:widyu/core/model/myPage/profile/user_profile.dart';
import 'package:widyu/feature/profile/profile_ui_event.dart';
import 'package:widyu/feature/profile/profile_ui_state.dart';

class ProfileViewModel with ChangeNotifier {
  final MyPageRepository _repository;

  ProfileUiState _uiState = const ProfileUiState();
  ProfileUiState get uiState => _uiState;

  final _uiEvent = StreamController<ProfileUiEvent>.broadcast();
  Stream<ProfileUiEvent> get uiEvent => _uiEvent.stream;

  ProfileViewModel({required MyPageRepository repository})
      : _repository = repository {
    _fetchUserProfile();
  }

  Future<void> updateName(String newName) async {
    final oldName = _uiState.name;
    if (newName == oldName) return;

    _uiState = _uiState.copyWith(name: newName);
    notifyListeners();

    final result = await _repository.updateName(newName);
    if (result is Failure) {
      _uiState = _uiState.copyWith(name: oldName);
      notifyListeners();
      _uiEvent.add(const UpdateNameFailure());
    }
  }

  Future<void> updateProfileImage(File file) async {
    final result = await _repository.updateProfileImage(file);

    if (result is Success) {
      await _fetchUserProfile();
    } else {
      _uiEvent.add(const UpdateProfileImageFailure());
    }
  }

  Future<void> _fetchUserProfile() async {
    _uiState = _uiState.copyWith(isLoading: true);
    notifyListeners();

    final result = await _repository.fetchUserProfile();
    if (result is Success) {
      final user = (result as Success<UserProfile>).data;
      _uiState = _uiState.copyWith(
        profileImage: user.profileImage ?? '',
        name: user.name,
        birthDate: user.birthDate.replaceAll('-', '.'),
        phoneNumber: user.phoneNumber,
        address: user.address,
        inviteCode: user.inviteCode,
      );
    } else {
      _uiEvent.add(const FetchProfileFailure());
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
