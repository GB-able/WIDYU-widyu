import 'dart:io';

import 'package:photo_manager/photo_manager.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:widyu/core/data/repository/album/album_repository.dart';
import 'package:widyu/core/data/repository/point/point_repository.dart';
import 'package:widyu/core/di/providers.dart';
import 'package:widyu/core/log/log.dart';
import 'package:widyu/core/model/api/api_result.dart';
import 'package:widyu/core/utils/show_toast.dart';

part 'manage_post_view_model.g.dart';

/// 상태는 업로드·수정 요청 중인지 여부다.
@riverpod
class ManagePostViewModel extends _$ManagePostViewModel {
  AlbumRepository get _repository => ref.read(albumRepositoryProvider);
  PointRepository get _pointRepository => ref.read(pointRepositoryProvider);

  @override
  bool build() => false;

  // 업로드는 화면이 닫혀도 끝까지 진행한다(세션이 끝나면 멈춘다).
  Future<bool> uploadFeed(List<AssetEntity> photos, String content) async {
    if (!ref.mounted || state) return false;
    final repository = _repository;
    final pointRepository = _pointRepository;
    if (repository.isDisposed) return false;

    state = true;

    final trimmed = content.trim();
    try {
      final files = await Future.wait(photos.map((e) => e.originFile));
      if (repository.isDisposed) return false;
      final result = await repository.uploadFeed(
        mediaFiles: files.whereType<File>().toList(),
        content: trimmed,
      );
      if (repository.isDisposed) return false;
      if (result is Failure) {
        showToast('게시글 업로드에 실패했습니다');
        return false;
      }
      WiduLog.ui.i('게시글 업로드 성공 media=${files.length}');
      await Future.wait([
        pointRepository.refresh(),
        repository.loadUnlockedAlbumIds(),
      ]);
      return !repository.isDisposed;
    } catch (e, stack) {
      WiduLog.ui.w('게시글 업로드 실패', error: e, stackTrace: stack);
      showToast('게시글 업로드에 실패했습니다');
      return false;
    } finally {
      if (ref.mounted) state = false;
    }
  }

  Future<String?> updateFeed(int albumId, String content) async {
    if (!ref.mounted || state) return null;
    final repository = _repository;
    if (repository.isDisposed) return null;

    state = true;

    try {
      final trimmed = content.trim();
      final updated = await repository.updateFeed(
        albumId: albumId,
        content: trimmed,
      );
      if (repository.isDisposed) return null;
      if (!updated) {
        showToast('게시글 수정에 실패했습니다');
        return null;
      }
      return trimmed;
    } finally {
      if (ref.mounted) state = false;
    }
  }
}
