class AlbumComment {
  final int commentId;
  final int? albumId;
  final String content;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final int authorId;
  final String authorName;
  final String? authorProfileImage;
  final int likeCount;
  final bool isReply;
  final int? parentCommentId;
  final bool canEdit;
  final List<AlbumComment> replies;

  const AlbumComment({
    required this.commentId,
    this.albumId,
    required this.content,
    required this.createdAt,
    this.updatedAt,
    required this.authorId,
    required this.authorName,
    this.authorProfileImage,
    this.likeCount = 0,
    this.isReply = false,
    this.parentCommentId,
    this.canEdit = false,
    this.replies = const [],
  });

  factory AlbumComment.fromJson(Map<String, dynamic> json) {
    final author = json['author'] as Map<String, dynamic>?;

    return AlbumComment(
      commentId: json['commentId'] as int,
      albumId: json['albumId'] as int?,
      content: json['content'] as String? ?? '',
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
      authorId: (author?['memberId'] ?? json['authorId']) as int,
      authorName: (author?['name'] ?? json['authorName']) as String? ?? '',
      authorProfileImage:
          (author?['profileImage'] ?? json['authorProfileImage']) as String?,
      likeCount: json['likeCount'] as int? ?? 0,
      isReply: json['isReply'] as bool? ?? false,
      parentCommentId: json['parentCommentId'] as int?,
      canEdit: json['canEdit'] as bool? ?? false,
      replies: (json['replies'] as List<dynamic>? ?? [])
          .map((e) => AlbumComment.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
