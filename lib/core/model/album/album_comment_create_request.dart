import 'package:freezed_annotation/freezed_annotation.dart';

part 'album_comment_create_request.freezed.dart';
part 'album_comment_create_request.g.dart';

@freezed
abstract class AlbumCommentCreateRequest with _$AlbumCommentCreateRequest {
  const factory AlbumCommentCreateRequest({
    required String content,
    int? parentCommentId,
  }) = _AlbumCommentCreateRequest;

  factory AlbumCommentCreateRequest.fromJson(Map<String, dynamic> json) =>
      _$AlbumCommentCreateRequestFromJson(json);
}
