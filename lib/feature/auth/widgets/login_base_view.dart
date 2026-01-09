import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:widyu/core/ui/theme/colors.dart';
import 'package:widyu/core/ui/theme/typos.dart';
import 'package:widyu/core/ui/widgets/icon_widget.dart';
import 'package:widyu/feature/auth/login_view_model.dart';

class LoginBaseView extends StatelessWidget {
  const LoginBaseView({
    super.key,
    required this.title,
    required this.description,
    required this.onBack,
    required this.btn,
    required this.child,
  });

  final String title;
  final String description;
  final VoidCallback onBack;
  final Widget btn;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginViewModel>(
      builder: (context, viewModel, _) {
        return Stack(
          children: [
            Scaffold(
              backgroundColor: MyColor.white,
              appBar: AppBar(
                leading: GestureDetector(
                  onTap: onBack,
                  child: const Padding(
                    padding: EdgeInsets.only(left: 16),
                    child: IconWidget(
                      icon: "back",
                      width: 22,
                      color: MyColor.grey600,
                    ),
                  ),
                ),
                leadingWidth: 38,
                backgroundColor: MyColor.white,
                elevation: 0,
                toolbarHeight: 44,
              ),
              body: GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                },
                behavior: HitTestBehavior.opaque,
                child: SafeArea(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            children: [
                              const SizedBox(height: 28),
                              Text(
                                title,
                                style: MyTypo.title2.copyWith(
                                  color: MyColor.grey800,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                description,
                                style: MyTypo.body1.copyWith(
                                  color: MyColor.grey600,
                                ),
                              ),
                              child,
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: btn,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (viewModel.state.isLoading)
              const Center(
                child: CircularProgressIndicator(),
              ),
          ],
        );
      },
    );
  }
}
