// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feed.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Feed _$FeedFromJson(Map<String, dynamic> json) => _Feed(
      albumId: (json['albumId'] as num).toInt(),
      authorName: json['authorName'] as String,
      authorProfileImage: json['authorProfileImage'] as String?,
      content: json['content'] as String,
      mediaUrls:
          (json['mediaUrls'] as List<dynamic>).map((e) => e as String).toList(),
      thumbnailUrls: (json['thumbnailUrls'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      likeCount: (json['likeCount'] as num).toInt(),
      commentCount: (json['commentCount'] as num).toInt(),
      viewers: (json['viewers'] as List<dynamic>)
          .map((e) => Member.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      canEdit: json['canEdit'] as bool,
      price: (json['price'] as num).toInt(),
    );

Map<String, dynamic> _$FeedToJson(_Feed instance) => <String, dynamic>{
      'albumId': instance.albumId,
      'authorName': instance.authorName,
      'authorProfileImage': instance.authorProfileImage,
      'content': instance.content,
      'mediaUrls': instance.mediaUrls,
      'thumbnailUrls': instance.thumbnailUrls,
      'likeCount': instance.likeCount,
      'commentCount': instance.commentCount,
      'viewers': instance.viewers,
      'createdAt': instance.createdAt.toIso8601String(),
      'canEdit': instance.canEdit,
      'price': instance.price,
    };
