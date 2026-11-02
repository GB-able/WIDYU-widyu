import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:widyu/core/data/repository/myPage/my_page_repository.dart';
import 'package:widyu/core/di/providers.dart';
import 'package:widyu/core/model/api/api_result.dart';
import 'package:widyu/core/model/myPage/contact/contact.dart';
import 'package:widyu/core/model/myPage/contact/family_member.dart';
import 'package:widyu/feature/contact/contact_ui_event.dart';
import 'package:widyu/feature/contact/contact_view_model.dart';

class _Repository extends Fake implements MyPageRepository {
  ApiResult<Contact> contact = const ApiResult.failure('error');
  ApiResult<void> update = const ApiResult.failure('error');
  Completer<ApiResult<Contact>>? pending;

  @override
  Future<ApiResult<Contact>> fetchContact() =>
      pending?.future ?? Future.value(contact);

  @override
  Future<ApiResult<void>> updateRepresentativeContact(int memberId) async =>
      update;
}

FamilyMember _member(int id, {bool representative = false}) => FamilyMember(
      memberId: id,
      name: '$id',
      phoneNumber: '010',
      isRepresentative: representative,
    );

void main() {
  late _Repository repository;
  late ProviderContainer container;
  late List<ContactUiEvent> events;

  // 첫 listen에서 build()가 동기로 실행되고 조회는 다음 microtask에 시작한다.
  // 이벤트를 놓치지 않도록 await 전에 uiEvent를 구독한다.
  setUp(() {
    repository = _Repository();
    container = ProviderContainer.test(overrides: [
      myPageRepositoryProvider.overrideWithValue(repository),
    ]);
    events = [];
  });

  void listen() {
    container.listen(contactViewModelProvider, (_, __) {});
    container.read(contactViewModelProvider.notifier).uiEvent.listen(events.add);
  }

  test('대표 연락처를 맨 앞으로 정렬해 불러온다', () async {
    repository.contact = ApiResult.success(Contact(
      representative: null,
      familyMembers: [_member(1), _member(2, representative: true)],
    ));
    listen();
    expect(container.read(contactViewModelProvider).isLoading, isTrue);

    await pumpEventQueue();
    final state = container.read(contactViewModelProvider);
    expect(state.isLoading, isFalse);
    expect(state.familyMembers.map((m) => m.memberId), [2, 1]);
    expect(events, isEmpty);
  });

  test('조회에 실패하면 실패를 알리고 로딩을 끝낸다', () async {
    listen();

    await pumpEventQueue();
    expect(events.single, isA<FetchContactFailure>());
    expect(container.read(contactViewModelProvider).isLoading, isFalse);
  });

  test('대표 연락처 변경에 실패하면 실패를 알린다', () async {
    repository.contact = const ApiResult.success(
      Contact(representative: null, familyMembers: []),
    );
    listen();
    await pumpEventQueue();

    await container
        .read(contactViewModelProvider.notifier)
        .updateRepresentativeContact(1);
    await pumpEventQueue();
    expect(events.single, isA<UpdateRepresentativeContactFailure>());
  });

  test('조회 중 폐기되면 상태와 이벤트를 쓰지 않는다', () async {
    repository.pending = Completer();
    listen();
    await pumpEventQueue();

    container.dispose();
    repository.pending!.complete(const ApiResult.failure('error'));
    await pumpEventQueue();
    expect(events, isEmpty);
  });

  test('다시 빌드돼도 같은 이벤트 stream을 유지한다', () async {
    listen();
    await pumpEventQueue();

    container.invalidate(contactViewModelProvider);
    container.read(contactViewModelProvider);
    await pumpEventQueue();
    expect(events, [isA<FetchContactFailure>(), isA<FetchContactFailure>()]);
  });
}
