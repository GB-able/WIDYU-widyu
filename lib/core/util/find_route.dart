import 'package:url_launcher/url_launcher.dart';
import 'package:widyu/core/data/repository/location/location_repository.dart';
import 'package:widyu/core/model/location/user_location.dart';
import 'package:widyu/core/util/kakao_map_launcher.dart';
import 'package:widyu/core/util/show_toast.dart';

/// 건강 일정 장소로 길을 안내한다. 좌표가 있으면 카카오맵, 없거나 실패하면 구글 지도 검색을 연다.
Future<void> findRouteTo({
  required LocationRepository locationRepository,
  required String address,
  double? latitude,
  double? longitude,
}) async {
  try {
    var isOpened = false;
    if (latitude != null && longitude != null) {
      final current = await locationRepository.getCurrentLocation();
      isOpened = await KakaoMapLauncher.openRoute(
        destination: UserLocation(latitude: latitude, longitude: longitude),
        start: current,
        destinationName: address,
      );
    }
    if (!isOpened) {
      final uri = Uri.https('www.google.com', '/maps/search/', {
        'api': '1',
        'query': address,
      });
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
      if (!launched) {
        throw Exception('다른 지도 맵 열기 실패');
      }
    }
  } catch (e) {
    showToast('길을 안내할 수 없습니다.');
  }
}
