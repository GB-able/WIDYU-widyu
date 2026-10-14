import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:widyu/core/ui/theme/colors.dart';
import 'package:widyu/core/ui/theme/typos.dart';
import 'package:widyu/core/ui/widgets/widyu_icon.dart';
import 'package:widyu/core/utils/show_toast.dart';

part 'widget/camera_capture_view.dart';
part 'widget/medication_camera_app_bar.dart';

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

/// 약 복용 인증 사진을 촬영한다.
/// 촬영하면 바로 사진 경로를 결과로 pop 하고, 업로드는 홈 화면이 맡는다.
class MedicationCameraScreen extends StatelessWidget {
  /// 이번 회차에 복용할 약 개수
  final int? doseCount;

  const MedicationCameraScreen({super.key, required this.doseCount});

  void _handleCameraFailure(BuildContext context) {
    showToast('카메라를 실행할 수 없어요. 잠시 후 다시 시도해 주세요.');
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    // 하단 내비게이션 바 스타일은 화면 아래쪽 영역에서 읽으므로 화면 전체를 감싼다.
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: _systemOverlayStyle,
      child: Scaffold(
        backgroundColor: MyColor.black,
        extendBodyBehindAppBar: true,
        appBar: const _MedicationCameraAppBar(),
        body: _CameraCaptureView(
          doseCount: doseCount,
          onCaptured: (path) => context.pop(path),
          onFailure: () => _handleCameraFailure(context),
        ),
      ),
    );
  }
}
