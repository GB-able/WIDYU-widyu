import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:widyu/core/data/repository/album/album_repository_impl.dart';
import 'package:widyu/core/model/album/album_cache.dart';
import 'package:widyu/core/model/album/album_stat.dart';
import 'package:widyu/core/model/album/album_unlock.dart';

import '../../../../feature/album/album_fakes.dart';

void main() {
  late FakeAlbumDataSource dataSource;
  late FakePointRepository points;
  late AlbumRepositoryImpl repository;

  AlbumRepositoryImpl create() => AlbumRepositoryImpl(
        remoteDataSource: dataSource,
        pointRepository: points,
      );

  AlbumCache cache() => repository.currentCache;

  Completer<void> gate(String name) =>
      dataSource.gates[name] = Completer<void>();

  final unlocked = okResponse(
      AlbumUnlock(unlockId: 1, albumId: 1, unlockedAt: DateTime(2026)));

  setUp(() {
    dataSource = FakeAlbumDataSource();
    points = FakePointRepository();
    repository = create()..hydrate([feed(1)]);
  });

  tearDown(() => repository.dispose());

  test('삭제에 성공한 뒤에만 캐시에서 빼고, 다시 지워도 한 번만 알린다', () async {
    final deletions = <Set<int>>[];
    var last = cache().deletedIds;
    final subscription = repository.cache.listen((cache) {
      if (identical(cache.deletedIds, last)) return;
      last = cache.deletedIds;
      expect(cache.postOf(1), isNull);
      deletions.add(cache.deletedIds);
    });
    addTearDown(subscription.cancel);

    await repository.toggleLike(1);
    repository.onCommentAdded(1);
    expect(await repository.updateFeed(albumId: 1, content: '수정'), isTrue);
    await pumpEventQueue();
    expect(deletions, isEmpty);

    dataSource.deleted = errorResponse();
    expect(await repository.deleteFeed(1), isFalse);
    await pumpEventQueue();
    expect(deletions, isEmpty);

    dataSource.deleted = okResponse();
    expect(await repository.deleteFeed(1), isTrue);
    expect(await repository.deleteFeed(1), isTrue);
    await pumpEventQueue();
    expect(deletions, [
      {1},
    ]);
    expect(() => cache().deletedIds.clear(), throwsUnsupportedError);
  });

  test('수정·삭제에 실패하면 캐시를 그대로 둔다', () async {
    dataSource
      ..updated = errorResponse()
      ..deleted = errorResponse();

    expect(await repository.updateFeed(albumId: 1, content: '수정'), isFalse);
    expect(await repository.deleteFeed(1), isFalse);
    expect(cache().postOf(1)!.content, '내용 1');
    expect(cache().isDeleted(1), isFalse);
  });

  test('상세 응답은 썸네일과 좋아요·댓글 수를 상세 값으로 바꾼다', () {
    repository.hydrate([
      feedDetail(1).copyWith(
        content: '상세',
        thumbnailUrls: ['detail_thumb.jpg'],
        likeCount: 7,
        commentCount: 4,
      ),
    ]);

    expect(cache().postOf(1)!.content, '상세');
    expect(cache().postOf(1)!.thumbnailUrls, ['detail_thumb.jpg']);
    expect(cache().statOf(1).likeCount, 7);
    expect(cache().statOf(1).commentCount, 4);
  });

  test('폐기된 저장소는 늦은 응답을 반영하지 않고 새 저장소와 섞이지 않는다', () {
    final previous = repository..dispose();
    repository = create();

    previous.hydrate([feed(1).copyWith(content: '늦은 응답')]);
    expect(previous.currentCache.postOf(1)!.content, '내용 1');
    expect(cache().postOf(1), isNull);

    repository.hydrate([feed(1).copyWith(content: '새 세션')]);
    expect(cache().postOf(1)!.content, '새 세션');
  });

  test('잠금 해제는 성공 전까지 잠긴 상태이고, 예외 뒤 다시 시도할 수 있다', () async {
    final pending = gate('unlockFeed');
    dataSource.errors['unlockFeed'] = Exception('network');

    final unlocking = repository.unlock(1);
    expect(cache().isUnlocked(1), isFalse);
    expect(cache().isUnlocking(1), isTrue);
    expect(await repository.unlock(1), isFalse);

    pending.complete();
    expect(await unlocking, isFalse);
    expect(cache().isUnlocked(1), isFalse);
    expect(cache().isUnlocking(1), isFalse);
    expect(points.refreshCalls, 0);

    dataSource
      ..gates.remove('unlockFeed')
      ..errors.remove('unlockFeed')
      ..unlockResult = unlocked;
    expect(await repository.unlock(1), isTrue);
    expect(cache().isUnlocked(1), isTrue);
    expect(cache().isUnlocking(1), isFalse);
    expect(points.refreshCalls, 1);
  });

  test('좋아요 요청 중 좋아요 목록을 다시 불러와도 좋아요 상태를 유지한다', () async {
    final pending = gate('likeFeed');

    final liking = repository.toggleLike(1);
    expect(cache().statOf(1).isLiked, isTrue);
    await repository.loadLikedAlbumIds();
    pending.complete();
    await liking;

    expect(cache().statOf(1).isLiked, isTrue);
  });

  test('수정·좋아요 성공은 그사이 늘어난 댓글 수를 지우지 않는다', () async {
    final edit = gate('updateFeed');
    final like = gate('likeFeed');

    final editing = repository.updateFeed(albumId: 1, content: '수정');
    final liking = repository.toggleLike(1);
    repository.onCommentAdded(1);
    edit.complete();
    await editing;
    like.complete();
    await liking;

    expect(cache().postOf(1)!.content, '수정');
    expect(
      cache().statOf(1),
      const AlbumStat(isLiked: true, likeCount: 1, commentCount: 1),
    );
  });

  test('좋아요 실패로 되돌려도 그사이 늘어난 댓글 수는 유지한다', () async {
    final pending = gate('likeFeed');
    dataSource.likeResult = errorResponse();

    final liking = repository.toggleLike(1);
    repository.onCommentAdded(1);
    pending.complete();
    await liking;

    expect(
      cache().statOf(1),
      const AlbumStat(isLiked: false, likeCount: 0, commentCount: 1),
    );
  });

  test('폐기된 저장소의 잠금 해제 목록 응답은 새 저장소에 반영하지 않는다', () async {
    final pending = gate('fetchUnlockedAlbums');
    dataSource.unlocked = okResponse([1]);

    final loading = repository.loadUnlockedAlbumIds();
    repository.dispose();
    repository = create();
    pending.complete();
    await loading;

    expect(cache().isUnlocked(1), isFalse);
  });

  test('잠금 해제 목록을 불러오는 중 해제한 게시물은 목록 응답 뒤에도 열려 있다', () async {
    final pending = gate('fetchUnlockedAlbums');
    dataSource
      ..unlocked = okResponse([2])
      ..unlockResult = unlocked;

    final loading = repository.loadUnlockedAlbumIds();
    expect(await repository.unlock(1), isTrue);
    pending.complete();
    await loading;

    expect(cache().isUnlocked(1), isTrue);
    expect(cache().isUnlocked(2), isTrue);
  });

  test('잠금 해제 목록 확인을 동시에 불러도 한 번만 요청하고, 실패하면 다시 요청한다', () async {
    int requests() =>
        dataSource.calls.where((name) => name == 'fetchUnlockedAlbums').length;
    final pending = gate('fetchUnlockedAlbums');
    dataSource.unlocked = errorResponse();

    final first = repository.ensureUnlockedLoaded();
    final second = repository.ensureUnlockedLoaded();
    pending.complete();
    await Future.wait([first, second]);
    expect(requests(), 1);

    dataSource
      ..gates.remove('fetchUnlockedAlbums')
      ..unlocked = okResponse([1]);
    await repository.ensureUnlockedLoaded();
    await repository.ensureUnlockedLoaded();
    expect(requests(), 2);
    expect(cache().isUnlocked(1), isTrue);
  });

  test('이전 세션의 변경은 같은 id의 새 게시물을 바꾸지 않는다', () async {
    final like = gate('likeFeed');
    final unlock = gate('unlockFeed');
    final edit = gate('updateFeed');
    final delete = gate('deleteFeed');
    dataSource
      ..likeResult = errorResponse()
      ..unlockResult = unlocked;

    final liking = repository.toggleLike(1);
    final unlocking = repository.unlock(1);
    final editing = repository.updateFeed(albumId: 1, content: '이전 세션 수정');
    final deleting = repository.deleteFeed(1);
    repository.dispose();
    repository = create()..hydrate([feed(1).copyWith(content: '새 세션')]);
    for (final gate in [like, unlock, edit, delete]) {
      gate.complete();
    }

    await liking;
    expect(await unlocking, isFalse);
    expect(await editing, isFalse);
    expect(await deleting, isFalse);
    expect(cache().postOf(1)!.content, '새 세션');
    expect(cache().isDeleted(1), isFalse);
    expect(cache().statOf(1).isLiked, isFalse);
    expect(cache().isUnlocked(1), isFalse);
    expect(points.refreshCalls, 0);
  });

  test('대기 중인 좋아요·잠금 해제가 삭제를 되돌리지 않는다', () async {
    final like = gate('likeFeed');
    final unlock = gate('unlockFeed');
    dataSource
      ..likeResult = errorResponse()
      ..unlockResult = unlocked;

    final liking = repository.toggleLike(1);
    final unlocking = repository.unlock(1);
    await repository.deleteFeed(1);
    like.complete();
    unlock.complete();

    await liking;
    expect(await unlocking, isFalse);
    expect(cache().postOf(1), isNull);
    expect(cache().isUnlocking(1), isFalse);
    expect(cache().isUnlocked(1), isFalse);
    expect(cache().statOf(1).likeCount, 0);
  });
}
