// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Media _$MediaFromJson(Map<String, dynamic> json) => _Media(
      id: (json['id'] as num).toInt(),
      postId: (json['postId'] as num).toInt(),
      type: $enumDecode(_$MediaTypeEnumMap, json['type']),
      duration: (json['duration'] as num?)?.toInt(),
      thumbnailUrl: json['thumbnailUrl'] as String?,
      createdAt: json['createdAt'] as String,
    );

Map<String, dynamic> _$MediaToJson(_Media instance) => <String, dynamic>{
      'id': instance.id,
      'postId': instance.postId,
      'type': _$MediaTypeEnumMap[instance.type]!,
      'duration': instance.duration,
      'thumbnailUrl': instance.thumbnailUrl,
      'createdAt': instance.createdAt,
    };

const _$MediaTypeEnumMap = {
  MediaType.image: 'image',
  MediaType.video: 'video',
};
