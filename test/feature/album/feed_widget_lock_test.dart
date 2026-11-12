import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:widyu/core/data/repository/album/album_repository.dart';
import 'package:widyu/core/data/repository/album/album_repository_impl.dart';
import 'package:widyu/core/di/providers.dart';
import 'package:widyu/core/model/album/feed.dart';
import 'package:widyu/core/ui/widgets/widu_icon.dart';
import 'package:widyu/feature/album/feed/feed_tab_view.dart';
import 'package:widyu/gen/assets.gen.dart';

import 'album_fakes.dart';

final lockIcon = find.byWidgetPredicate(
  (widget) => widget is WiduIcon && widget.icon == Assets.icons.ic60Lock,
);

const lockMessage = '소식을 구매하고\n가족들의 일상을 둘러보세요';

late FakeAlbumDataSource dataSource;

Feed buildFeed({required int albumId, required bool canEdit}) => Feed(
      albumId: albumId,
      authorName: '엄마',
      content: '비밀 본문입니다',
      mediaUrls: const ['https://example.com/a.jpg'],
      thumbnailUrls: const ['https://example.com/a.jpg'],
      likeCount: 3,
      commentCount: 2,
      viewers: const [],
      createdAt: DateTime(2025, 9),
      canEdit: canEdit,
      price: 50,
    );

Future<AlbumRepository> pumpFeed(
  WidgetTester tester, {
  required Feed feed,
  List<int> unlockedIds = const [],
}) async {
  dataSource = FakeAlbumDataSource()
    ..feeds = okResponse(page([feed]))
    ..unlocked = okResponse(unlockedIds);
  final pointRepository = FakePointRepository();
  final albumRepository = AlbumRepositoryImpl(
    remoteDataSource: dataSource,
    pointRepository: pointRepository,
  );
  addTearDown(albumRepository.dispose);
  await albumRepository.loadUnlockedAlbumIds();

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        pointRepositoryProvider.overrideWithValue(pointRepository),
        albumRepositoryProvider.overrideWithValue(albumRepository),
      ],
      child: const MaterialApp(home: Scaffold(body: FeedTabView())),
    ),
  );
  await settle(tester);
  return albumRepository;
}

Future<void> settle(WidgetTester tester) async {
  await tester.pump();
  await tester.pump();
}

void main() {
  testWidgets('공통 저장소에서 수정·삭제하면 기존 카드에 바로 반영된다', (tester) async {
    final store = await pumpFeed(
      tester,
      feed: buildFeed(albumId: 1, canEdit: true),
      unlockedIds: [1],
    );
    expect(find.text('비밀 본문입니다'), findsOneWidget);
    await store.updateFeed(albumId: 1, content: '수정된 본문');
    await settle(tester);
    expect(find.text('수정된 본문'), findsOneWidget);
    expect(find.text('비밀 본문입니다'), findsNothing);
    await store.deleteFeed(1);
    await settle(tester);
    expect(find.text('수정된 본문'), findsNothing);
    expect(lockIcon, findsNothing);
  });

  testWidgets('잠긴 피드는 가격과 안내 문구를 덮고 본문을 감춘다', (tester) async {
    await pumpFeed(tester, feed: buildFeed(albumId: 1, canEdit: false));

    expect(find.text('50P'), findsOneWidget);
    expect(find.text(lockMessage), findsOneWidget);
    expect(lockIcon, findsOneWidget);
    expect(find.text('비밀 본문입니다'), findsNothing);
  });

  testWidgets('해금한 앨범은 덮개 없이 본문이 보인다', (tester) async {
    await pumpFeed(
      tester,
      feed: buildFeed(albumId: 1, canEdit: false),
      unlockedIds: const [1],
    );

    expect(lockIcon, findsNothing);
    expect(find.text('50P'), findsNothing);
    expect(find.text('비밀 본문입니다'), findsOneWidget);
  });

  testWidgets('내가 쓴 글도 해금 목록에 없으면 잠긴 것으로 본다', (tester) async {
    await pumpFeed(tester, feed: buildFeed(albumId: 2, canEdit: true));

    expect(lockIcon, findsOneWidget);
    expect(find.text('비밀 본문입니다'), findsNothing);
  });

  testWidgets('해금 목록을 다시 읽으면 새로 올린 글이 열린다', (tester) async {
    final store = await pumpFeed(
      tester,
      feed: buildFeed(albumId: 3, canEdit: true),
    );
    expect(lockIcon, findsOneWidget);

    dataSource.unlocked = okResponse([3]);
    await store.loadUnlockedAlbumIds();
    await settle(tester);

    expect(lockIcon, findsNothing);
    expect(find.text('비밀 본문입니다'), findsOneWidget);
  });
}
