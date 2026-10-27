import 'package:widyu/core/model/permission/permission_type.dart';

enum PermissionRecoveryAction { cancel, retry, openSettings }

enum PermissionRecoveryMode { rationale, settings }

typedef PermissionRecoveryPrompt = Future<PermissionRecoveryAction> Function(
  PermissionType type,
  PermissionRecoveryMode mode,
);
