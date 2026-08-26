import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:widyu/core/model/camera/camera_capture_result.dart';

class CameraManager {
  CameraManager._();

  static final ImagePicker _imagePicker = ImagePicker();

  /// 시스템 기본 카메라 앱을 실행하여 사진 한 장을 촬영한다.
  /// 권한 요청 및 예외 처리를 모두 내부에서 수행하며 예외를 던지지 않는다.
  static Future<CameraCaptureResult> takePhoto() async {
    try {
      final permissionResult = await _ensureCameraPermission();
      if (permissionResult != null) return permissionResult;

      final file = await _imagePicker.pickImage(source: ImageSource.camera);
      if (file == null) return const CameraCaptureCanceled();

      return CameraCaptureSuccess(file.path);
    } catch (_) {
      return const CameraCaptureFailure();
    }
  }

  /// 카메라 권한을 확인하고 필요하면 요청한다.
  /// 허용된 경우 null, 그렇지 않으면 해당하는 실패 결과를 반환한다.
  static Future<CameraCaptureResult?> _ensureCameraPermission() async {
    var status = await Permission.camera.status;
    if (status.isGranted || status.isLimited) return null;

    status = await Permission.camera.request();
    if (status.isGranted || status.isLimited) return null;

    if (status.isPermanentlyDenied || status.isRestricted) {
      return const CameraPermissionPermanentlyDenied();
    }
    return const CameraPermissionDenied();
  }
}
