import 'package:flutter/foundation.dart';
import 'package:widyu/core/data/provider/point_provider.dart';
import 'package:widyu/core/data/repository/album/album_repository.dart';
import 'package:widyu/core/log/log.dart';
import 'package:widyu/core/model/album/album_post.dart';
import 'package:widyu/core/model/album/album_stat.dart';
import 'package:widyu/core/model/album/album_unlock.dart';
import 'package:widyu/core/model/album/feed_base.dart';
import 'package:widyu/core/model/album/member.dart';
import 'package:widyu/core/model/api/api_result.dart';

class AlbumProvider with ChangeNotifier {
  final AlbumRepository _repository;
  final PointProvider _pointProvider;

  AlbumProvider({
    required AlbumRepository repository,
    required PointProvider pointProvider,
  })  : _repository = repository,
        _pointProvider = pointProvider;

  bool _disposed = false;

  @override
  void dispose() {
    _disposed = true;
    _deletedAlbumIds.dispose();
    super.dispose();
  }

  final Map<int, AlbumPost> _posts = {};
  final _deletedAlbumIds = ValueNotifier<Set<int>>(const {});
  bool get isDisposed => _disposed;

  ValueListenable<Set<int>> get deletedAlbumIds => _deletedAlbumIds;
  AlbumPost? postOf(int albumId) => _posts[albumId];
  bool isDeleted(int albumId) => _deletedAlbumIds.value.contains(albumId);

  bool _canApplyRead(int albumId) =>
      !isDeleted(albumId) && !_pendingLikeIds.contains(albumId);

  Future<bool> updateFeed({
    required int albumId,
    required String content,
  }) async {
    if (_disposed || isDeleted(albumId)) return false;
    final result = await _repository.updateFeed(
      albumId: albumId,
      content: content,
    );
    if (_disposed || isDeleted(albumId)) return false;
    if (result is Failure) {
      return false;
    }
    WiduLog.ui.i('게시글 수정 성공 albumId=$albumId');
    final post = _posts[albumId];
    if (post != null) _posts[albumId] = post.copyWith(content: content);
    notifyListeners();
    return true;
  }

  final Map<int, AlbumStat> _stats = {};
  final Set<int> _pendingLikeIds = {};

  final Set<int> _unlockedIds = {};
  final Set<int> _pendingUnlockedIds = {};

  bool isUnlocked(int albumId) => _unlockedIds.contains(albumId);

  bool isUnlocking(int albumId) => _pendingUnlockedIds.contains(albumId);

  bool _isUnlockedLoaded = false;

  Future<void> ensureUnlockedLoaded() async {
    if (_isUnlockedLoaded) return;
    await loadUnlockedAlbumIds();
  }

  Future<void> loadUnlockedAlbumIds() async {
    if (_disposed) return;
    final result = await _repository.fetchUnlockedAlbums();
    if (_disposed || result is! Success<List<int>>) return;

    _unlockedIds
      ..clear()
      ..addAll(result.data.where((id) => !isDeleted(id)));
    _isUnlockedLoaded = true;
    notifyListeners();
  }

  Future<bool> unlock(int albumId) async {
    if (_disposed || isDeleted(albumId)) return false;
    if (_unlockedIds.contains(albumId)) return true;
    if (!_pendingUnlockedIds.add(albumId)) return false;
    notifyListeners();

    try {
      final result = await _repository.unlockFeed(albumId);
      if (_disposed || isDeleted(albumId)) return false;

      if (result is Failure) {
        return false;
      }

      final unlockedId = (result as Success<AlbumUnlock>).data.albumId;
      WiduLog.ui.i('게시글 잠금 해제 성공 albumId=$albumId');
      _unlockedIds
        ..add(albumId)
        ..add(unlockedId);
      notifyListeners();

      await _pointProvider.refresh();
      return !_disposed && !isDeleted(albumId);
    } finally {
      if (!_disposed) {
        _pendingUnlockedIds.remove(albumId);
        notifyListeners();
      }
    }
  }

  AlbumStat statOf(int albumId) {
    return _stats[albumId] ??
        const AlbumStat(isLiked: false, likeCount: 0, commentCount: 0);
  }

  bool isLiked(int albumId) => statOf(albumId).isLiked;

  Future<void> loadLikedAlbumIds() async {
    if (_disposed) return;
    final result = await _repository.fetchLikedFeeds();
    if (_disposed || result is! Success<List<int>>) return;

    final liked = result.data.toSet();
    for (final id in {..._stats.keys, ...liked}) {
      if (!_canApplyRead(id)) continue;
      _stats[id] = statOf(id).copyWith(isLiked: liked.contains(id));
    }
    notifyListeners();
  }

  void hydrate(Iterable<FeedBase> feeds) {
    if (_disposed) return;
    var changed = false;

    for (final feed in feeds) {
      if (!_canApplyRead(feed.albumId)) continue;
      final previous = _posts[feed.albumId];
      _posts[feed.albumId] = AlbumPost.fromFeed(
        feed,
        thumbnailUrls: previous?.thumbnailUrls ?? const [],
      );
      _stats[feed.albumId] = AlbumStat(
        isLiked: statOf(feed.albumId).isLiked,
        likeCount: feed.likeCount,
        commentCount: feed.commentCount,
      );
      changed = true;
    }

    if (changed) notifyListeners();
  }

  Future<void> toggleLike(int albumId) async {
    if (_disposed || isDeleted(albumId)) return;
    if (_pendingLikeIds.contains(albumId)) return;

    final before = statOf(albumId);
    final wasLiked = before.isLiked;

    _pendingLikeIds.add(albumId);
    _stats[albumId] = before.copyWith(
      isLiked: !wasLiked,
      likeCount: wasLiked ? before.likeCount - 1 : before.likeCount + 1,
    );
    notifyListeners();

    final result = wasLiked
        ? await _repository.unlikeFeed(albumId)
        : await _repository.likeFeed(albumId);

    if (_disposed || isDeleted(albumId)) return;
    _pendingLikeIds.remove(albumId);

    if (result is Failure) {
      _stats[albumId] = statOf(
        albumId,
      ).copyWith(isLiked: wasLiked, likeCount: before.likeCount);
      notifyListeners();
      return;
    }
    WiduLog.ui.i('${wasLiked ? '좋아요 취소' : '좋아요'} 성공 albumId=$albumId');
  }

  Future<bool> deleteFeed(int albumId) async {
    if (_disposed) return false;
    if (isDeleted(albumId)) return true;
    final result = await _repository.deleteFeed(albumId);

    if (result is Failure) {
      return false;
    }

    WiduLog.ui.i('게시글 삭제 성공 albumId=$albumId');
    if (_disposed) return false;
    _posts.remove(albumId);
    _stats.remove(albumId);
    _pendingLikeIds.remove(albumId);
    _pendingUnlockedIds.remove(albumId);
    _unlockedIds.remove(albumId);
    _deletedAlbumIds.value = Set.unmodifiable({
      ..._deletedAlbumIds.value,
      albumId,
    });
    notifyListeners();
    return true;
  }

  void addViewer(int albumId, Member viewer) {
    if (_disposed || isDeleted(albumId)) return;
    final post = _posts[albumId];
    if (post == null || post.viewers.any((v) => v.id == viewer.id)) return;
    _posts[albumId] = post.copyWith(viewers: [...post.viewers, viewer]);
    notifyListeners();
  }

  void onCommentAdded(int albumId) => _addCommentCount(albumId, 1);

  void onCommentDeleted(int albumId, {int count = 1}) =>
      _addCommentCount(albumId, -count);

  void _addCommentCount(int albumId, int delta) {
    if (_disposed || isDeleted(albumId)) return;
    final stat = _stats[albumId];
    if (stat == null) return;

    final count = stat.commentCount + delta;
    _stats[albumId] = stat.copyWith(commentCount: count < 0 ? 0 : count);
    notifyListeners();
  }
}
