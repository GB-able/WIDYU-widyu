import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:widyu/core/ui/theme/colors.dart';
import 'package:widyu/core/ui/theme/typos.dart';
import 'package:widyu/core/ui/widgets/custom_text_field.dart';
import 'package:widyu/core/ui/widgets/widyu_text_button.dart';
import 'package:widyu/core/utils/phone_formatter.dart';
import 'package:widyu/feature/auth/widgets/login_base_view.dart';

class LoginPhoneView extends StatelessWidget {
  const LoginPhoneView({
    super.key,
    required this.controller,
    required this.isLoading,
    required this.onBack,
    required this.onSubmit,
  });

  final TextEditingController controller;
  final bool isLoading;
  final VoidCallback onBack;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return LoginBaseView(
      title: '전화번호로 로그인해요',
      description: '보호자 계정에서 등록한 전화번호를 입력해주세요.',
      onBack: onBack,
      isLoading: isLoading,
      btn: WidyuTextButton(
          onTap: onSubmit,
          text: '완료',
          enable: controller.text.isNotEmpty && controller.text.length == 13),
      child: Column(
        children: [
          const SizedBox(height: 27),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 4,
            children: [
              Text(
                '전화번호',
                style: MyTypo.subTitle2.copyWith(
                  color: MyColor.grey700,
                ),
              ),
              CustomTextField(
                controller: controller,
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
  }
}
