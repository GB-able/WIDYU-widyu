import 'package:widyu/core/model/album/album_post.dart';
import 'package:widyu/core/model/album/album_stat.dart';

/// 세션 동안 공유하는 앨범 캐시.
/// 바뀐 컬렉션만 새로 만들기 때문에 `identical`로 무엇이 바뀌었는지 알 수 있다.
class AlbumCache {
  const AlbumCache({
    this.posts = const {},
    this.stats = const {},
    this.unlockedIds = const {},
    this.unlockingIds = const {},
    this.deletedIds = const {},
  });

  final Map<int, AlbumPost> posts;
  final Map<int, AlbumStat> stats;
  final Set<int> unlockedIds;
  final Set<int> unlockingIds;
  final Set<int> deletedIds;

  AlbumPost? postOf(int albumId) => posts[albumId];

  AlbumStat statOf(int albumId) =>
      stats[albumId] ??
      const AlbumStat(isLiked: false, likeCount: 0, commentCount: 0);

  bool isUnlocked(int albumId) => unlockedIds.contains(albumId);

  bool isUnlocking(int albumId) => unlockingIds.contains(albumId);

  bool isDeleted(int albumId) => deletedIds.contains(albumId);

  AlbumCache copyWith({
    Map<int, AlbumPost>? posts,
    Map<int, AlbumStat>? stats,
    Set<int>? unlockedIds,
    Set<int>? unlockingIds,
    Set<int>? deletedIds,
  }) =>
      AlbumCache(
        posts: posts == null ? this.posts : Map.unmodifiable(posts),
        stats: stats == null ? this.stats : Map.unmodifiable(stats),
        unlockedIds: unlockedIds == null
            ? this.unlockedIds
            : Set.unmodifiable(unlockedIds),
        unlockingIds: unlockingIds == null
            ? this.unlockingIds
            : Set.unmodifiable(unlockingIds),
        deletedIds:
            deletedIds == null ? this.deletedIds : Set.unmodifiable(deletedIds),
      );
}
