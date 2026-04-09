import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:widyu/core/data/repository/auth/auth_repository.dart';
import 'package:widyu/feature/auth/login_ui_state.dart';
import 'package:widyu/feature/auth/login_view_model.dart';
import 'package:widyu/feature/auth/widgets/login_code_view.dart';
import 'package:widyu/feature/auth/widgets/login_phone_view.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LoginViewModel(
        authRepository: context.read<AuthRepository>(),
      ),
      child: Consumer<LoginViewModel>(builder: (context, viewModel, child) {
        final state = viewModel.state;
        return switch (state) {
          LoginPhoneState() => const LoginPhoneView(),
          LoginCodeState() => const LoginCodeView(),
        };
      }),
    );
  }
}
