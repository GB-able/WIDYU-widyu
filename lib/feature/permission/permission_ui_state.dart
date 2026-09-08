import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:widyu/core/model/permission/permission_type.dart';
import 'package:widyu/feature/permission/permission_ui_model.dart';

part 'permission_ui_state.freezed.dart';

@freezed
abstract class PermissionUiState with _$PermissionUiState {
  const PermissionUiState._();

  const factory PermissionUiState({
    @Default(false) bool isRequesting,
    @Default(PermissionType.values) List<PermissionType> permissions,
  }) = _PermissionUiState;

  List<PermissionType> get requiredPermissions =>
      permissions.where((type) => type.isRequired).toList();

  List<PermissionType> get optionalPermissions =>
      permissions.where((type) => !type.isRequired).toList();
}
