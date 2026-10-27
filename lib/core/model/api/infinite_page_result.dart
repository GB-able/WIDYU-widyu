import 'package:freezed_annotation/freezed_annotation.dart';

part 'infinite_page_result.freezed.dart';
part 'infinite_page_result.g.dart';

@Freezed(genericArgumentFactories: true)
abstract class InfinitePageResult<T> with _$InfinitePageResult<T> {
  const factory InfinitePageResult({
    @Default([]) List<T> items,
    required String? nextCursor,
    @Default(false) bool hasNext,
  }) = _InfinitePageResult<T>;

  factory InfinitePageResult.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) =>
      _$InfinitePageResultFromJson(json, fromJsonT);
}
