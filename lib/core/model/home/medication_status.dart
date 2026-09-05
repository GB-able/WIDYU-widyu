import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:widyu/core/model/home/senior_card.dart';
import 'package:widyu/core/utils/extensions/medicine_extension.dart';
import 'package:widyu/core/utils/extensions/string_extension.dart';

part 'medication_status.freezed.dart';

@freezed
sealed class MedicationStatus with _$MedicationStatus {
  /// 인증 가능
  const factory MedicationStatus.available({
    required DateTime doseAt,
    required DateTime closesAt,
    required int takenCount,
    required int totalCount,
  }) = MedicationAvailable;

  /// 인증 예정
  const factory MedicationStatus.upcoming({
    required DateTime doseAt,
    required DateTime opensAt,
    required int takenCount,
    required int totalCount,
  }) = MedicationUpcoming;

  /// 복용 완료
  const factory MedicationStatus.completed({required int totalCount}) =
      MedicationCompleted;

  /// 미복용분은 남았으나 인증 불가능
  const factory MedicationStatus.missed({
    required int takenCount,
    required int totalCount,
  }) = MedicationMissed;

  /// 등록된 약 없음
  const factory MedicationStatus.none() = MedicationNone;

  /// 초기 상태 / 조회 실패
  const factory MedicationStatus.unknown() = MedicationUnknown;
}

MedicationStatus resolveMedicationStatus({
  required MedicationSummary? medicine,
  required DateTime now,
}) {
  if (medicine == null) return const MedicationStatus.unknown();

  final total = medicine.todayTotalCount ?? 0;
  final taken = medicine.todayTakenCount ?? 0;
  if (total == 0) return const MedicationStatus.none();
  if (taken >= total) return MedicationStatus.completed(totalCount: total);

  // 1순위: 회차별 스케줄 중 미복용분
  final pending = medicine.scheduleStatuses
      .where((s) => !s.taken)
      .map((s) => s.doseTime?.toAlarmAt(now))
      .whereType<DateTime>()
      .toList()
    ..sort();

  // 폴백: scheduleStatuses 가 비어 있으면 nextAlarmTime 단일 값
  final candidates = pending.isNotEmpty
      ? pending
      : [medicine.nextAlarmTime?.toAlarmAt(now)].whereType<DateTime>().toList();

  if (candidates.isEmpty) {
    return MedicationStatus.missed(takenCount: taken, totalCount: total);
  }

  // 가능한 복용 시간 중 가장 빠른 시간
  for (final doseAt in candidates) {
    if (doseAt.isWithinVerifyWindow(now)) {
      return MedicationStatus.available(
        doseAt: doseAt,
        closesAt: doseAt.windowClosesAt,
        takenCount: taken,
        totalCount: total,
      );
    }
  }

  // 가장 빠른 시간
  for (final doseAt in candidates) {
    final opensAt = doseAt.windowOpensAt;
    if (now.isBefore(opensAt)) {
      return MedicationStatus.upcoming(
        doseAt: doseAt,
        opensAt: opensAt,
        takenCount: taken,
        totalCount: total,
      );
    }
  }

  return MedicationStatus.missed(takenCount: taken, totalCount: total);
}
