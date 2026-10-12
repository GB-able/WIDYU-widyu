import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:medication_alarm/medication_alarm.dart';
import 'package:provider/provider.dart';
import 'package:widyu/app/routes/app_route.dart';
import 'package:widyu/core/data/provider/medication_alarm_provider.dart';
import 'package:widyu/core/model/goal/medication/medication_point_result.dart';

Future<MedicationPointResult?> openMedicationForSchedule(
    BuildContext context, int scheduleId, DateTime date) async {
  final service = context.read<MedicationAlarmProvider>();
  final caps = await service.capabilities();
  if (!context.mounted) return null;
  return context.push<MedicationPointResult>(AppRoute.medicationVerify.path,
      extra: {
    'memberId': service.state['memberId'],
    'timeZone': caps['timeZone'],
    'occurrences': [
      {
        'scheduleId': scheduleId,
        'localDate': MedicationSchedule.localDate(date)
      },
    ],
  });
}
