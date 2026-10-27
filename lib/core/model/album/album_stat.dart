import 'package:freezed_annotation/freezed_annotation.dart';

part 'album_stat.freezed.dart';

@freezed
abstract class AlbumStat with _$AlbumStat {
  const factory AlbumStat({
    required bool isLiked,
    required int likeCount,
    required int commentCount,
  }) = _AlbumStat;
}
