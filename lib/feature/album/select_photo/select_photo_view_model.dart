import 'dart:async';

import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:widyu/core/log/log.dart';
import 'package:widyu/core/utils/permission_manager.dart';
import 'package:widyu/core/utils/settings_return_controller.dart';
import 'package:widyu/core/utils/show_toast.dart';
import 'package:widyu/feature/album/select_photo/select_photo_ui_state.dart';

part 'select_photo_view_model.g.dart';

const _maxVideoDurationSeconds = 60;
const _pageSize = 100;
const _maxSelectCount = 8;
const _photoRequestOption = PermissionRequestOption(
  androidPermission: AndroidPermission(
    type: RequestType.common,
    mediaLocation: true,
  ),
);

enum PhotoFilter {
  all(label: '전체', type: RequestType.common),
  image(label: '사진', type: RequestType.image),
  video(label: '동영상', type: RequestType.video);

  const PhotoFilter({required this.label, required this.type});
  final String label;
  final RequestType type;
}

@riverpod
class SelectPhotoViewModel extends _$SelectPhotoViewModel {
  late SettingsReturnController _settings;
  final Map<PhotoFilter, AssetPathEntity?> _paths = {};
  final Map<PhotoFilter, int> _nextPage = {};

  @override
  SelectPhotoUiState build() {
    _settings =
        SettingsReturnController(launcher: PermissionManager.openSettings);
    ref.onDispose(_settings.dispose);
    // Notifier는 다시 빌드돼도 재사용되므로, 상태와 함께 페이지 정보도 비운다.
    _paths.clear();
    _nextPage.clear();
    unawaited(Future.microtask(_init));
    return const SelectPhotoUiState();
  }

  Future<void> _init() async {
    if (!ref.mounted) return;
    await checkCameraPermission();
    if (!ref.mounted) return;
    await _setPhotoPermission(
      PhotoManager.requestPermissionExtend(requestOption: _photoRequestOption),
    );
  }

  Future<void> checkCameraPermission() async {
    final permission = await Permission.camera.status;
    if (!ref.mounted) return;
    state = state.copyWith(cameraPermission: permission);
  }

  Future<void> requestCameraPermission() async {
    final permission = state.cameraPermission;
    if (permission == PermissionStatus.permanentlyDenied ||
        permission == PermissionStatus.restricted) {
      await _openSettingsAndRecheck(checkCameraPermission);
    } else {
      final requested = await Permission.camera.request();
      if (!ref.mounted) return;
      state = state.copyWith(cameraPermission: requested);
    }
  }

  Future<void> checkAlbumPermission() => _setPhotoPermission(
        PhotoManager.getPermissionState(requestOption: _photoRequestOption),
      );

  Future<void> requestAlbumPermission() async {
    await _setPhotoPermission(
      PhotoManager.requestPermissionExtend(requestOption: _photoRequestOption),
    );
    if (!ref.mounted) return;
    if (!state.hasPhotoPermission) {
      await _openSettingsAndRecheck(checkAlbumPermission);
    }
  }

  Future<void> _setPhotoPermission(Future<PermissionState> permission) async {
    final result = await permission;
    if (!ref.mounted) return;
    state = state.copyWith(photoPermission: result);
    if (state.hasPhotoPermission) await _loadAssets(state.filter);
  }

  Future<void> _openSettingsAndRecheck(Future<void> Function() recheck) async {
    if (await _settings.open() == SettingsReturnResult.returned) {
      if (!ref.mounted) return;
      await recheck();
    }
  }

  Future<void> setFilter(PhotoFilter filter) async {
    if (state.filter == filter) return;
    state = state.copyWith(filter: filter);
    if (state.hasPhotoPermission && !_paths.containsKey(filter)) {
      await _loadAssets(filter);
    }
  }

  Future<void> loadMore() => _loadPage(state.filter);

  Future<void> _loadAssets(PhotoFilter filter) async {
    if (_paths.containsKey(filter)) return;

    final paths = await PhotoManager.getAssetPathList(
      onlyAll: true,
      type: filter.type,
      filterOption: FilterOptionGroup(
        orders: [
          const OrderOption(),
        ],
      ),
    );
    if (!ref.mounted) return;
    if (paths.isEmpty) {
      _paths[filter] = null;
      state = state.copyWith(
        assetsByFilter: {...state.assetsByFilter, filter: const []},
        totalCountByFilter: {...state.totalCountByFilter, filter: 0},
        hasMoreByFilter: {...state.hasMoreByFilter, filter: false},
      );
      return;
    }

    final path = paths.first;
    _paths[filter] = path;
    _nextPage[filter] = 0;
    state = state.copyWith(
      assetsByFilter: {...state.assetsByFilter, filter: const []},
      hasMoreByFilter: {...state.hasMoreByFilter, filter: true},
    );
    final totalCount = await path.assetCountAsync;
    if (!ref.mounted) return;
    state = state.copyWith(
      totalCountByFilter: {...state.totalCountByFilter, filter: totalCount},
    );
    await _loadPage(filter);
  }

  Future<void> _loadPage(PhotoFilter filter) async {
    final path = _paths[filter];
    if (path == null) return;
    if (state.loadingFilters.contains(filter)) return;
    if (!(state.hasMoreByFilter[filter] ?? false)) return;

    state = state.copyWith(loadingFilters: {...state.loadingFilters, filter});
    try {
      final page = _nextPage[filter] ?? 0;
      final loaded = await path.getAssetListPaged(page: page, size: _pageSize);
      _nextPage[filter] = page + 1;
      if (!ref.mounted) return;

      if (loaded.isEmpty) {
        state = state.copyWith(
          hasMoreByFilter: {...state.hasMoreByFilter, filter: false},
        );
        return;
      }

      final prev = state.assetsByFilter[filter] ?? const <AssetEntity>[];
      final ids = prev.map((e) => e.id).toSet();
      state = state.copyWith(
        assetsByFilter: {
          ...state.assetsByFilter,
          filter: [
            ...prev,
            ...loaded.where(
              (e) =>
                  (e.type == AssetType.image || e.type == AssetType.video) &&
                  !ids.contains(e.id),
            ),
          ],
        },
      );
    } catch (e, stack) {
      WiduLog.ui.w('사진 목록 불러오기 실패', error: e, stackTrace: stack);
    } finally {
      if (ref.mounted) {
        state = state.copyWith(
          loadingFilters: {...state.loadingFilters}..remove(filter),
        );
      }
    }
  }

  bool toggleSelection(AssetEntity asset) {
    final selected = [...state.selected];
    final index = selected.indexWhere((e) => e.id == asset.id);
    if (index >= 0) {
      selected.removeAt(index);
    } else {
      if (selected.length >= _maxSelectCount) {
        showToast('최대 $_maxSelectCount개까지 선택 가능합니다');
        return false;
      }
      if (asset.type == AssetType.video &&
          asset.duration > _maxVideoDurationSeconds) {
        showToast('영상은 최대 1분길이만 선택 가능합니다');
        return false;
      }
      selected.add(asset);
    }
    state = state.copyWith(selected: selected);
    return true;
  }

  Future<void> captureFromCamera() async {
    if (state.isCapturing) return;
    if (state.selected.length >= _maxSelectCount) {
      showToast('최대 $_maxSelectCount개까지 선택 가능합니다');
      return;
    }

    if (!state.hasCameraPermission) {
      await requestCameraPermission();
      if (!ref.mounted || !state.hasCameraPermission) return;
    }

    state = state.copyWith(isCapturing: true);
    try {
      final picked = await ImagePicker().pickImage(source: ImageSource.camera);
      if (picked == null) return;

      // 화면이 먼저 닫혀도 찍은 사진은 갤러리에 저장한다(기존 동작).
      final asset = await PhotoManager.editor.saveImageWithPath(
        picked.path,
        title: picked.name,
      );
      if (!ref.mounted) return;

      final assetsByFilter = {...state.assetsByFilter};
      final totalCountByFilter = {...state.totalCountByFilter};
      for (final key in assetsByFilter.keys.toList()) {
        if (key == PhotoFilter.video) continue;
        assetsByFilter[key] = [asset, ...?assetsByFilter[key]];
        totalCountByFilter[key] = (totalCountByFilter[key] ?? 0) + 1;
      }
      state = state.copyWith(
        assetsByFilter: assetsByFilter,
        totalCountByFilter: totalCountByFilter,
        selected: [...state.selected, asset],
      );
    } finally {
      if (ref.mounted) state = state.copyWith(isCapturing: false);
    }
  }
}
