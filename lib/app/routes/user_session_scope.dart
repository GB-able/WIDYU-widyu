import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:widyu/core/data/repository/album/album_repository.dart';
import 'package:widyu/core/data/repository/album/album_repository_impl.dart';
import 'package:widyu/core/data/repository/goal/walk_repository.dart';
import 'package:widyu/core/data/repository/goal/walk_repository_impl.dart';
import 'package:widyu/core/data/repository/notification/notification_repository.dart';
import 'package:widyu/core/data/repository/point/point_repository.dart';
import 'package:widyu/core/data/repository/point/point_repository_impl.dart';
import 'package:widyu/core/data/source/album/album_remote_data_source.dart';
import 'package:widyu/core/data/source/goal/walk_local_data_source.dart';
import 'package:widyu/core/data/source/goal/walk_remote_data_source.dart';
import 'package:widyu/core/data/source/point/point_remote_data_source.dart';
import 'package:widyu/core/notification/fcm_token_service.dart';
import 'package:widyu/core/utils/walk_tracker.dart';

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
        Provider<WalkRepository>(
          create: (context) => WalkRepositoryImpl(
            localDataSource: context.read<WalkLocalDataSource>(),
            remoteDataSource: context.read<WalkRemoteDataSource>(),
          ),
          dispose: (_, repository) => repository.dispose(),
        ),
        Provider<WalkTracker>(
          lazy: false,
          create: (context) => WalkTracker(
            repository: context.read<WalkRepository>(),
          )..start(),
          dispose: (_, tracker) => tracker.dispose(),
        ),
        Provider<AlbumRepository>(
          create: (context) => AlbumRepositoryImpl(
            remoteDataSource: context.read<AlbumRemoteDataSource>(),
            pointRepository: context.read<PointRepository>(),
          ),
          dispose: (_, repository) => repository.dispose(),
        ),
      ],
      child: child,
    );
  }
}
