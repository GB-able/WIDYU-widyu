import 'package:flutter_test/flutter_test.dart';
import 'package:widyu/core/model/album/comment.dart';

void main() {
  test('author 객체 형태를 파싱한다', () {
    final comment = Comment.fromJson({
      'commentId': 1,
      'content': 'a',
      'createdAt': '2026-10-14T00:00:00',
      'author': {'memberId': 7, 'name': '민', 'profileImage': 'p.jpg'},
      'canEdit': true,
    });
    expect(comment.author.id, 7);
    expect(comment.author.name, '민');
    expect(comment.canEdit, true);
  });

  test('평평한 author 필드 형태를 파싱한다', () {
    final comment = Comment.fromJson({
      'commentId': 1,
      'content': 'a',
      'createdAt': '2026-10-14T00:00:00',
      'authorId': 7,
      'authorName': '민',
    });
    expect(comment.author.id, 7);
    expect(comment.author.name, '민');
    expect(comment.author.profileImage, isNull);
    expect(comment.canEdit, false);
  });
}
