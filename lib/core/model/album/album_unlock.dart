import 'package:freezed_annotation/freezed_annotation.dart';

part 'album_unlock.freezed.dart';
part 'album_unlock.g.dart';

@freezed
abstract class AlbumUnlock with _$AlbumUnlock {
  const factory AlbumUnlock({
    required int unlockId,
    required int albumId,
    String? albumTitle,
    required DateTime unlockedAt,
    String? message,
  }) = _AlbumUnlock;

  factory AlbumUnlock.fromJson(Map<String, dynamic> json) =>
      _$AlbumUnlockFromJson(json);
}
