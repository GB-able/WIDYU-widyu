// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Comment _$CommentFromJson(Map<String, dynamic> json) => _Comment(
      commentId: (json['commentId'] as num).toInt(),
      content: json['content'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      author: Member.fromJson(json['author'] as Map<String, dynamic>),
      canEdit: json['canEdit'] as bool,
      replies: (json['replies'] as List<dynamic>?)
          ?.map((e) => Comment.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CommentToJson(_Comment instance) => <String, dynamic>{
      'commentId': instance.commentId,
      'content': instance.content,
      'createdAt': instance.createdAt.toIso8601String(),
      'author': instance.author,
      'canEdit': instance.canEdit,
      'replies': instance.replies,
    };
