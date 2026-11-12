import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:widyu/core/data/repository/myPage/my_page_repository.dart';
import 'package:widyu/core/di/providers.dart';
import 'package:widyu/core/model/api/api_result.dart';
import 'package:widyu/core/model/myPage/user/user.dart';
import 'package:widyu/feature/album/post/post_screen.dart';

import 'album_fakes.dart';

class _MyPage extends Fake implements MyPageRepository {
  @override
  Future<ApiResult<User>> fetchUser() async =>
      const Success(User(memberId: 1, name: '나', points: 0));
}

void main() {
  Future<String> sendWhileTyping(
    WidgetTester tester, {
    required String typedAfterSend,
  }) async {
    final dataSource = FakeAlbumDataSource()
      ..unlocked = okResponse([1])
      ..detail = okResponse(feedDetail(1))
      ..createdComment = okResponse(comment(5));
    final repository = fakeAlbumRepository(dataSource);
    addTearDown(repository.dispose);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          albumRepositoryProvider.overrideWithValue(repository),
          myPageRepositoryProvider.overrideWithValue(_MyPage()),
        ],
        child: const MaterialApp(home: PostScreen(postId: 1)),
      ),
    );
    await tester.pumpAndSettle();

    final input = find.byType(TextFormField);
    await tester.enterText(input, '안녕');
    final pending = dataSource.gates['createComment'] = Completer<void>();
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pump();

    await tester.enterText(input, typedAfterSend);
    pending.complete();
    await tester.pumpAndSettle();

    return tester.widget<TextFormField>(input).controller!.text;
  }

  testWidgets('전송한 문구 그대로면 등록 후 입력창을 비운다', (tester) async {
    expect(await sendWhileTyping(tester, typedAfterSend: '안녕'), isEmpty);
  });

  testWidgets('응답을 기다리는 동안 새로 쓴 문구는 지우지 않는다', (tester) async {
    expect(await sendWhileTyping(tester, typedAfterSend: '안녕 반가워'), '안녕 반가워');
  });
}
