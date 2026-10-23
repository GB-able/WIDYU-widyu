import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_phone_number/get_phone_number.dart';
import 'package:widyu/core/data/repository/auth/auth_repository.dart';
import 'package:widyu/core/model/api/api_result.dart';
import 'package:widyu/core/model/permission/permission_type.dart';
import 'package:widyu/core/utils/permission_manager.dart';
import 'package:widyu/feature/auth/login_ui_state.dart';

class LoginViewModel with ChangeNotifier {
  final AuthRepository _authRepository;
  static const int inviteCodeLength = 7;

  bool _canGetPhoneNumber = false;
  bool _isDisposed = false;
  bool _isGettingPhoneNumber = false;
  final List<TextEditingController> codeControllers =
      List.generate(inviteCodeLength, (_) => TextEditingController());
  final List<FocusNode> codeFocusNodes =
      List.generate(inviteCodeLength, (_) => FocusNode());
  final TextEditingController phoneController = TextEditingController();

  bool get canGetPhoneNumber => _canGetPhoneNumber;
  LoginUiState _state = const LoginPhoneState(isLoading: true);
  String? _phoneNumber;
  final List<String> _prevCodes = List.generate(7, (_) => '');
  int _loginFailedCount = 0;

  LoginUiState get state => _state;

  String? get phoneNumber => _phoneNumber;

  LoginViewModel({
    required AuthRepository authRepository,
  }) : _authRepository = authRepository {
    for (int i = 0; i < codeControllers.length; i++) {
      final index = i;
      codeControllers[index].addListener(() {
        final currentValue = codeControllers[index].text;
        final previousValue = _prevCodes[index];

        if (currentValue.isEmpty && previousValue.isNotEmpty && index > 0) {
          codeFocusNodes[index - 1].requestFocus();
          codeControllers[index - 1].selection = TextSelection.fromPosition(
            TextPosition(offset: codeControllers[index - 1].text.length),
          );
        } else if (currentValue.isNotEmpty &&
            previousValue.isEmpty &&
            index < inviteCodeLength - 1) {
          codeFocusNodes[index + 1].requestFocus();
        }

        _prevCodes[index] = currentValue;

        changeState(const LoginCodeState());
        notifyListeners();
      });
    }

    phoneController.addListener(() {
      notifyListeners();
    });

    unawaited(getPhoneNumber());
  }

  @override
  void dispose() {
    _isDisposed = true;
    for (var controller in codeControllers) {
      controller.dispose();
    }
    for (var focusNode in codeFocusNodes) {
      focusNode.dispose();
    }
    phoneController.dispose();
    super.dispose();
  }

  String _formatPhoneNumber(String phoneNumber) {
    return phoneNumber.replaceAll(RegExp(r'[^\d]'), '');
  }

  /// 화면 진입 시 전화 권한을 확인해 번호를 자동 입력한다.
  ///
  /// 아직 묻지 않은 상태(denied)면 한 번만 요청하고, 영구 거절·미지원·제한
  /// 상태는 요청 없이 수동 입력을 유지한다. 영구 거절 시 다시 묻지 않는 것은
  /// request()를 호출하지 않는 것으로 충족되므로 별도 플래그가 필요 없다.
  Future<void> getPhoneNumber() async {
    if (_isDisposed || _isGettingPhoneNumber) return;
    _isGettingPhoneNumber = true;
    try {
      var result = await PermissionManager.status(PermissionType.phone);
      if (_isDisposed) return;
      if (result == PermissionRequestResult.denied) {
        result = await PermissionManager.request(PermissionType.phone);
        if (_isDisposed) return;
      }
      if (result != PermissionRequestResult.granted) {
        _state = const LoginPhoneState();
        _canGetPhoneNumber = false;
        notifyListeners();
        return;
      }

      final phoneNumber = await GetPhoneNumber().getPhoneNumber();
      if (_isDisposed) return;
      final formattedPhone = _formatPhoneNumber(phoneNumber);
      if (formattedPhone.isNotEmpty) {
        setPhoneNumber(formattedPhone);
        _state = const LoginCodeState();
        _canGetPhoneNumber = true;
      } else {
        throw Exception('전화번호를 가져오지 못했습니다');
      }
    } catch (_) {
      if (_isDisposed) return;
      _state = const LoginPhoneState();
      _canGetPhoneNumber = false;
    } finally {
      _isGettingPhoneNumber = false;
    }
    if (!_isDisposed) notifyListeners();
  }

  void setPhoneNumber(String phoneNumber) {
    _phoneNumber = _formatPhoneNumber(phoneNumber);
    changeState(const LoginCodeState());
    notifyListeners();
  }

  void resetPhone() {
    _phoneNumber = null;
    phoneController.clear();
    notifyListeners();
  }

  void resetCode() {
    for (var controller in codeControllers) {
      controller.clear();
    }
    for (int i = 0; i < _prevCodes.length; i++) {
      final index = i;
      _prevCodes[index] = '';
    }
    notifyListeners();
  }

  void changeState(LoginUiState state) {
    _state = state;
    notifyListeners();
  }

  Future<void> login({
    required void Function() onSuccess,
    required void Function(String error) onFailure,
  }) async {
    assert(_phoneNumber != null && _phoneNumber!.isNotEmpty);

    final inviteCode = codeControllers.map((c) => c.text).join();
    assert(inviteCode.length == inviteCodeLength);

    final result = await _authRepository.login(inviteCode, _phoneNumber!);
    switch (result) {
      case Success():
        onSuccess();
      case Failure(statusCode: 404):
        changeState(LoginCodeState(
            error: ++_loginFailedCount < 3
                ? LoginError.loginFailed
                : LoginError.loginFailedALot));
      case Failure():
        onFailure('로그인 실패. 잠시 후 다시 시도하세요');
    }
    notifyListeners();
  }
}
