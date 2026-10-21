import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:medication_alarm/medication_alarm.dart';
import 'package:provider/provider.dart';
import 'package:widyu/app/routes/app_route.dart';
import 'package:widyu/core/data/repository/goal/medication_repository.dart';
import 'package:widyu/core/model/goal/medication/medication_point_result.dart';

Future<MedicationPointResult?> openMedicationForSchedule(
    BuildContext context, int scheduleId, DateTime date,
    {int? doseCount}) async {
  final repository = context.read<MedicationRepository>();
  Object? memberId;
  try {
    memberId = (await repository.alarmState())['memberId'];
  } catch (_) {}
  if (!context.mounted) return null;
  return context
      .push<MedicationPointResult>(AppRoute.medicationCamera.path, extra: {
    'memberId': memberId,
    'occurrences': [
      {
        'scheduleId': scheduleId,
        'localDate': MedicationSchedule.localDate(date),
        if (doseCount != null) 'doseCount': doseCount,
      },
    ],
  });
}
