import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:widyu/core/data/provider/album_provider.dart';
import 'package:widyu/core/data/provider/walk_provider.dart';
import 'package:widyu/core/data/repository/album/album_repository.dart';
import 'package:widyu/core/data/repository/goal/walk_repository.dart';
import 'package:widyu/core/data/repository/notification/notification_repository.dart';
import 'package:widyu/core/data/repository/point/point_repository.dart';
import 'package:widyu/core/data/repository/point/point_repository_impl.dart';
import 'package:widyu/core/data/source/point/point_remote_data_source.dart';
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
        Provider<PointRepository>(
          create: (context) => PointRepositoryImpl(
            remoteDataSource: context.read<PointRemoteDataSource>(),
          ),
          dispose: (_, repository) => repository.dispose(),
        ),
        ChangeNotifierProvider<WalkProvider>(
          lazy: false,
          create: (context) => WalkProvider(
            repository: context.read<WalkRepository>(),
          )..start(),
        ),
        ChangeNotifierProvider<AlbumProvider>(
          create: (context) => AlbumProvider(
            repository: context.read<AlbumRepository>(),
            pointRepository: context.read<PointRepository>(),
          ),
        ),
      ],
      child: child,
    );
  }
}
