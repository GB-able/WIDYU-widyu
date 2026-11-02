import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:widyu/app/routes/app_route.dart';
import 'package:widyu/core/di/providers.dart';
import 'package:widyu/core/utils/show_toast.dart';
import 'package:widyu/feature/auth/login_ui_state.dart';
import 'package:widyu/feature/auth/login_view_model.dart';
import 'package:widyu/feature/auth/widgets/login_code_view.dart';
import 'package:widyu/feature/auth/widgets/login_phone_view.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _codeController = TextEditingController();
  final _phoneController = TextEditingController();
  // 입력이 바뀔 때마다 화면을 다시 그린다(입력값은 상태가 아니라 컨트롤러에 있다).
  late final _inputs = Listenable.merge([_codeController, _phoneController]);
  String _prevCode = '';

  @override
  void initState() {
    super.initState();
    _codeController.addListener(_onCodeChanged);
  }

  @override
  void dispose() {
    _codeController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _onCodeChanged() {
    final text = _codeController.text;
    final end = TextSelection.collapsed(offset: text.length);
    if (_codeController.selection != end) _codeController.selection = end;
    if (text == _prevCode) return;
    _prevCode = text;
    ref
        .read(loginViewModelProvider.notifier)
        .changeState(const LoginCodeState());
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(loginViewModelProvider.notifier);
    final state = ref.watch(loginViewModelProvider);

    return ListenableBuilder(
      listenable: _inputs,
      builder: (context, _) => switch (state) {
        LoginPhoneState() => LoginPhoneView(
            controller: _phoneController,
            isLoading: state.isLoading,
            onBack: () {
              viewModel.resetPhone();
              _phoneController.clear();
              context.pop();
            },
            onSubmit: () {
              viewModel.setPhoneNumber(_phoneController.text);
              viewModel.changeState(const LoginCodeState());
            },
          ),
        LoginCodeState() => LoginCodeView(
            controller: _codeController,
            isLoading: state.isLoading,
            error: state.error,
            onBack: () => viewModel.backFromCode(
              close: context.pop,
              clearCode: _codeController.clear,
            ),
            onLogin: () => viewModel.login(
              _codeController.text,
              onSuccess: () {
                unawaited(ref.read(appServiceControllerProvider).start());
                context.go(AppRoute.home.path);
              },
              onFailure: showToast,
            ),
          ),
      },
    );
  }
}
