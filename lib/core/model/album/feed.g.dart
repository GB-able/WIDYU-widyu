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
      primaryMediaType: json['primaryMediaType'] as String?,
      mediaCount: (json['mediaCount'] as num).toInt(),
      photoCount: (json['photoCount'] as num).toInt(),
      videoCount: (json['videoCount'] as num).toInt(),
      likeCount: (json['likeCount'] as num).toInt(),
      commentCount: (json['commentCount'] as num).toInt(),
      viewers: (json['viewers'] as List<dynamic>)
          .map((e) => Viewer.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      canEdit: json['canEdit'] as bool,
      videoDuration: json['videoDuration'] as String?,
    );

Map<String, dynamic> _$FeedToJson(_Feed instance) => <String, dynamic>{
      'albumId': instance.albumId,
      'authorName': instance.authorName,
      'authorProfileImage': instance.authorProfileImage,
      'content': instance.content,
      'mediaUrls': instance.mediaUrls,
      'thumbnailUrls': instance.thumbnailUrls,
      'primaryMediaType': instance.primaryMediaType,
      'mediaCount': instance.mediaCount,
      'photoCount': instance.photoCount,
      'videoCount': instance.videoCount,
      'likeCount': instance.likeCount,
      'commentCount': instance.commentCount,
      'viewers': instance.viewers,
      'createdAt': instance.createdAt.toIso8601String(),
      'canEdit': instance.canEdit,
      'videoDuration': instance.videoDuration,
    };
