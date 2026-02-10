import '../../model/location/location_service_state.dart';

// 추후 뷰모델의 UI 이벤트를 통해 처리 예정
extension LocationServiceStateExtension on LocationServiceState {
  String? get message {
    if (!serviceEnabled) {
      return "위치 추적 기능을 사용하려면 GPS를 켜주세요.";
    }
    if (!permissionGranted) {
      return "권한이 거절되어 위치 추적 기능이 제한됩니다.";
    }
    return null;
  }
}
