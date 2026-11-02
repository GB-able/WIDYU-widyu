import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:widyu/core/data/repository/auth/auth_repository.dart';
import 'package:widyu/core/di/providers.dart';
import 'package:widyu/core/model/api/api_result.dart';
import 'package:widyu/feature/auth/login_ui_state.dart';
import 'package:widyu/feature/auth/login_view_model.dart';

class _Auth extends Fake implements AuthRepository {
  ApiResult<void> result = const ApiResult.failure('error', statusCode: 404);
  Completer<ApiResult<void>>? pending;

  @override
  Future<ApiResult<void>> login(String inviteCode, String phoneNumber) =>
      pending?.future ?? Future.value(result);
}

void main() {
  // 테스트 호스트는 Android가 아니어서 전화 권한 확인이 미지원으로 끝나 직접 입력 상태가 된다.
  // 실제 화면처럼 이 확인(로딩)이 끝난 뒤에 번호를 입력하도록, 테스트마다 먼저 pumpEventQueue한다.
  late _Auth auth;
  late ProviderContainer container;
  var successes = 0;
  final failures = <String>[];

  setUp(() {
    auth = _Auth();
    container = ProviderContainer.test(overrides: [
      authRepositoryProvider.overrideWithValue(auth),
    ]);
    successes = 0;
    failures.clear();
  });

  // 첫 listen에서 build()가 실행되고 전화번호 확인은 다음 microtask에 시작한다.
  LoginViewModel listen() {
    container.listen(loginViewModelProvider, (_, __) {});
    return container.read(loginViewModelProvider.notifier);
  }

  LoginUiState state() => container.read(loginViewModelProvider);

  Future<void> login(LoginViewModel viewModel) => viewModel.login(
        '1234567',
        onSuccess: () => successes++,
        onFailure: failures.add,
      );

  test('전화번호를 가져오지 못하면 로딩을 끝내고 직접 입력 화면을 보여 준다', () async {
    listen();
    expect(state(), isA<LoginPhoneState>());
    expect(state().isLoading, isTrue);

    await pumpEventQueue();
    expect(state(), isA<LoginPhoneState>());
    expect(state().isLoading, isFalse);
  });

  test('전화번호 확인 시작 전에 폐기돼도 오류가 없다', () async {
    listen();
    container.dispose();
    // 첫 await 전에는 ref를 쓰지 않아 첫 줄 가드가 없어도 통과한다(패턴 일관성용 가드).
    await pumpEventQueue();
  });

  test('초대숫자가 틀리면 세 번째부터 보호자 확인을 안내한다', () async {
    final viewModel = listen();
    await pumpEventQueue();
    viewModel.setPhoneNumber('010-1234-5678');

    await login(viewModel);
    expect(state().error, LoginError.loginFailed);
    await login(viewModel);
    expect(state().error, LoginError.loginFailed);
    await login(viewModel);
    expect(state().error, LoginError.loginFailedALot);
    expect(state(), isA<LoginCodeState>());
    expect(successes, 0);
  });

  test('로그인에 성공하면 성공 콜백을, 그 밖의 실패면 실패 콜백을 부른다', () async {
    final viewModel = listen();
    await pumpEventQueue();
    viewModel.setPhoneNumber('01012345678');

    auth.result = const ApiResult.success(null);
    await login(viewModel);
    expect(successes, 1);

    auth.result = const ApiResult.failure('error', statusCode: 500);
    await login(viewModel);
    expect(failures, ['로그인 실패. 잠시 후 다시 시도하세요']);
    expect(state().error, isNull);
  });

  test('로그인 중 폐기되면 콜백과 상태를 쓰지 않는다', () async {
    final viewModel = listen();
    await pumpEventQueue();
    viewModel.setPhoneNumber('01012345678');
    auth.pending = Completer();
    final request = login(viewModel);

    container.dispose();
    auth.pending!.complete(const ApiResult.success(null));
    // 가드가 없으면 폐기된 화면의 콜백을 부르거나 폐기된 state에 쓴다.
    await request;
    expect(successes, 0);
  });

  test('전화번호를 직접 입력했으면 뒤로 갈 때 초대숫자를 지운 다음 전화번호 입력으로 돌아간다',
      () async {
    final viewModel = listen();
    await pumpEventQueue();
    viewModel.setPhoneNumber('01012345678');
    LoginUiState? whenCleared;
    var closed = false;

    viewModel.backFromCode(
      close: () => closed = true,
      // 화면에서는 초대숫자를 지우면 입력 리스너가 초대숫자 상태로 바꾼다.
      // 상태를 먼저 바꾸면 그 뒤에 지우면서 초대숫자 화면으로 되돌아가므로 순서를 고정한다.
      clearCode: () => whenCleared = state(),
    );
    expect(whenCleared, isA<LoginCodeState>());
    expect(state(), isA<LoginPhoneState>());
    expect(closed, isFalse);
  });
}
