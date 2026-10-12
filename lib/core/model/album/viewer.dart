import 'package:freezed_annotation/freezed_annotation.dart';

part 'viewer.freezed.dart';
part 'viewer.g.dart';

@freezed
abstract class Viewer with _$Viewer {
  const factory Viewer({
    @JsonKey(name: 'memberId') int? id,
    required String name,
    String? profileImage,
  }) = _Viewer;

  factory Viewer.fromJson(Map<String, dynamic> json) => _$ViewerFromJson(json);
}
