// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(PostViewModel)
final postViewModelProvider = PostViewModelFamily._();

final class PostViewModelProvider
    extends $NotifierProvider<PostViewModel, PostUiState> {
  PostViewModelProvider._(
      {required PostViewModelFamily super.from, required int super.argument})
      : super(
          retry: null,
          name: r'postViewModelProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$postViewModelHash();

  @override
  String toString() {
    return r'postViewModelProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  PostViewModel create() => PostViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PostUiState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PostUiState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is PostViewModelProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$postViewModelHash() => r'019bd3fb7392fc97e885520fd89dd0fe6f620bae';

final class PostViewModelFamily extends $Family
    with
        $ClassFamilyOverride<PostViewModel, PostUiState, PostUiState,
            PostUiState, int> {
  PostViewModelFamily._()
      : super(
          retry: null,
          name: r'postViewModelProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  PostViewModelProvider call(
    int id,
  ) =>
      PostViewModelProvider._(argument: id, from: this);

  @override
  String toString() => r'postViewModelProvider';
}

abstract class _$PostViewModel extends $Notifier<PostUiState> {
  late final _$args = ref.$arg as int;
  int get id => _$args;

  PostUiState build(
    int id,
  );
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<PostUiState, PostUiState>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<PostUiState, PostUiState>, PostUiState, Object?, Object?>;
    element.handleCreate(
        ref,
        () => build(
              _$args,
            ));
  }
}
