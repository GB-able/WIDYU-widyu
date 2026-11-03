import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'
    show ConsumerWidget, WidgetRef;
import 'package:provider/provider.dart' show MultiProvider, Provider;
import 'package:widyu/core/di/providers.dart';

/// 로그인 후 사용하는 화면들이 공유하는 저장소
///
/// 이 위젯이 붙잡고 있는 동안 세션 provider가 유지되고, 셸이 내려가면(로그아웃) 폐기된다.
/// 화면들이 아직 Provider로 읽으므로 같은 인스턴스를 넘겨주는 브리지를 둔다.
class UserSessionScope extends ConsumerWidget {
  const UserSessionScope({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MultiProvider(
      providers: [
        Provider.value(value: ref.watch(fcmTokenServiceProvider)),
        Provider.value(value: ref.watch(pointRepositoryProvider)),
        Provider.value(value: ref.watch(walkRepositoryProvider)),
        Provider.value(value: ref.watch(walkTrackerProvider)),
        Provider.value(value: ref.watch(albumRepositoryProvider)),
      ],
      child: child,
    );
  }
}
