import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:widyu/core/data/repository/notification/notification_repository.dart';
import 'package:widyu/core/di/providers.dart';
import 'package:widyu/core/model/api/api_result.dart';
import 'package:widyu/core/model/notification/notification_setting.dart';
import 'package:widyu/feature/notification_setting/notification_setting_ui_event.dart';
import 'package:widyu/feature/notification_setting/notification_setting_view_model.dart';

class _Repository extends Fake implements NotificationRepository {
  final pending = Completer<ApiResult<List<NotificationSetting>>>();
  int calls = 0;

  @override
  Future<ApiResult<List<NotificationSetting>>> fetchNotificationSettings() {
    calls++;
    return pending.future;
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
    container.read(notificationSettingViewModelProvider.notifier).uiEvent.listen(events.add);
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
}
