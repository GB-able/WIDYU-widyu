import 'package:freezed_annotation/freezed_annotation.dart';

part 'walk.freezed.dart';
part 'walk.g.dart';

@freezed
abstract class Walk with _$Walk {
  const factory Walk({
    required int goal,
    @JsonKey(name: 'steps') required int actual,
    bool? isReward, // [TODO] 변경 예정
  }) = _Walk;

  factory Walk.fromJson(Map<String, dynamic> json) => _$WalkFromJson(json);
}
