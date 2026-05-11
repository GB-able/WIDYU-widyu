import 'package:freezed_annotation/freezed_annotation.dart';

part 'family_code.freezed.dart';
part 'family_code.g.dart';

@freezed
abstract class FamilyCode with _$FamilyCode {
  const factory FamilyCode({
    required String familyCode,
  }) = _FamilyCode;

  factory FamilyCode.fromJson(Map<String, dynamic> json) =>
      _$FamilyCodeFromJson(json);
}
