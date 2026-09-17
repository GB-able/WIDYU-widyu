import 'package:image_picker/image_picker.dart';
import 'package:widyu/core/model/camera/camera_capture_result.dart';

class CameraManager {
  CameraManager._();

  static final ImagePicker _imagePicker = ImagePicker();

  /// 시스템 기본 카메라 앱을 실행하여 사진 한 장을 촬영한다.
  /// 카메라 권한은 호출자(`HomeViewModel.takeMedicationPhoto`)가 촬영 전에 보장한다.
  /// 이 메서드는 권한을 확인하거나 요청하지 않는다.
  static Future<CameraCaptureResult> takePhoto() async {
    try {
      final file = await _imagePicker.pickImage(source: ImageSource.camera);
      if (file == null) return const CameraCaptureCanceled();

      return CameraCaptureSuccess(file.path);
    } catch (_) {
      return const CameraCaptureFailure();
    }
  }
}
