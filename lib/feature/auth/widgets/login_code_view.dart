import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:widyu/app/routes/app_route.dart';
import 'package:widyu/core/theme/colors.dart';
import 'package:widyu/core/theme/typos.dart';
import 'package:widyu/core/utils/show_toast.dart';
import 'package:widyu/core/widgets/text_btn.dart';
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
        btn: TextBtn(
          onTap: () {
            viewModel.login(
              onSuccess: () {
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
              viewModel.codeControllers.every(
                (controller) => controller.text.isNotEmpty,
              ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 58),
            Column(
              spacing: 12,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  spacing: 8,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(
                    7,
                    (index) => Container(
                      constraints: const BoxConstraints(maxWidth: 42),
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
                      child: TextField(
                        controller: viewModel.codeControllers[index],
                        focusNode: viewModel.codeFocusNodes[index],
                        textAlign: TextAlign.center,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                          counterText: '',
                        ),
                        maxLength: 1,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        style: MyTypo.largeTitle.copyWith(
                            color: MyColor.black,
                            height: 1,
                            textBaseline: TextBaseline.alphabetic),
                      ),
                    ),
                  ),
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
