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
      likeCount: (json['likeCount'] as num).toInt(),
      commentCount: (json['commentCount'] as num).toInt(),
      viewCount: (json['viewCount'] as num?)?.toInt() ?? 0,
      price: (json['price'] as num?)?.toInt(),
      author: Member.fromJson(json['author'] as Map<String, dynamic>),
      viewers: (json['viewers'] as List<dynamic>?)
              ?.map((e) => Viewer.fromJson(e as Map<String, dynamic>))
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
      'likeCount': instance.likeCount,
      'commentCount': instance.commentCount,
      'viewCount': instance.viewCount,
      'price': instance.price,
      'author': instance.author,
      'viewers': instance.viewers,
      'comments': instance.comments,
      'createdAt': instance.createdAt.toIso8601String(),
      'canEdit': instance.canEdit,
    };
