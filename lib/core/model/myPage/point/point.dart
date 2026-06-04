import 'package:freezed_annotation/freezed_annotation.dart';

part 'point.freezed.dart';
part 'point.g.dart';

@freezed
abstract class Point with _$Point {
  const factory Point({
    required String type,
    required int amount,
    required String description,
    required DateTime createdAt,
  }) = _Point;

  factory Point.fromJson(Map<String, dynamic> json) => _$PointFromJson(json);
}
