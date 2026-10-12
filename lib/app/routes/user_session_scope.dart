import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:widyu/core/data/provider/point_provider.dart';
import 'package:widyu/core/data/provider/step_provider.dart';
import 'package:widyu/core/data/repository/goal/walk_repository.dart';
import 'package:widyu/core/data/repository/notification/notification_repository.dart';
import 'package:widyu/core/data/repository/point/point_repository.dart';
import 'package:widyu/core/notification/fcm_token_service.dart';

/// 로그인 후 사용하는 화면들이 공유하는 저장소
class UserSessionScope extends StatelessWidget {
  const UserSessionScope({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<FcmTokenService>(
          lazy: false,
          create: (context) => FcmTokenService(
            repository: context.read<NotificationRepository>(),
          )..start(),
          dispose: (_, service) => service.dispose(),
        ),
        ChangeNotifierProvider<PointProvider>(
          create: (context) =>
              PointProvider(repository: context.read<PointRepository>()),
        ),
        ChangeNotifierProvider<StepProvider>(
          lazy: false,
          create: (context) => StepProvider(
            repository: context.read<WalkRepository>(),
          )..start(),
        ),
      ],
      child: child,
    );
  }
}
