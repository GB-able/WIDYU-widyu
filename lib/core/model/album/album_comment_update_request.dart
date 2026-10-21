import 'package:freezed_annotation/freezed_annotation.dart';

part 'album_comment_update_request.freezed.dart';
part 'album_comment_update_request.g.dart';

@freezed
abstract class AlbumCommentUpdateRequest with _$AlbumCommentUpdateRequest {
  const factory AlbumCommentUpdateRequest({
    required String content,
  }) = _AlbumCommentUpdateRequest;

  factory AlbumCommentUpdateRequest.fromJson(Map<String, dynamic> json) =>
      _$AlbumCommentUpdateRequestFromJson(json);
}
