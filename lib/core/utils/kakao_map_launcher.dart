import 'package:url_launcher/url_launcher.dart';
import 'package:widyu/core/model/location/user_location.dart';

/// 카카오맵 길찾기의 이동 수단. 카카오맵 URL Scheme 의 `by` 파라미터 값과 1:1로 대응한다.
enum KakaoMapRouteType {
  car('CAR'),
  publicTransit('PUBLICTRANSIT'),
  foot('FOOT');

  final String value;

  const KakaoMapRouteType(this.value);
}

/// 카카오맵 길찾기를 실행한다.
/// 카카오맵 앱이 없으면 카카오맵 웹 길찾기 링크로 대체한다.
class KakaoMapLauncher {
  KakaoMapLauncher._();

  /// [start] 에서 [destination] 으로 향하는 길찾기를 연다.
  ///
  /// [start] 가 null 이면 출발지를 생략해 카카오맵이 잡은 현재 위치를 그대로 쓴다.
  /// [destinationName] 은 앱을 못 열어 웹으로 넘어갔을 때 지도에 표시할 목적지 이름이다.
  ///
  /// 앱과 웹 모두 실패하면 false 를 반환한다.
  static Future<bool> openRoute({
    required UserLocation destination,
    UserLocation? start,
    String? destinationName,
    KakaoMapRouteType routeType = KakaoMapRouteType.publicTransit,
  }) async {
    final scheme = Uri.parse(
      'kakaomap://route'
      '?ep=${_coordinate(destination)}'
      '${start == null ? '' : '&sp=${_coordinate(start)}'}'
      '&by=${routeType.value}',
    );

    if (await _tryLaunch(scheme)) return true;

    final name = (destinationName == null || destinationName.isEmpty)
        ? '목적지'
        : destinationName;
    final web = Uri.parse(
      'https://map.kakao.com/link/to/'
      '${Uri.encodeComponent(name)},${_coordinate(destination)}',
    );

    return _tryLaunch(web, mode: LaunchMode.externalApplication);
  }

  /// 카카오맵 좌표 표기법(`위도,경도`)
  static String _coordinate(UserLocation location) =>
      '${location.latitude},${location.longitude}';

  /// canLaunchUrl 은 플랫폼 설정(Android queries / iOS LSApplicationQueriesSchemes)에
  /// 누락이 있으면 설치되어 있어도 false 를 주기 때문에, 판단을 launchUrl 결과에 맡긴다.
  static Future<bool> _tryLaunch(
    Uri uri, {
    LaunchMode mode = LaunchMode.platformDefault,
  }) async {
    try {
      return await launchUrl(uri, mode: mode);
    } catch (_) {
      return false;
    }
  }
}
