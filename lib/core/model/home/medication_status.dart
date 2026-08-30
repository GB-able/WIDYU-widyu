import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:widyu/core/model/home/senior_card.dart';

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

const _doseWindow = Duration(minutes: 30);

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
      .map((s) => _anchorToday(s.doseTime, now))
      .whereType<DateTime>()
      .toList()
    ..sort();

  // 폴백: scheduleStatuses 가 비어 있으면 nextAlarmTime 단일 값
  final candidates = pending.isNotEmpty
      ? pending
      : [_anchorToday(medicine.nextAlarmTime, now)]
          .whereType<DateTime>()
          .toList();

  if (candidates.isEmpty) {
    return MedicationStatus.missed(takenCount: taken, totalCount: total);
  }

  // 가능한 복용 시간 중 가장 빠른 시간
  for (final doseAt in candidates) {
    final opensAt = doseAt.subtract(_doseWindow);
    final closesAt = doseAt.add(_doseWindow);
    if (!now.isBefore(opensAt) && !now.isAfter(closesAt)) {
      // 양끝 포함
      return MedicationStatus.available(
        doseAt: doseAt,
        closesAt: closesAt,
        takenCount: taken,
        totalCount: total,
      );
    }
  }

  // 가장 빠른 시간
  for (final doseAt in candidates) {
    final opensAt = doseAt.subtract(_doseWindow);
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

DateTime? _anchorToday(String? hhmm, DateTime now) {
  if (hhmm == null || hhmm.isEmpty) return null;
  final parts = hhmm.split(':');
  if (parts.length < 2) return null;
  final h = int.tryParse(parts[0]);
  final m = int.tryParse(parts[1]);
  if (h == null || m == null || h < 0 || h > 23 || m < 0 || m > 59) return null;
  return DateTime(now.year, now.month, now.day, h, m);
}
