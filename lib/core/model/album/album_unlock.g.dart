// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'album_unlock.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AlbumUnlock _$AlbumUnlockFromJson(Map<String, dynamic> json) => _AlbumUnlock(
      unlockId: (json['unlockId'] as num).toInt(),
      albumId: (json['albumId'] as num).toInt(),
      albumTitle: json['albumTitle'] as String?,
      unlockedAt: DateTime.parse(json['unlockedAt'] as String),
      message: json['message'] as String?,
    );

Map<String, dynamic> _$AlbumUnlockToJson(_AlbumUnlock instance) =>
    <String, dynamic>{
      'unlockId': instance.unlockId,
      'albumId': instance.albumId,
      'albumTitle': instance.albumTitle,
      'unlockedAt': instance.unlockedAt.toIso8601String(),
      'message': instance.message,
    };
