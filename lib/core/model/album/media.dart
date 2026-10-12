import 'package:freezed_annotation/freezed_annotation.dart';

part 'media.freezed.dart';
part 'media.g.dart';

enum MediaType {
  image,
  video,
}

@freezed
abstract class Media with _$Media {
  const factory Media({
    required int id,
    required int postId,
    required MediaType type,
    required int? duration,
    required String? thumbnailUrl,
    required String createdAt,
  }) = _Media;

  factory Media.fromJson(Map<String, dynamic> json) => _$MediaFromJson(json);
}
