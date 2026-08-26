import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:widyu/core/ui/theme/colors.dart';
import 'package:widyu/core/ui/theme/typos.dart';
import 'package:widyu/core/utils/phone_formatter.dart';
import 'package:widyu/core/ui/widgets/custom_text_field.dart';
import 'package:widyu/core/ui/widgets/widyu_text_button.dart';
import 'package:widyu/feature/auth/login_ui_state.dart';
import 'package:widyu/feature/auth/login_view_model.dart';
import 'package:widyu/feature/auth/widgets/login_base_view.dart';

class LoginPhoneView extends StatelessWidget {
  const LoginPhoneView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginViewModel>(builder: (context, viewModel, _) {
      return LoginBaseView(
        title: '전화번호로 로그인해요',
        description: '보호자 계정에서 등록한 전화번호를 입력해주세요.',
        onBack: () {
          viewModel.resetPhone();
          context.pop();
        },
        btn: WidyuTextButton(
            onTap: () {
              viewModel.setPhoneNumber(viewModel.phoneController.text);
              viewModel.changeState(const LoginCodeState());
            },
            text: '완료',
            enable: viewModel.phoneController.text.isNotEmpty &&
                viewModel.phoneController.text.length == 13),
        child: Column(
          children: [
            const SizedBox(height: 27),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 4,
              children: [
                Text(
                  "전화번호",
                  style: MyTypo.subTitle2.copyWith(
                    color: MyColor.grey700,
                  ),
                ),
                CustomTextField(
                  controller: viewModel.phoneController,
                  hintText: '전화번호를 입력해주세요',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '전화번호를 입력해주세요';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    PhoneFormatter(),
                  ],
                  maxLength: 13,
                ),
              ],
            )
          ],
        ),
      );
    });
  }
}
