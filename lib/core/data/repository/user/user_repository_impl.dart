import 'dart:async';
import 'dart:io';

import 'package:rxdart/rxdart.dart';
import 'package:widyu/core/data/repository/user/user_repository.dart';
import 'package:widyu/core/data/source/myPage/my_page_remote_data_source.dart';
import 'package:widyu/core/model/api/api_result.dart';
import 'package:widyu/core/model/myPage/user/user.dart';
import 'package:widyu/core/utils/extensions/api_result_extension.dart';

class UserRepositoryImpl extends UserRepository {
  final MyPageRemoteDataSource _remoteDataSource;

  UserRepositoryImpl({required MyPageRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  final _status =
      BehaviorSubject<UserStatus>.seeded((user: null, isLoading: false));
  Future<bool>? _fetching;
  bool _disposed = false;

  @override
  void dispose() {
    _disposed = true;
    _status.close();
  }

  @override
  Stream<UserStatus> get status => _status.stream;

  @override
  UserStatus get currentStatus => _status.value;

  void _emit(User? user, {required bool isLoading}) {
    if (_disposed) return;
    _status.add((user: user, isLoading: isLoading));
  }

  @override
  Future<bool> ensureLoaded() async {
    if (currentStatus.user != null) return true;
    return _fetch();
  }

  Future<bool> _fetch() =>
      _fetching ??= _requestUser().whenComplete(() => _fetching = null);

  Future<bool> _requestUser() async {
    _emit(currentStatus.user, isLoading: true);
    final result = await _remoteDataSource.fetchUser().toApiResult();
    if (_disposed) return false;
    _emit(
      result is Success<User> ? result.data : currentStatus.user,
      isLoading: false,
    );
    return result is Success;
  }

  /// 변경 전에 시작된 조회는 이전 값을 가져오므로, 끝난 뒤 다시 조회한다.
  void _refetchAfterCurrent() =>
      unawaited((_fetching ?? Future.value(true)).then((_) => _fetch()));

  @override
  Future<ApiResult<void>> updateName(String name) async {
    final result = await _remoteDataSource.updateName(name).toApiResult();
    if (_disposed || result is! Success) return result;
    final user = currentStatus.user;
    if (_fetching != null || user == null) {
      _refetchAfterCurrent();
    } else {
      _emit(user.copyWith(name: name), isLoading: false);
    }
    return result;
  }

  @override
  Future<ApiResult<void>> updateProfileImage(File profileImage) async {
    final result =
        await _remoteDataSource.updateProfileImage(profileImage).toApiResult();
    // 새 사진 주소는 서버만 알기 때문에 다시 조회한다.
    if (!_disposed && result is Success) _refetchAfterCurrent();
    return result;
  }
}
