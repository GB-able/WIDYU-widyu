/// 피드 하나의 좋아요/댓글 카운트 스냅샷.
class AlbumStat {
  const AlbumStat({
    required this.isLiked,
    required this.likeCount,
    required this.commentCount,
  });

  final bool isLiked;
  final int likeCount;
  final int commentCount;

  AlbumStat copyWith({bool? isLiked, int? likeCount, int? commentCount}) {
    return AlbumStat(
      isLiked: isLiked ?? this.isLiked,
      likeCount: likeCount ?? this.likeCount,
      commentCount: commentCount ?? this.commentCount,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AlbumStat &&
        other.isLiked == isLiked &&
        other.likeCount == likeCount &&
        other.commentCount == commentCount;
  }

  @override
  int get hashCode => Object.hash(isLiked, likeCount, commentCount);
}
