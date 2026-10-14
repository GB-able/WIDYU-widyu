class EditPostExtra {
  const EditPostExtra({
    required this.albumId,
    required this.content,
    required this.mediaUrls,
  });

  final int albumId;
  final String content;
  final List<String> mediaUrls;
}
