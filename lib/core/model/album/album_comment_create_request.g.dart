// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'album_comment_create_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AlbumCommentCreateRequest _$AlbumCommentCreateRequestFromJson(
        Map<String, dynamic> json) =>
    _AlbumCommentCreateRequest(
      content: json['content'] as String,
      parentCommentId: (json['parentCommentId'] as num?)?.toInt(),
    );

Map<String, dynamic> _$AlbumCommentCreateRequestToJson(
        _AlbumCommentCreateRequest instance) =>
    <String, dynamic>{
      'content': instance.content,
      'parentCommentId': instance.parentCommentId,
    };
