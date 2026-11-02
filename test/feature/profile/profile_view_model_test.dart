import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:widyu/core/data/repository/myPage/my_page_repository.dart';
import 'package:widyu/core/di/providers.dart';
import 'package:widyu/core/model/api/api_result.dart';
import 'package:widyu/core/model/myPage/profile/user_profile.dart';
import 'package:widyu/feature/profile/profile_ui_event.dart';
import 'package:widyu/feature/profile/profile_view_model.dart';

class _Repository extends Fake implements MyPageRepository {
  final pending = Completer<ApiResult<UserProfile>>();
  int calls = 0;

  @override
  Future<ApiResult<UserProfile>> fetchUserProfile() {
    calls++;
    return pending.future;
  }
}

void main() {
  late _Repository repository;
  late ProviderContainer container;
  late List<ProfileUiEvent> events;

  setUp(() {
    repository = _Repository();
    container = ProviderContainer.test(overrides: [
      myPageRepositoryProvider.overrideWithValue(repository),
    ]);
    events = [];
  });

  // 첫 listen에서 build()가 실행되고 조회는 다음 microtask에 시작한다.
  // setUp과 테스트 본문 사이에도 microtask가 돌므로 테스트 안에서 부른다.
  void listen() {
    container.listen(profileViewModelProvider, (_, __) {});
    container
        .read(profileViewModelProvider.notifier)
        .uiEvent
        .listen(events.add);
  }

  test('조회 시작 전에 폐기되면 조회하지 않는다', () async {
    listen();
    container.dispose();
    // 가드가 없으면 폐기된 Notifier의 state에 접근하다가 예외가 나서 실패한다.
    await pumpEventQueue();
    expect(repository.calls, 0);
    expect(events, isEmpty);
  });

  test('조회 중 폐기되면 상태와 이벤트를 쓰지 않는다', () async {
    listen();
    await pumpEventQueue();
    expect(repository.calls, 1);

    container.dispose();
    repository.pending.complete(const ApiResult.failure('error'));
    // 가드가 없으면 폐기된 Notifier의 state나 닫힌 이벤트 stream에 쓰다가 예외가 나서 실패한다.
    await pumpEventQueue();
    expect(events, isEmpty);
  });

  test('프로필을 불러오고 생년월일을 점으로 구분한다', () async {
    listen();
    await pumpEventQueue();

    repository.pending.complete(const ApiResult.success(UserProfile(
      name: '홍길동',
      birthDate: '1950-01-02',
      phoneNumber: '010-0000-0000',
      address: '서울',
      inviteCode: 'CODE',
    )));
    await pumpEventQueue();
    final state = container.read(profileViewModelProvider);
    expect(state.isLoading, isFalse);
    expect(state.profileImage, '');
    expect(state.name, '홍길동');
    expect(state.birthDate, '1950.01.02');
    expect(state.phoneNumber, '010-0000-0000');
    expect(state.address, '서울');
    expect(state.inviteCode, 'CODE');
    expect(events, isEmpty);
  });
}
