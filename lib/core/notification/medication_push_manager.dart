import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:widyu/core/data/repository/goal/medication_repository_impl.dart';
import 'package:widyu/core/data/source/goal/medication_alarm_local_data_source_impl.dart';
import 'package:widyu/core/data/source/goal/medication_remote_data_source_impl.dart';
import 'package:widyu/core/log/log.dart';
import 'package:widyu/core/model/notification/notification_type.dart';
import 'package:widyu/core/network/api_client.dart';
import 'package:widyu/core/network/token_manager.dart';
import 'package:widyu/firebase_options.dart';

class MedicationPushManager {
  MedicationPushManager._();

  static bool isMedicationChange(RemoteMessage message) => [
        NotificationType.medicationScheduleSync,
        NotificationType.medicationScheduleCreated,
        NotificationType.medicationScheduleChanged,
        NotificationType.medicationScheduleDeleted,
      ].any((type) => type.matches(message.data));

  static Future<String?> authenticatedMember() async {
    if (!await TokenManager().hasToken()) return null;
    return TokenManager().memberId;
  }

  static MedicationRepositoryImpl createRepository() =>
      MedicationRepositoryImpl(
        remoteDataSource:
            MedicationRemoteDataSourceImpl(apiClient: ApiClient()),
        localDataSource: MedicationAlarmLocalDataSourceImpl(),
        currentMember: authenticatedMember,
      );

  static Future<void> handleBackgroundMessage(RemoteMessage message) async {
    WiduLog.bg.i('약 복용 일정 변경 푸시 수신');
    WiduLog.bg.t(() => '약 복용 푸시 data: ${message.data}');
    WidgetsFlutterBinding.ensureInitialized();
    await dotenv.load();
    try {
      if (Firebase.apps.isEmpty) {
        await Firebase.initializeApp(
            options: DefaultFirebaseOptions.currentPlatform);
      }
    } catch (e, stack) {
      WiduLog.bg.w('Firebase 초기화 실패', error: e, stackTrace: stack);
    }
    await createRepository().syncAlarmSchedule();
  }
}
