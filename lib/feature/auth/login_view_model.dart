import 'package:flutter/material.dart';
import 'package:get_phone_number/get_phone_number.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:widyu/core/data/repository/auth/auth_repository.dart';
import 'package:widyu/core/model/api/api_result.dart';
import 'package:widyu/feature/auth/login_ui_state.dart';

class LoginViewModel with ChangeNotifier {
  final AuthRepository _authRepository;
  static const int inviteCodeLength = 7;

  bool _canGetPhoneNumber = false;
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

  LoginViewModel({required AuthRepository authRepository})
      : _authRepository = authRepository {
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

        changeState(const LoginCodeState(error: null));
        notifyListeners();
      });
    }

    phoneController.addListener(() {
      notifyListeners();
    });

    getPhoneNumber();
  }

  @override
  void dispose() {
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

  void getPhoneNumber() async {
    try {
      final status = await Permission.phone.request();
      if (!status.isGranted) {
        throw Exception('전화번호 권한이 없습니다');
      }

      final phoneNumber = await GetPhoneNumber().getPhoneNumber();
      debugPrint('전화번호: $phoneNumber');
      final formattedPhone = _formatPhoneNumber(phoneNumber);
      if (formattedPhone.isNotEmpty) {
        setPhoneNumber(formattedPhone);
        _state = const LoginCodeState();
        _canGetPhoneNumber = true;
      } else {
        throw Exception('전화번호를 가져오지 못했습니다');
      }
    } catch (e) {
      _state = const LoginPhoneState();
      _canGetPhoneNumber = false;
    }
    notifyListeners();
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
        onFailure("로그인 실패. 잠시 후 다시 시도하세요");
    }
    notifyListeners();
  }
}
