import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:widyu/core/log/log.dart';
import 'package:widyu/core/utils/show_toast.dart';

const _maxVideoDurationSeconds = 60;
const _pageSize = 100;
const _maxSelectCount = 8;

enum PhotoFilter {
  all(label: '전체', type: RequestType.common),
  image(label: '사진', type: RequestType.image),
  video(label: '동영상', type: RequestType.video);

  const PhotoFilter({required this.label, required this.type});
  final String label;
  final RequestType type;
}

class SelectPhotoViewModel extends ChangeNotifier {
  PermissionStatus? _cameraPermission;
  PermissionState? _photoPermission;
  PhotoFilter _filter = PhotoFilter.all;
  final Map<PhotoFilter, List<AssetEntity>> _assets = {};
  final Map<PhotoFilter, AssetPathEntity?> _paths = {};
  final Map<PhotoFilter, int> _nextPage = {};
  final Map<PhotoFilter, int> _totalCount = {};
  final Map<PhotoFilter, bool> _hasMore = {};
  final Set<PhotoFilter> _loading = {};
  final List<AssetEntity> _selected = [];
  bool _isCapturing = false;

  PermissionStatus? get cameraPermission => _cameraPermission;
  PermissionState? get photoPermission => _photoPermission;
  PhotoFilter get filter => _filter;
  List<AssetEntity> get currAssets => _assets[_filter] ?? const [];
  List<AssetEntity> get selected => List.unmodifiable(_selected);
  bool get isCapturing => _isCapturing;
  bool get isLoading => _loading.contains(_filter) && currAssets.isEmpty;
  int get totalCount => _totalCount[_filter] ?? 0;
  bool get hasMore => _hasMore[_filter] ?? false;
  bool get hasCameraPermission => _cameraPermission == PermissionStatus.granted;
  bool get hasPhotoPermission =>
      _photoPermission == PermissionState.authorized ||
      _photoPermission == PermissionState.limited;

  Future<void> init() async {
    await checkCameraPermission();
    await checkAlbumPermission();
    if (hasPhotoPermission) await _loadAssets(_filter);
  }

  Future<void> checkCameraPermission() async {
    _cameraPermission = await Permission.camera.status;
    notifyListeners();
  }

  Future<void> requestCameraPermission() async {
    if (_cameraPermission == PermissionStatus.permanentlyDenied ||
        _cameraPermission == PermissionStatus.restricted) {
      await openAppSettings();
      await checkCameraPermission();
    } else {
      _cameraPermission = await Permission.camera.request();
      notifyListeners();
    }
  }

  Future<void> checkAlbumPermission() async {
    _photoPermission = await PhotoManager.getPermissionState(
      requestOption: const PermissionRequestOption(
        androidPermission: AndroidPermission(
          type: RequestType.common,
          mediaLocation: true,
        ),
      ),
    );

    if (_photoPermission == PermissionState.notDetermined) {
      await requestAlbumPermission();
    }
    notifyListeners();
  }

  Future<void> requestAlbumPermission() async {
    if (_photoPermission == PermissionState.denied ||
        _photoPermission == PermissionState.restricted) {
      await PhotoManager.openSetting();
      await checkAlbumPermission();
    } else {
      _photoPermission = await PhotoManager.requestPermissionExtend();
      notifyListeners();
      if (hasPhotoPermission) await _loadAssets(_filter);
    }
  }

  Future<void> setFilter(PhotoFilter filter) async {
    if (_filter == filter) return;
    _filter = filter;
    notifyListeners();
    if (hasPhotoPermission && !_paths.containsKey(filter)) {
      await _loadAssets(filter);
    }
  }

  Future<void> loadMore() => _loadPage(_filter);

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
    if (paths.isEmpty) {
      _paths[filter] = null;
      _assets[filter] = [];
      _totalCount[filter] = 0;
      _hasMore[filter] = false;
      notifyListeners();
      return;
    }

    final path = paths.first;
    _paths[filter] = path;
    _assets[filter] = [];
    _nextPage[filter] = 0;
    _hasMore[filter] = true;
    _totalCount[filter] = await path.assetCountAsync;
    await _loadPage(filter);
  }

  Future<void> _loadPage(PhotoFilter filter) async {
    final path = _paths[filter];
    if (path == null) return;
    if (_loading.contains(filter)) return;
    if (!(_hasMore[filter] ?? false)) return;

    _loading.add(filter);
    notifyListeners();
    try {
      final page = _nextPage[filter] ?? 0;
      final loaded = await path.getAssetListPaged(page: page, size: _pageSize);
      _nextPage[filter] = page + 1;

      if (loaded.isEmpty) {
        _hasMore[filter] = false;
        return;
      }

      final prev = _assets[filter] ?? const <AssetEntity>[];
      final ids = prev.map((e) => e.id).toSet();
      _assets[filter] = [
        ...prev,
        ...loaded.where(
          (e) =>
              (e.type == AssetType.image || e.type == AssetType.video) &&
              !ids.contains(e.id),
        ),
      ];
    } catch (e, stack) {
      WiduLog.ui.w('사진 목록 불러오기 실패', error: e, stackTrace: stack);
    } finally {
      _loading.remove(filter);
      notifyListeners();
    }
  }

  int? selectOrder(AssetEntity asset) {
    final index = _selected.indexWhere((e) => e.id == asset.id);
    return index >= 0 ? index + 1 : null;
  }

  bool toggleSelection(AssetEntity asset) {
    final index = _selected.indexWhere((e) => e.id == asset.id);
    if (index >= 0) {
      _selected.removeAt(index);
    } else {
      if (_selected.length >= _maxSelectCount) {
        showToast('최대 $_maxSelectCount개까지 선택 가능합니다');
        return false;
      }
      if (asset.type == AssetType.video &&
          asset.duration > _maxVideoDurationSeconds) {
        showToast('영상은 최대 1분길이만 선택 가능합니다');
        return false;
      }
      _selected.add(asset);
    }
    notifyListeners();
    return true;
  }

  Future<void> captureFromCamera() async {
    if (_isCapturing) return;
    if (_selected.length >= _maxSelectCount) {
      showToast('최대 $_maxSelectCount개까지 선택 가능합니다');
      return;
    }

    if (!hasCameraPermission) {
      await requestCameraPermission();
      if (!hasCameraPermission) return;
    }

    _isCapturing = true;
    notifyListeners();
    try {
      final picked = await ImagePicker().pickImage(source: ImageSource.camera);
      if (picked == null) return;

      final asset = await PhotoManager.editor.saveImageWithPath(
        picked.path,
        title: picked.name,
      );

      for (final key in _assets.keys.toList()) {
        if (key == PhotoFilter.video) continue;
        _assets[key] = [asset, ...?_assets[key]];
        _totalCount[key] = (_totalCount[key] ?? 0) + 1;
      }
      _selected.add(asset);
    } finally {
      _isCapturing = false;
      notifyListeners();
    }
  }
}
