import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:widyu/app/routes/app_route.dart';
import 'package:widyu/core/model/location/location_service_state.dart';
import 'package:widyu/core/ui/theme/colors.dart';
import 'package:widyu/core/ui/theme/typos.dart';
import 'package:widyu/core/ui/widgets/ui_event_listener.dart';
import 'package:widyu/core/ui/widgets/widyu_text_button.dart';
import 'package:widyu/core/ui/widgets/permission_recovery_dialog.dart';
import 'package:widyu/core/utils/app_service_controller.dart';
import 'package:widyu/core/utils/show_toast.dart';
import 'package:widyu/core/model/permission/permission_recovery_prompt.dart';
import 'package:widyu/core/model/permission/permission_type.dart';
import 'package:widyu/feature/permission/permission_ui_model.dart';
import 'package:widyu/feature/locationSetup/location_setup_ui_event.dart';
import 'package:widyu/feature/locationSetup/location_setup_ui_state.dart';
import 'package:widyu/feature/locationSetup/location_setup_view_model.dart';

class LocationSetupScreen extends StatelessWidget {
  const LocationSetupScreen({super.key});

  void _handleEvent(BuildContext context, LocationSetupUiEvent event) {
    switch (event) {
      case LocationSetupNavigateHome():
        context.go(AppRoute.home.path);
      case LocationSetupFailure(:final message):
        showToast(message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LocationSetupViewModel(
        serviceController: context.read<AppServiceController>(),
      )..initialize(),
      builder: (context, _) {
        final viewModel = context.read<LocationSetupViewModel>();
        final uiState =
            context.select<LocationSetupViewModel, LocationSetupUiState>(
          (viewModel) => viewModel.uiState,
        );
        final serviceState =
            context.select<AppServiceController, LocationServiceState?>(
          (controller) => controller.state,
        );
        final hasServiceError = context.select<AppServiceController, bool>(
          (controller) => controller.hasServiceError,
        );
        return UiEventListener(
          stream: viewModel.uiEvent,
          onEvent: (event) => _handleEvent(context, event),
          child: Scaffold(
            backgroundColor: MyColor.white,
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Spacer(),
                    Text('위치 공유를 설정해 주세요', style: MyTypo.title1),
                    const SizedBox(height: 16),
                    Text(
                      '앱을 사용하지 않는 동안에도 보호자에게 위치를 전달해요.\n위치 항상 허용이 필요해요.',
                      style: MyTypo.body2.copyWith(color: MyColor.grey700),
                    ),
                    const SizedBox(height: 20),
                    if (!uiState.isLoading && serviceState != null)
                      Text(
                        hasServiceError
                            ? '위치 공유를 시작하지 못했어요. 다시 시도해 주세요.'
                            : _requirementText(uiState),
                        style: MyTypo.helper2.copyWith(color: MyColor.grey600),
                      ),
                    const Spacer(),
                    WidyuTextButton(
                      text: hasServiceError
                          ? '다시 시도'
                          : !uiState.hasBackgroundLocation
                              ? '위치 권한 설정하기'
                              : !uiState.isLocationServiceEnabled
                                  ? '기기 위치 켜기'
                                  : '설정하기',
                      enable: !uiState.isLoading && !uiState.isConfiguring,
                      onTap: hasServiceError
                          ? viewModel.retry
                          : () => viewModel.configure(
                                showPrompt: (type, mode) =>
                                    _showPrompt(context, type, mode),
                              ),
                    ),
                    const SizedBox(height: 12),
                    Center(
                      child: TextButton(
                        onPressed: uiState.isConfiguring
                            ? null
                            : viewModel.completeLater,
                        child: const Text('나중에'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  String _requirementText(LocationSetupUiState state) {
    if (!state.hasBackgroundLocation) return '위치 항상 허용이 필요해요.';
    if (!state.isLocationServiceEnabled) return '기기의 위치 서비스를 켜 주세요.';
    return '';
  }
}

Future<PermissionRecoveryAction> _showPrompt(
  BuildContext context,
  PermissionType type,
  PermissionRecoveryMode mode,
) =>
    PermissionRecoveryDialog.show(
      context,
      permissionName: type.title,
      description: type.description,
      mode: mode,
    );
