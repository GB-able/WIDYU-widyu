import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:widyu/core/model/album/feed_base.dart';
import 'package:widyu/core/model/album/member.dart';

part 'album_post.freezed.dart';

@freezed
abstract class AlbumPost with _$AlbumPost {
  const factory AlbumPost({
    required int albumId,
    required String authorName,
    String? authorProfileImage,
    required String content,
    required List<String> mediaUrls,
    required List<String> thumbnailUrls,
    required List<FeedMediaType> mediaTypes,
    required List<Member> viewers,
    required DateTime createdAt,
    required bool canEdit,
    required int price,
  }) = _AlbumPost;

  factory AlbumPost.fromFeed(FeedBase feed) => AlbumPost(
        albumId: feed.albumId,
        authorName: feed.authorName,
        authorProfileImage: feed.authorProfileImage,
        content: feed.content,
        mediaUrls: feed.mediaUrls,
        thumbnailUrls: feed.thumbnailUrls,
        mediaTypes: feed.mediaTypes,
        viewers: feed.viewers,
        createdAt: feed.createdAt,
        canEdit: feed.canEdit,
        price: feed.price,
      );
}
