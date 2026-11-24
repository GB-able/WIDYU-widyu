import 'package:freezed_annotation/freezed_annotation.dart';

part 'walk_daily.freezed.dart';
part 'walk_daily.g.dart';

/// `GET /goals/walks/monthly` 의 `dailyData` 하나. 그 달 모든 날짜가 온다.
@freezed
abstract class WalkDaily with _$WalkDaily {
  const factory WalkDaily({
    required DateTime date,
    // 목표를 정하기 전 날은 null이다.
    int? goal,
    int? actual,
  }) = _WalkDaily;

  factory WalkDaily.fromJson(Map<String, dynamic> json) =>
      _$WalkDailyFromJson(json);
}
