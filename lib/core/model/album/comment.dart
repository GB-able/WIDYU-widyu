import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:widyu/core/model/album/member.dart';

part 'comment.freezed.dart';
part 'comment.g.dart';

Object? _readAuthor(Map<dynamic, dynamic> json, String key) =>
    json[key] ??
    {
      'memberId': json['authorId'],
      'name': json['authorName'] ?? '',
      'profileImage': json['authorProfileImage'],
    };

@freezed
abstract class Comment with _$Comment {
  const factory Comment({
    required int commentId,
    required String content,
    required DateTime createdAt,
    @JsonKey(readValue: _readAuthor) required Member author,
    @Default(false) bool canEdit,
    List<Comment>? replies,
  }) = _Comment;

  factory Comment.fromJson(Map<String, dynamic> json) =>
      _$CommentFromJson(json);
}
