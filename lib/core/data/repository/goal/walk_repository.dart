import 'package:widyu/core/model/goal/walk/walk_sync_result.dart';

abstract class WalkRepository {
  Future<bool> ensurePermission();

  Future<WalkSaveResult> sync({
    required String memberId,
    bool full = false,
    bool Function()? isCancelled,
    bool background = false,
  });
}
