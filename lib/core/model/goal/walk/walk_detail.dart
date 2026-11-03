import 'package:freezed_annotation/freezed_annotation.dart';

part 'walk_detail.freezed.dart';
part 'walk_detail.g.dart';

@freezed
abstract class WalkDetail with _$WalkDetail {
  const factory WalkDetail({
    required int goal,
    required int actual,
  }) = _WalkDetail;

  factory WalkDetail.fromJson(Map<String, dynamic> json) =>
      _$WalkDetailFromJson(json);
}
