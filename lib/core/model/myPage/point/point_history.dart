import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:widyu/core/model/myPage/point/point.dart';

part 'point_history.freezed.dart';
part 'point_history.g.dart';

@freezed
abstract class PointHistory with _$PointHistory {
  const factory PointHistory({
    required int currentPoints,
    required List<Point> histories,
  }) = _PointHistory;

  factory PointHistory.fromJson(Map<String, dynamic> json) =>
      _$PointHistoryFromJson(json);
}
