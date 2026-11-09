import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:widyu/core/ui/theme/colors.dart';
import 'package:widyu/core/ui/theme/typos.dart';
import 'package:widyu/core/ui/widgets/widyu_text_button.dart';
import 'package:widyu/feature/auth/login_ui_state.dart';
import 'package:widyu/feature/auth/login_view_model.dart';
import 'package:widyu/feature/auth/widgets/login_base_view.dart';

class LoginCodeView extends StatelessWidget {
  const LoginCodeView({
    super.key,
    required this.controller,
    required this.isLoading,
    required this.error,
    required this.onBack,
    required this.onLogin,
  });

  final TextEditingController controller;
  final bool isLoading;
  final LoginError? error;
  final VoidCallback onBack;
  final VoidCallback onLogin;

  @override
  Widget build(BuildContext context) {
    return LoginBaseView(
      title: '초대숫자로 로그인해요',
      description: '보호자 계정에서 생성된 초대숫자로 로그인해 주세요.',
      onBack: onBack,
      isLoading: isLoading,
      btn: WidyuTextButton(
        onTap: onLogin,
        text: '로그인',
        enable: !isLoading &&
            error == null &&
            controller.text.length == LoginViewModel.inviteCodeLength,
      ),
      child: Column(
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
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(
                      LoginViewModel.inviteCodeLength,
                      (index) {
                        final code = controller.text;
                        return Container(
                          width: 42,
                          height: 58,
                          decoration: BoxDecoration(
                            color: error != null
                                ? MyColor.orange100
                                : MyColor.grey100,
                            borderRadius: BorderRadius.circular(3),
                            border: Border.all(
                                color: error != null
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
                      controller: controller,
                      autofocus: true,
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
              if (error case final error?)
                Text(
                  error.message,
                  style: MyTypo.helper2.copyWith(
                    color: MyColor.red,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
