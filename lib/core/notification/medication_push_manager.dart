import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:widyu/core/data/repository/goal/medication_repository_impl.dart';
import 'package:widyu/core/data/source/goal/medication_alarm_local_data_source_impl.dart';
import 'package:widyu/core/data/source/goal/medication_remote_data_source_impl.dart';
import 'package:widyu/core/log/log.dart';
import 'package:widyu/core/network/api_client.dart';
import 'package:widyu/core/network/token_manager.dart';
import 'package:widyu/firebase_options.dart';

Future<bool> initializeMedicationPush() async {
  try {
    if (Firebase.apps.isEmpty) return false;
    FirebaseMessaging.onBackgroundMessage(medicationBackgroundMessage);
    return true;
  } catch (e, stack) {
    WiduLog.data.w('약 복용 푸시 초기화 실패', error: e, stackTrace: stack);
    return false;
  }
}

bool isMedicationChange(RemoteMessage message) =>
    message.data['type'] == 'MEDICATION_SCHEDULE_CHANGED';

Future<String?> authenticatedMedicationMember() async {
  if (!await TokenManager().hasToken()) return null;
  return TokenManager().memberId;
}

MedicationRepositoryImpl createMedicationRepository() =>
    MedicationRepositoryImpl(
      remoteDataSource: MedicationRemoteDataSourceImpl(apiClient: ApiClient()),
      localDataSource: MedicationAlarmLocalDataSourceImpl(),
      currentMember: authenticatedMedicationMember,
    );

@pragma('vm:entry-point')
Future<void> medicationBackgroundMessage(RemoteMessage message) async {
  if (!isMedicationChange(message)) return;
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
  await createMedicationRepository().syncAlarmSchedule();
}
