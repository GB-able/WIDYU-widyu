import 'dart:io';

import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:widyu/core/data/provider/album_provider.dart';
import 'package:widyu/core/data/provider/point_provider.dart';
import 'package:widyu/core/data/repository/album/album_repository.dart';
import 'package:widyu/core/log/log.dart';
import 'package:widyu/core/model/api/api_result.dart';
import 'package:widyu/core/utils/show_toast.dart';

class ManagePostViewModel extends ChangeNotifier {
  ManagePostViewModel({
    required AlbumRepository repository,
    required AlbumProvider albumProvider,
    required PointProvider pointProvider,
    String? initialContent,
  })  : _repository = repository,
        _albumProvider = albumProvider,
        _pointProvider = pointProvider {
    if (initialContent != null) _contentCtrl.text = initialContent;
    _contentCtrl.addListener(notifyListeners);
  }

  final AlbumRepository _repository;
  final AlbumProvider _albumProvider;
  final PointProvider _pointProvider;

  final _contentCtrl = TextEditingController();
  int _currIdx = 0;
  bool _isUploading = false;
  bool _disposed = false;

  TextEditingController get contentCtrl => _contentCtrl;
  int get currIdx => _currIdx;
  bool get isUploading => _isUploading;

  @override
  void dispose() {
    _disposed = true;
    _contentCtrl.removeListener(notifyListeners);
    _contentCtrl.dispose();
    super.dispose();
  }

  void setCurrIdx(int index) {
    _currIdx = index;
    notifyListeners();
  }

  Future<bool> uploadFeed(List<AssetEntity> photos) async {
    if (_disposed || _isUploading || _albumProvider.isDisposed) {
      return false;
    }

    _isUploading = true;
    notifyListeners();

    final content = _contentCtrl.text.trim();
    try {
      final files = await Future.wait(photos.map((e) => e.originFile));
      if (_albumProvider.isDisposed) return false;
      final result = await _repository.uploadFeed(
        mediaFiles: files.whereType<File>().toList(),
        content: content,
      );
      if (_albumProvider.isDisposed) return false;
      if (result is Failure) {
        showToast('게시글 업로드에 실패했습니다');
        return false;
      }
      await Future.wait([
        _pointProvider.refresh(),
        _albumProvider.loadUnlockedAlbumIds(),
      ]);
      return !_albumProvider.isDisposed;
    } catch (e, stack) {
      WiduLog.ui.w('게시글 업로드 실패', error: e, stackTrace: stack);
      showToast('게시글 업로드에 실패했습니다');
      return false;
    } finally {
      _isUploading = false;
      if (!_disposed) notifyListeners();
    }
  }

  Future<String?> updateFeed(int albumId) async {
    if (_disposed || _isUploading || _albumProvider.isDisposed) {
      return null;
    }

    _isUploading = true;
    notifyListeners();

    try {
      final content = _contentCtrl.text.trim();
      final updated = await _albumProvider.updateFeed(
        albumId: albumId,
        content: content,
      );
      if (_albumProvider.isDisposed) return null;
      if (!updated) {
        showToast('게시글 수정에 실패했습니다');
        return null;
      }
      return content;
    } finally {
      _isUploading = false;
      if (!_disposed) notifyListeners();
    }
  }
}
