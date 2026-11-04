import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:rxdart/rxdart.dart';
import 'package:widyu/core/data/repository/user/user_repository.dart';
import 'package:widyu/core/model/api/api_result.dart';
import 'package:widyu/core/model/myPage/user/user.dart';

/// 처음 [ensureLoaded]에서 [pending]을 기다린 뒤 [result]를 캐시한다.
class FakeUserRepository extends Fake implements UserRepository {
  ApiResult<User> result = const ApiResult.failure('unused');
  Completer<void>? pending;
  int loads = 0;

  final _status =
      BehaviorSubject<UserStatus>.seeded((user: null, isLoading: false));

  @override
  Stream<UserStatus> get status => _status.stream;

  @override
  UserStatus get currentStatus => _status.value;

  @override
  Future<bool> ensureLoaded() async {
    loads++;
    if (currentStatus.user != null) return true;
    _status.add((user: null, isLoading: true));
    await pending?.future;
    final result = this.result;
    final user = result is Success<User> ? result.data : null;
    _status.add((user: user, isLoading: false));
    return user != null;
  }

  void emit(User user) => _status.add((user: user, isLoading: false));
}
