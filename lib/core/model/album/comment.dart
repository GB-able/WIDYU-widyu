import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:widyu/core/model/album/member.dart';

part 'comment.freezed.dart';
part 'comment.g.dart';

@freezed
abstract class Comment with _$Comment {
  const factory Comment({
    required int commentId,
    required String content,
    required DateTime createdAt,
    required Member author,
    required bool canEdit,
    List<Comment>? replies,
  }) = _Comment;

  factory Comment.fromJson(Map<String, dynamic> json) =>
      _$CommentFromJson(json);
}
