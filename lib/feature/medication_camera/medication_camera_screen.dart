import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:widyu/core/data/repository/goal/medication_repository.dart';
import 'package:widyu/core/data/repository/point/point_repository.dart';
import 'package:widyu/core/ui/theme/colors.dart';
import 'package:widyu/core/ui/theme/typos.dart';
import 'package:widyu/core/ui/widgets/custom_dialog.dart';
import 'package:widyu/core/ui/widgets/ui_event_listener.dart';
import 'package:widyu/core/ui/widgets/widu_icon.dart';
import 'package:widyu/core/utils/show_toast.dart';
import 'package:widyu/feature/medication_camera/medication_camera_ui_event.dart';
import 'package:widyu/feature/medication_camera/medication_camera_ui_state.dart';
import 'package:widyu/feature/medication_camera/medication_camera_view_model.dart';
import 'package:widyu/gen/assets.gen.dart';

part 'widgets/camera_capture_view.dart';
part 'widgets/medication_camera_app_bar.dart';

/// 앱 바, 시스템 바, 하단 버튼 영역에 깔아 뒤의 카메라 화면이 비쳐 보이게 하는 반투명 배경
const _scrimColor = Color(0x80000000);

const _systemOverlayStyle = SystemUiOverlayStyle(
  statusBarColor: Colors.transparent,
  statusBarIconBrightness: Brightness.light,
  statusBarBrightness: Brightness.dark,
  systemNavigationBarColor: _scrimColor,
  systemNavigationBarIconBrightness: Brightness.light,
  systemNavigationBarContrastEnforced: false,
);

class MedicationCameraScreen extends StatelessWidget {
  const MedicationCameraScreen({super.key, required this.group});
  final Map<String, dynamic> group;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MedicationCameraViewModel(
        medicationRepository: context.read<MedicationRepository>(),
        pointRepository: context.read<PointRepository>(),
        group: group,
      )..load(),
      child: const _MedicationCameraView(),
    );
  }
}

class _MedicationCameraView extends StatefulWidget {
  const _MedicationCameraView();

  @override
  State<_MedicationCameraView> createState() => _MedicationCameraViewState();
}

class _MedicationCameraViewState extends State<_MedicationCameraView>
    with WidgetsBindingObserver {
  MedicationCameraViewModel get _viewModel =>
      context.read<MedicationCameraViewModel>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state != AppLifecycleState.resumed ||
        !_viewModel.uiState.isPermissionDenied) {
      return;
    }
    final status = await Permission.camera.status;
    if (mounted) _viewModel.setPermissionDenied(!status.isGranted);
  }

  void _handleCameraFailure() {
    showToast('카메라를 실행할 수 없어요. 잠시 후 다시 시도해 주세요.');
    context.pop();
  }

  Future<void> _showNotice(String message) async {
    await showDialog<void>(
      context: context,
      builder: (_) => CustomDialog(title: message),
    );
    if (mounted) context.pop();
  }

  Future<void> _handleEvent(MedicationCameraUiEvent event) async {
    switch (event) {
      case OccurrenceNotFound():
        await _showNotice('존재하지 않는 복약 일정이에요.');
      case VerifyWindowClosed():
        await _showNotice('인증 가능 시간이 지났어요.');
      case VerifySuccess(:final result):
        context.pop(result);
      case VerifyFailure(:final reason):
        if (!kDebugMode) {
          showToast('복용 인증에 실패했어요.');
          return;
        }
        await showDialog<void>(
          context: context,
          builder: (_) =>
              CustomDialog(title: '복용 인증에 실패했어요.', description: reason),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final uiState =
        context.select<MedicationCameraViewModel, MedicationCameraUiState>(
            (vm) => vm.uiState);

    return UiEventListener(
      stream: _viewModel.uiEvent,
      onEvent: _handleEvent,
      child: PopScope(
        canPop: !uiState.isBusy,
        child: AnnotatedRegion<SystemUiOverlayStyle>(
          value: _systemOverlayStyle,
          child: Scaffold(
            backgroundColor: MyColor.black,
            extendBodyBehindAppBar: true,
            appBar: _MedicationCameraAppBar(enabled: !uiState.isBusy),
            body: Stack(
              fit: StackFit.expand,
              children: [
                _buildBody(uiState),
                if (uiState.isBusy)
                  const AbsorbPointer(
                    child: ColoredBox(
                      color: _scrimColor,
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(MedicationCameraUiState uiState) {
    if (uiState.isPermissionDenied) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('카메라 권한이 필요해요.',
                style: MyTypo.body1.copyWith(color: MyColor.white)),
            const TextButton(onPressed: openAppSettings, child: Text('설정 열기')),
          ],
        ),
      );
    }
    if (!uiState.isReady) {
      return const Center(child: CircularProgressIndicator());
    }
    return _CameraCaptureView(
      doseLabel: _viewModel.doseLabel,
      onCaptured: (path) => _viewModel.submit(File(path)),
      onPermissionDenied: () => _viewModel.setPermissionDenied(true),
      onFailure: _handleCameraFailure,
    );
  }
}
