sealed class CameraCaptureResult {
  const CameraCaptureResult();
}

class CameraCaptureSuccess extends CameraCaptureResult {
  final String filePath;

  const CameraCaptureSuccess(this.filePath);
}

class CameraCaptureCanceled extends CameraCaptureResult {
  const CameraCaptureCanceled();
}

class CameraCaptureFailure extends CameraCaptureResult {
  const CameraCaptureFailure();
}
