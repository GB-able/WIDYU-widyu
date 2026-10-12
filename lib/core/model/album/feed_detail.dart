import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:widyu/core/model/album/comment.dart';
import 'package:widyu/core/model/album/feed_base.dart';
import 'package:widyu/core/model/album/member.dart';
import 'package:widyu/core/model/album/viewer.dart';

part 'feed_detail.freezed.dart';
part 'feed_detail.g.dart';

@freezed
abstract class FeedDetail with _$FeedDetail implements FeedBase {
  const FeedDetail._();

  const factory FeedDetail({
    @JsonKey(name: 'postId') required int albumId,
    required String content,
    required List<String> mediaUrls,
    required int likeCount,
    required int commentCount,
    @Default(0) int viewCount,
    int? price,
    required Member author,
    @Default([]) List<Viewer> viewers,
    @Default([]) List<Comment> comments,
    required DateTime createdAt,
    required bool canEdit,
  }) = _FeedDetail;

  @override
  String get authorName => author.name;

  @override
  String? get authorProfileImage => author.profileImage;

  factory FeedDetail.fromJson(Map<String, dynamic> json) =>
      _$FeedDetailFromJson(json);
}
