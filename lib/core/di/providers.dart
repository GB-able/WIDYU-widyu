import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:widyu/core/data/repository/album/album_repository.dart';
import 'package:widyu/core/data/repository/album/album_repository_impl.dart';
import 'package:widyu/core/data/repository/auth/auth_repository.dart';
import 'package:widyu/core/data/repository/auth/auth_repository_impl.dart';
import 'package:widyu/core/data/repository/goal/goal_repository.dart';
import 'package:widyu/core/data/repository/goal/goal_repository_impl.dart';
import 'package:widyu/core/data/repository/goal/medication_repository.dart';
import 'package:widyu/core/data/repository/goal/medication_repository_impl.dart';
import 'package:widyu/core/data/repository/goal/walk_repository.dart';
import 'package:widyu/core/data/repository/goal/walk_repository_impl.dart';
import 'package:widyu/core/data/repository/heartRate/heart_rate_repository.dart';
import 'package:widyu/core/data/repository/heartRate/heart_rate_repository_impl.dart';
import 'package:widyu/core/data/repository/home/home_repository.dart';
import 'package:widyu/core/data/repository/home/home_repository_impl.dart';
import 'package:widyu/core/data/repository/incident/incident_repository.dart';
import 'package:widyu/core/data/repository/incident/incident_repository_impl.dart';
import 'package:widyu/core/data/repository/location/location_repository.dart';
import 'package:widyu/core/data/repository/location/location_repository_impl.dart';
import 'package:widyu/core/data/repository/myPage/my_page_repository.dart';
import 'package:widyu/core/data/repository/myPage/my_page_repository_impl.dart';
import 'package:widyu/core/data/repository/notification/notification_repository.dart';
import 'package:widyu/core/data/repository/notification/notification_repository_impl.dart';
import 'package:widyu/core/data/repository/point/point_repository.dart';
import 'package:widyu/core/data/repository/point/point_repository_impl.dart';
import 'package:widyu/core/data/repository/user/user_repository.dart';
import 'package:widyu/core/data/repository/user/user_repository_impl.dart';
import 'package:widyu/core/data/source/album/album_remote_data_source_impl.dart';
import 'package:widyu/core/data/source/auth/auth_local_data_source_impl.dart';
import 'package:widyu/core/data/source/auth/auth_remote_data_source_impl.dart';
import 'package:widyu/core/data/source/device/device_local_data_source_impl.dart';
import 'package:widyu/core/data/source/goal/goal_remote_data_source_impl.dart';
import 'package:widyu/core/data/source/goal/medication_alarm_local_data_source_impl.dart';
import 'package:widyu/core/data/source/goal/medication_remote_data_source_impl.dart';
import 'package:widyu/core/data/source/goal/walk_local_data_source.dart';
import 'package:widyu/core/data/source/goal/walk_local_data_source_impl.dart';
import 'package:widyu/core/data/source/goal/walk_remote_data_source_impl.dart';
import 'package:widyu/core/data/source/heartRate/heart_rate_local_data_source_impl.dart';
import 'package:widyu/core/data/source/heartRate/heart_rate_remote_data_source_impl.dart';
import 'package:widyu/core/data/source/home/home_remote_data_source_impl.dart';
import 'package:widyu/core/data/source/incident/incident_remote_data_source_impl.dart';
import 'package:widyu/core/data/source/location/location_local_data_source_impl.dart';
import 'package:widyu/core/data/source/location/location_remote_data_source_impl.dart';
import 'package:widyu/core/data/source/myPage/my_page_remote_data_source_impl.dart';
import 'package:widyu/core/data/source/notification/notification_remote_data_source_impl.dart';
import 'package:widyu/core/data/source/point/point_remote_data_source_impl.dart';
import 'package:widyu/core/model/permission/permission_type.dart';
import 'package:widyu/core/network/api_client.dart';
import 'package:widyu/core/network/socket_client.dart';
import 'package:widyu/core/notification/fcm_token_service.dart';
import 'package:widyu/core/notification/medication_push_manager.dart';
import 'package:widyu/core/utils/app_service_controller.dart';
import 'package:widyu/core/utils/background_location_notice_controller.dart';
import 'package:widyu/core/utils/kakao_map_launcher.dart';
import 'package:widyu/core/utils/permission_manager.dart';
import 'package:widyu/core/utils/permission_recovery_controller.dart';
import 'package:widyu/core/utils/walk_tracker.dart';

part 'providers.g.dart';

// 앱 수명: 앱이 실행되는 동안 인스턴스 하나를 유지한다.
// DataSource는 Repository 안에서 바로 만든다. (ApiClient·SocketClient는 싱글톤)

@Riverpod(keepAlive: true)
AppServiceController appServiceController(Ref ref) {
  final controller = AppServiceController();
  ref.onDispose(controller.dispose);
  return controller;
}

@Riverpod(keepAlive: true)
BackgroundLocationNoticeController backgroundLocationNoticeController(
  Ref ref,
) {
  final controller = BackgroundLocationNoticeController();
  ref.onDispose(controller.dispose);
  return controller;
}

@Riverpod(keepAlive: true)
KakaoMapRouteOpener kakaoMapRouteOpener(Ref ref) => KakaoMapLauncher.openRoute;

@Riverpod(keepAlive: true)
AuthRepository authRepository(Ref ref) => AuthRepositoryImpl(
      remoteDatasource: AuthRemoteDataSourceImpl(apiClient: ApiClient()),
      localDataSource: AuthLocalDataSourceImpl(),
    );

@Riverpod(keepAlive: true)
GoalRepository goalRepository(Ref ref) => GoalRepositoryImpl(
      goalRemoteDataSource: GoalRemoteDataSourceImpl(apiClient: ApiClient()),
    );

@Riverpod(keepAlive: true)
MedicationRepository medicationRepository(Ref ref) => MedicationRepositoryImpl(
      localDataSource: MedicationAlarmLocalDataSourceImpl(),
      remoteDataSource: MedicationRemoteDataSourceImpl(apiClient: ApiClient()),
      currentMember: authenticatedMedicationMember,
    );

@Riverpod(keepAlive: true)
PermissionRecoveryController alarmPermissionRecoveryController(Ref ref) {
  final repository = ref.watch(medicationRepositoryProvider);

  Future<PermissionRequestResult> status(PermissionType type) async {
    final current = await PermissionManager.status(type);
    if (type != PermissionType.notification ||
        current != PermissionRequestResult.granted) {
      return current;
    }
    final capabilities = await repository.alarmCapabilities();
    return capabilities['notifications'] == false
        ? PermissionRequestResult.permanentlyDenied
        : current;
  }

  final controller = PermissionRecoveryController(
    statusReader: status,
    rationaleReader: (_) async => true,
    settingsRechecker: (type, settings) =>
        PermissionManager.openSettingsAndRecheck(
      type,
      settings,
      isGrantedReader: (type) async =>
          await status(type) == PermissionRequestResult.granted,
    ),
  );
  ref.onDispose(controller.dispose);
  return controller;
}

@Riverpod(keepAlive: true)
HeartRateRepository heartRateRepository(Ref ref) => HeartRateRepositoryImpl(
      localDataSource: HeartRateLocalDataSourceImpl(),
      remoteDataSource: HeartRateRemoteDataSourceImpl(apiClient: ApiClient()),
    );

@Riverpod(keepAlive: true)
HomeRepository homeRepository(Ref ref) => HomeRepositoryImpl(
      remoteDataSource: HomeRemoteDataSourceImpl(apiClient: ApiClient()),
    );

@Riverpod(keepAlive: true)
IncidentRepository incidentRepository(Ref ref) => IncidentRepositoryImpl(
      remoteDataSource: IncidentRemoteDataSourceImpl(apiClient: ApiClient()),
    );

@Riverpod(keepAlive: true)
LocationRepository locationRepository(Ref ref) => LocationRepositoryImpl(
      localDataSource: LocationLocalDataSourceImpl(),
      remoteDataSource:
          LocationRemoteDataSourceImpl(socketClient: SocketClient()),
      authLocalDataSource: AuthLocalDataSourceImpl(),
      deviceLocalDataSource: DeviceLocalDataSourceImpl(),
    );

@Riverpod(keepAlive: true)
MyPageRepository myPageRepository(Ref ref) => MyPageRepositoryImpl(
      remoteDataSource: MyPageRemoteDataSourceImpl(apiClient: ApiClient()),
    );

@Riverpod(keepAlive: true)
NotificationRepository notificationRepository(Ref ref) =>
    NotificationRepositoryImpl(
      remoteDataSource:
          NotificationRemoteDataSourceImpl(apiClient: ApiClient()),
    );

/// 걸음 데이터베이스·Health 설정을 세션이 바뀌어도 다시 하지 않도록 앱 수명으로 둔다.
@Riverpod(keepAlive: true)
WalkLocalDataSource walkLocalDataSource(Ref ref) => WalkLocalDataSourceImpl();

// 세션 수명: UserSessionScope(로그인 후 셸)가 붙잡고 있는 동안만 유지하고,
// 셸이 내려가면(로그아웃) 폐기된다.

@riverpod
FcmTokenService fcmTokenService(Ref ref) {
  final service =
      FcmTokenService(repository: ref.watch(notificationRepositoryProvider))
        ..start();
  ref.onDispose(service.dispose);
  return service;
}

@riverpod
PointRepository pointRepository(Ref ref) {
  final repository = PointRepositoryImpl(
    remoteDataSource: PointRemoteDataSourceImpl(apiClient: ApiClient()),
  );
  ref.onDispose(repository.dispose);
  return repository;
}

@riverpod
UserRepository userRepository(Ref ref) {
  final repository = UserRepositoryImpl(
    remoteDataSource: MyPageRemoteDataSourceImpl(apiClient: ApiClient()),
  );
  ref.onDispose(repository.dispose);
  return repository;
}

@riverpod
WalkRepository walkRepository(Ref ref) {
  final repository = WalkRepositoryImpl(
    localDataSource: ref.watch(walkLocalDataSourceProvider),
    remoteDataSource: WalkRemoteDataSourceImpl(apiClient: ApiClient()),
  );
  ref.onDispose(repository.dispose);
  return repository;
}

@riverpod
WalkTracker walkTracker(Ref ref) {
  final tracker = WalkTracker(
    repository: ref.watch(walkRepositoryProvider),
    pointRepository: ref.watch(pointRepositoryProvider),
  )..start();
  ref.onDispose(tracker.dispose);
  return tracker;
}

@riverpod
AlbumRepository albumRepository(Ref ref) {
  final repository = AlbumRepositoryImpl(
    remoteDataSource: AlbumRemoteDataSourceImpl(apiClient: ApiClient()),
    pointRepository: ref.watch(pointRepositoryProvider),
  );
  ref.onDispose(repository.dispose);
  return repository;
}

// 화면 수명: 이 자원을 쓰는 ViewModel이 build()에서 watch로 붙잡고, 함께 폐기된다.
// 여러 화면이 동시에 watch하면 인스턴스를 공유하므로, 다른 화면에서 쓸 때는 provider를 따로 둔다.

@riverpod
PermissionRecoveryController permissionRecoveryController(Ref ref) {
  final controller = PermissionRecoveryController();
  ref.onDispose(controller.dispose);
  return controller;
}

@riverpod
PermissionRecoveryController homePermissionRecoveryController(Ref ref) {
  final controller = PermissionRecoveryController();
  ref.onDispose(controller.dispose);
  return controller;
}
