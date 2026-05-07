import 'package:freezed_annotation/freezed_annotation.dart';

part 'representative.freezed.dart';
part 'representative.g.dart';

@freezed
abstract class Representative with _$Representative {
  const factory Representative({
    required String name,
    required String phoneNumber,
  }) = _Representative;

  factory Representative.fromJson(Map<String, dynamic> json) =>
      _$RepresentativeFromJson(json);
}
