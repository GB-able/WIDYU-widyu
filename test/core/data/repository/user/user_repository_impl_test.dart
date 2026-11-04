import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:widyu/core/data/repository/user/user_repository_impl.dart';
import 'package:widyu/core/data/source/myPage/my_page_remote_data_source.dart';
import 'package:widyu/core/model/api/api_response.dart';
import 'package:widyu/core/model/myPage/user/user.dart';

void main() {
  late _Remote remote;
  late UserRepositoryImpl repository;

  setUp(() {
    remote = _Remote();
    repository = UserRepositoryImpl(remoteDataSource: remote);
  });

  tearDown(() => repository.dispose());

  test('동시에 불러도 한 번만 조회하고, 그 뒤에는 캐시를 쓴다', () async {
    final results = await Future.wait(
      [repository.ensureLoaded(), repository.ensureLoaded()],
    );
    expect(results, [true, true]);
    expect(await repository.ensureLoaded(), isTrue);
    expect(remote.fetches, 1);
    expect(repository.currentStatus.user?.name, '홍길동');
  });

  test('이름을 바꾸면 다시 조회하지 않고 캐시에 반영한다', () async {
    await repository.ensureLoaded();
    await repository.updateName('김철수');
    expect(repository.currentStatus.user?.name, '김철수');
    expect(remote.fetches, 1);
  });

  test('조회 중에 이름을 바꾸면 조회가 끝난 뒤 다시 조회한다', () async {
    remote.gate = Completer();
    final loading = repository.ensureLoaded();
    await repository.updateName('김철수');

    remote.name = '김철수';
    remote.gate!.complete();
    await loading;
    await pumpEventQueue();
    expect(remote.fetches, 2);
    expect(repository.currentStatus.user?.name, '김철수');
  });
}

class _Remote extends Fake implements MyPageRemoteDataSource {
  String name = '홍길동';
  Completer<void>? gate;
  int fetches = 0;

  @override
  Future<ApiResponse<User>> fetchUser() async {
    fetches++;
    final user = User(memberId: 1, name: name, points: 0);
    await gate?.future;
    gate = null;
    return ApiResponse(statusCode: 200, code: 'OK', message: '', data: user);
  }

  @override
  Future<ApiResponse<void>> updateName(String name) async =>
      ApiResponse(statusCode: 200, code: 'OK', message: '');
}
