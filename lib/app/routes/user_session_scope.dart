import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'
    show ConsumerWidget, WidgetRef;
import 'package:widyu/core/di/providers.dart';

/// 로그인 후 사용하는 화면들이 공유하는 저장소의 수명
///
/// 이 위젯이 붙잡고 있는 동안 세션 provider가 유지되고, 셸이 내려가면(로그아웃) 폐기된다.
class UserSessionScope extends ConsumerWidget {
  const UserSessionScope({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref
      ..listen(fcmTokenServiceProvider, (_, __) {})
      ..listen(pointRepositoryProvider, (_, __) {})
      ..listen(walkRepositoryProvider, (_, __) {})
      ..listen(walkTrackerProvider, (_, __) {})
      ..listen(albumRepositoryProvider, (_, __) {});
    return child;
  }
}
