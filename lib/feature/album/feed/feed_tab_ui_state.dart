import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:widyu/core/model/album/album_cache.dart';
import 'package:widyu/core/utils/infinite_scroll.dart';

part 'feed_tab_ui_state.freezed.dart';

@freezed
abstract class FeedTabUiState with _$FeedTabUiState {
  const factory FeedTabUiState({
    // 캐시에 남아 있는(삭제되지 않은) 게시물 id만 담는다.
    @Default(InfiniteScrollState<int>()) InfiniteScrollState<int> list,
    @Default(AlbumCache()) AlbumCache cache,
    @Default({}) Set<int> expandedFeedIds,
  }) = _FeedTabUiState;
}
