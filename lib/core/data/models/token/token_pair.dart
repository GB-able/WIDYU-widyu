import 'package:freezed_annotation/freezed_annotation.dart';

part 'token_pair.freezed.dart';
part 'token_pair.g.dart';

@freezed
abstract class TokenPair with _$TokenPair {
  const factory TokenPair({
    required String accessToken,
    required String refreshToken,
  }) = _TokenPair;

  factory TokenPair.fromJson(Map<String, dynamic> json) =>
      _$TokenPairFromJson(json);
}
