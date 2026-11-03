import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:widyu/core/model/album/album_cache.dart';
import 'package:widyu/core/model/album/media.dart';
import 'package:widyu/core/utils/infinite_scroll.dart';

part 'photo_tab_ui_state.freezed.dart';

@freezed
abstract class PhotoTabUiState with _$PhotoTabUiState {
  const factory PhotoTabUiState({
    // 삭제된 게시물의 미디어는 뺀다.
    @Default(InfiniteScrollState<Media>()) InfiniteScrollState<Media> list,
    @Default(AlbumCache()) AlbumCache cache,
  }) = _PhotoTabUiState;
}
