import 'dart:async';
import 'dart:io';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:widyu/core/data/repository/myPage/my_page_repository.dart';
import 'package:widyu/core/data/repository/user/user_repository.dart';
import 'package:widyu/core/di/providers.dart';
import 'package:widyu/core/log/log.dart';
import 'package:widyu/core/model/api/api_result.dart';
import 'package:widyu/core/model/myPage/profile/user_profile.dart';
import 'package:widyu/feature/profile/profile_ui_event.dart';
import 'package:widyu/feature/profile/profile_ui_state.dart';

part 'profile_view_model.g.dart';

@riverpod
class ProfileViewModel extends _$ProfileViewModel {
  final _uiEvent = StreamController<ProfileUiEvent>.broadcast();

  // 일회성 이벤트는 state가 아니라 stream으로 내보낸다.
  // ignore: riverpod_lint/avoid_public_notifier_properties
  Stream<ProfileUiEvent> get uiEvent => _uiEvent.stream;

  MyPageRepository get _repository => ref.read(myPageRepositoryProvider);
  UserRepository get _userRepository => ref.read(userRepositoryProvider);

  @override
  ProfileUiState build() {
    // onDispose는 다시 빌드될 때도 불리므로, 실제로 폐기될 때만 닫는다.
    ref.onDispose(() {
      if (!ref.mounted) _uiEvent.close();
    });
    unawaited(Future.microtask(_fetchUserProfile));
    return const ProfileUiState(isLoading: true);
  }

  Future<void> updateName(String newName) async {
    final oldName = state.name;
    if (newName == oldName) return;

    state = state.copyWith(name: newName);

    final result = await _userRepository.updateName(newName);
    if (!ref.mounted) return;
    if (result is Failure) {
      state = state.copyWith(name: oldName);
      _uiEvent.add(const UpdateNameFailure());
      return;
    }
    WiduLog.ui.i('이름 변경 성공');
  }

  Future<void> updateProfileImage(File file) async {
    final result = await _userRepository.updateProfileImage(file);
    if (!ref.mounted) return;

    if (result is Success) {
      WiduLog.ui.i('프로필 사진 변경 성공');
      await _fetchUserProfile();
    } else {
      _uiEvent.add(const UpdateProfileImageFailure());
    }
  }

  Future<void> _fetchUserProfile() async {
    if (!ref.mounted) return;
    state = state.copyWith(isLoading: true);

    final result = await _repository.fetchUserProfile();
    if (!ref.mounted) return;
    if (result is Success) {
      final user = (result as Success<UserProfile>).data;
      state = state.copyWith(
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
    state = state.copyWith(isLoading: false);
  }
}
