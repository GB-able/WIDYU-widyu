import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:widyu/core/data/provider/medication_alarm_provider.dart';
import 'package:widyu/core/data/provider/point_provider.dart';
import 'package:widyu/core/ui/theme/colors.dart';
import 'package:widyu/core/ui/theme/typos.dart';
import 'package:widyu/core/ui/widgets/ui_event_listener.dart';
import 'package:widyu/core/utils/show_toast.dart';
import 'package:widyu/feature/goal/medication/medication_verification_ui_event.dart';
import 'package:widyu/feature/goal/medication/medication_verification_ui_state.dart';
import 'package:widyu/feature/goal/medication/medication_verification_view_model.dart';

class MedicationVerificationScreen extends StatelessWidget {
  const MedicationVerificationScreen({super.key, required this.group});
  final Map<String, dynamic> group;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MedicationVerificationViewModel(
        medicationAlarmProvider: context.read<MedicationAlarmProvider>(),
        pointProvider: context.read<PointProvider>(),
        group: group,
      ),
      child: const _MedicationVerificationView(),
    );
  }
}

class _MedicationVerificationView extends StatefulWidget {
  const _MedicationVerificationView();

  @override
  State<_MedicationVerificationView> createState() =>
      _MedicationVerificationViewState();
}

class _MedicationVerificationViewState
    extends State<_MedicationVerificationView> with WidgetsBindingObserver {
  CameraController? _cameraController;
  bool _initializing = false;

  MedicationVerificationViewModel get _viewModel =>
      context.read<MedicationVerificationViewModel>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _initializeCamera(request: true);
      await _viewModel.load();
      await _initializeCamera(request: true);
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _disposeCamera();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _initializeCamera();
    } else if (state == AppLifecycleState.inactive) {
      _disposeCamera();
    }
  }

  Future<void> _initializeCamera({bool request = false}) async {
    if (!mounted ||
        _initializing ||
        _viewModel.uiState.photo != null ||
        _cameraController != null) {
      return;
    }
    _initializing = true;
    try {
      final permission = request
          ? await Permission.camera.request()
          : await Permission.camera.status;
      if (!mounted) return;
      _viewModel.setPermissionDenied(!permission.isGranted);
      if (!permission.isGranted || !_viewModel.uiState.isReady) return;
      final cameras = await availableCameras();
      final camera = cameras.firstWhere(
          (camera) => camera.lensDirection == CameraLensDirection.back,
          orElse: () => cameras.first);
      final controller =
          CameraController(camera, ResolutionPreset.high, enableAudio: false);
      _cameraController = controller;
      await controller.initialize();
      if (mounted) setState(() {});
    } finally {
      _initializing = false;
    }
  }

  void _disposeCamera() {
    _cameraController?.dispose();
    _cameraController = null;
  }

  Future<void> _capture() async {
    if (_viewModel.uiState.isBusy ||
        _cameraController?.value.isInitialized != true) {
      return;
    }
    final image = await _cameraController!.takePicture();
    if (mounted) _viewModel.setPhoto(File(image.path));
  }

  Future<void> _handleEvent(MedicationVerificationUiEvent event) async {
    switch (event) {
      case OccurrenceNotFound():
        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: const Text('존재하지 않는 복약 일정이에요.'),
            actions: [
              TextButton(onPressed: context.pop, child: const Text('확인')),
            ],
          ),
        );
        if (mounted) context.pop();
      case VerifySuccess(:final result):
        context.pop(result);
      case VerifyFailure():
        showToast('복용 인증에 실패했어요.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final uiState = context.select<MedicationVerificationViewModel,
        MedicationVerificationUiState>((vm) => vm.uiState);

    return UiEventListener(
      stream: _viewModel.uiEvent,
      onEvent: _handleEvent,
      child: Scaffold(
        backgroundColor: MyColor.black,
        appBar: AppBar(
          backgroundColor: MyColor.black,
          foregroundColor: MyColor.white,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new),
            onPressed: uiState.isBusy ? null : context.pop,
          ),
        ),
        body: _buildBody(uiState),
      ),
    );
  }

  Widget _buildBody(MedicationVerificationUiState uiState) {
    if (uiState.isPermissionDenied) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('카메라 권한 없음',
                style: MyTypo.body1.copyWith(color: MyColor.white)),
            const TextButton(onPressed: openAppSettings, child: Text('설정 열기')),
          ],
        ),
      );
    }
    final photo = uiState.photo;
    if (photo != null) {
      return Column(
        children: [
          Expanded(child: Image.file(photo, fit: BoxFit.cover)),
          ElevatedButton(
              onPressed: uiState.isBusy ? null : _viewModel.submit,
              child: const Text('인증하기')),
        ],
      );
    }
    final controller = _cameraController;
    if (controller == null || !controller.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }
    return Column(
      children: [
        Expanded(child: CameraPreview(controller)),
        IconButton(
          iconSize: 64,
          color: MyColor.white,
          onPressed: _capture,
          icon: const Icon(Icons.camera),
        ),
      ],
    );
  }
}
