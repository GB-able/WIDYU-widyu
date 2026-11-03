// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feed_detail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FeedDetail _$FeedDetailFromJson(Map<String, dynamic> json) => _FeedDetail(
      albumId: (json['postId'] as num).toInt(),
      content: json['content'] as String,
      mediaUrls:
          (json['mediaUrls'] as List<dynamic>).map((e) => e as String).toList(),
      thumbnailUrls: (json['thumbnailUrls'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      mediaTypes: (json['mediaTypes'] as List<dynamic>?)
              ?.map((e) => $enumDecode(_$FeedMediaTypeEnumMap, e))
              .toList() ??
          const [],
      likeCount: (json['likeCount'] as num).toInt(),
      commentCount: (json['commentCount'] as num).toInt(),
      price: (json['price'] as num).toInt(),
      author: Member.fromJson(json['author'] as Map<String, dynamic>),
      viewers: (json['viewers'] as List<dynamic>?)
              ?.map((e) => Member.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      comments: (json['comments'] as List<dynamic>?)
              ?.map((e) => Comment.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      createdAt: DateTime.parse(json['createdAt'] as String),
      canEdit: json['canEdit'] as bool,
    );

Map<String, dynamic> _$FeedDetailToJson(_FeedDetail instance) =>
    <String, dynamic>{
      'postId': instance.albumId,
      'content': instance.content,
      'mediaUrls': instance.mediaUrls,
      'thumbnailUrls': instance.thumbnailUrls,
      'mediaTypes':
          instance.mediaTypes.map((e) => _$FeedMediaTypeEnumMap[e]!).toList(),
      'likeCount': instance.likeCount,
      'commentCount': instance.commentCount,
      'price': instance.price,
      'author': instance.author,
      'viewers': instance.viewers,
      'comments': instance.comments,
      'createdAt': instance.createdAt.toIso8601String(),
      'canEdit': instance.canEdit,
    };

const _$FeedMediaTypeEnumMap = {
  FeedMediaType.photo: 'PHOTO',
  FeedMediaType.video: 'VIDEO',
};
