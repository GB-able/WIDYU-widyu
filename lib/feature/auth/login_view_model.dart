import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:get_phone_number/get_phone_number.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:widyu/core/data/repository/auth/auth_repository.dart';
import 'package:widyu/core/di/providers.dart';
import 'package:widyu/core/log/log.dart';
import 'package:widyu/core/model/api/api_result.dart';
import 'package:widyu/core/model/permission/permission_type.dart';
import 'package:widyu/core/utils/permission_manager.dart';
import 'package:widyu/feature/auth/login_ui_state.dart';

part 'login_view_model.g.dart';

@riverpod
class LoginViewModel extends _$LoginViewModel {
  static const int inviteCodeLength = 7;

  bool _canGetPhoneNumber = false;
  bool _isGettingPhoneNumber = false;
  String? _phoneNumber;
  int _loginFailedCount = 0;

  AuthRepository get _authRepository => ref.read(authRepositoryProvider);

  @override
  LoginUiState build() {
    unawaited(Future.microtask(_getPhoneNumber));
    return const LoginPhoneState(isLoading: true);
  }

  String _formatPhoneNumber(String phoneNumber) {
    return phoneNumber.replaceAll(RegExp(r'[^\d]'), '');
  }

  /// 화면 진입 시 전화 권한을 확인해 번호를 자동 입력한다.
  ///
  /// 아직 묻지 않은 상태(denied)면 한 번만 요청하고, 영구 거절·미지원·제한
  /// 상태는 요청 없이 수동 입력을 유지한다. 영구 거절 시 다시 묻지 않는 것은
  /// request()를 호출하지 않는 것으로 충족되므로 별도 플래그가 필요 없다.
  Future<void> _getPhoneNumber() async {
    if (!ref.mounted || _isGettingPhoneNumber) return;
    _isGettingPhoneNumber = true;
    try {
      var result = await PermissionManager.status(PermissionType.phone);
      if (!ref.mounted) return;
      if (result == PermissionRequestResult.denied) {
        result = await PermissionManager.request(PermissionType.phone);
        if (!ref.mounted) return;
      }
      if (result != PermissionRequestResult.granted) {
        state = const LoginPhoneState();
        _canGetPhoneNumber = false;
        return;
      }

      final phoneNumber = await GetPhoneNumber().getPhoneNumber();
      if (!ref.mounted) return;
      final formattedPhone = _formatPhoneNumber(phoneNumber);
      if (formattedPhone.isNotEmpty) {
        setPhoneNumber(formattedPhone);
        _canGetPhoneNumber = true;
      } else {
        throw Exception('전화번호를 가져오지 못했습니다');
      }
    } catch (_) {
      if (!ref.mounted) return;
      state = const LoginPhoneState();
      _canGetPhoneNumber = false;
    } finally {
      _isGettingPhoneNumber = false;
    }
  }

  void setPhoneNumber(String phoneNumber) {
    _phoneNumber = _formatPhoneNumber(phoneNumber);
    changeState(const LoginCodeState());
  }

  void resetPhone() {
    _phoneNumber = null;
  }

  void changeState(LoginUiState state) {
    this.state = state;
  }

  /// 초대숫자 화면에서 뒤로 간다. 전화번호를 자동으로 가져왔다면 로그인 화면을 닫고,
  /// 아니면 입력한 초대숫자를 지우고 전화번호 입력으로 돌아간다.
  /// 초대숫자를 지우면 입력 변경으로 초대숫자 상태가 되므로, 지운 뒤에 상태를 바꾼다.
  void backFromCode({
    required VoidCallback close,
    required VoidCallback clearCode,
  }) {
    if (_canGetPhoneNumber) {
      changeState(const LoginPhoneState());
      close();
    } else {
      clearCode();
      changeState(const LoginPhoneState());
    }
  }

  Future<void> login(
    String inviteCode, {
    required void Function() onSuccess,
    required void Function(String error) onFailure,
  }) async {
    assert(_phoneNumber != null && _phoneNumber!.isNotEmpty);
    assert(inviteCode.length == inviteCodeLength);

    final result = await _authRepository.login(inviteCode, _phoneNumber!);
    if (!ref.mounted) return;
    switch (result) {
      case Success():
        WiduLog.ui.i('로그인 성공');
        onSuccess();
      case Failure(statusCode: 404):
        changeState(LoginCodeState(
            error: ++_loginFailedCount < 3
                ? LoginError.loginFailed
                : LoginError.loginFailedALot));
      case Failure():
        onFailure('로그인 실패. 잠시 후 다시 시도하세요');
    }
  }
}
