import 'dart:io';

import 'package:widyu/core/model/api/api_result.dart';
import 'package:widyu/core/model/myPage/user/user.dart';

typedef UserStatus = ({User? user, bool isLoading});

/// 로그인한 사용자 정보를 세션 동안 들고 있는다. 홈·내정보가 같은 값을 구독한다.
abstract class UserRepository {
  /// 사용자 정보와 조회 중 여부. 구독 시 최신 값을 먼저 받는다.
  Stream<UserStatus> get status;
  UserStatus get currentStatus;

  /// 아직 불러오지 않았으면 불러온다. 조회 중이면 그 요청을 함께 기다린다. 실패하면 false.
  Future<bool> ensureLoaded();
  Future<ApiResult<void>> updateName(String name);
  Future<ApiResult<void>> updateProfileImage(File profileImage);
  void dispose();
}
