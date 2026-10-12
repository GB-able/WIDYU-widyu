import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:widyu/core/model/album/feed_base.dart';
import 'package:widyu/core/model/album/viewer.dart';

part 'feed.freezed.dart';
part 'feed.g.dart';

@freezed
abstract class Feed with _$Feed implements FeedBase {
  const factory Feed({
    required int albumId,
    required String authorName,
    String? authorProfileImage,
    required String content,
    required List<String> mediaUrls,
    required List<String> thumbnailUrls,
    required String? primaryMediaType,
    required int mediaCount,
    required int photoCount,
    required int videoCount,
    required int likeCount,
    required int commentCount,
    required List<Viewer> viewers,
    required DateTime createdAt,
    required bool canEdit,
    String? videoDuration,
  }) = _Feed;

  factory Feed.fromJson(Map<String, dynamic> json) => _$FeedFromJson(json);
}
