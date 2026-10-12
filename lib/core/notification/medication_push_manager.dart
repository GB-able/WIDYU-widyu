import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:medication_alarm/medication_alarm.dart';
import 'package:widyu/core/data/provider/medication_alarm_provider.dart';
import 'package:widyu/core/data/repository/goal/medication_repository_impl.dart';
import 'package:widyu/core/data/source/goal/medication_remote_data_source_impl.dart';
import 'package:widyu/core/network/api_client.dart';
import 'package:widyu/core/network/token_manager.dart';
import 'package:widyu/firebase_options.dart';

Future<bool> initializeMedicationPush() async {
  try {
    if (Firebase.apps.isEmpty) return false;
    FirebaseMessaging.onBackgroundMessage(medicationBackgroundMessage);
    return true;
  } catch (e, stack) {
    debugPrint('[MedicationPush] 초기화 실패: $e\n$stack');
    return false;
  }
}

bool isMedicationChange(RemoteMessage message) =>
    message.data['type'] == 'MEDICATION_SCHEDULE_CHANGED';

Future<String?> authenticatedMedicationMember() async {
  if (!await TokenManager().hasToken()) return null;
  return TokenManager().memberId;
}

MedicationAlarmProvider createMedicationAlarmProvider() =>
    MedicationAlarmProvider(
      repository: MedicationRepositoryImpl(
        remoteDataSource: MedicationRemoteDataSourceImpl(apiClient: ApiClient()),
      ),
      native: MedicationAlarm(),
      currentMember: authenticatedMedicationMember,
    );

@pragma('vm:entry-point')
Future<void> medicationBackgroundMessage(RemoteMessage message) async {
  if (!isMedicationChange(message)) return;
  debugPrint('[MedicationSync] 백그라운드 푸시 수신: ${message.data}');
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  try {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform);
    }
  } catch (e) {
    debugPrint('[MedicationSync] 백그라운드 Firebase 초기화 실패: $e');
  }
  final service = createMedicationAlarmProvider();
  try {
    await service.sync();
  } finally {
    service.dispose();
  }
}
