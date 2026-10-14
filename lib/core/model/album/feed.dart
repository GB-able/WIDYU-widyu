import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:widyu/core/model/album/feed_base.dart';
import 'package:widyu/core/model/album/member.dart';

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
    required int likeCount,
    required int commentCount,
    required List<Member> viewers,
    required DateTime createdAt,
    required bool canEdit,
    required int price,
  }) = _Feed;

  factory Feed.fromJson(Map<String, dynamic> json) => _$FeedFromJson(json);
}
