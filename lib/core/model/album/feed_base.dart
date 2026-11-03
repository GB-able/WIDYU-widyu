import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:widyu/core/model/album/member.dart';

enum FeedMediaType {
  @JsonValue('PHOTO')
  photo,
  @JsonValue('VIDEO')
  video,
}

abstract interface class FeedBase {
  int get albumId;
  String get authorName;
  String? get authorProfileImage;
  String get content;
  List<String> get mediaUrls;
  List<String> get thumbnailUrls;
  List<FeedMediaType> get mediaTypes;
  int get likeCount;
  int get commentCount;
  List<Member> get viewers;
  DateTime get createdAt;
  bool get canEdit;
  int get price;
}
