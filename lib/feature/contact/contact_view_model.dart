import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:widyu/core/data/repository/myPage/my_page_repository.dart';
import 'package:widyu/core/di/providers.dart';
import 'package:widyu/core/log/log.dart';
import 'package:widyu/core/model/api/api_result.dart';
import 'package:widyu/core/model/myPage/contact/contact.dart';
import 'package:widyu/feature/contact/contact_ui_event.dart';
import 'package:widyu/feature/contact/contact_ui_state.dart';

part 'contact_view_model.g.dart';

@riverpod
class ContactViewModel extends _$ContactViewModel {
  final _uiEvent = StreamController<ContactUiEvent>.broadcast();

  // 일회성 이벤트는 state가 아니라 stream으로 내보낸다.
  // ignore: riverpod_lint/avoid_public_notifier_properties
  Stream<ContactUiEvent> get uiEvent => _uiEvent.stream;

  MyPageRepository get _repository => ref.read(myPageRepositoryProvider);

  @override
  ContactUiState build() {
    // onDispose는 다시 빌드될 때도 불리므로, 실제로 폐기될 때만 닫는다.
    ref.onDispose(() {
      if (!ref.mounted) _uiEvent.close();
    });
    unawaited(Future.microtask(_fetchContact));
    return const ContactUiState(isLoading: true);
  }

  Future<void> updateRepresentativeContact(int memberId) async {
    state = state.copyWith(isLoading: true);

    final result = await _repository.updateRepresentativeContact(memberId);
    if (!ref.mounted) return;
    if (result is Success) {
      WiduLog.ui.i('대표 연락처 변경 성공 memberId=$memberId');
      await _fetchContact();
    } else {
      _uiEvent.add(const UpdateRepresentativeContactFailure());
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> _fetchContact() async {
    if (!ref.mounted) return;
    state = state.copyWith(isLoading: true);

    final result = await _repository.fetchContact();
    if (!ref.mounted) return;
    if (result is Success) {
      final data = (result as Success<Contact>).data;
      state = state.copyWith(
        representative: data.representative,
        familyMembers: [...data.familyMembers]..sort((a, b) {
            if (a.isRepresentative == b.isRepresentative) return 0;
            return a.isRepresentative ? -1 : 1;
          }),
      );
    } else {
      _uiEvent.add(const FetchContactFailure());
    }
    state = state.copyWith(isLoading: false);
  }
}
