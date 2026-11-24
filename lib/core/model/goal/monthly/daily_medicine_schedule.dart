import 'package:freezed_annotation/freezed_annotation.dart';

part 'daily_medicine_schedule.freezed.dart';
part 'daily_medicine_schedule.g.dart';

/// 서버가 그날 기준으로 정한 복용 상태. 인증 마감(알람 + 30분)이 지나면 [missed]가 된다.
enum MedicineDoseState {
  @JsonValue('DONE')
  done,
  @JsonValue('UPCOMING')
  upcoming,
  @JsonValue('MISSED')
  missed,
}

/// `GET /goals/medicine-schedules/daily` 의 일정 하나.
@freezed
abstract class DailyMedicineSchedule with _$DailyMedicineSchedule {
  const factory DailyMedicineSchedule({
    required int medicineScheduleId,
    // 알약 수라 0.5정처럼 소수일 수 있다.
    double? totalCount,
    required String alarmTime,
    required MedicineDoseState status,
    String? proofImageUrl,
  }) = _DailyMedicineSchedule;

  factory DailyMedicineSchedule.fromJson(Map<String, dynamic> json) =>
      _$DailyMedicineScheduleFromJson(json);
}
