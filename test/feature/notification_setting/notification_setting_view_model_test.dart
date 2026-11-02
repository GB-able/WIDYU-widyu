import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:widyu/core/data/repository/notification/notification_repository.dart';
import 'package:widyu/core/di/providers.dart';
import 'package:widyu/core/model/api/api_result.dart';
import 'package:widyu/core/model/notification/notification_group.dart';
import 'package:widyu/core/model/notification/notification_setting.dart';
import 'package:widyu/feature/notification_setting/notification_setting_ui_event.dart';
import 'package:widyu/feature/notification_setting/notification_setting_view_model.dart';

class _Repository extends Fake implements NotificationRepository {
  final pending = Completer<ApiResult<List<NotificationSetting>>>();
  int calls = 0;
  ApiResult<NotificationSetting> update = const ApiResult.failure('error');
  NotificationSetting? updated;

  @override
  Future<ApiResult<List<NotificationSetting>>> fetchNotificationSettings() {
    calls++;
    return pending.future;
  }

  @override
  Future<ApiResult<NotificationSetting>> updateNotificationSettings(
      NotificationSetting setting) async {
    updated = setting;
    return update;
  }
}

void main() {
  late _Repository repository;
  late ProviderContainer container;
  late List<NotificationSettingUiEvent> events;

  setUp(() {
    repository = _Repository();
    container = ProviderContainer.test(overrides: [
      notificationRepositoryProvider.overrideWithValue(repository),
    ]);
    events = [];
  });

  // 첫 listen에서 build()가 실행되고 조회는 다음 microtask에 시작한다.
  // setUp과 테스트 본문 사이에도 microtask가 돌므로 테스트 안에서 부른다.
  void listen() {
    container.listen(notificationSettingViewModelProvider, (_, __) {});
    container
        .read(notificationSettingViewModelProvider.notifier)
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

  // 앨범·홈 설정을 불러온 상태로 만든다(정책 버전 3).
  Future<void> load() async {
    listen();
    await pumpEventQueue();
    repository.pending.complete(const ApiResult.success([
      NotificationSetting(
        group: NotificationGroup.home,
        groupName: '홈',
        enabled: true,
        policyRevision: 3,
      ),
      NotificationSetting(
        group: NotificationGroup.album,
        groupName: '앨범',
        enabled: true,
        policyRevision: 3,
      ),
    ]));
    await pumpEventQueue();
  }

  test('알림 설정을 표시 순서대로 불러온다', () async {
    await load();

    final state = container.read(notificationSettingViewModelProvider);
    expect(state.isLoading, isFalse);
    expect(state.policyRevision, 3);
    expect(
      state.notifications.map((n) => n.group),
      [NotificationGroup.album, NotificationGroup.home],
    );
  });

  test('변경에 성공하면 응답 값과 정책 버전을 반영한다', () async {
    await load();
    repository.update = const ApiResult.success(NotificationSetting(
      group: NotificationGroup.album,
      groupName: '앨범',
      enabled: false,
      policyRevision: 4,
    ));

    final album = container
        .read(notificationSettingViewModelProvider)
        .notifications
        .first;
    await container
        .read(notificationSettingViewModelProvider.notifier)
        .updateNotificationSetting(album.copyWith(enabled: false));

    expect(repository.updated?.policyRevision, 3);
    final state = container.read(notificationSettingViewModelProvider);
    expect(state.notifications.first.enabled, isFalse);
    expect(state.isUpdating, isFalse);
    expect(state.policyRevision, 4);
  });

  test('변경에 실패하면 되돌리고 실패를 알린다', () async {
    await load();
    final before =
        container.read(notificationSettingViewModelProvider).notifications;

    await container
        .read(notificationSettingViewModelProvider.notifier)
        .updateNotificationSetting(before.first.copyWith(enabled: false));
    await pumpEventQueue();

    expect(container.read(notificationSettingViewModelProvider).notifications,
        before);
    expect(events.single, isA<UpdateNotificationSettingFailure>());
  });
}
