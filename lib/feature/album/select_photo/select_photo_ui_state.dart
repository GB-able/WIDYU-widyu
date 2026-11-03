import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:widyu/feature/album/select_photo/select_photo_view_model.dart';

part 'select_photo_ui_state.freezed.dart';

@freezed
abstract class SelectPhotoUiState with _$SelectPhotoUiState {
  const SelectPhotoUiState._();

  const factory SelectPhotoUiState({
    PermissionStatus? cameraPermission,
    PermissionState? photoPermission,
    @Default(PhotoFilter.all) PhotoFilter filter,
    @Default({}) Map<PhotoFilter, List<AssetEntity>> assetsByFilter,
    @Default({}) Map<PhotoFilter, int> totalCountByFilter,
    @Default({}) Map<PhotoFilter, bool> hasMoreByFilter,
    @Default({}) Set<PhotoFilter> loadingFilters,
    @Default([]) List<AssetEntity> selected,
    @Default(false) bool isCapturing,
  }) = _SelectPhotoUiState;

  List<AssetEntity> get currAssets => assetsByFilter[filter] ?? const [];
  bool get isLoading => loadingFilters.contains(filter) && currAssets.isEmpty;
  int get totalCount => totalCountByFilter[filter] ?? 0;
  bool get hasMore => hasMoreByFilter[filter] ?? false;
  bool get hasCameraPermission => cameraPermission == PermissionStatus.granted;
  bool get hasPhotoPermission =>
      photoPermission == PermissionState.authorized ||
      photoPermission == PermissionState.limited;

  int? selectOrder(AssetEntity asset) {
    final index = selected.indexWhere((e) => e.id == asset.id);
    return index >= 0 ? index + 1 : null;
  }
}
