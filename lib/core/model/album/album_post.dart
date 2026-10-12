import 'package:flutter/foundation.dart';
import 'package:widyu/core/model/album/feed.dart';
import 'package:widyu/core/model/album/feed_base.dart';
import 'package:widyu/core/model/album/viewer.dart';

/// 목록과 상세가 공유하는 게시물 정보. 댓글 목록과 페이지 정보는 포함하지 않는다.
@immutable
class AlbumPost {
  AlbumPost.fromFeed(FeedBase feed, {List<String> thumbnailUrls = const []})
      : albumId = feed.albumId,
        authorName = feed.authorName,
        authorProfileImage = feed.authorProfileImage,
        content = feed.content,
        mediaUrls = List.unmodifiable(feed.mediaUrls),
        thumbnailUrls = List.unmodifiable(
          feed is Feed ? feed.thumbnailUrls : thumbnailUrls,
        ),
        viewers = List.unmodifiable(feed.viewers),
        createdAt = feed.createdAt,
        canEdit = feed.canEdit;

  AlbumPost._withContent(AlbumPost post, this.content)
      : albumId = post.albumId,
        authorName = post.authorName,
        authorProfileImage = post.authorProfileImage,
        mediaUrls = post.mediaUrls,
        thumbnailUrls = post.thumbnailUrls,
        viewers = post.viewers,
        createdAt = post.createdAt,
        canEdit = post.canEdit;

  final int albumId;
  final String authorName;
  final String? authorProfileImage;
  final String content;
  final List<String> mediaUrls;
  final List<String> thumbnailUrls;
  final List<Viewer> viewers;
  final DateTime createdAt;
  final bool canEdit;

  AlbumPost withContent(String content) =>
      AlbumPost._withContent(this, content);
}
