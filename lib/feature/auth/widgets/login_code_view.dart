import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:widyu/app/routes/app_route.dart';
import 'package:widyu/core/ui/theme/colors.dart';
import 'package:widyu/core/ui/theme/typos.dart';
import 'package:widyu/core/utils/app_service_controller.dart';
import 'package:widyu/core/utils/show_toast.dart';
import 'package:widyu/core/ui/widgets/widyu_text_button.dart';
import 'package:widyu/feature/auth/login_ui_state.dart';
import 'package:widyu/feature/auth/login_view_model.dart';
import 'package:widyu/feature/auth/widgets/login_base_view.dart';

class LoginCodeView extends StatelessWidget {
  const LoginCodeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginViewModel>(builder: (context, viewModel, child) {
      return LoginBaseView(
        title: '초대숫자로 로그인해요',
        description: '보호자 계정에서 생성된 초대숫자로 로그인해 주세요.',
        onBack: () {
          if (viewModel.canGetPhoneNumber) {
            viewModel.changeState(const LoginPhoneState());
            context.pop();
          } else {
            viewModel.resetCode();
            viewModel.changeState(const LoginPhoneState());
          }
        },
        btn: WidyuTextButton(
          onTap: () {
            viewModel.login(
              onSuccess: () {
                unawaited(context.read<AppServiceController>().start());
                context.go(AppRoute.home.path);
              },
              onFailure: (error) {
                showToast(error);
              },
            );
          },
          text: '로그인',
          enable: !viewModel.state.isLoading &&
              viewModel.state.error == null &&
              viewModel.codeController.text.length ==
                  LoginViewModel.inviteCodeLength,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 58),
            Column(
              spacing: 12,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Row(
                      spacing: 8,
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(
                        LoginViewModel.inviteCodeLength,
                        (index) {
                          final code = viewModel.codeController.text;
                          return Container(
                            width: 42,
                            height: 58,
                            decoration: BoxDecoration(
                              color: viewModel.state.error != null
                                  ? MyColor.orange100
                                  : MyColor.grey100,
                              borderRadius: BorderRadius.circular(3),
                              border: Border.all(
                                  color: viewModel.state.error != null
                                      ? MyColor.red
                                      : MyColor.grey200),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              index < code.length ? code[index] : '',
                              style: MyTypo.largeTitle
                                  .copyWith(color: MyColor.black, height: 1),
                            ),
                          );
                        },
                      ),
                    ),
                    Positioned.fill(
                      child: TextField(
                        controller: viewModel.codeController,
                        maxLength: LoginViewModel.inviteCodeLength,
                        keyboardType: TextInputType.number,
                        autofillHints: const [AutofillHints.oneTimeCode],
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        showCursor: false,
                        enableInteractiveSelection: false,
                        style: const TextStyle(color: Colors.transparent),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          counterText: '',
                        ),
                      ),
                    ),
                  ],
                ),
                if (viewModel.state.error != null)
                  Text(
                    viewModel.state.error!.message,
                    style: MyTypo.helper2.copyWith(
                      color: MyColor.red,
                    ),
                  ),
              ],
            ),
          ],
        ),
      );
    });
  }
}
