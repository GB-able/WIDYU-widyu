import 'package:image_picker/image_picker.dart';
import 'package:widyu/core/model/camera/camera_capture_result.dart';
import 'package:widyu/core/model/permission/permission_type.dart';
import 'package:widyu/core/utils/permission_manager.dart';

class CameraManager {
  CameraManager._();

  static final ImagePicker _imagePicker = ImagePicker();

  /// 시스템 기본 카메라 앱을 실행하여 사진 한 장을 촬영한다.
  /// 권한은 기능 진입 흐름에서 미리 확인한다. 이 메서드는 권한 요청을 하지 않는다.
  static Future<CameraCaptureResult> takePhoto() async {
    try {
      final permissionResult = await _checkCameraPermission();
      if (permissionResult != null) return permissionResult;

      final file = await _imagePicker.pickImage(source: ImageSource.camera);
      if (file == null) return const CameraCaptureCanceled();

      return CameraCaptureSuccess(file.path);
    } catch (_) {
      return const CameraCaptureFailure();
    }
  }

  /// 카메라 권한을 확인한다.
  /// 허용된 경우 null, 그렇지 않으면 해당하는 실패 결과를 반환한다.
  static Future<CameraCaptureResult?> _checkCameraPermission() async {
    if (await PermissionManager.isGranted(PermissionType.camera)) return null;

    final result = await PermissionManager.status(PermissionType.camera);
    return switch (result) {
      PermissionRequestResult.granted => null,
      PermissionRequestResult.permanentlyDenied =>
        const CameraPermissionPermanentlyDenied(),
      PermissionRequestResult.denied ||
      PermissionRequestResult.restricted ||
      PermissionRequestResult.canceled ||
      PermissionRequestResult.settingsLaunchFailed ||
      PermissionRequestResult.unsupported =>
        const CameraPermissionDenied(),
    };
  }
}
