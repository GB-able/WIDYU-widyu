import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:widyu/core/data/repository/album/album_repository_impl.dart';
import 'package:widyu/core/di/providers.dart';
import 'package:widyu/feature/album/manage_post/manage_post_view_model.dart';

import 'album_fakes.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late FakeAlbumDataSource dataSource;
  late AlbumRepositoryImpl repository;
  late FakePointRepository pointRepository;
  late ProviderContainer container;

  setUp(() {
    dataSource = FakeAlbumDataSource();
    repository = fakeAlbumRepository(dataSource);
    pointRepository = FakePointRepository();
    container = ProviderContainer.test(
      overrides: [
        albumRepositoryProvider.overrideWithValue(repository),
        pointRepositoryProvider.overrideWithValue(pointRepository),
      ],
    );
  });

  ManagePostViewModel listen() {
    container.listen(managePostViewModelProvider, (_, __) {});
    return container.read(managePostViewModelProvider.notifier);
  }

  bool isUploading() => container.read(managePostViewModelProvider);

  test('올리면 포인트와 잠금 해제 목록을 갱신한다', () async {
    final viewModel = listen();
    final uploaded = viewModel.uploadFeed([], '내용');
    expect(isUploading(), isTrue);

    expect(await uploaded, isTrue);
    expect(isUploading(), isFalse);
    expect(dataSource.calls, ['uploadFeed', 'fetchUnlockedAlbums']);
    expect(pointRepository.refreshCalls, 1);
  });

  test('올리는 중 화면이 닫혀도 포인트와 잠금 해제 목록은 갱신한다', () async {
    final viewModel = listen();
    dataSource.gates['uploadFeed'] = Completer();
    final uploaded = viewModel.uploadFeed([], '내용');
    await pumpEventQueue();

    container.dispose();
    dataSource.gates['uploadFeed']!.complete();
    // finally의 가드가 없으면 폐기된 state에 쓰다가 예외가 난다.
    expect(await uploaded, isTrue);
    expect(dataSource.calls, ['uploadFeed', 'fetchUnlockedAlbums']);
    expect(pointRepository.refreshCalls, 1);
  });

  test('올리는 중에는 다시 올리지 않는다', () async {
    final viewModel = listen();
    dataSource.gates['uploadFeed'] = Completer();
    final first = viewModel.uploadFeed([], '내용');
    expect(await viewModel.uploadFeed([], '내용'), isFalse);

    dataSource.gates['uploadFeed']!.complete();
    await first;
    expect(dataSource.calls.where((c) => c == 'uploadFeed'), hasLength(1));
  });

  test('수정하면 앞뒤 공백을 뺀 내용을 돌려준다', () async {
    final viewModel = listen();
    expect(await viewModel.updateFeed(1, '  수정  '), '수정');
    expect(dataSource.contents, ['수정']);
    expect(isUploading(), isFalse);
  });

  test('수정 중 화면이 닫혀도 예외 없이 끝난다', () async {
    final viewModel = listen();
    dataSource.gates['updateFeed'] = Completer();
    final updated = viewModel.updateFeed(1, '수정');
    await pumpEventQueue();

    container.dispose();
    dataSource.gates['updateFeed']!.complete();
    // finally의 가드가 없으면 폐기된 state에 쓰다가 예외가 난다.
    expect(await updated, '수정');
  });
}
