import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:widyu/core/data/repository/incident/incident_repository.dart';
import 'package:widyu/core/notification/safety_push_manager.dart';
import 'package:widyu/core/ui/theme/colors.dart';
import 'package:widyu/core/ui/theme/typos.dart';
import 'package:widyu/core/ui/widgets/ui_event_listener.dart';
import 'package:widyu/core/ui/widgets/widyu_asset_image.dart';
import 'package:widyu/core/ui/widgets/widyu_icon.dart';
import 'package:widyu/core/utils/show_toast.dart';
import 'package:widyu/feature/safety_check/safety_check_ui_event.dart';
import 'package:widyu/feature/safety_check/safety_check_ui_state.dart';
import 'package:widyu/feature/safety_check/safety_check_view_model.dart';

part 'widgets/safety_check_content.dart';
part 'widgets/safety_check_result_content.dart';
part 'widgets/slide_button.dart';

class SafetyCheckScreen extends StatelessWidget {
  const SafetyCheckScreen({super.key, required this.incidentId});

  final String incidentId;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SafetyCheckViewModel(
        repository: context.read<IncidentRepository>(),
        incidentId: incidentId,
      )..start(),
      child: const _SafetyCheckView(),
    );
  }
}

class _SafetyCheckView extends StatelessWidget {
  const _SafetyCheckView();

  void _handleEvent(BuildContext context, SafetyCheckUiEvent event) {
    switch (event) {
      case RespondFailure():
        showToast('응답을 보내지 못했어요. 다시 시도해 주세요.');
      case CloseScreen():
        SafetyPushManager.releaseLockScreen();
        if (context.canPop()) context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<SafetyCheckViewModel>();
    final phase = context.select<SafetyCheckViewModel, SafetyCheckPhase>(
        (vm) => vm.uiState.phase);

    return UiEventListener(
      stream: viewModel.uiEvent,
      onEvent: (event) => _handleEvent(context, event),
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: PopScope(
          canPop: false,
          child: Scaffold(
            backgroundColor: MyColor.dim,
            body: Stack(
              children: [
                SafeArea(
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 24),
                      child: Image.asset('assets/images/img_64_logo.png',
                          width: 64, fit: BoxFit.contain),
                    ),
                  ),
                ),
                Center(
                  child: switch (phase) {
                    SafetyCheckPhase.confirm =>
                      _SafetyCheckContent(onCancel: viewModel.respondOk),
                    SafetyCheckPhase.okay => const _SafetyCheckResultContent(
                        title: '괜찮다고 보호자에게\n전해드렸어요.',
                        description: '괜찮으시면 시간 안에 누르지 않으면\n보호자에게 알려드려요.',
                      ),
                    SafetyCheckPhase.notOkay => const _SafetyCheckResultContent(
                        title: '보호자에게 알렸어요.',
                        description: '연락을 기다리는 동안 안전한 곳에서\n잠시 기다려주세요.',
                      ),
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
