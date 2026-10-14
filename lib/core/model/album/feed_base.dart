import 'package:widyu/core/model/album/member.dart';

abstract interface class FeedBase {
  int get albumId;
  String get authorName;
  String? get authorProfileImage;
  String get content;
  List<String> get mediaUrls;
  int get likeCount;
  int get commentCount;
  List<Member> get viewers;
  DateTime get createdAt;
  bool get canEdit;
  int get price;
}
